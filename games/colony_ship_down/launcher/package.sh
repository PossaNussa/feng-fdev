#!/usr/bin/env bash
# Build the Colony Ship Down launcher folder (+ zip) from a built engine.
#
#   launcher/package.sh <engine_root> <binary> <out_dir> [dll_dir...]
#
#   engine_root  the engine checkout (has builtin/, client/shaders, textures/, fonts/)
#   binary       the built luanti / luanti.exe
#   out_dir      where ColonyShipDown/ and the zip go
#   dll_dir      (Windows) files to copy next to the exe, e.g. MinGW DLLs
#
# The layout is flat (ColonyShipDown.exe next to builtin/); the engine finds
# its data next to the exe (porting.cpp "flat portable layout").
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENGINE="$1"; BIN="$2"; OUT="$3"; shift 3
PKG="$OUT/ColonyShipDown"
rm -rf "$PKG"; mkdir -p "$PKG"

ext=""; [[ "$BIN" == *.exe ]] && ext=".exe"
cp "$BIN" "$PKG/ColonyShipDown$ext"
chmod +x "$PKG/ColonyShipDown$ext"
for f in "$@"; do cp "$f" "$PKG/"; done

cp -r "$ENGINE/builtin" "$PKG/"
mkdir -p "$PKG/client"; cp -r "$ENGINE/client/shaders" "$PKG/client/"
mkdir -p "$PKG/textures"; cp -r "$ENGINE/textures/base" "$PKG/textures/"
for d in fonts locale; do [ -d "$ENGINE/$d" ] && cp -r "$ENGINE/$d" "$PKG/"; done

# Our main menu replaces the engine's (kept as init_luanti.lua for reference)
mv "$PKG/builtin/mainmenu/init.lua" "$PKG/builtin/mainmenu/init_luanti.lua"
cp "$HERE/mainmenu/init.lua" "$HERE/mainmenu/csd_menu_bg.png" "$HERE/mainmenu/csd_header.png" "$PKG/builtin/mainmenu/"

cp "$HERE/client.conf" "$PKG/minetest.conf"
cp "$HERE/README.txt" "$PKG/README.txt"
for f in LICENSE.txt COPYING.LESSER; do [ -f "$ENGINE/$f" ] && cp "$ENGINE/$f" "$PKG/ENGINE-$f"; done
mkdir -p "$PKG/worlds" "$PKG/games"   # empty: this build only joins servers

( cd "$OUT" && rm -f ColonyShipDown.zip && (command -v zip >/dev/null && zip -qr ColonyShipDown.zip ColonyShipDown \
	|| python3 -c "import shutil; shutil.make_archive('ColonyShipDown', 'zip', '.', 'ColonyShipDown')") )
echo "Built $PKG and $OUT/ColonyShipDown.zip"
