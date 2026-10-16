#!/usr/bin/env python3
"""Build csd_create's models and atlas texture (original art, safe to release).

    python3 games/colony_ship_down/tools/make_create_assets.py

Writes mods/csd/csd_create/models/*.glb and textures/csd_create_*.png.
The look is "Create-ish" (chunky brass, steel and orange machinery) but every
model and pixel is generated here; nothing comes from the Create mod.
"""

import math
import os
import random
import sys

from PIL import Image, ImageDraw

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from meshlib import Atlas, Mesh, compose, rot_x, rot_z, write_glb  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
MOD = os.path.join(os.path.dirname(HERE), "mods", "csd", "csd_create")
MODELS = os.path.join(MOD, "models")
TEX = os.path.join(MOD, "textures")

# -- atlas ---------------------------------------------------------------------

ATLAS_SIZE = 64
atlas = Atlas(ATLAS_SIZE)
MATS = [
    "steel", "dark", "brass", "copper",
    "glow", "hazard", "grille", "glass",
    "rubber", "orange", "panel", "glow_orange",
    "dial", "red", "plate", "shaft",
]
for i, m in enumerate(MATS):
    atlas.add(m, (i % 4) * 16, (i // 4) * 16, 16, 16)


def paint_atlas(path, cell_glow=1.0):
    rnd = random.Random(7)
    img = Image.new("RGBA", (ATLAS_SIZE, ATLAS_SIZE))
    d = ImageDraw.Draw(img)

    def cell(name):
        x, y, _, _ = atlas.rects[name]
        return x, y

    def noisy(name, base, var=10, border=None, rivets=False):
        x, y = cell(name)
        for i in range(16):
            for j in range(16):
                n = rnd.randint(-var, var)
                img.putpixel((x + i, y + j), tuple(max(0, min(255, c + n)) for c in base) + (255,))
        if border:
            d.rectangle([x, y, x + 15, y + 15], outline=border)
        if rivets:
            for (i, j) in ((2, 2), (13, 2), (2, 13), (13, 13)):
                img.putpixel((x + i, y + j), (230, 230, 230, 255))
                img.putpixel((x + i + 1, y + j + 1), (60, 60, 70, 255))

    noisy("steel", (150, 158, 170), 8, border=(100, 106, 118), rivets=True)
    noisy("dark", (58, 62, 74), 6, border=(36, 38, 46))
    noisy("brass", (196, 156, 72), 10, border=(140, 104, 40))
    noisy("copper", (196, 110, 70), 10, border=(130, 70, 40))
    noisy("panel", (205, 210, 218), 5, border=(150, 156, 168), rivets=True)
    noisy("plate", (110, 116, 128), 7, border=(80, 84, 96), rivets=True)
    noisy("rubber", (30, 30, 34), 4)
    noisy("orange", (224, 128, 36), 8, border=(160, 84, 20))
    noisy("red", (190, 40, 40), 8, border=(120, 20, 20))

    # shaft: long highlight stripes
    x, y = cell("shaft")
    for i in range(16):
        shade = 120 + int(60 * (1 - abs(i - 6) / 8))
        d.line([x + i, y, x + i, y + 15], fill=(shade, shade + 4, shade + 12, 255))
    # glows
    for name, col in (("glow", (90, 230, 255)), ("glow_orange", (255, 170, 60))):
        x, y = cell(name)
        k = cell_glow if name == "glow" else 1.0
        for i in range(16):
            for j in range(16):
                f = 0.75 + 0.25 * rnd.random()
                img.putpixel((x + i, y + j), tuple(int(c * f * k) for c in col) + (255,))
    # hazard stripes
    x, y = cell("hazard")
    for i in range(16):
        for j in range(16):
            on = ((i + j) // 4) % 2 == 0
            img.putpixel((x + i, y + j), (235, 190, 40, 255) if on else (30, 30, 30, 255))
    # grille
    x, y = cell("grille")
    d.rectangle([x, y, x + 15, y + 15], fill=(40, 44, 52, 255))
    for j in range(1, 16, 3):
        d.line([x + 1, y + j, x + 14, y + j], fill=(16, 16, 20, 255))
    d.rectangle([x, y, x + 15, y + 15], outline=(90, 96, 108, 255))
    # glass
    x, y = cell("glass")
    d.rectangle([x, y, x + 15, y + 15], fill=(40, 70, 90, 255))
    d.line([x + 3, y + 12, x + 12, y + 3], fill=(120, 170, 200, 255))
    # dial face
    x, y = cell("dial")
    d.rectangle([x, y, x + 15, y + 15], fill=(40, 40, 46, 255))
    d.ellipse([x + 1, y + 1, x + 14, y + 14], fill=(232, 228, 210, 255), outline=(120, 100, 60, 255))
    d.pieslice([x + 2, y + 2, x + 13, y + 13], 200, 250, fill=(110, 200, 110, 255))
    d.pieslice([x + 2, y + 2, x + 13, y + 13], 290, 340, fill=(220, 80, 60, 255))
    d.ellipse([x + 4, y + 4, x + 11, y + 11], fill=(232, 228, 210, 255))
    img.save(path)


# -- models --------------------------------------------------------------------

def M():
    return Mesh(atlas)


def hand_crank():
    base = M()
    base.cylinder(0.22, 0.3, 0.5, "dark", "plate", seg=10)          # bearing housing against the shaft
    base.box(-0.3, -0.3, 0.42, 0.3, 0.3, 0.5, "plate")             # mounting plate
    rotor = M()
    rotor.cylinder(0.08, -0.05, 0.45, "shaft", seg=8)
    rotor.box(-0.06, -0.06, -0.14, 0.38, 0.06, -0.04, "brass")     # arm
    rotor.cylinder(0.06, -0.45, -0.1, "rubber", seg=8, center=(0.33, 0, 0))  # handle
    return [(base, None), (rotor, ("spin", "z"))]


def turbine():
    frame = M()
    t = 0.12
    for sx in (-1, 1):
        for sy in (-1, 1):
            x0, x1 = (0.5 - t, 0.5) if sx > 0 else (-0.5, -0.5 + t)
            y0, y1 = (0.5 - t, 0.5) if sy > 0 else (-0.5, -0.5 + t)
            frame.box(x0, y0, -0.5, x1, y1, 0.5, "steel")  # corner posts
    frame.box(-0.5, -0.5, -0.38, 0.5, -0.38, 0.38, "plate")           # floor plate
    frame.box(-0.5, 0.38, -0.38, 0.5, 0.5, 0.38, "plate", top="hazard")  # roof
    for sx in (-1, 1):
        frame.box(sx * 0.44 - 0.04, -0.38, -0.38, sx * 0.44 + 0.04, 0.38, 0.38, "grille")  # side vents
    for sz in (-1, 1):
        frame.ring(0.24, 0.38, sz * 0.47 - 0.03, sz * 0.47 + 0.03, "orange", seg=16)       # end flanges
    rotor = M()
    rotor.cylinder(0.1, -0.5, 0.5, "shaft", seg=8)
    rotor.cylinder(0.16, -0.18, 0.18, "brass", seg=12)
    for k in range(8):
        rotor.box(0.12, -0.035, -0.14, 0.34, 0.035, 0.14, "glow", transform=compose(rot_x(0), rot_z(k * 45 + 10)))
    rotor.ring(0.33, 0.36, -0.16, 0.16, "glow_orange", seg=16)
    return [(frame, None), (rotor, ("spin", "z"))]


def encased_fan():
    casing = M()
    casing.box(-0.5, -0.5, -0.1, 0.5, 0.5, 0.5, "steel", front="plate", back="plate")
    casing.ring(0.36, 0.5, -0.5, -0.1, "orange", face="orange", seg=16)
    casing.box(-0.42, -0.04, -0.46, 0.42, 0.04, -0.42, "dark")        # front guard bars
    casing.box(-0.04, -0.42, -0.46, 0.04, 0.42, -0.42, "dark")
    rotor = M()
    rotor.cylinder(0.1, -0.35, 0.5, "shaft", seg=8)
    rotor.cylinder(0.12, -0.38, -0.25, "brass", seg=10)
    for k in range(5):
        rotor.box(0.08, -0.07, -0.33, 0.34, 0.07, -0.29, "panel", transform=compose(rot_x(-25), rot_z(k * 72)))
    return [(casing, None), (rotor, ("spin", "z"))]


def flywheel():
    rotor = M()
    rotor.cylinder(0.11, -0.5, 0.5, "shaft", seg=8)
    rotor.cylinder(0.2, -0.16, 0.16, "dark", "brass", seg=12)
    for k in range(6):
        rotor.box(0.18, -0.06, -0.08, 0.95, 0.06, 0.08, "steel", transform=rot_z(k * 60))
    rotor.ring(0.92, 1.18, -0.14, 0.14, "brass", face="copper", seg=32)
    return [(rotor, ("spin", "z"))]


def gauge():
    body = M()
    body.box(-0.32, -0.32, -0.32, 0.32, 0.32, 0.32, "dark", top="plate", bottom="plate")
    for sx in (-1, 1):
        x0, x1 = (0.32, 0.36) if sx > 0 else (-0.36, -0.32)
        body.box(x0, -0.28, -0.28, x1, 0.28, 0.28, "brass", side="dial")
    body.cylinder(0.09, -0.5, -0.32, "shaft", seg=8, caps=False)
    body.cylinder(0.09, 0.32, 0.5, "shaft", seg=8, caps=False)
    return [(body, None)]


def gauge_needle():
    needle = M()
    for sx in (-1, 1):
        x0, x1 = (0.365, 0.38) if sx > 0 else (-0.38, -0.365)
        needle.box(x0, -0.025, -0.025, x1, 0.22, 0.025, "red")
    return [(needle, ("dial", "x", 120))]


def press():
    frame = M()
    frame.box(-0.5, 0.05, -0.5, 0.5, 0.5, 0.5, "orange", top="hazard", bottom="dark")
    frame.box(-0.5, -0.5, -0.5, -0.36, 0.05, -0.36, "steel")
    frame.box(0.36, -0.5, -0.5, 0.5, 0.05, -0.36, "steel")
    frame.box(-0.5, -0.5, 0.36, -0.36, 0.05, 0.5, "steel")
    frame.box(0.36, -0.5, 0.36, 0.5, 0.05, 0.5, "steel")
    head = M()
    head.cylinder(0.12, 0.05, -0.32, "shaft", seg=8, axis="y")
    head.box(-0.34, -0.46, -0.34, 0.34, -0.3, 0.34, "steel", bottom="plate")
    return [(frame, None), (head, ("stroke", (0, -0.62, 0)))]


def depot():
    m = M()
    m.box(-0.5, -0.5, -0.5, 0.5, -0.25, 0.5, "dark", top="plate")
    m.box(-0.5, -0.25, -0.5, 0.5, -0.15, -0.42, "orange")
    m.box(-0.5, -0.25, 0.42, 0.5, -0.15, 0.5, "orange")
    m.box(-0.5, -0.25, -0.42, -0.42, -0.15, 0.42, "orange")
    m.box(0.42, -0.25, -0.42, 0.5, -0.15, 0.42, "orange")
    return [(m, None)]


def capacitor():
    m = M()
    m.box(-0.5, -0.5, -0.5, 0.5, -0.3, 0.5, "plate")
    m.box(-0.5, 0.3, -0.5, 0.5, 0.5, 0.5, "plate", top="hazard")
    for x in (-0.25, 0.25):
        for z in (-0.2, 0.2):
            m.cylinder(0.15, -0.3, 0.3, "glow", "glow", seg=10, axis="y", center=(x, 0, z))
    m.cylinder(0.1, 0.3, 0.5, "shaft", seg=8)          # input shaft stub out the back (+Z)
    m.box(-0.06, -0.3, -0.5, 0.06, 0.3, -0.44, "brass")  # front bus bar
    return [(m, None)]


def pump():
    casing = M()
    casing.box(-0.4, -0.4, -0.4, 0.4, 0.4, 0.4, "steel", front="glass", back="plate")
    for sx in (-1, 1):
        casing.cylinder(0.16, 0.0, 0.1, "copper", seg=10, axis="x", center=(sx * 0.4 + (0.0 if sx > 0 else -0.1), 0, 0))
        casing.ring(0.12, 0.2, 0.0, 0.06, "brass", seg=12, axis="x", center=(sx * 0.48, 0, 0))
    casing.box(-0.45, -0.5, -0.45, 0.45, -0.4, 0.45, "dark")
    rotor = M()
    rotor.cylinder(0.08, -0.38, 0.5, "shaft", seg=8)
    for k in range(6):
        rotor.box(0.06, -0.03, -0.3, 0.32, 0.03, 0.3, "orange", transform=rot_z(k * 60 + 15))
    return [(casing, None), (rotor, ("spin", "z"))]


def sprinkler():
    base = M()
    base.cylinder(0.14, 0.15, 0.5, "dark", "plate", seg=10)       # pedestal towards the shaft
    base.cylinder(0.22, 0.42, 0.5, "steel", "plate", seg=12)
    rotor = M()
    rotor.cylinder(0.07, -0.1, 0.5, "shaft", seg=8)
    rotor.cylinder(0.12, -0.12, 0.05, "brass", seg=10)
    for k in range(3):
        rotor.box(0.08, -0.03, -0.06, 0.42, 0.03, 0.0, "copper", transform=rot_z(k * 120))
        rotor.cylinder(0.05, -0.16, -0.02, "glow", seg=6, center=(0.42 * math.cos(math.radians(k * 120)),
                                                                0.42 * math.sin(math.radians(k * 120)), 0))
    return [(base, None), (rotor, ("spin", "z"))]


MODELS_TO_BUILD = {
    "csd_create_pump.glb": pump,
    "csd_create_sprinkler.glb": sprinkler,
    "csd_create_hand_crank.glb": hand_crank,
    "csd_create_turbine.glb": turbine,
    "csd_create_encased_fan.glb": encased_fan,
    "csd_create_flywheel.glb": flywheel,
    "csd_create_gauge.glb": gauge,
    "csd_create_gauge_needle.glb": gauge_needle,
    "csd_create_press.glb": press,
    "csd_create_depot.glb": depot,
    "csd_create_capacitor.glb": capacitor,
}


def split_static(parts):
    """Static parts go in a node mesh, animated ones in an entity mesh."""
    static = [(m, None) for m, a in parts if a is None]
    moving = [(m, a) for m, a in parts if a is not None]
    return static, moving


def inventory_icon(path, draw):
    img = Image.new("RGBA", (32, 32), (0, 0, 0, 0))
    draw(ImageDraw.Draw(img))
    img.save(path)


def main():
    os.makedirs(MODELS, exist_ok=True)
    os.makedirs(TEX, exist_ok=True)
    paint_atlas(os.path.join(TEX, "csd_create_atlas.png"))
    for level in range(4):
        paint_atlas(os.path.join(TEX, "csd_create_atlas_charge%d.png" % level), cell_glow=0.25 + 0.25 * level)

    for fname, builder in MODELS_TO_BUILD.items():
        parts = builder()
        static, moving = split_static(parts)
        stem = fname[:-4]
        if static and moving:
            write_glb(os.path.join(MODELS, stem + "_base.glb"), static)
            write_glb(os.path.join(MODELS, stem + "_rotor.glb"), moving)
        else:
            write_glb(os.path.join(MODELS, fname), static or moving)

    # Inventory images for parts drawn only by entities.
    def fly(d):
        d.ellipse([2, 2, 29, 29], outline=(196, 156, 72, 255), width=4)
        for a in range(0, 360, 60):
            import math
            d.line([16, 16, 16 + 12 * math.cos(math.radians(a)), 16 + 12 * math.sin(math.radians(a))],
                   fill=(150, 158, 170, 255), width=2)
        d.ellipse([12, 12, 20, 20], fill=(58, 62, 74, 255))
    inventory_icon(os.path.join(TEX, "csd_create_flywheel_inv.png"), fly)
    print("wrote", len(MODELS_TO_BUILD), "models")


if __name__ == "__main__":
    main()
