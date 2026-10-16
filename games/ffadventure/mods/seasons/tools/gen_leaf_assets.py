#!/usr/bin/env python3
"""Generate the seasonal leaf base tiles and palettes for mods/seasons.

Luanti node palettes MULTIPLY the tile, so the base tile must be a bright
greyscale for the palette to have headroom to reach saturated colours. The
originals are far too dark and saturated to desaturate at runtime with [hsl:
apple's HSL lightness maxes at 64 while its green channel reaches 127, and
multiply can only darken.

So: bake a normalised greyscale base per species, then solve each palette entry
so that mean(base) * palette / 255 lands on the wanted colour.

Palette index == param2. Index 0 must be the summer look, because every dtrees
growth rule calls set_node() without a param2 field, which forces param2 = 0 --
so freshly grown leaves appear at index 0 in every season.
"""
import os
from PIL import Image

MODS = "/root/Documents/luanti-fdev-master/games/ffadventure/mods"
OUT = os.path.join(MODS, "seasons", "textures")

SRC = {
    "apple":  f"{MODS}/dtrees/textures/dt_apple_tree_leaves.png",
    "aspen":  f"{MODS}/dtrees/textures/dt_aspen_tree_leaves.png",
    "acacia": f"{MODS}/dtrees/textures/dt_acacia_tree_leaves.png",
    "sakura": f"{MODS}/cherrytree/textures/dt_sakura_tree_leaves.png",
}

# Keyframes: (foliage_stage 0..1, RGB). Stage 0 is summer, stage 1 is deep winter.
#
# apple/acacia keep their shipped green at stage 0, so with seasons disabled or
# before the repaint ABM runs, they look exactly as they do today.
#
# aspen is the interesting one: dtrees ships it ALREADY gold, so today it looks
# autumnal in midsummer. We give it a proper summer green and let it reach
# roughly its shipped gold at peak autumn -- strictly more correct year-round.
#
# sakura is a blossom texture, pink rather than green. It holds its blossom
# through spring and summer and only browns in autumn, so this can only add to
# how the game looks today, never regress it.
RAMPS = {
    "apple": [
        (0.00, (28, 93, 0)),      # shipped deep green
        (0.35, (86, 116, 12)),    # yellowing
        (0.60, (190, 140, 40)),   # gold
        (0.80, (162, 96, 34)),    # russet
        (1.00, (104, 71, 40)),    # dead brown
    ],
    "aspen": [
        (0.00, (58, 118, 34)),    # summer green (dtrees ships gold; this is the fix)
        (0.35, (140, 150, 40)),   # turning
        (0.60, (239, 174, 62)),   # its shipped gold, at peak autumn
        (0.80, (198, 126, 44)),   # deep amber
        (1.00, (112, 78, 40)),    # dead brown
    ],
    "acacia": [
        (0.00, (98, 132, 75)),    # shipped olive-green
        (0.35, (132, 138, 68)),   # drying
        (0.60, (156, 116, 56)),   # russet
        (0.80, (132, 96, 52)),
        (1.00, (100, 76, 48)),    # dead brown
    ],
    "sakura": [
        (0.00, (145, 107, 132)),  # shipped blossom pink
        (0.45, (145, 107, 132)),  # hold blossom through spring and summer
        (0.65, (176, 122, 96)),   # dusty rose to tan
        (0.85, (142, 100, 70)),
        (1.00, (110, 82, 62)),    # dead brown
    ],
}

BASE_PEAK = 250.0  # brightest greyscale value in the baked base tile


def lerp(a, b, t):
    return a + (b - a) * t


def sample_ramp(keys, t):
    if t <= keys[0][0]:
        return keys[0][1]
    for i in range(len(keys) - 1):
        a, b = keys[i], keys[i + 1]
        if a[0] <= t <= b[0]:
            span = b[0] - a[0]
            u = 0.0 if span <= 0 else (t - a[0]) / span
            return tuple(lerp(a[1][c], b[1][c], u) for c in range(3))
    return keys[-1][1]


os.makedirs(OUT, exist_ok=True)
report = []

for name, path in SRC.items():
    im = Image.open(path).convert("RGBA")
    w, h = im.size
    px = list(im.getdata())

    # HSL lightness, matching how a desaturate would read the texture.
    lum = [(max(p[:3]) + min(p[:3])) / 2 for p in px]
    opaque = [lum[i] for i, p in enumerate(px) if p[3] > 128]
    lmax = max(opaque) if opaque else 255.0

    scale = BASE_PEAK / lmax
    base_px = []
    for i, p in enumerate(px):
        v = int(round(min(255.0, lum[i] * scale)))
        base_px.append((v, v, v, p[3]))

    base = Image.new("RGBA", (w, h))
    base.putdata(base_px)
    base.save(os.path.join(OUT, f"seasons_leaf_{name}.png"))

    base_mean = sum(q[0] for i, q in enumerate(base_px) if px[i][3] > 128) / max(1, len(opaque))

    # Palette: 16x16, read row-major, so index == param2.
    pal = Image.new("RGBA", (16, 16))
    pdata = []
    worst = 1.0
    for idx in range(256):
        target = sample_ramp(RAMPS[name], idx / 255.0)
        # A palette multiplies, so the brightest reachable colour is base_mean.
        # Where a target exceeds that, scale the whole triple down rather than
        # letting one channel clip -- that preserves the hue exactly and only
        # costs a little brightness.
        peak = max(target)
        if peak > base_mean:
            k = base_mean / peak
            target = tuple(c * k for c in target)
            worst = min(worst, k)
        entry = tuple(
            max(0, min(255, int(round(255.0 * target[c] / base_mean))))
            for c in range(3)
        )
        pdata.append((entry[0], entry[1], entry[2], 255))
    pal.putdata(pdata)
    pal.save(os.path.join(OUT, f"seasons_leaf_{name}_palette.png"))

    # Verify: simulate the multiply at index 0 and compare with the original.
    p0 = pdata[0]
    got = tuple(base_mean * p0[c] / 255.0 for c in range(3))
    orig_mean = tuple(
        sum(p[c] for p in px if p[3] > 128) / max(1, len(opaque)) for c in range(3)
    )
    s0 = sample_ramp(RAMPS[name], 0.0)
    err = max(abs(got[c] - s0[c]) for c in range(3))
    report.append(
        f"{name:7s} {w}x{h}  base_mean={base_mean:5.1f}  "
        f"idx0 want=({s0[0]:3.0f},{s0[1]:3.0f},{s0[2]:3.0f}) "
        f"got=({got[0]:3.0f},{got[1]:3.0f},{got[2]:3.0f}) err={err:.1f}  "
        f"brightness_headroom={worst*100:.0f}%"
    )

print("\n".join(report))
