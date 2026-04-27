import http.server
import json
import os
import subprocess
import threading
import time
import urllib.parse
import urllib.request
import webbrowser

from requests_oauth2client import OAuth2Client

OAUTH_STATE_PATH = os.path.expanduser("~/.local/state/noon/user/generated/oauth.json")


class NoonAuthenticator:
    def __init__(self, scopes, service_name=None, client_id=None, client_secret=None):
        self.scopes = scopes
        self.service = service_name

        self.cid = (
            client_id
            or (
                os.environ.get(f"NOON_{service_name.upper()}_ID")
                if service_name
                else None
            )
            or os.environ.get("NOON_OAUTH_ID")
        )

        self.sec = (
            client_secret
            or (
                os.environ.get(f"NOON_{service_name.upper()}_SECRET")
                if service_name
                else None
            )
            or os.environ.get("NOON_OAUTH_SECRET")
        )

        if not self.cid:
            raise ValueError(
                "Auth Error: Missing Client ID. Set NOON_OAUTH_ID environment variable."
            )

        self.client = OAuth2Client(
            token_endpoint="https://oauth2.googleapis.com/token",
            client_id=self.cid,
            client_secret=self.sec,
        )

    def _load_vault(self) -> dict:
        try:
            with open(OAUTH_STATE_PATH) as f:
                return json.load(f)
        except:
            return {}

    def _save_to_vault(self, token_data):
        os.makedirs(os.path.dirname(OAUTH_STATE_PATH), exist_ok=True)
        if "expires_in" in token_data and "expires_at" not in token_data:
            token_data["expires_at"] = int(time.time()) + int(token_data["expires_in"])
        state = self._load_vault()
        state[self.cid] = token_data
        with open(OAUTH_STATE_PATH, "w") as f:
            json.dump(state, f, indent=2)

    def get_token(self) -> dict:
        return self._load_vault().get(self.cid)

    def is_authenticated(self) -> bool:
        token = self.get_token()
        return bool(token and "access_token" in token)

    def get_valid_token(self) -> dict | None:
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

    def auth_loopback(self, port=8085, interactive=False):
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

        server = http.server.HTTPServer(("127.0.0.1", port), Handler)
        threading.Thread(target=server.handle_request, daemon=True).start()

        webbrowser.open(f"https://accounts.google.com/o/oauth2/v2/auth?{params}")
        if interactive:
            print(
                f"[NOON AUTH] Authorize in browser: https://accounts.google.com/o/oauth2/v2/auth?{params}"
            )
        else:
            subprocess.run(
                ["notify-send", "Noon Auth", "Authorize in the browser window"]
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
        try:
            state = self._load_vault()
            del state[self.cid]
            with open(OAUTH_STATE_PATH, "w") as f:
                json.dump(state, f, indent=2)
        except:
            pass

    def get_user_info(self) -> dict:
        token = self.get_token()
        if not token:
            return {}
        try:
            with urllib.request.urlopen(
                urllib.request.Request(
                    "https://www.googleapis.com/oauth2/v3/userinfo",
                    headers={"Authorization": f"Bearer {token['access_token']}"},
                ),
                timeout=10,
            ) as resp:
                return json.loads(resp.read())
        except:
            return {}
