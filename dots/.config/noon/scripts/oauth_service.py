# oauth_service.py
import http.server
import json
import os
import subprocess
import threading
import time
import urllib
import urllib.parse
import urllib.request
import webbrowser

from requests_oauth2client import OAuth2Client

OAUTH_STATE_PATH = os.path.expanduser("~/.local/state/noon/user/generated/oauth.json")


class NoonAuthenticator:
    def __init__(self, service_name, scopes, client_id=None, client_secret=None):
        self.service = service_name
        self.scopes = scopes

        env_prefix = f"NOON_{service_name.upper()}"
        self.cid = (
            client_id
            or os.environ.get(f"{env_prefix}_ID")
            or os.environ.get("NOON_OAUTH_ID")
        )
        self.sec = (
            client_secret
            or os.environ.get(f"{env_prefix}_SECRET")
            or os.environ.get("NOON_OAUTH_SECRET")
        )

        if not self.cid:
            raise ValueError(
                f"Auth Error: Missing Client ID for service '{service_name}'. "
                f"Set {env_prefix}_ID or NOON_OAUTH_ID environment variable."
            )

    def get_token(self) -> dict:
        if not os.path.exists(OAUTH_STATE_PATH):
            return None
        try:
            with open(OAUTH_STATE_PATH, "r") as f:
                data = json.load(f)
                return data.get(self.service)
        except:
            return None

    def is_authenticated(self) -> bool:
        token_data = self.get_token()
        return bool(token_data and "access_token" in token_data)

    def get_valid_token(self) -> dict | None:
        """Returns a valid token, refreshing if expired. None if not authenticated."""
        token = self.get_token()
        if not token:
            return None
        if time.time() >= token.get("expires_at", 0) - 60:
            try:
                resp = urllib.request.urlopen(
                    urllib.request.Request(
                        "https://oauth2.googleapis.com/token",
                        data=urllib.parse.urlencode(
                            {
                                "client_id": self.cid,
                                "client_secret": self.sec,
                                "refresh_token": token["refresh_token"],
                                "grant_type": "refresh_token",
                            }
                        ).encode(),
                        method="POST",
                    )
                )
                new_token = json.loads(resp.read())
                new_token.setdefault("refresh_token", token["refresh_token"])
                self._save_to_vault(new_token)
                return new_token
            except Exception:
                return None
        return token

    def auth(self, interactive=False):
        """Device Authorization Grant flow. Only works with Google-whitelisted scopes."""
        resp = self.client.session.post(
            "https://oauth2.googleapis.com/device/code",
            data={"client_id": self.cid, "scope": self.scopes},
        )
        print(resp.text)
        resp.raise_for_status()
        data = resp.json()

        user_code = data["user_code"]
        device_code = data["device_code"]
        url = data["verification_url"]
        interval = data.get("interval", 5)

        try:
            subprocess.run(["wl-copy"], input=user_code.encode(), check=True)
        except FileNotFoundError:
            pass

        if interactive:
            print(f"[{self.service.upper()}] Open: {url}")
            print(
                f"[{self.service.upper()}] Enter Code: {user_code} (Copied to clipboard)"
            )
            webbrowser.open(url)
            input("Press Enter once you have authorized in the browser...")
        else:
            webbrowser.open(url)
            subprocess.run(
                [
                    "notify-send",
                    f"Noon Auth: {self.service}",
                    f"Code: {user_code}\nCopied to clipboard. Authorize in browser.",
                ]
            )

        while True:
            token_resp = self.client.session.post(
                self.client.token_endpoint,
                data={
                    "client_id": self.cid,
                    "client_secret": self.sec,
                    "grant_type": "urn:ietf:params:oauth:grant-type:device_code",
                    "device_code": device_code,
                },
            )
            token_data = token_resp.json()
            if "error" in token_data:
                if token_data["error"] == "authorization_pending":
                    time.sleep(interval)
                    continue
                raise Exception(f"OAuth Error ({self.service}): {token_data['error']}")
            self._save_to_vault(token_data)
            return token_data

    def auth_loopback(self, port=8085, interactive=False):
        """Loopback redirect flow. Use for scopes not supported by device flow (e.g. Tasks, Calendar)."""
        redirect_uri = f"http://127.0.0.1:{port}"
        params = urllib.parse.urlencode(
            {
                "client_id": self.cid,
                "redirect_uri": redirect_uri,
                "response_type": "code",
                "scope": self.scopes,
                "access_type": "offline",
                "prompt": "consent",
            }
        )
        auth_url = f"https://accounts.google.com/o/oauth2/v2/auth?{params}"

        code_holder = {}

        class Handler(http.server.BaseHTTPRequestHandler):
            def do_GET(self):
                code_holder["code"] = urllib.parse.parse_qs(
                    urllib.parse.urlparse(self.path).query
                ).get("code", [None])[0]
                self.send_response(200)
                self.end_headers()
                self.wfile.write(b"Authorized. You can close this tab.")

            def log_message(self, *args):
                pass

        server = http.server.HTTPServer(("localhost", port), Handler)
        threading.Thread(target=server.handle_request, daemon=True).start()
        print(f"[DEBUG] auth_url: {auth_url}")
        print(f"[DEBUG] redirect_uri: {redirect_uri}")
        webbrowser.open(auth_url)
        if interactive:
            print(f"[{self.service.upper()}] Authorize in browser: {auth_url}")
        else:
            subprocess.run(
                [
                    "notify-send",
                    f"Noon Auth: {self.service}",
                    "Authorize in the browser window",
                ]
            )

        while "code" not in code_holder:
            time.sleep(0.5)
        server.server_close()

        resp = urllib.request.urlopen(
            urllib.request.Request(
                "https://oauth2.googleapis.com/token",
                data=urllib.parse.urlencode(
                    {
                        "code": code_holder["code"],
                        "client_id": self.cid,
                        "client_secret": self.sec,
                        "redirect_uri": redirect_uri,
                        "grant_type": "authorization_code",
                    }
                ).encode(),
                method="POST",
            )
        )
        token_data = json.loads(resp.read())
        self._save_to_vault(token_data)
        return token_data

    def revoke(self):
        if not os.path.exists(OAUTH_STATE_PATH):
            return
        try:
            with open(OAUTH_STATE_PATH, "r") as f:
                state = json.load(f)
            if self.service in state:
                del state[self.service]
                with open(OAUTH_STATE_PATH, "w") as f:
                    json.dump(state, f, indent=2)
        except:
            pass

    def _save_to_vault(self, token_data):
        os.makedirs(os.path.dirname(OAUTH_STATE_PATH), exist_ok=True)
        state = {}
        if os.path.exists(OAUTH_STATE_PATH):
            try:
                with open(OAUTH_STATE_PATH, "r") as f:
                    state = json.load(f)
            except:
                pass
        if "expires_in" in token_data and "expires_at" not in token_data:
            token_data["expires_at"] = int(time.time()) + int(token_data["expires_in"])
        state[self.service] = token_data
        with open(OAUTH_STATE_PATH, "w") as f:
            json.dump(state, f, indent=2)

    def get_user_info(self) -> dict:
        token = self.get_token()
        if not token:
            return {}
        req = urllib.request.Request(
            "https://www.googleapis.com/oauth2/v3/userinfo",
            headers={"Authorization": f"Bearer {token['access_token']}"},
        )
        try:
            with urllib.request.urlopen(req, timeout=10) as resp:
                return json.loads(resp.read())
        except:
            return {}
