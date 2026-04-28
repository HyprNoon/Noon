import json
import sys
import time
import urllib.error
import urllib.request
from pathlib import Path

from oauth_service import NoonAuthenticator

STATES_FILE = Path("~/.local/state/noon/states.json").expanduser()
GID_MAP_FILE = Path("~/.local/state/noon/gid_map.json").expanduser()
TASKLIST_NAME = "Noon"
SCOPES = "https://www.googleapis.com/auth/tasks"
STATUS_TAGS = ["[todo]", "[wip]", "[final]", "[done]"]
STATES_KEY = ["services", "todo", "tasks"]

auth = NoonAuthenticator(SCOPES)


def api(method, path, body=None):
    token = auth.get_valid_token()
    if not token:
        raise RuntimeError("No valid auth token")
    req = urllib.request.Request(
        f"https://tasks.googleapis.com/tasks/v1{path}",
        data=json.dumps(body).encode() if body else None,
        headers={
            "Authorization": f"Bearer {token['access_token']}",
            "Content-Type": "application/json",
        },
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


def get_tasklist_id():
    lists = api("GET", "/users/@me/lists").get("items", [])
    for lst in lists:
        if lst["title"] == TASKLIST_NAME:
            return lst["id"]
    return api("POST", "/users/@me/lists", {"title": TASKLIST_NAME})["id"]


def fetch_remote(tasklist):
    items = api("GET", f"/lists/{tasklist}/tasks").get("items", [])
    return [i for i in items if i.get("status") != "completed"]


def load_states():
    data = json.loads(STATES_FILE.read_text())
    tasks = data
    for k in STATES_KEY:
        tasks = tasks[k]
    return data, tasks


def write_states(data, tasks):
    d = data
    for k in STATES_KEY[:-1]:
        d = d[k]
    d[STATES_KEY[-1]] = tasks
    STATES_FILE.write_text(json.dumps(data, indent=2))


def load_gid_map():
    try:
        return json.loads(GID_MAP_FILE.read_text())
    except Exception:
        return {}


def save_gid_map(m):
    GID_MAP_FILE.parent.mkdir(parents=True, exist_ok=True)
    GID_MAP_FILE.write_text(json.dumps(m, indent=2))


def task_key(task):
    return f"{task['content']}|{task.get('due', -1)}"


def status_from_notes(notes):
    try:
        return STATUS_TAGS.index(notes)
    except ValueError:
        return 0


def parse_due(due):
    if not due:
        return -1
    t = time.strptime(due, "%Y-%m-%dT%H:%M:%S.000Z")
    return f"{t.tm_mday}/{t.tm_mon}"


def format_due(due):
    if not due or due == -1:
        return None
    try:
        day, month = str(due).split("/")
        return f"{time.strftime('%Y')}-{int(month):02d}-{int(day):02d}T00:00:00.000Z"
    except ValueError:
        return None


def pull(tasklist):
    data, _ = load_states()
    gid_map = {}
    tasks = []
    for item in fetch_remote(tasklist):
        task = {
            "content": item["title"],
            "status": status_from_notes(item.get("notes", "")),
            "due": parse_due(item.get("due", "")),
        }
        tasks.append(task)
        gid_map[task_key(task)] = item["id"]
    write_states(data, tasks)
    save_gid_map(gid_map)


def push(tasklist):
    _, tasks = load_states()
    gid_map = load_gid_map()
    local_keys = {task_key(t) for t in tasks}

    for task in tasks:
        key = task_key(task)
        body = {"title": task["content"], "notes": STATUS_TAGS[task["status"]]}
        due = format_due(task.get("due", -1))
        if due:
            body["due"] = due
        gid = gid_map.get(key)
        if gid:
            api("PATCH", f"/lists/{tasklist}/tasks/{gid}", body)
        else:
            gid_map[key] = api("POST", f"/lists/{tasklist}/tasks", body)["id"]

    known_gids = {gid_map[k] for k in local_keys if k in gid_map}
    for item in fetch_remote(tasklist):
        if item["id"] not in known_gids:
            api("DELETE", f"/lists/{tasklist}/tasks/{item['id']}")

    save_gid_map({k: v for k, v in gid_map.items() if k in local_keys})


COMMANDS = {"pull": pull, "push": push}


def main():
    if not auth.is_authenticated():
        auth.auth_loopback(interactive=True)

    if len(sys.argv) != 2 or sys.argv[1] not in COMMANDS:
        print(f"Usage: {sys.argv[0]} <{'|'.join(COMMANDS)}>")
        sys.exit(1)

    try:
        tasklist = get_tasklist_id()
        COMMANDS[sys.argv[1]](tasklist)
        print(f"Done: {sys.argv[1]}")
    except Exception as e:
        print(f"Failed: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
