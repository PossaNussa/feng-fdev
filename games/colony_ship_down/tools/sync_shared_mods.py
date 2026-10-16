#!/usr/bin/env python3
"""Keep the mods Colony Ship Down shares with ffadventure in sync.

ffadventure is the source of truth. The mods named in shared_mods.txt are
copied from games/ffadventure/mods/<name> into
games/colony_ship_down/mods/ffa_shared/<name>.

    sync_shared_mods.py status            what differs, and on which side
    sync_shared_mods.py pull [mod ...]    ffadventure -> CSD (all listed mods by default)
    sync_shared_mods.py push mod [...]    CSD -> ffadventure, for fixes made in CSD

Manifest entries are folder names in games/ffadventure/mods, or
"modpack/mod" to take a single mod out of a modpack.
    sync_shared_mods.py deps              check every hard dependency resolves inside CSD

A small state file (mods/ffa_shared/.sync_state.json) remembers the content hash
of each mod at the last sync, so `status` can tell "changed in ffadventure"
from "changed in CSD" from "changed on both sides". pull/push refuse to
overwrite a side that has its own unsynced edits unless --force is given.
"""

import argparse
import hashlib
import json
import os
import re
import shutil
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
GAME = os.path.dirname(HERE)
GAMES = os.path.dirname(GAME)
FFA_MODS = os.path.join(GAMES, "ffadventure", "mods")
SHARED = os.path.join(GAME, "mods", "ffa_shared")
CSD_OWN = os.path.join(GAME, "mods", "csd")
MANIFEST = os.path.join(GAME, "shared_mods.txt")
STATE = os.path.join(SHARED, ".sync_state.json")

IGNORE_DIRS = {".git", "__pycache__", ".github"}
IGNORE_FILES = {".DS_Store"}


def src_path(entry):
    """Manifest entries are mod folders, or "modpack/mod" for one mod out of a modpack."""
    return os.path.join(FFA_MODS, *entry.split("/"))


def dst_path(entry):
    return os.path.join(SHARED, entry.split("/")[-1])


def read_manifest():
    names = []
    with open(MANIFEST, encoding="utf-8") as f:
        for line in f:
            line = line.split("#", 1)[0].strip()
            if line:
                names.append(line)
    return names


def walk_files(root):
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = sorted(d for d in dirnames if d not in IGNORE_DIRS)
        for fn in sorted(filenames):
            if fn in IGNORE_FILES or fn.endswith((".pyc", ".bak", "~")):
                continue
            yield os.path.join(dirpath, fn)


def tree_hash(root):
    if not os.path.isdir(root):
        return None
    h = hashlib.sha1()
    for path in walk_files(root):
        rel = os.path.relpath(path, root).replace(os.sep, "/")
        h.update(rel.encode())
        h.update(b"\0")
        with open(path, "rb") as f:
            h.update(hashlib.sha1(f.read()).digest())
    return h.hexdigest()


def load_state():
    try:
        with open(STATE, encoding="utf-8") as f:
            return json.load(f)
    except (OSError, ValueError):
        return {}


def save_state(state):
    os.makedirs(SHARED, exist_ok=True)
    with open(STATE, "w", encoding="utf-8") as f:
        json.dump(state, f, indent=1, sort_keys=True)
        f.write("\n")


def copy_tree(src, dst):
    if os.path.islink(dst) or os.path.isfile(dst):
        os.remove(dst)
    elif os.path.isdir(dst):
        shutil.rmtree(dst)
    shutil.copytree(src, dst, symlinks=False,
                    ignore=shutil.ignore_patterns(*IGNORE_DIRS, *IGNORE_FILES, "*.pyc", "*.bak"))


def classify(name, state):
    ffa = tree_hash(src_path(name))
    csd = tree_hash(dst_path(name))
    last = state.get(name)
    if ffa is None:
        return "missing-in-ffadventure", ffa, csd
    if csd is None:
        return "not-pulled", ffa, csd
    if ffa == csd:
        return "in-sync", ffa, csd
    if last is None:
        return "differs (no sync record)", ffa, csd
    if csd == last:
        return "changed-in-ffadventure", ffa, csd
    if ffa == last:
        return "changed-in-csd", ffa, csd
    return "CHANGED-ON-BOTH-SIDES", ffa, csd


def cmd_status(args):
    state = load_state()
    names = read_manifest()
    counts = {}
    for name in names:
        status, _, _ = classify(name, state)
        counts[status] = counts.get(status, 0) + 1
        if status != "in-sync" or args.verbose:
            print(f"{status:28} {name}")
    extra = sorted(set(os.listdir(SHARED)) - {n.split("/")[-1] for n in names} - {".sync_state.json", "modpack.conf"}) \
        if os.path.isdir(SHARED) else []
    for name in extra:
        print(f"{'not-in-manifest':28} {name}")
    print("; ".join(f"{v} {k}" for k, v in sorted(counts.items())))


def cmd_pull(args):
    state = load_state()
    names = args.mods or read_manifest()
    manifest = set(read_manifest())
    rc = 0
    for name in names:
        if name not in manifest:
            print(f"skip {name}: not in shared_mods.txt (add it there first)")
            rc = 1
            continue
        status, ffa, _ = classify(name, state)
        if status == "missing-in-ffadventure":
            print(f"skip {name}: no such mod in ffadventure")
            rc = 1
            continue
        if status in ("changed-in-csd", "CHANGED-ON-BOTH-SIDES") and not args.force:
            print(f"skip {name}: CSD copy has its own edits ({status}); push them or use --force")
            rc = 1
            continue
        if status != "in-sync":
            copy_tree(src_path(name), dst_path(name))
            print(f"pulled {name}")
        state[name] = ffa
    # Mods dropped from the manifest are removed from the CSD copy.
    if not args.mods:
        keep = {n.split("/")[-1] for n in manifest}
        for name in sorted(os.listdir(SHARED)):
            path = os.path.join(SHARED, name)
            if os.path.isdir(path) and name not in keep:
                shutil.rmtree(path)
                print(f"removed {name} (no longer in shared_mods.txt)")
        for name in list(state):
            if name not in manifest:
                state.pop(name)
    write_modpack_conf()
    save_state(state)
    return rc


def cmd_push(args):
    state = load_state()
    rc = 0
    for name in args.mods:
        status, _, csd = classify(name, state)
        if csd is None:
            print(f"skip {name}: not present in CSD")
            rc = 1
            continue
        if status in ("changed-in-ffadventure", "CHANGED-ON-BOTH-SIDES") and not args.force:
            print(f"skip {name}: ffadventure copy has newer edits ({status}); pull first or use --force")
            rc = 1
            continue
        if status != "in-sync":
            copy_tree(dst_path(name), src_path(name))
            print(f"pushed {name} -> ffadventure")
        state[name] = csd
    save_state(state)
    return rc


def write_modpack_conf():
    os.makedirs(SHARED, exist_ok=True)
    with open(os.path.join(SHARED, "modpack.conf"), "w", encoding="utf-8") as f:
        f.write("name = ffa_shared\n"
                "title = ffadventure shared mods\n"
                "description = Mods copied from ffadventure by tools/sync_shared_mods.py. "
                "Edit them in ffadventure, not here.\n")


# --- dependency check -------------------------------------------------------

def parse_conf(path):
    out = {}
    try:
        with open(path, encoding="utf-8", errors="replace") as f:
            text = f.read()
    except OSError:
        return out
    # Support the """ multi-line values some mods use.
    for m in re.finditer(r'^\s*(\w+)\s*=\s*(?:"""(.*?)"""|(.*))$', text, re.M | re.S):
        out[m.group(1)] = (m.group(2) if m.group(2) is not None else m.group(3) or "").strip()
    return out


def find_mods(root):
    """Yield (modname, path, conf) for every mod under root (recursing modpacks)."""
    if not os.path.isdir(root):
        return
    for entry in sorted(os.listdir(root)):
        path = os.path.join(root, entry)
        if not os.path.isdir(path) or entry.startswith("."):
            continue
        if os.path.isfile(os.path.join(path, "modpack.conf")) or os.path.isfile(os.path.join(path, "modpack.txt")):
            yield from find_mods(path)
        elif os.path.isfile(os.path.join(path, "init.lua")):
            conf = parse_conf(os.path.join(path, "mod.conf"))
            yield conf.get("name") or entry, path, conf


def split_deps(value):
    return [d.strip() for d in re.split(r"[,\s]+", value or "") if d.strip()]


def cmd_deps(args):
    mods = {}
    for root in (SHARED, CSD_OWN):
        for name, path, conf in find_mods(root):
            mods[name] = (path, conf)
    missing = 0
    for name, (path, conf) in sorted(mods.items()):
        for dep in split_deps(conf.get("depends")):
            if dep not in mods:
                print(f"{name}: missing hard dependency '{dep}'  ({os.path.relpath(path, GAME)})")
                missing += 1
    print(f"{len(mods)} mods, {missing} missing hard dependencies")
    return 1 if missing else 0


def main():
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = p.add_subparsers(dest="cmd", required=True)
    s = sub.add_parser("status")
    s.add_argument("-v", "--verbose", action="store_true", help="also list mods that are in sync")
    s = sub.add_parser("pull")
    s.add_argument("mods", nargs="*")
    s.add_argument("--force", action="store_true")
    s = sub.add_parser("push")
    s.add_argument("mods", nargs="+")
    s.add_argument("--force", action="store_true")
    sub.add_parser("deps")
    args = p.parse_args()
    return {"status": cmd_status, "pull": cmd_pull, "push": cmd_push, "deps": cmd_deps}[args.cmd](args) or 0


if __name__ == "__main__":
    sys.exit(main())
