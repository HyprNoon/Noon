import json
import time
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path

from oauth_service import NoonAuthenticator

STATES_FILE = Path("~/.local/state/noon/states.json").expanduser()
GID_MAP_FILE = Path("~/.local/state/noon/todo_gid_map.json").expanduser()
TASKLIST_ID = "@default"
SCOPES = "https://www.googleapis.com/auth/tasks"

auth = NoonAuthenticator("google_tasks", SCOPES)


def load_gid_map():
    try:
        return json.loads(GID_MAP_FILE.read_text())
    except:
        return {}


def save_gid_map(m):
    GID_MAP_FILE.parent.mkdir(parents=True, exist_ok=True)
    GID_MAP_FILE.write_text(json.dumps(m, indent=2))


def task_key(task):
    return f"{task['content']}|{task.get('due', -1)}"


def load_local_tasks():
    return json.loads(STATES_FILE.read_text())["services"]["todo"]["tasks"]


def api(method, path, body=None):
    token = auth.get_valid_token()
    if not token:
        raise Exception("No valid auth token")
    headers = {
        "Authorization": f"Bearer {token['access_token']}",
        "Content-Type": "application/json",
    }
    req = urllib.request.Request(
        f"https://tasks.googleapis.com/tasks/v1{path}",
        data=json.dumps(body).encode() if body else None,
        headers=headers,
        method=method,
    )
    try:
        with urllib.request.urlopen(req, timeout=10) as r:
            content = r.read()
            return json.loads(content) if content else {}
    except urllib.error.HTTPError as e:
        if e.code == 204:
            return {}
        raise


def sync():
    local_tasks = load_local_tasks()
    gid_map = load_gid_map()
    local_keys = {task_key(t) for t in local_tasks}

    remote_items = api("GET", f"/lists/{TASKLIST_ID}/tasks?showCompleted=true").get(
        "items", []
    )
    remote_by_id = {t["id"]: t for t in remote_items}

    for task in local_tasks:
        key = task_key(task)
        gid = gid_map.get(key)
        body = {"title": task["content"], "notes": str(task["status"])}
        if task.get("due", -1) != -1:
            body["due"] = task["due"]

        if not gid:
            gid_map[key] = api("POST", f"/lists/{TASKLIST_ID}/tasks", body)["id"]
        else:
            remote = remote_by_id.get(gid)
            if not remote:
                gid_map[key] = api("POST", f"/lists/{TASKLIST_ID}/tasks", body)["id"]
            elif remote.get("title") != task["content"] or remote.get("notes") != str(
                task["status"]
            ):
                api("PATCH", f"/lists/{TASKLIST_ID}/tasks/{gid}", body)

    known_gids = {gid_map[k] for k in local_keys if k in gid_map}
    for remote_task in remote_items:
        if remote_task["id"] not in known_gids:
            api("DELETE", f"/lists/{TASKLIST_ID}/tasks/{remote_task['id']}")

    save_gid_map({k: v for k, v in gid_map.items() if k in local_keys})


def main():
    if not auth.is_authenticated():
        auth.auth_loopback(interactive=True)
    try:
        sync()
        print("Synced")
    except Exception as e:
        print(f"Sync failed: {e}")


if __name__ == "__main__":
    main()
