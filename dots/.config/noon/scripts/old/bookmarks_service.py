#!/usr/bin/env python3
"""
Firefox Bookmarks Manager
Extracts bookmarks from Firefox places.sqlite database.

Usage:
    python3 firefox-bookmarks.py list              # List all bookmarks
    python3 firefox-bookmarks.py profiles          # List all Firefox profiles
    python3 firefox-bookmarks.py open <url>        # Open URL in Firefox
    python3 firefox-bookmarks.py fetch-favicons    # Download all favicons to cache
    python3 firefox-bookmarks.py remove <id>       # Remove bookmark by ID
"""

import concurrent.futures
import hashlib
import json
import os
import shutil
import sqlite3
import subprocess
import sys
from pathlib import Path
from urllib.parse import urlparse
from urllib.request import Request, urlopen


def get_favicon_cache_path():
    """Get the favicon cache directory."""
    cache_dir = Path.home() / ".cache" / "quickshell" / "media" / "favicons"
    cache_dir.mkdir(parents=True, exist_ok=True)
    return cache_dir


def get_favicon_filename(url):
    """Generate a unique filename for a favicon based on URL."""
    url_hash = hashlib.md5(url.encode()).hexdigest()[:16]
    try:
        domain = urlparse(url).netloc.replace("www.", "").replace(".", "_")
        return f"{domain}_{url_hash}.png"
    except:
        return f"favicon_{url_hash}.png"


def download_favicon(url, cache_path):
    """Download favicon for a URL and save to cache."""
    try:
        domain = urlparse(url).netloc or urlparse(url).path
        if not domain:
            return None

        # Try Google favicons first (most reliable and fast)
        favicon_url = f"https://www.google.com/s2/favicons?domain={domain}&sz=32"
        req = Request(favicon_url, headers={"User-Agent": "Mozilla/5.0"})

        with urlopen(req, timeout=3) as response:
            if response.status == 200:
                favicon_data = response.read()
                if favicon_data:
                    cache_path.write_bytes(favicon_data)
                    return str(cache_path)
        return None
    except:
        return None


def download_favicon_task(bookmark):
    """Task for parallel favicon download."""
    url = bookmark.get("url")
    if not url:
        return {"status": "failed"}

    cache_dir = get_favicon_cache_path()
    cache_path = cache_dir / get_favicon_filename(url)

    if cache_path.exists():
        return {"status": "cached"}

    if download_favicon(url, cache_path):
        return {"status": "downloaded"}

    return {"status": "failed"}


def find_firefox_profiles():
    """Find all Firefox profile directories."""
    if sys.platform == "win32":
        profile_base = (
            Path(os.environ.get("APPDATA", "")) / "Mozilla" / "Firefox" / "Profiles"
        )
    elif sys.platform == "darwin":
        profile_base = (
            Path.home() / "Library" / "Application Support" / "Firefox" / "Profiles"
        )
    else:
        profile_base = Path.home() / ".mozilla" / "firefox"

    if not profile_base.exists():
        return []

    return [
        p for p in profile_base.iterdir() if p.is_dir() and not p.name.startswith(".")
    ]


def find_active_profile():
    """Find the profile that contains places.sqlite."""
    for profile in find_firefox_profiles():
        if (profile / "places.sqlite").exists():
            return profile
    return None


def connect_to_db(places_db):
    """Connect to the Firefox database, trying different methods."""
    # Try immutable mode first (fastest, works with Firefox open)
    try:
        return sqlite3.connect(f"file:{places_db}?immutable=1", uri=True)
    except sqlite3.OperationalError:
        pass

    # Try read-only mode
    try:
        return sqlite3.connect(f"file:{places_db}?mode=ro", uri=True)
    except:
        pass

    # Last resort: temporary copy
    temp_db = places_db.parent / "places_temp.sqlite"
    shutil.copy2(places_db, temp_db)
    conn = sqlite3.connect(str(temp_db))
    import atexit

    atexit.register(lambda: temp_db.unlink(missing_ok=True))
    return conn


def get_bookmarks(profile_path):
    """Extract bookmarks from Firefox places.sqlite database."""
    places_db = profile_path / "places.sqlite"
    if not places_db.exists():
        raise FileNotFoundError(f"places.sqlite not found at {places_db}")

    conn = connect_to_db(places_db)

    # Use a single optimized query
    query = """
    SELECT b.id, b.title, p.url, b.dateAdded, b.lastModified, b.parent
    FROM moz_bookmarks b
    LEFT JOIN moz_places p ON b.fk = p.id
    WHERE b.type = 1 AND p.url IS NOT NULL
    ORDER BY b.id
    """

    bookmarks = []
    cache_dir = get_favicon_cache_path()

    # Batch process rows
    for row in conn.execute(query):
        url = row[2]

        # Quick favicon check
        favicon_local = ""
        favicon_fallback = ""

        if url:
            cache_path = cache_dir / get_favicon_filename(url)
            if cache_path.exists():
                favicon_local = f"file://{cache_path}"

            # Generate fallback URL
            try:
                domain = urlparse(url).netloc
                if domain:
                    favicon_fallback = (
                        f"https://www.google.com/s2/favicons?domain={domain}&sz=32"
                    )
            except:
                pass

        bookmarks.append(
            {
                "id": row[0],
                "title": row[1] or "Untitled",
                "url": url,
                "date_added": row[3],
                "last_modified": row[4],
                "parent_id": row[5],
                "favicon_local": favicon_local,
                "favicon_url": favicon_fallback,
                "has_cached_favicon": bool(favicon_local),
            }
        )

    conn.close()
    return bookmarks


def list_profiles():
    """List all Firefox profiles."""
    profiles = find_firefox_profiles()
    result = [
        {
            "name": profile.name,
            "path": str(profile),
            "has_places": (profile / "places.sqlite").exists(),
        }
        for profile in profiles
    ]
    print(json.dumps(result, indent=2))


def list_bookmarks():
    """List all bookmarks from active profile."""
    profile_path = find_active_profile()
    if not profile_path:
        print(json.dumps({"error": "No Firefox profile found"}, indent=2))
        sys.exit(1)

    try:
        bookmarks = get_bookmarks(profile_path)
        print(json.dumps(bookmarks, indent=2))
    except Exception as e:
        print(json.dumps({"error": str(e)}, indent=2))
        sys.exit(1)


def open_url(url):
    """Open URL in existing Firefox instance or new tab."""
    try:
        subprocess.run(["xdg-open", url], check=True, capture_output=True, timeout=5)
        print(json.dumps({"success": True, "url": url}, indent=2))
    except subprocess.TimeoutExpired:
        print(json.dumps({"success": True, "url": url}, indent=2))
    except (subprocess.CalledProcessError, FileNotFoundError):
        try:
            subprocess.Popen(
                ["firefox", url], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
            )
            print(json.dumps({"success": True, "url": url}, indent=2))
        except Exception as e:
            print(json.dumps({"success": False, "error": str(e)}, indent=2))
            sys.exit(1)
    except Exception as e:
        print(json.dumps({"success": False, "error": str(e)}, indent=2))
        sys.exit(1)


def fetch_all_favicons():
    """Download favicons for all bookmarks in parallel."""
    try:
        profile_path = find_active_profile()
        if not profile_path:
            print(json.dumps({"error": "No Firefox profile found"}, indent=2))
            sys.exit(1)

        bookmarks = get_bookmarks(profile_path)
        results = {"total": len(bookmarks), "downloaded": 0, "cached": 0, "failed": 0}

        # Use thread pool for parallel downloads (max 20 concurrent)
        with concurrent.futures.ThreadPoolExecutor(max_workers=20) as executor:
            futures = [
                executor.submit(download_favicon_task, bookmark)
                for bookmark in bookmarks
            ]

            for future in concurrent.futures.as_completed(futures):
                try:
                    result = future.result()
                    status = result.get("status", "failed")
                    results[status] = results.get(status, 0) + 1
                except:
                    results["failed"] += 1

        print(json.dumps(results, indent=2))
    except Exception as e:
        print(json.dumps({"error": str(e)}, indent=2))
        sys.exit(1)


def remove_bookmark(bookmark_id):
    """Remove a bookmark by ID from Firefox database."""
    try:
        profile_path = find_active_profile()
        if not profile_path:
            print(
                json.dumps(
                    {"success": False, "error": "No Firefox profile found"}, indent=2
                )
            )
            sys.exit(1)

        places_db = profile_path / "places.sqlite"
        if not places_db.exists():
            print(
                json.dumps(
                    {"success": False, "error": "places.sqlite not found"}, indent=2
                )
            )
            sys.exit(1)

        conn = sqlite3.connect(str(places_db))
        cursor = conn.cursor()

        cursor.execute(
            "SELECT id, title FROM moz_bookmarks WHERE id = ?", (bookmark_id,)
        )
        result = cursor.fetchone()

        if not result:
            conn.close()
            print(
                json.dumps(
                    {"success": False, "error": f"Bookmark {bookmark_id} not found"},
                    indent=2,
                )
            )
            sys.exit(1)

        bookmark_title = result[1] or "Untitled"
        cursor.execute("DELETE FROM moz_bookmarks WHERE id = ?", (bookmark_id,))
        conn.commit()
        conn.close()

        print(
            json.dumps(
                {
                    "success": True,
                    "id": bookmark_id,
                    "title": bookmark_title,
                    "message": f"Bookmark '{bookmark_title}' removed successfully",
                },
                indent=2,
            )
        )

    except sqlite3.OperationalError as e:
        error_msg = (
            "Database is locked. Please close Firefox and try again."
            if "locked" in str(e).lower()
            else str(e)
        )
        print(json.dumps({"success": False, "error": error_msg}, indent=2))
        sys.exit(1)
    except Exception as e:
        print(json.dumps({"success": False, "error": str(e)}, indent=2))
        sys.exit(1)


# Execute command
if len(sys.argv) < 2:
    print(
        "Usage: firefox-bookmarks.py {list|profiles|open <url>|fetch-favicons|remove <id>}",
        file=sys.stderr,
    )
    sys.exit(1)

command = sys.argv[1].lower()

if command == "list":
    list_bookmarks()
elif command == "profiles":
    list_profiles()
elif command == "open":
    if len(sys.argv) < 3:
        print("Error: open command requires URL", file=sys.stderr)
        sys.exit(1)
    open_url(sys.argv[2])
elif command == "fetch-favicons":
    fetch_all_favicons()
elif command == "remove":
    if len(sys.argv) < 3:
        print("Error: remove command requires bookmark ID", file=sys.stderr)
        sys.exit(1)
    try:
        remove_bookmark(int(sys.argv[2]))
    except ValueError:
        print(json.dumps({"success": False, "error": "Invalid bookmark ID"}, indent=2))
        sys.exit(1)
else:
    print(f"Error: Unknown command '{command}'", file=sys.stderr)
    sys.exit(1)
