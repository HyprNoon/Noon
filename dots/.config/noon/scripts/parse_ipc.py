#!/usr/bin/env python3
import subprocess, json, sys, os, re

def parse_fn(line):
    m = re.match(r"function (\w+)\((.*?)\):\s*(\S+)", line)
    if not m:
        return None
    name, args_str, ret = m.group(1), m.group(2), m.group(3)
    args = []
    if args_str.strip():
        for a in args_str.split(","):
            parts = a.strip().split(": ")
            args.append({"name": parts[0], "type": parts[1]} if len(parts) == 2 else {"name": parts[0], "type": "any"})
    return name, {"arguments": args, "return": ret}

def main():
    config = os.environ.get("SHELL_PATH", "")
    cmd = ["qs", "-p", config, "ipc", "show"] if config else ["qs", "ipc", "show"]

    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        print(json.dumps({"error": result.stderr.strip() or result.stdout.strip() or "Unknown error", "returncode": result.returncode}, indent=2))
        sys.exit(1)

    targets = {}
    current = None
    for line in result.stdout.splitlines():
        if line.startswith("target "):
            current = line.removeprefix("target ").strip()
            targets[current] = {}
        elif current and line.startswith("  function "):
            parsed = parse_fn(line.strip())
            if parsed:
                targets[current][parsed[0]] = parsed[1]

    print(json.dumps(targets, indent=2))

if __name__ == "__main__":
    main()
