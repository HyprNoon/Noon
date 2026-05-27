import json
import os
import subprocess
import sys
import time
import urllib.error
import urllib.request
from pathlib import Path

from oauth_service import NoonAuthenticator

STORE_FILE = Path("~/.local/state/noon/user/generated/todo.json").expanduser()
GID_MAP_FILE = Path(
    "~/.local/state/noon/user/generated/calendar_gid_map.json"
).expanduser()
SCOPES = "https://www.googleapis.com/auth/calendar"
CALENDAR_ID = "primary"


def get_auth():
    client_id = os.environ.get("NOON_CALENDAR_ID")
    client_secret = os.environ.get("NOON_CALENDAR_SECRET")
    missing = [
        name
        for name, val in [
            ("NOON_CALENDAR_ID", client_id),
            ("NOON_CALENDAR_SECRET", client_secret),
        ]
        if not val
    ]
    if missing:
        raise ValueError(f"Missing required env vars: {', '.join(missing)}")
    return NoonAuthenticator(client_id, client_secret, SCOPES)


def get_timezone():
    try:
        return subprocess.check_output(
            ["timedatectl", "show", "-p", "Timezone", "--value"], text=True
        ).strip()
    except Exception:
        return "UTC"


TIMEZONE = get_timezone()


def api(method, path, body=None):
    token = auth.get_valid_token()
    if not token:
        raise RuntimeError("No valid auth token")
    req = urllib.request.Request(
        f"https://www.googleapis.com/calendar/v3{path}",
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


def fetch_remote():
    return api(
        "GET",
        f"/calendars/{CALENDAR_ID}/events?singleEvents=true&orderBy=startTime",
    ).get("items", [])


def load_events():
    data = json.loads(STORE_FILE.read_text())
    return data, data["events"]


def write_events(data, events):
    data["events"] = events
    STORE_FILE.write_text(json.dumps(data, indent=4))


def load_gid_map():
    try:
        return json.loads(GID_MAP_FILE.read_text())
    except Exception:
        return {}


def save_gid_map(m):
    GID_MAP_FILE.parent.mkdir(parents=True, exist_ok=True)
    GID_MAP_FILE.write_text(json.dumps(m, indent=2))


def event_key(event):
    return f"{event['content']}|{event.get('start', '')}|{event.get('time', '')}"


def parse_dt(dt):
    dt = dt.split("+")[0].rstrip("Z")
    t = time.strptime(dt, "%Y-%m-%dT%H:%M:%S")
    return (
        f"{t.tm_mday}/{t.tm_mon}/{t.tm_year}",
        f"{t.tm_hour:02d}:{t.tm_min:02d}",
        t.tm_hour * 60 + t.tm_min,
    )


def format_event(event):
    day, month, year = event["start"].split("/")
    h, m = map(int, event.get("time", "00:00").split(":"))
    end_mins = h * 60 + m + event.get("duration", 60)
    end_h, end_m = divmod(end_mins, 60)
    end_day, end_month, end_year = event.get("end", event["start"]).split("/")
    return {
        "summary": event["content"],
        "start": {
            "dateTime": f"{year}-{int(month):02d}-{int(day):02d}T{h:02d}:{m:02d}:00",
            "timeZone": TIMEZONE,
        },
        "end": {
            "dateTime": f"{end_year}-{int(end_month):02d}-{int(end_day):02d}T{end_h:02d}:{end_m:02d}:00",
            "timeZone": TIMEZONE,
        },
    }


def pull():
    data, _ = load_events()
    gid_map = {}
    events = []
    for item in fetch_remote():
        start_raw = item.get("start", {}).get("dateTime")
        if not start_raw:
            continue
        start, t, start_mins = parse_dt(start_raw)
        end_raw = item.get("end", {}).get("dateTime", start_raw)
        end, _, end_mins = parse_dt(end_raw)
        event = {
            "content": item.get("summary", ""),
            "start": start,
            "end": end,
            "time": t,
            "duration": end_mins - start_mins,
        }
        events.append(event)
        gid_map[event_key(event)] = item["id"]
    write_events(data, events)
    print(events)
    save_gid_map(gid_map)


def push():
    _, events = load_events()
    gid_map = load_gid_map()
    local_keys = set()
    for event in events:
        key = event_key(event)
        local_keys.add(key)
        body = format_event(event)
        gid = gid_map.get(key)
        if gid:
            api("PATCH", f"/calendars/{CALENDAR_ID}/events/{gid}", body)
        else:
            gid_map[key] = api("POST", f"/calendars/{CALENDAR_ID}/events", body)["id"]
    known_gids = {gid_map[k] for k in local_keys if k in gid_map}
    for item in fetch_remote():
        if item["id"] not in known_gids:
            api("DELETE", f"/calendars/{CALENDAR_ID}/events/{item['id']}")
    save_gid_map({k: v for k, v in gid_map.items() if k in local_keys})


COMMANDS = {"pull": pull, "push": push}


def main():
    global auth
    auth = get_auth()
    if not auth.is_authenticated():
        auth.auth_loopback(interactive=True)
    if len(sys.argv) != 2 or sys.argv[1] not in COMMANDS:
        print(f"Usage: {sys.argv[0]} <{'|'.join(COMMANDS)}>")
        sys.exit(1)
    try:
        COMMANDS[sys.argv[1]]()
        print(f"Done: {sys.argv[1]}")
    except Exception as e:
        print(f"Failed: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
