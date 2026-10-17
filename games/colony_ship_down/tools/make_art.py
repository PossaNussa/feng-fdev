#!/usr/bin/env python3
"""Generate Colony Ship Down's textures, skybox, menu art and sounds.

    python3 games/colony_ship_down/tools/make_art.py

Everything is procedural and original (PIL for images, a tiny synth +
oggenc for sounds), so it can be released with the game. Re-running gives
the same output (fixed random seeds). csd_create's model atlas is made by
make_create_assets.py instead.
"""

import math
import os
import random
import shutil
import struct
import subprocess
import tempfile
import wave

from PIL import Image, ImageDraw, ImageFilter

HERE = os.path.dirname(os.path.abspath(__file__))
GAME = os.path.dirname(HERE)
MODS = os.path.join(GAME, "mods", "csd")


def out(mod, name):
    d = os.path.join(MODS, mod, "textures")
    os.makedirs(d, exist_ok=True)
    return os.path.join(d, name)


def clamp(v):
    return max(0, min(255, int(v)))


def noise_fill(img, base, var, rnd, box=None):
    x0, y0, x1, y1 = box or (0, 0, img.width, img.height)
    for x in range(x0, x1):
        for y in range(y0, y1):
            n = rnd.randint(-var, var)
            img.putpixel((x, y), tuple(clamp(c + n) for c in base[:3]) + (base[3] if len(base) > 3 else 255,))


def panel(base, var=6, border=None, rivets=None, seed=1, size=16):
    rnd = random.Random(seed)
    img = Image.new("RGBA", (size, size))
    noise_fill(img, base, var, rnd)
    d = ImageDraw.Draw(img)
    if border:
        d.rectangle([0, 0, size - 1, size - 1], outline=border)
    if rivets:
        for (x, y) in ((2, 2), (size - 3, 2), (2, size - 3), (size - 3, size - 3)):
            img.putpixel((x, y), rivets)
    return img


def shade(c, k):
    return tuple(clamp(v * k) for v in c[:3]) + (255,)


def save(img, mod, name):
    img.save(out(mod, name))


def anim(frames):
    w, h = frames[0].size
    img = Image.new("RGBA", (w, h * len(frames)))
    for i, f in enumerate(frames):
        img.paste(f, (0, i * h))
    return img


# =============================================================================
# csd_ship
# =============================================================================

def ship_textures():
    M = "csd_ship"
    HULL = (78, 84, 96)
    hull = panel(HULL, 6, border=(54, 58, 68), rivets=(140, 146, 158, 255), seed=11)
    d = ImageDraw.Draw(hull)
    d.line([0, 8, 15, 8], fill=(60, 64, 74, 255))
    save(hull, M, "csd_ship_hull.png")
    save(panel((60, 64, 74), 6, border=(44, 46, 54), rivets=(120, 126, 138, 255), seed=14), M, "csd_ship_hull_dark.png")
    for nm, col in (("blue", (40, 110, 200)), ("orange", (230, 120, 30))):
        save(panel(col, 6, seed=15), M, "csd_ship_hull_stripe_%s.png" % nm)
    save(panel((226, 230, 236), 4, seed=16), M, "csd_ship_hull_marking.png")
    rad = panel((70, 50, 40), 5, border=(50, 36, 30), seed=17)
    d = ImageDraw.Draw(rad)
    for y in range(2, 15, 3):
        d.line([1, y, 14, y], fill=(200, 100, 50, 255))
    save(rad, M, "csd_ship_radiator.png")
    save(panel((210, 214, 220), 4, border=(170, 176, 186), seed=18), M, "csd_ship_dish.png")
    fr = []
    for on in (True, False, False):
        im = Image.new("RGBA", (16, 16), (40, 40, 44, 255))
        ImageDraw.Draw(im).ellipse([3, 3, 12, 12], fill=(255, 50, 30, 255) if on else (80, 30, 30, 255))
        fr.append(im)
    save(anim(fr), M, "csd_ship_beacon.png")
    dome = Image.new("RGBA", (16, 16), (60, 150, 255, 120))
    ImageDraw.Draw(dome).rectangle([0, 0, 15, 15], outline=(150, 210, 255, 200))
    save(dome, M, "csd_ship_sensor_dome.png")
    save(panel((52, 56, 66), 5, border=(34, 36, 42), seed=12), M, "csd_ship_hull_rib.png")
    vent = panel(HULL, 4, border=(54, 58, 68), seed=13)
    d = ImageDraw.Draw(vent)
    for y in range(3, 14, 3):
        d.line([2, y, 13, y], fill=(24, 26, 30, 255))
    save(vent, M, "csd_ship_hull_vent.png")

    WALL = (196, 202, 212)
    wall = panel(WALL, 4, border=(150, 156, 168), rivets=(120, 126, 140, 255), seed=21)
    save(wall, M, "csd_ship_wall.png")
    trim = wall.copy()
    d = ImageDraw.Draw(trim)
    d.rectangle([0, 6, 15, 9], fill=(70, 150, 200, 255))
    d.line([0, 7, 15, 7], fill=(140, 220, 255, 255))
    save(trim, M, "csd_ship_wall_trim.png")
    save(panel((70, 76, 90), 5, border=(46, 50, 60), rivets=(110, 116, 130, 255), seed=22), M, "csd_ship_wall_dark.png")
    pipes = panel((90, 96, 108), 4, border=(60, 64, 74), seed=23)
    d = ImageDraw.Draw(pipes)
    for x, col in ((3, (170, 120, 60)), (8, (120, 160, 190)), (12, (170, 120, 60))):
        d.rectangle([x, 0, x + 1, 15], fill=col + (255,))
        d.line([x, 0, x, 15], fill=shade(col, 1.3))
    save(pipes, M, "csd_ship_wall_pipes.png")
    med = panel((226, 234, 236), 3, border=(170, 190, 196), seed=24)
    save(med, M, "csd_ship_wall_med.png")
    cross = med.copy()
    d = ImageDraw.Draw(cross)
    d.rectangle([6, 3, 9, 12], fill=(220, 70, 80, 255))
    d.rectangle([3, 6, 12, 9], fill=(220, 70, 80, 255))
    save(cross, M, "csd_ship_wall_med_cross.png")
    hydro = panel((170, 200, 170), 5, border=(110, 140, 110), seed=25)
    d = ImageDraw.Draw(hydro)
    for x in range(1, 16, 4):
        d.line([x, 15, x + 2, 9], fill=(70, 150, 70, 255))
    save(hydro, M, "csd_ship_wall_hydro.png")

    floor = panel((104, 110, 122), 5, border=(76, 80, 90), seed=31)
    d = ImageDraw.Draw(floor)
    for i in range(0, 16, 4):
        for j in range(0, 16, 4):
            floor.putpixel((i + 1, j + 1), (132, 138, 150, 255))
            floor.putpixel((i + 2, j + 2), (132, 138, 150, 255))
    save(floor, M, "csd_ship_floor.png")
    grate = Image.new("RGBA", (16, 16), (40, 44, 50, 255))
    d = ImageDraw.Draw(grate)
    for i in range(0, 16, 3):
        d.line([i, 0, i, 15], fill=(110, 116, 126, 255))
        d.line([0, i, 15, i], fill=(90, 96, 106, 255))
    save(grate, M, "csd_ship_floor_grate.png")
    tile = Image.new("RGBA", (16, 16))
    rnd = random.Random(32)
    for x in range(16):
        for y in range(16):
            c = (214, 220, 226) if ((x // 8 + y // 8) % 2 == 0) else (196, 204, 212)
            tile.putpixel((x, y), tuple(clamp(v + rnd.randint(-3, 3)) for v in c) + (255,))
    ImageDraw.Draw(tile).rectangle([0, 0, 15, 15], outline=(160, 168, 178, 255))
    save(tile, M, "csd_ship_floor_tile.png")
    save(panel((70, 90, 140), 8, seed=33), M, "csd_ship_floor_carpet.png")
    haz = Image.new("RGBA", (16, 16))
    for x in range(16):
        for y in range(16):
            haz.putpixel((x, y), (230, 180, 40, 255) if ((x + y) // 4) % 2 == 0 else (36, 36, 40, 255))
    save(haz, M, "csd_ship_floor_hazard.png")
    ceil = panel((150, 156, 166), 4, border=(116, 120, 130), seed=34)
    save(ceil, M, "csd_ship_ceiling.png")
    rc = panel((60, 90, 96), 6, border=(30, 50, 56), rivets=(150, 220, 220, 255), seed=35)
    d = ImageDraw.Draw(rc)
    d.rectangle([0, 6, 15, 9], fill=(230, 180, 40, 255))
    save(rc, M, "csd_ship_reactor_casing.png")
    save(panel((44, 46, 54), 6, border=(30, 30, 36), seed=36), M, "csd_ship_engine.png")

    crate = panel((150, 120, 60), 8, border=(90, 70, 30), seed=41)
    d = ImageDraw.Draw(crate)
    d.line([1, 1, 14, 14], fill=(110, 86, 40, 255))
    d.line([14, 1, 1, 14], fill=(110, 86, 40, 255))
    save(crate, M, "csd_ship_crate.png")
    save(panel((130, 104, 50), 6, border=(90, 70, 30), seed=42), M, "csd_ship_crate_top.png")
    save(panel((90, 110, 140), 5, border=(60, 70, 90), seed=43), M, "csd_ship_locker_top.png")
    save(panel((90, 110, 140), 5, border=(60, 70, 90), seed=44), M, "csd_ship_locker_side.png")
    lf = panel((100, 124, 156), 5, border=(60, 70, 90), seed=45)
    d = ImageDraw.Draw(lf)
    d.line([8, 1, 8, 14], fill=(60, 70, 90, 255))
    for y in (3, 4, 5):
        d.line([2, y, 6, y], fill=(50, 60, 80, 255))
        d.line([10, y, 14, y], fill=(50, 60, 80, 255))
    save(lf, M, "csd_ship_locker_front.png")

    def light_tex(core_col, edge):
        img = Image.new("RGBA", (16, 16), edge + (255,))
        d = ImageDraw.Draw(img)
        d.rectangle([2, 2, 13, 13], fill=core_col + (255,))
        d.rectangle([4, 4, 11, 11], fill=tuple(clamp(c * 1.08 + 10) for c in core_col) + (255,))
        return img
    save(light_tex((235, 244, 255), (120, 126, 136)), M, "csd_ship_light.png")
    save(light_tex((255, 70, 50), (110, 40, 40)), M, "csd_ship_light_alert.png")
    save(light_tex((70, 60, 54), (90, 94, 102)), M, "csd_ship_light_off.png")
    strip = Image.new("RGBA", (16, 16), (60, 66, 78, 255))
    ImageDraw.Draw(strip).rectangle([0, 6, 15, 9], fill=(160, 235, 255, 255))
    save(strip, M, "csd_ship_light_strip.png")
    for name, col in (("csd_ship_light_strip_alert.png", (255, 70, 50)), ("csd_ship_light_strip_off.png", (70, 60, 54))):
        st = Image.new("RGBA", (16, 16), (60, 66, 78, 255))
        ImageDraw.Draw(st).rectangle([0, 6, 15, 9], fill=col + (255,))
        save(st, M, name)
    glow = Image.new("RGBA", (16, 16))
    rnd = random.Random(51)
    for x in range(16):
        for y in range(16):
            k = rnd.random()
            glow.putpixel((x, y), (clamp(120 + 80 * k), clamp(180 + 60 * k), 255, 255))
    save(glow, M, "csd_ship_engine_glow.png")
    frames = []
    for f in range(4):
        img = Image.new("RGBA", (16, 16))
        for x in range(16):
            for y in range(16):
                v = 0.5 + 0.5 * math.sin((y + f * 4) * 0.8 + x * 0.3)
                img.putpixel((x, y), (clamp(60 + 80 * v), clamp(220 + 30 * v), clamp(180 + 60 * v), 200))
        frames.append(img)
    save(anim(frames), M, "csd_ship_reactor_core.png")
    for name, col in (("csd_ship_running_red.png", (255, 40, 40)), ("csd_ship_running_green.png", (40, 255, 80))):
        img = Image.new("RGBA", (16, 16), (40, 40, 44, 255))
        ImageDraw.Draw(img).ellipse([3, 3, 12, 12], fill=col + (255,))
        save(img, M, name)
    frame = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    d = ImageDraw.Draw(frame)
    d.rectangle([0, 0, 15, 15], outline=(96, 104, 118, 255))
    d.rectangle([1, 1, 14, 14], outline=(60, 66, 78, 255))
    save(frame, M, "csd_ship_window_frame.png")
    det = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    ImageDraw.Draw(det).line([4, 11, 9, 6], fill=(200, 230, 255, 70))
    save(det, M, "csd_ship_window_detail.png")
    frames = []
    for f in range(4):
        img = Image.new("RGBA", (16, 16))
        for x in range(16):
            for y in range(16):
                v = 0.5 + 0.5 * math.sin((x + y + f * 4) * 0.7)
                img.putpixel((x, y), (80, clamp(170 + 60 * v), 255, clamp(50 + 50 * v)))
        frames.append(img)
    save(anim(frames), M, "csd_ship_forcefield.png")
    frames = []
    for f in range(4):
        img = Image.new("RGBA", (16, 16), (40, 110, 255, 34))
        d = ImageDraw.Draw(img)
        for k in range(3):
            y = (15 - (f * 4 + k * 6)) % 16
            d.line([2 + k * 5, y, 3 + k * 5, y], fill=(170, 220, 255, 150))
        frames.append(img)
    save(anim(frames), M, "csd_ship_gravlift.png")

    save(panel((60, 90, 140), 6, border=(40, 60, 100), seed=61), M, "csd_ship_seat.png")
    save(panel((120, 60, 80), 7, border=(80, 40, 50), seed=62), M, "csd_ship_sofa.png")
    save(panel((210, 214, 220), 3, border=(150, 156, 166), seed=63), M, "csd_ship_table_top.png")
    bt = panel((200, 204, 214), 4, seed=64)
    d = ImageDraw.Draw(bt)
    d.rectangle([0, 0, 15, 4], fill=(240, 240, 244, 255))
    d.rectangle([0, 5, 15, 15], fill=(70, 100, 160, 255))
    save(bt, M, "csd_ship_bunk_top.png")
    save(panel((70, 76, 90), 4, border=(46, 50, 60), seed=65), M, "csd_ship_bunk_side.png")
    cryo = Image.new("RGBA", (16, 16), (60, 70, 86, 255))
    d = ImageDraw.Draw(cryo)
    d.rounded_rectangle([1, 1, 14, 14], 4, fill=(150, 210, 235, 255), outline=(80, 100, 120, 255))
    d.ellipse([6, 2, 9, 5], fill=(110, 150, 170, 255))          # a sleeping colonist
    d.rectangle([5, 6, 10, 13], fill=(110, 150, 170, 255))
    for (x, y) in ((3, 4), (12, 9), (4, 12)):
        cryo.putpixel((x, y), (235, 250, 255, 255))
    save(cryo, M, "csd_ship_cryo_top.png")

    # Upright 2-node cryopod: one 16x32 front split into bottom/top halves.
    pod = Image.new("RGBA", (16, 32), (0, 0, 0, 0))
    d = ImageDraw.Draw(pod)
    d.rectangle([0, 0, 15, 31], fill=(70, 80, 96, 255))                       # frame
    d.rounded_rectangle([2, 2, 13, 29], 4, fill=(140, 205, 235, 150))           # glass (see-through)
    d.ellipse([6, 5, 9, 8], fill=(225, 190, 160, 230))                          # sleeper: head
    d.rectangle([5, 9, 10, 18], fill=(90, 130, 190, 230))                       # suit
    d.rectangle([5, 19, 7, 27], fill=(80, 110, 170, 230)); d.rectangle([8, 19, 10, 27], fill=(80, 110, 170, 230))
    for (x, y) in ((3, 4), (12, 10), (4, 22), (11, 26), (3, 15)):              # frost sparkles
        d.point((x, y), fill=(240, 252, 255, 255))
    d.rectangle([3, 30, 12, 30], fill=(90, 230, 255, 255))                      # status light strip
    save(pod.crop((0, 16, 16, 32)), M, "csd_ship_cryo2_front_bottom.png")
    save(pod.crop((0, 0, 16, 16)), M, "csd_ship_cryo2_front_top.png")
    cs2 = panel((70, 80, 96), 4, border=(46, 52, 64), seed=67)
    ImageDraw.Draw(cs2).line([7, 0, 7, 15], fill=(120, 220, 255, 255))
    save(cs2, M, "csd_ship_cryo2_side.png")
    save(panel((90, 100, 116), 4, border=(46, 52, 64), seed=68), M, "csd_ship_cryo2_top.png")
    inv = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    inv.paste(pod.resize((8, 16)), (4, 0))
    save(inv, M, "csd_ship_cryo2_inv.png")
    frost = Image.new("RGBA", (128, 128), (0, 0, 0, 0))
    rf = random.Random(69)
    for x in range(128):
        for y in range(128):
            dd = math.hypot((x - 63.5) / 64, (y - 63.5) / 64)
            a = clamp((dd - 0.45) * 260) + rf.randint(0, 25)
            frost.putpixel((x, y), (200, 235, 255, clamp(a)))
    save(frost, M, "csd_ship_cryo_frost.png")
    cs = panel((70, 76, 90), 4, border=(46, 50, 60), seed=66)
    ImageDraw.Draw(cs).line([2, 8, 13, 8], fill=(120, 220, 255, 255))
    save(cs, M, "csd_ship_cryo_side.png")
    frames = []
    rnd = random.Random(67)
    for f in range(4):
        img = Image.new("RGBA", (16, 16), (14, 24, 40, 255))
        d = ImageDraw.Draw(img)
        d.rectangle([0, 0, 15, 15], outline=(60, 70, 90, 255))
        for k in range(4):
            w = rnd.randint(3, 12)
            d.line([2, 3 + k * 3, 2 + w, 3 + k * 3], fill=(90, 220, 255, 255) if k != f else (255, 200, 80, 255))
        frames.append(img)
    save(anim(frames), M, "csd_ship_screen.png")
    frames = []
    for f in range(4):
        img = Image.new("RGBA", (16, 16), (14, 24, 40, 255))
        for x in range(1, 15):
            for y in range(1, 15):
                v = rnd.randint(30, 200)
                img.putpixel((x, y), (v, v, v, 255))
        ImageDraw.Draw(img).rectangle([0, 0, 15, 15], outline=(60, 70, 90, 255))
        frames.append(img)
    save(anim(frames), M, "csd_ship_screen_static.png")
    st = Image.new("RGBA", (4, 4), (0, 0, 0, 0))
    ImageDraw.Draw(st).rectangle([0, 0, 3, 3], fill=(200, 210, 200, 70))
    save(st, M, "csd_ship_haze.png")
    sp = Image.new("RGBA", (4, 4), (0, 0, 0, 0))
    ImageDraw.Draw(sp).rectangle([1, 1, 2, 2], fill=(255, 220, 120, 255))
    save(sp, M, "csd_ship_spark.png")
    sm = Image.new("RGBA", (8, 8), (0, 0, 0, 0))
    ImageDraw.Draw(sm).ellipse([0, 0, 7, 7], fill=(230, 235, 240, 90))
    save(sm, M, "csd_ship_steam.png")
    # particles are square billboards: a soft round star
    streak = Image.new("RGBA", (8, 8), (0, 0, 0, 0))
    for x in range(8):
        for y in range(8):
            dd = math.hypot(x - 3.5, y - 3.5) / 3.5
            streak.putpixel((x, y), (225, 238, 255, clamp(255 * max(0, 1 - dd) ** 1.5)))
    save(streak, M, "csd_ship_star_streak.png")
    pot = Image.new("RGBA", (16, 16), (70, 50, 30, 255))
    noise_fill(pot, (80, 56, 34), 10, random.Random(68), (2, 2, 14, 14))
    save(pot, M, "csd_ship_pot_top.png")
    plant = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    d = ImageDraw.Draw(plant)
    for k, (x, top) in enumerate(((3, 4), (6, 1), (8, 3), (11, 2), (13, 6))):
        d.line([8, 15, x, top], fill=(60 + k * 12, 170 + k * 8, 80, 255), width=1)
        d.ellipse([x - 1, top - 1, x + 1, top + 1], fill=(90, 200, 100, 255))
    save(plant, M, "csd_ship_plant.png")
    wilt = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    d = ImageDraw.Draw(wilt)
    for k, (x, top) in enumerate(((2, 10), (5, 8), (9, 9), (12, 11), (14, 12))):
        d.line([8, 15, x, top], fill=(130 + k * 8, 110, 50, 255))
        d.point((x, top + 1), fill=(150, 120, 60, 255))
    save(wilt, M, "csd_ship_plant_wilted.png")
    sign = Image.new("RGBA", (16, 16), (24, 30, 44, 255))
    d = ImageDraw.Draw(sign)
    d.rectangle([0, 5, 15, 10], fill=(40, 120, 170, 255))
    for x in range(2, 14, 2):
        d.point((x, 7), fill=(220, 240, 255, 255))
        d.point((x + 1, 8), fill=(220, 240, 255, 255))
    save(sign, M, "csd_ship_sign.png")
    ct = panel((200, 204, 212), 3, border=(140, 146, 158), seed=137)
    save(ct, M, "csd_ship_counter_top.png")
    ctf = ct.copy()
    d = ImageDraw.Draw(ctf)
    for (x, y) in ((2, 2), (9, 2), (2, 9), (9, 9)):
        d.rounded_rectangle([x, y, x + 5, y + 4], 1, fill=(200, 190, 150, 255), outline=(120, 110, 80, 255))
        d.rectangle([x + 1, y + 1, x + 4, y + 2], fill=(90, 160, 90, 255))
    save(ctf, M, "csd_ship_counter_top_full.png")
    cside = panel((90, 110, 140), 4, border=(60, 70, 90), seed=138)
    ImageDraw.Draw(cside).rectangle([0, 2, 15, 3], fill=(230, 180, 40, 255))
    save(cside, M, "csd_ship_counter_side.png")
    save(panel((170, 176, 186), 3, border=(110, 116, 128), seed=139), M, "csd_ship_tap.png")
    drop = Image.new("RGBA", (4, 4), (0, 0, 0, 0))
    ImageDraw.Draw(drop).ellipse([0, 0, 3, 3], fill=(120, 180, 255, 220))
    save(drop, M, "csd_ship_droplet.png")
    tur = panel((80, 86, 98), 5, border=(50, 54, 64), rivets=(200, 60, 50, 255), seed=140)
    ImageDraw.Draw(tur).rectangle([5, 5, 10, 10], fill=(200, 50, 40, 255))
    save(tur, M, "csd_ship_turret.png")
    # sliding door: one 16x32 panel split into bottom/top halves
    door = Image.new("RGBA", (16, 32), (150, 158, 172, 255))
    noise_fill(door, (150, 158, 172), 4, random.Random(141))
    d = ImageDraw.Draw(door)
    d.rectangle([0, 0, 15, 31], outline=(90, 96, 108, 255))
    d.rectangle([4, 4, 11, 12], fill=(40, 70, 90, 255), outline=(90, 96, 108, 255))   # window
    d.line([5, 10, 9, 6], fill=(140, 200, 230, 255))
    for y in range(24, 31):                                                             # hazard kick plate
        for x in range(1, 15):
            door.putpixel((x, y), (230, 180, 40, 255) if ((x + y) // 3) % 2 == 0 else (36, 36, 40, 255))
    d.rectangle([7, 16, 8, 20], fill=(90, 230, 255, 255))                              # status light
    save(door.crop((0, 16, 16, 32)), M, "csd_ship_door_bottom.png")
    save(door.crop((0, 0, 16, 16)), M, "csd_ship_door_top.png")
    save(panel((90, 96, 108), 3, seed=142), M, "csd_ship_door_edge.png")
    dinv = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    dinv.paste(door.resize((8, 16)), (4, 0))
    save(dinv, M, "csd_ship_door_inv.png")
    las = Image.new("RGBA", (8, 8), (0, 0, 0, 0))
    for x in range(8):
        for y in range(8):
            dd = math.hypot(x - 3.5, y - 3.5) / 3.5
            las.putpixel((x, y), (255, clamp(80 + 120 * (1 - dd)), 60, clamp(255 * max(0, 1 - dd))))
    save(las, M, "csd_ship_laser.png")
    ex = Image.new("RGBA", (8, 8), (0, 0, 0, 0))
    for x in range(8):
        for y in range(8):
            dd = math.hypot(x - 3.5, y - 3.5) / 3.5
            ex.putpixel((x, y), (255, clamp(200 * (1 - dd) + 40), 40, clamp(230 * max(0, 1 - dd ** 2))))
    save(ex, M, "csd_ship_explosion.png")
    plate = Image.new("RGBA", (64, 32), (16, 24, 40, 255))
    d = ImageDraw.Draw(plate)
    d.rectangle([0, 0, 63, 31], outline=(70, 160, 220, 255))
    d.rectangle([1, 1, 62, 30], outline=(30, 60, 90, 255))
    save(plate, M, "csd_ship_sign_plate.png")
    save(Image.new("RGBA", (8, 8), (40, 46, 56, 255)), M, "csd_ship_sign_edges.png")
    inv = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    d = ImageDraw.Draw(inv)
    d.rectangle([1, 4, 14, 11], fill=(16, 24, 40, 255), outline=(70, 160, 220, 255))
    d.line([3, 7, 12, 7], fill=(230, 240, 255, 255))
    save(inv, M, "csd_ship_sign_inv.png")


# =============================================================================
# csd_tasks
# =============================================================================

def screen_base(seed, bg=(10, 18, 32)):
    """16x16 front tile: upper part is the screen, lower part the cabinet."""
    img = Image.new("RGBA", (16, 16), (78, 84, 98, 255))
    noise_fill(img, (78, 84, 98), 4, random.Random(seed), (0, 0, 16, 16))
    d = ImageDraw.Draw(img)
    d.rectangle([1, 1, 14, 9], fill=bg + (255,), outline=(40, 46, 56, 255))
    d.line([2, 12, 6, 12], fill=(230, 180, 40, 255))
    d.point((12, 12), fill=(90, 255, 120, 255))
    d.point((10, 12), fill=(255, 80, 80, 255))
    return img, d


def task_textures():
    M = "csd_tasks"
    side = panel((78, 84, 98), 4, border=(54, 58, 68), seed=101)
    save(side, M, "csd_tasks_console_side.png")
    top = panel((92, 98, 112), 4, border=(54, 58, 68), seed=102)
    ImageDraw.Draw(top).rectangle([3, 3, 12, 6], fill=(40, 120, 170, 255))
    save(top, M, "csd_tasks_console_top.png")
    save(panel((120, 96, 60), 6, border=(80, 60, 30), seed=103), M, "csd_tasks_planter_side.png")

    def screen(name, draw, seed, bg=(10, 18, 32)):
        img, d = screen_base(seed, bg)
        draw(d, img)
        save(img, M, "csd_tasks_screen_%s.png" % name)

    screen("wiring", lambda d, i: [d.line([2, 2 + k * 2, 13, 8 - k * 2], fill=c) for k, c in
                                  enumerate([(255, 60, 60), (60, 140, 255), (255, 210, 60), (255, 80, 220)])], 111)
    screen("nav_console", lambda d, i: (d.ellipse([4, 2, 11, 9], outline=(90, 220, 255)), d.line([7, 5, 10, 3], fill=(255, 220, 90))), 112)
    screen("reactor_console", lambda d, i: [d.rectangle([2 + (k % 3) * 4, 2 + (k // 3) * 3, 4 + (k % 3) * 4, 3 + (k // 3) * 3],
                                                         fill=(90, 220, 255) if k in (1, 5) else (30, 60, 90)) for k in range(6)], 113)
    screen("id_reader", lambda d, i: (d.rectangle([2, 4, 13, 6], fill=(30, 30, 34)), d.rectangle([3, 2, 7, 8], fill=(230, 210, 110))), 114)
    screen("o2_filter", lambda d, i: [d.line([2, y, 13, y], fill=(90, 160, 120)) for y in range(2, 10, 2)], 115, (20, 30, 24))
    screen("comms_terminal", lambda d, i: (d.rectangle([2, 6, 13, 8], outline=(90, 220, 255)), d.rectangle([3, 7, 8, 7], fill=(90, 220, 255)),
                                           d.line([7, 2, 7, 5], fill=(200, 140, 255))), 116)
    screen("nav_upload", lambda d, i: (d.rectangle([2, 6, 13, 8], outline=(90, 255, 150)), d.line([7, 5, 7, 2], fill=(90, 255, 150)),
                                       d.line([5, 4, 7, 2], fill=(90, 255, 150)), d.line([9, 4, 7, 2], fill=(90, 255, 150))), 117)
    pad = Image.new("RGBA", (16, 16), (40, 46, 56, 255))
    d = ImageDraw.Draw(pad)
    d.ellipse([1, 1, 14, 14], fill=(30, 90, 60, 255), outline=(90, 255, 140, 255))
    d.ellipse([5, 5, 10, 10], outline=(90, 255, 140, 255))
    save(pad, M, "csd_tasks_screen_med_scanner.png")
    soil = Image.new("RGBA", (16, 16))
    noise_fill(soil, (70, 50, 30), 12, random.Random(118))
    d = ImageDraw.Draw(soil)
    for (x, y) in ((4, 4), (11, 5), (7, 11)):
        d.line([x - 2, y, x + 2, y], fill=(90, 190, 90, 255))
        d.line([x, y - 2, x, y + 2], fill=(90, 190, 90, 255))
    save(soil, M, "csd_tasks_screen_planter.png")
    screen("fuel_pump", lambda d, i: (d.rectangle([4, 2, 11, 9], outline=(255, 170, 60)), d.rectangle([5, 5, 10, 8], fill=(255, 170, 60))), 119)
    screen("engine_port", lambda d, i: (d.ellipse([3, 2, 12, 9], outline=(255, 170, 60)), d.ellipse([6, 4, 9, 7], fill=(255, 120, 40))), 120)
    screen("garbage_chute", lambda d, i: (d.rectangle([3, 2, 12, 9], fill=(30, 30, 30)), d.line([3, 2, 12, 9], fill=(230, 180, 40)),
                                          d.line([12, 2, 3, 9], fill=(230, 180, 40))), 121, (30, 30, 30))
    screen("weapons_console", lambda d, i: (d.ellipse([3, 2, 12, 9], outline=(255, 90, 90)), d.line([7, 1, 7, 10], fill=(255, 90, 90)),
                                            d.line([2, 5, 13, 5], fill=(255, 90, 90)), d.point((10, 3), fill=(200, 200, 200))), 122)
    screen("shield_console", lambda d, i: [d.regular_polygon((4 + (k % 3) * 4, 4 + (k // 3) * 3, 2), 6,
                                                             fill=(200, 230, 255) if k % 2 else (200, 50, 50)) for k in range(6)], 123)
    screen("galley_station", lambda d, i: (d.ellipse([3, 3, 12, 9], fill=(230, 230, 230)), d.ellipse([5, 4, 10, 8], fill=(220, 120, 60))), 124)
    screen("centrifuge", lambda d, i: [d.rectangle([3 + k * 3, 3, 4 + k * 3, 9], fill=c) for k, c in
                                       enumerate([(200, 120, 255), (120, 220, 255), (255, 200, 90)])], 125)

    # Station state overlays (drawn over the screen area)
    ok = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    d = ImageDraw.Draw(ok)
    d.rectangle([1, 1, 14, 9], fill=(20, 120, 50, 170))
    d.line([4, 5, 6, 7], fill=(160, 255, 170, 255)); d.line([6, 7, 11, 2], fill=(160, 255, 170, 255))
    save(ok, M, "csd_tasks_overlay_ok.png")
    warn = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    d = ImageDraw.Draw(warn)
    d.rectangle([1, 1, 14, 9], fill=(150, 20, 10, 190))
    d.line([7, 2, 7, 6], fill=(255, 220, 120, 255)); d.line([8, 2, 8, 6], fill=(255, 220, 120, 255))
    d.point((7, 8), fill=(255, 220, 120, 255)); d.point((8, 8), fill=(255, 220, 120, 255))
    save(warn, M, "csd_tasks_overlay_warn.png")

    # Vent grilles: normal, clean (just fixed), clogged (failing)
    def grille(base, slot, dirt, glow=None, seed=130):
        rnd = random.Random(seed)
        im = Image.new("RGBA", (16, 16), base + (255,))
        d = ImageDraw.Draw(im)
        d.rectangle([0, 0, 15, 15], outline=shade(base, 0.6))
        for y in range(2, 14, 2):
            d.line([2, y, 13, y], fill=slot + (255,))
        if glow:
            for y in range(2, 14, 2):
                d.point((rnd.randint(3, 12), y), fill=glow + (255,))
        for _ in range(dirt):
            x, y = rnd.randint(1, 14), rnd.randint(1, 14)
            im.putpixel((x, y), (rnd.randint(90, 130), rnd.randint(80, 110), 60, 255))
        return im
    save(grille((120, 126, 138), (30, 34, 40), 8), M, "csd_tasks_vent.png")
    save(grille((150, 158, 170), (20, 50, 70), 0, glow=(120, 220, 255)), M, "csd_tasks_vent_clean.png")
    clog = grille((110, 104, 90), (60, 50, 34), 60, seed=131)
    ImageDraw.Draw(clog).rectangle([4, 6, 10, 11], fill=(100, 84, 54, 255))
    save(clog, M, "csd_tasks_vent_clogged.png")
    # Planters: lush (watered) and dry (failing)
    lush = Image.new("RGBA", (16, 16))
    noise_fill(lush, (50, 36, 22), 8, random.Random(132))
    d = ImageDraw.Draw(lush)
    for (x, y) in ((3, 3), (8, 4), (12, 3), (4, 9), (10, 10), (7, 13), (13, 12)):
        d.ellipse([x - 2, y - 2, x + 2, y + 2], fill=(70, 190, 80, 255))
        d.point((x, y), fill=(140, 240, 120, 255))
    save(lush, M, "csd_tasks_planter_lush.png")
    dry = Image.new("RGBA", (16, 16))
    noise_fill(dry, (130, 100, 64), 10, random.Random(133))
    d = ImageDraw.Draw(dry)
    for (x, y) in ((4, 4), (11, 5), (7, 11)):
        d.line([x - 2, y, x + 2, y], fill=(150, 120, 60, 255))
    d.line([1, 8, 6, 9], fill=(90, 70, 40, 255)); d.line([9, 13, 14, 11], fill=(90, 70, 40, 255))  # cracks
    save(dry, M, "csd_tasks_planter_dry.png")
    # Hull panels: worn, freshly patched, broken
    hp = panel((90, 96, 108), 6, border=(60, 64, 74), rivets=(150, 156, 168, 255), seed=134)
    d = ImageDraw.Draw(hp)
    d.line([3, 4, 7, 8], fill=(40, 40, 46, 255)); d.line([7, 8, 6, 12], fill=(40, 40, 46, 255))
    save(hp, M, "csd_tasks_hull_panel.png")
    fx = panel((170, 176, 186), 4, border=(230, 180, 40), rivets=(240, 240, 240, 255), seed=135)
    save(fx, M, "csd_tasks_hull_panel_fixed.png")
    br = panel((70, 66, 66), 8, border=(50, 40, 40), seed=136)
    d = ImageDraw.Draw(br)
    d.polygon([(5, 3), (11, 5), (12, 11), (6, 13), (3, 8)], fill=(15, 10, 20, 255))
    for (a, b2) in (((5, 3), (2, 1)), ((12, 11), (15, 14)), ((11, 5), (14, 2))):
        d.line([a, b2], fill=(255, 150, 60, 255))
    save(br, M, "csd_tasks_hull_panel_broken.png")
    # Task items
    def item(name, draw):
        im = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
        draw(ImageDraw.Draw(im))
        save(im, M, "csd_tasks_%s.png" % name)
    item("ration", lambda d: (d.rounded_rectangle([2, 4, 13, 12], 2, fill=(200, 190, 150), outline=(120, 110, 80)),
                              d.rectangle([4, 6, 11, 8], fill=(90, 160, 90)), d.line([4, 10, 9, 10], fill=(150, 120, 80))))
    item("data_chip", lambda d: (d.rectangle([3, 3, 12, 12], fill=(30, 60, 50), outline=(160, 200, 120)),
                                 d.rectangle([6, 6, 9, 9], fill=(90, 220, 255)),
                                 [d.line([x, 1, x, 3], fill=(220, 200, 90)) for x in (5, 8, 11)]))
    item("fuel_cell", lambda d: (d.rounded_rectangle([4, 2, 11, 14], 2, fill=(70, 74, 84), outline=(40, 40, 46)),
                                 d.rectangle([5, 4, 10, 12], fill=(255, 150, 40)), d.rectangle([6, 1, 9, 2], fill=(180, 180, 190))))
    item("scrap_metal", lambda d: (d.polygon([(2, 9), (7, 4), (13, 6), (12, 12), (5, 13)], fill=(120, 116, 110), outline=(70, 66, 62)),
                                   d.line([5, 8, 10, 10], fill=(150, 90, 50))))
    item("hull_patch", lambda d: (d.rectangle([2, 3, 13, 12], fill=(170, 176, 186), outline=(230, 180, 40)),
                                  [d.point(p, fill=(240, 240, 240)) for p in ((4, 5), (11, 5), (4, 10), (11, 10))]))

    # UI
    p = Image.new("RGBA", (24, 24), (10, 16, 30, 235))
    d = ImageDraw.Draw(p)
    d.rectangle([0, 0, 23, 23], outline=(70, 160, 220, 255))
    d.rectangle([1, 1, 22, 22], outline=(30, 60, 90, 255))
    for (x, y) in ((2, 2), (21, 2), (2, 21), (21, 21)):
        p.putpixel((x, y), (140, 220, 255, 255))
    save(p, M, "csd_tasks_panel.png")
    bg = Image.new("RGBA", (104, 12), (10, 16, 30, 200))
    ImageDraw.Draw(bg).rectangle([0, 0, 103, 11], outline=(70, 90, 120, 255))
    save(bg, M, "csd_tasks_bar_bg.png")
    save(Image.new("RGBA", (100, 8), (255, 255, 255, 255)), M, "csd_tasks_bar_fg.png")
    ast = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    d = ImageDraw.Draw(ast)
    d.ellipse([2, 3, 13, 13], fill=(120, 104, 90, 255), outline=(70, 60, 50, 255))
    d.ellipse([5, 5, 7, 7], fill=(90, 78, 66, 255))
    d.ellipse([9, 9, 11, 11], fill=(90, 78, 66, 255))
    save(ast, M, "csd_tasks_asteroid.png")
    sp = Image.new("RGBA", (4, 4), (0, 0, 0, 0))
    ImageDraw.Draw(sp).rectangle([1, 1, 2, 2], fill=(120, 255, 160, 255))
    save(sp, M, "csd_tasks_scan_particle.png")
    aw = Image.new("RGBA", (32, 32), (0, 0, 0, 0))
    d = ImageDraw.Draw(aw)
    d.regular_polygon((16, 16, 14), 6, fill=(30, 60, 100, 255), outline=(140, 220, 255, 255))
    d.polygon([(16, 6), (19, 13), (26, 13), (20, 18), (22, 25), (16, 21), (10, 25), (12, 18), (6, 13), (13, 13)], fill=(255, 210, 80, 255))
    save(aw, M, "csd_tasks_award.png")


# =============================================================================
# csd_events
# =============================================================================

def event_textures():
    M = "csd_events"

    def screen(name, draw, seed, bg=(10, 18, 32)):
        img, d = screen_base(seed, bg)
        draw(d, img)
        save(img, M, "csd_events_screen_%s.png" % name)

    pad = Image.new("RGBA", (16, 16), (40, 46, 56, 255))
    d = ImageDraw.Draw(pad)
    d.rectangle([1, 1, 14, 14], fill=(90, 70, 20, 255), outline=(230, 180, 40, 255))
    d.ellipse([4, 3, 11, 12], outline=(255, 230, 120, 255))      # hand outline
    for x in (5, 7, 9):
        d.line([x, 1, x, 4], fill=(255, 230, 120, 255))
    save(pad, M, "csd_events_screen_reactor_stabilizer.png")
    screen("o2_panel", lambda d, i: [d.rectangle([2 + (k % 3) * 4, 2 + (k // 3) * 3, 4 + (k % 3) * 4, 3 + (k // 3) * 3],
                                                  fill=(90, 220, 255)) for k in range(6)], 201)
    screen("breaker_panel", lambda d, i: [d.rectangle([2 + k * 2, 3 if k % 2 else 6, 2 + k * 2, 8 if k % 2 else 9],
                                                       fill=(90, 255, 120) if k % 2 else (255, 80, 80)) for k in range(6)], 202)
    screen("comms_dish", lambda d, i: (d.arc([2, 2, 13, 13], 200, 340, fill=(200, 140, 255)), d.line([7, 7, 11, 3], fill=(200, 140, 255))), 203)

    valve = Image.new("RGBA", (16, 16), (70, 76, 90, 255))
    d = ImageDraw.Draw(valve)
    d.rectangle([0, 0, 15, 15], outline=(46, 50, 60, 255))
    d.ellipse([2, 2, 13, 13], outline=(200, 40, 40, 255), width=2)
    d.line([7, 3, 7, 12], fill=(200, 40, 40, 255)); d.line([3, 7, 12, 7], fill=(200, 40, 40, 255))
    d.ellipse([6, 6, 9, 9], fill=(230, 180, 40, 255))
    save(valve, M, "csd_events_screen_valve.png")
    v = Image.new("RGBA", (256, 256), (0, 0, 0, 0))
    for x in range(256):
        for y in range(256):
            dx, dy = (x - 127.5) / 128, (y - 127.5) / 128
            r = math.sqrt(dx * dx + dy * dy)
            a = clamp((r - 0.55) / 0.6 * 170)
            v.putpixel((x, y), (255, 20, 10, a))
    save(v, M, "csd_events_vignette.png")
    frames = []
    for f in range(3):
        rnd = random.Random(210 + f)
        img = panel((78, 84, 96), 6, border=(54, 58, 68), seed=211)
        d = ImageDraw.Draw(img)
        for _ in range(6):
            x0, y0 = 8 + rnd.randint(-2, 2), 8 + rnd.randint(-2, 2)
            a = rnd.random() * math.tau
            d.line([x0, y0, x0 + math.cos(a) * 7, y0 + math.sin(a) * 7], fill=(255, clamp(120 + 40 * f), 40, 255))
        d.ellipse([5, 5, 10, 10], fill=(10, 6, 20, 255), outline=(255, 160, 60, 255))
        frames.append(img)
    save(anim(frames), M, "csd_events_breach.png")
    sp = Image.new("RGBA", (4, 4), (0, 0, 0, 0))
    ImageDraw.Draw(sp).rectangle([1, 1, 2, 2], fill=(255, 230, 120, 255))
    save(sp, M, "csd_events_spark.png")
    du = Image.new("RGBA", (4, 4), (0, 0, 0, 0))
    ImageDraw.Draw(du).rectangle([1, 1, 2, 2], fill=(200, 200, 210, 180))
    save(du, M, "csd_events_dust.png")


# =============================================================================
# csd_space: skybox
# =============================================================================

def sky_textures():
    M = "csd_space"
    S = 512
    faces = ["up", "down", "front", "back", "left", "right"]
    for idx, face in enumerate(faces):
        rnd = random.Random(300 + idx)
        img = Image.new("RGB", (S, S), (2, 3, 8))
        # nebula: a few soft blobs, stronger on the "front" and "left" faces
        neb = Image.new("RGB", (S, S), (0, 0, 0))
        d = ImageDraw.Draw(neb)
        strength = {"front": 1.0, "left": 0.7, "up": 0.4}.get(face, 0.25)
        for _ in range(14):
            x, y = rnd.randint(0, S), rnd.randint(0, S)
            r = rnd.randint(60, 180)
            col = rnd.choice([(70, 30, 110), (20, 60, 120), (110, 30, 70), (30, 90, 110)])
            col = tuple(int(c * strength) for c in col)
            d.ellipse([x - r, y - r, x + r, y + r], fill=col)
        neb = neb.filter(ImageFilter.GaussianBlur(60))
        # Fade the nebula out towards the face edges so every face meets its
        # neighbours on the same plain background (no seams on the cube).
        mask = Image.new("L", (S, S), 0)
        mp = mask.load()
        for x in range(S):
            for y in range(S):
                e = min(x, y, S - 1 - x, S - 1 - y) / (S * 0.28)
                mp[x, y] = clamp(204 * min(1.0, e) ** 1.5)
        img = Image.composite(neb, img, mask)
        px = img.load()
        for _ in range(1400):
            x, y = rnd.randrange(S), rnd.randrange(S)
            b = rnd.random() ** 3
            c = rnd.choice([(255, 255, 255), (200, 220, 255), (255, 230, 200), (255, 200, 200)])
            px[x, y] = tuple(clamp(v * (0.35 + 0.65 * b)) for v in c)
            if b > 0.75:
                for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                    xx, yy = (x + dx) % S, (y + dy) % S
                    px[xx, yy] = tuple(clamp(v * 0.45) for v in c)
        if face == "front":
            # a distant destination star
            d = ImageDraw.Draw(img)
            for r, a in ((40, 20), (24, 60), (12, 160)):
                d.ellipse([340 - r, 170 - r, 340 + r, 170 + r], fill=(clamp(255 * a / 160), clamp(220 * a / 160), clamp(180 * a / 160)))
            img = img.filter(ImageFilter.GaussianBlur(0.6))
        img.save(out(M, "csd_space_sky_%s.png" % face))


# =============================================================================
# csd_create extras, menu art
# =============================================================================

def misc_textures():
    w = Image.new("RGBA", (8, 8), (0, 0, 0, 0))
    ImageDraw.Draw(w).line([0, 4, 7, 4], fill=(220, 240, 255, 110))
    save(w, "csd_create", "csd_create_wind.png")
    s = Image.new("RGBA", (4, 4), (0, 0, 0, 0))
    ImageDraw.Draw(s).rectangle([1, 1, 2, 2], fill=(255, 210, 120, 255))
    save(s, "csd_create", "csd_create_spark.png")

    menu = os.path.join(GAME, "menu")
    os.makedirs(menu, exist_ok=True)
    sky = Image.open(out("csd_space", "csd_space_sky_front.png")).convert("RGBA")

    def ship_silhouette(d, x, y, scale):
        L = 120 * scale
        H = 18 * scale
        d.polygon([(x, y), (x + L, y), (x + L + 30 * scale, y + H / 2), (x + L, y + H), (x, y + H)], fill=(120, 128, 142, 255))
        for k in range(1, 6):
            d.line([x + k * L / 6, y, x + k * L / 6, y + H], fill=(80, 86, 98, 255))
        d.rectangle([x - 14 * scale, y + 2 * scale, x, y + 7 * scale], fill=(60, 64, 74, 255))
        d.rectangle([x - 14 * scale, y + 11 * scale, x, y + 16 * scale], fill=(60, 64, 74, 255))
        d.rectangle([x - 18 * scale, y + 3 * scale, x - 14 * scale, y + 6 * scale], fill=(120, 190, 255, 255))
        d.rectangle([x - 18 * scale, y + 12 * scale, x - 14 * scale, y + 15 * scale], fill=(120, 190, 255, 255))
        for k in range(10):
            d.point((x + 8 * scale + k * 11 * scale, y + 9 * scale), fill=(255, 230, 160, 255))

    icon = sky.resize((128, 128)).copy()
    ship_silhouette(ImageDraw.Draw(icon), 22, 54, 0.62)
    icon.save(os.path.join(menu, "icon.png"))
    header = sky.crop((0, 120, 512, 248)).resize((512, 128)).copy()
    d = ImageDraw.Draw(header)
    ship_silhouette(d, 300, 50, 1.2)
    for i, (txt, y) in enumerate((("COLONY SHIP", 26), ("DOWN", 66))):
        for dx, dy in ((2, 2),):
            d.text((24 + dx, y + dy), txt, fill=(0, 0, 0, 200), font_size=34)
        d.text((24, y), txt, fill=(150, 225, 255, 255), font_size=34)
    header.save(os.path.join(menu, "header.png"))
    # Launcher main menu background (16:9): starfield with the ship crossing it
    bg = sky.resize((1280, 1280)).crop((0, 280, 1280, 1000)).copy()
    d = ImageDraw.Draw(bg)
    ship_silhouette(d, 560, 470, 3.2)
    d.rectangle([0, 0, 1280, 720], outline=(20, 30, 50, 255))
    launcher_menu = os.path.join(GAME, "launcher", "mainmenu")
    os.makedirs(launcher_menu, exist_ok=True)
    bg.convert("RGB").save(os.path.join(launcher_menu, "csd_menu_bg.png"))
    header.save(os.path.join(launcher_menu, "csd_header.png"))


# =============================================================================
# Sounds
# =============================================================================

RATE = 22050


def write_ogg(mod, name, samples):
    if not shutil.which("oggenc"):
        print("oggenc not found; skipping", name)
        return
    d = os.path.join(MODS, mod, "sounds")
    os.makedirs(d, exist_ok=True)
    with tempfile.TemporaryDirectory() as tmp:
        wav = os.path.join(tmp, "s.wav")
        with wave.open(wav, "wb") as w:
            w.setnchannels(1)
            w.setsampwidth(2)
            w.setframerate(RATE)
            peak = max(1e-6, max(abs(s) for s in samples))
            w.writeframes(b"".join(struct.pack("<h", int(32000 * s / peak * 0.8)) for s in samples))
        subprocess.run(["oggenc", "-Q", "-q", "3", "-o", os.path.join(d, name + ".ogg"), wav], check=True)


def env(t, a, dur):
    return min(1.0, t / a) * max(0.0, 1 - t / dur)


def tone(freqs, dur, kind="sine", decay=None):
    out = []
    n = int(RATE * dur)
    for i in range(n):
        t = i / RATE
        f = freqs[min(len(freqs) - 1, int(t / dur * len(freqs)))]
        ph = 2 * math.pi * f * t
        v = math.sin(ph) if kind == "sine" else (1 if math.sin(ph) > 0 else -1) * 0.5
        out.append(v * env(t, 0.005, dur) * (math.exp(-t * decay) if decay else 1))
    return out


def noise(dur, decay=8, lowpass=0.2, seed=1):
    rnd = random.Random(seed)
    out, prev = [], 0.0
    for i in range(int(RATE * dur)):
        t = i / RATE
        prev += (rnd.uniform(-1, 1) - prev) * lowpass
        out.append(prev * math.exp(-t * decay))
    return out


def sounds():
    write_ogg("csd_tasks", "csd_tasks_done", tone([660, 880, 1320], 0.45, decay=4))
    write_ogg("csd_tasks", "csd_tasks_click", tone([1800], 0.04, kind="square", decay=60))
    write_ogg("csd_tasks", "csd_tasks_zap", [a + 0.4 * b for a, b in zip(tone([900, 600, 300], 0.18, kind="square", decay=12),
                                                                        noise(0.18, 20, 0.6, 2))])
    alarm = []
    for k in range(2):
        alarm += tone([700 + 300 * (i % 2) for i in range(6)], 0.5, kind="square")
    write_ogg("csd_events", "csd_events_alarm", alarm)
    write_ogg("csd_events", "csd_events_impact", [a + b for a, b in zip(noise(0.9, 4, 0.05, 3), tone([55, 40], 0.9, decay=3))])
    write_ogg("csd_create", "csd_create_crank", [a * 0.6 for a in noise(0.25, 10, 0.5, 4)])
    write_ogg("csd_create", "csd_create_charged", tone([440, 554, 659, 880], 0.7, decay=2))
    for k, notes in enumerate(([900, 1300, 1100], [700, 1000, 1500, 1200], [1500, 900]), start=1):
        write_ogg("csd_robots", "csd_robots_beep%d" % k, tone(notes, 0.08 * len(notes), kind="square", decay=3))
    write_ogg("csd_create", "csd_create_press", [a + b for a, b in zip(noise(0.3, 14, 0.3, 5), tone([120, 80], 0.3, decay=10))])


# =============================================================================
# csd_eva: spacesuit (64x32 skin-layout armor textures, painted from scratch)
# =============================================================================

def eva_textures():
    M = "csd_eva"
    WHITE, SHADE, ORANGE, GREY, VISOR = (232, 236, 240), (196, 202, 210), (240, 130, 30), (110, 116, 128), (30, 60, 110)
    rnd = random.Random(400)

    def cube(img, x, y, w, h, d, col, var=6):
        """Paint the 6 faces of a skin-layout box whose UV block starts at (x, y)."""
        for (fx, fy, fw, fh) in ((x + d, y, w, d), (x + d + w, y, w, d),          # top, bottom
                                 (x, y + d, d, h), (x + d, y + d, w, h),          # right, front
                                 (x + d + w, y + d, d, h), (x + d + w + d, y + d, w, h)):  # left, back
            for i in range(fw):
                for j in range(fh):
                    n = rnd.randint(-var, var)
                    img.putpixel((fx + i, fy + j), tuple(clamp(c + n) for c in col) + (255,))

    # helmet: head box (8x8x8 at 0,0)
    img = Image.new("RGBA", (64, 32), (0, 0, 0, 0))
    cube(img, 0, 0, 8, 8, 8, WHITE)
    d = ImageDraw.Draw(img)
    d.rectangle([9, 10, 14, 13], fill=VISOR + (255,))          # visor on the front face
    d.line([10, 10, 12, 10], fill=(150, 200, 255, 255))
    d.rectangle([8, 8, 15, 8], fill=ORANGE + (255,))
    d.point((1, 12), fill=(255, 60, 60, 255)); d.point((22, 12), fill=(60, 255, 90, 255))  # side lamps
    save(img, M, "csd_eva_helmet_eva.png")
    # suit: body (8x12x4 at 16,16) and arm (4x12x4 at 40,16)
    img = Image.new("RGBA", (64, 32), (0, 0, 0, 0))
    cube(img, 16, 16, 8, 12, 4, WHITE)
    cube(img, 40, 16, 4, 12, 4, WHITE)
    d = ImageDraw.Draw(img)
    d.rectangle([20, 20, 27, 21], fill=ORANGE + (255,))        # chest band
    d.rectangle([22, 23, 25, 26], fill=GREY + (255,))          # control box
    d.point((23, 24), fill=(90, 255, 120, 255)); d.point((24, 24), fill=(255, 200, 60, 255))
    d.rectangle([32, 21, 39, 30], fill=SHADE + (255,))         # back: air pack
    d.rectangle([33, 22, 38, 29], fill=GREY + (255,))
    d.rectangle([40, 26, 55, 27], fill=ORANGE + (255,))        # arm bands
    d.rectangle([40, 30, 55, 31], fill=GREY + (255,))          # gloves
    save(img, M, "csd_eva_chestplate_eva.png")
    # leggings: leg (4x12x4 at 0,16), upper part
    img = Image.new("RGBA", (64, 32), (0, 0, 0, 0))
    cube(img, 0, 16, 4, 12, 4, WHITE)
    d = ImageDraw.Draw(img)
    d.rectangle([0, 24, 15, 25], fill=SHADE + (255,))          # knee pads
    d.rectangle([4, 21, 7, 21], fill=ORANGE + (255,))
    for x in range(64):
        for y in range(29, 32):
            img.putpixel((x, y), (0, 0, 0, 0))
    save(img, M, "csd_eva_leggings_eva.png")
    # boots: bottom of the leg
    img = Image.new("RGBA", (64, 32), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.rectangle([0, 28, 15, 31], fill=GREY + (255,))
    d.rectangle([4, 16, 7, 19], fill=(70, 74, 84, 255))         # sole (bottom face)
    d.rectangle([0, 28, 15, 28], fill=ORANGE + (255,))
    save(img, M, "csd_eva_boots_eva.png")

    # previews (32x64 front view) and inventory icons
    def preview(name, draw):
        im = Image.new("RGBA", (32, 64), (0, 0, 0, 0))
        draw(ImageDraw.Draw(im))
        save(im, M, "csd_eva_%s_eva_preview.png" % ("chestplate" if name == "suit" else name))
    preview("helmet", lambda d: (d.rectangle([8, 0, 23, 15], fill=WHITE), d.rectangle([10, 5, 21, 11], fill=VISOR)))
    preview("suit", lambda d: (d.rectangle([8, 16, 23, 39], fill=WHITE), d.rectangle([0, 16, 7, 39], fill=WHITE),
                               d.rectangle([24, 16, 31, 39], fill=WHITE), d.rectangle([8, 20, 23, 22], fill=ORANGE)))
    preview("leggings", lambda d: (d.rectangle([8, 40, 23, 57], fill=WHITE), d.rectangle([8, 48, 23, 49], fill=SHADE)))
    preview("boots", lambda d: d.rectangle([8, 58, 23, 63], fill=GREY))

    def icon(name, draw):
        im = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
        draw(ImageDraw.Draw(im))
        save(im, M, "csd_eva_inv_%s.png" % ("chestplate" if name == "suit" else name))
    icon("helmet", lambda d: (d.rounded_rectangle([2, 2, 13, 13], 4, fill=WHITE, outline=GREY),
                              d.rectangle([4, 6, 11, 10], fill=VISOR), d.line([5, 6, 7, 6], fill=(150, 200, 255))))
    icon("suit", lambda d: (d.rectangle([4, 2, 11, 13], fill=WHITE, outline=GREY), d.rectangle([1, 3, 3, 10], fill=WHITE),
                            d.rectangle([12, 3, 14, 10], fill=WHITE), d.rectangle([4, 5, 11, 6], fill=ORANGE)))
    icon("leggings", lambda d: (d.rectangle([3, 2, 7, 14], fill=WHITE, outline=GREY), d.rectangle([8, 2, 12, 14], fill=WHITE, outline=GREY),
                                d.rectangle([3, 8, 12, 9], fill=SHADE)))
    icon("boots", lambda d: (d.rectangle([2, 7, 6, 13], fill=GREY), d.rectangle([9, 7, 13, 13], fill=GREY),
                             d.rectangle([2, 7, 13, 7], fill=ORANGE)))

    side = panel((90, 96, 108), 4, border=(60, 64, 74), seed=401)
    save(side, M, "csd_eva_locker_side.png")
    save(panel((110, 116, 128), 4, border=(60, 64, 74), seed=402), M, "csd_eva_locker_top.png")
    front = Image.new("RGBA", (16, 32), (90, 96, 108, 255))
    d = ImageDraw.Draw(front)
    d.rectangle([0, 0, 15, 31], outline=(60, 64, 74, 255))
    d.rectangle([2, 3, 13, 27], fill=(30, 50, 70, 255), outline=(240, 130, 30, 255))   # window
    d.rounded_rectangle([5, 5, 10, 10], 2, fill=WHITE)                                  # helmet behind glass
    d.rectangle([4, 11, 11, 22], fill=WHITE)
    d.rectangle([4, 14, 11, 14], fill=ORANGE)
    save(front.resize((16, 16)), M, "csd_eva_locker_front.png")


# =============================================================================
# csd_robots: robot skins (64x32 player-skin layout) and dialogue portraits
# =============================================================================

ROBOT_COLORS = [  # body, accent, eye
    ((200, 206, 214), (60, 140, 220), (120, 220, 255)),   # B-0B greeter
    ((230, 190, 60), (60, 60, 64), (255, 240, 120)),      # MOP-3 custodian
    ((220, 120, 40), (50, 54, 62), (255, 220, 80)),       # VOLT maintenance
    ((236, 240, 244), (210, 60, 70), (120, 255, 160)),    # NURSE-7
    ((240, 240, 236), (60, 60, 60), (255, 140, 60)),      # CHEF-BOT
    ((70, 80, 140), (200, 200, 230), (160, 200, 255)),    # ASTRA navigation
    ((90, 160, 80), (60, 90, 50), (220, 255, 120)),       # SPROUT
    ((120, 124, 130), (230, 180, 40), (255, 80, 60)),     # HAUL-9
]


def robot_skin(body, accent, eye, seed):
    rnd = random.Random(seed)
    img = Image.new("RGBA", (64, 32), (0, 0, 0, 0))

    def faces(x, y, w, h, d, col):
        for (fx, fy, fw, fh) in ((x + d, y, w, d), (x + d + w, y, w, d), (x, y + d, d, h), (x + d, y + d, w, h),
                                 (x + d + w, y + d, d, h), (x + d + w + d, y + d, w, h)):
            for i in range(fw):
                for j in range(fh):
                    k = 0.92 + 0.12 * rnd.random()
                    img.putpixel((fx + i, fy + j), tuple(clamp(c * k) for c in col[:3]) + (255,))
    faces(0, 0, 8, 8, 8, body)        # head
    faces(16, 16, 8, 12, 4, body)     # torso
    faces(40, 16, 4, 12, 4, shade(body, 0.85))  # arms
    faces(0, 16, 4, 12, 4, shade(body, 0.8))    # legs
    d = ImageDraw.Draw(img)
    # face: visor band with two glowing eyes
    d.rectangle([8, 10, 15, 13], fill=(20, 24, 30, 255))
    d.rectangle([9, 11, 10, 12], fill=eye + (255,)); d.rectangle([13, 11, 14, 12], fill=eye + (255,))
    d.rectangle([10, 14, 13, 14], fill=shade(body, 0.6))           # mouth grille
    d.point((11, 0), fill=accent + (255,)); d.point((12, 1), fill=accent + (255,))  # antenna dot on top
    # torso panel + accent stripe + joints
    d.rectangle([20, 20, 27, 21], fill=accent + (255,))
    d.rectangle([21, 23, 26, 27], fill=shade(body, 0.7), outline=shade(body, 0.5))
    d.point((22, 24), fill=eye + (255,)); d.point((25, 24), fill=(255, 90, 80, 255))
    for x0 in (40, 0):
        d.rectangle([x0, 24, x0 + 15, 24], fill=(40, 44, 50, 255))      # elbows / knees
    d.rectangle([0, 30, 15, 31], fill=accent + (255,))                   # feet
    d.rectangle([40, 30, 55, 31], fill=shade(body, 0.6))                 # hands
    return img


def robot_textures():
    M = "csd_robots"
    for i, (body, accent, eye) in enumerate(ROBOT_COLORS, start=1):
        skin = robot_skin(body, accent, eye, 500 + i)
        save(skin, M, "csd_robots_skin_%d.png" % i)
        # portrait: front view assembled from the skin's front faces, scaled up
        por = Image.new("RGBA", (16, 32), (0, 0, 0, 0))
        por.paste(skin.crop((8, 8, 16, 16)), (4, 0))      # head front
        por.paste(skin.crop((20, 20, 28, 32)), (4, 8))    # torso front
        por.paste(skin.crop((44, 20, 48, 32)), (0, 8))    # right arm
        por.paste(skin.crop((44, 20, 48, 32)).transpose(Image.FLIP_LEFT_RIGHT), (12, 8))
        por.paste(skin.crop((4, 20, 8, 32)), (4, 20))     # legs
        por.paste(skin.crop((4, 20, 8, 32)).transpose(Image.FLIP_LEFT_RIGHT), (8, 20))
        save(por.resize((64, 128), Image.NEAREST), M, "csd_robots_portrait_%d.png" % i)


# =============================================================================
# Broken lights, ducts, zoo (added later; `make_art.py extras` makes only these)
# =============================================================================

def crack(img, seed, col=(20, 20, 24, 255)):
    rnd = random.Random(seed)
    d = ImageDraw.Draw(img)
    for _ in range(3):
        x, y = 8, 8
        for _ in range(6):
            nx, ny = x + rnd.randint(-3, 3), y + rnd.randint(-3, 3)
            d.line([x, y, nx, ny], fill=col)
            x, y = nx, ny
    return img


def extra_textures():
    M = "csd_ship"
    # Shot-out lights: dark, cracked, a scorch in the middle
    img = Image.new("RGBA", (16, 16), (90, 94, 102, 255))
    d = ImageDraw.Draw(img)
    d.rectangle([2, 2, 13, 13], fill=(46, 44, 42, 255))
    d.ellipse([5, 5, 10, 10], fill=(24, 22, 20, 255))
    save(crack(img, 71, (150, 150, 160, 255)), M, "csd_ship_light_broken.png")
    st = Image.new("RGBA", (16, 16), (60, 66, 78, 255))
    ImageDraw.Draw(st).rectangle([0, 6, 15, 9], fill=(40, 38, 36, 255))
    for x in (3, 4, 10, 11, 12):
        st.putpixel((x, 7), (150, 150, 160, 255))
    save(st, M, "csd_ship_light_strip_broken.png")
    # Replacement bulb (item)
    b = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    d = ImageDraw.Draw(b)
    d.ellipse([3, 1, 12, 10], fill=(235, 244, 255, 230), outline=(160, 190, 220, 255))
    d.rectangle([5, 10, 10, 13], fill=(150, 156, 166, 255))
    d.line([5, 11, 10, 11], fill=(100, 104, 112, 255))
    d.rectangle([6, 14, 9, 15], fill=(90, 90, 96, 255))
    d.line([7, 4, 7, 8], fill=(255, 220, 140, 255))
    d.line([8, 4, 8, 8], fill=(255, 220, 140, 255))
    save(b, M, "csd_ship_bulb.png")

    # Ducts: the casing that fills the crawlspace, the inside of a duct, a
    # see-through grate (floor of a duct over a room, and wall/ceiling vents)
    save(panel((58, 62, 70), 5, border=(40, 42, 48), seed=81), M, "csd_ship_duct_casing.png")
    duct = panel((128, 134, 144), 6, seed=82)
    d = ImageDraw.Draw(duct)
    for y in (0, 8):
        d.line([0, y, 15, y], fill=(96, 100, 110, 255))
    for x in (3, 12):
        for y in (2, 10):
            duct.putpixel((x, y), (170, 176, 186, 255))
    save(duct, M, "csd_ship_duct.png")
    grate = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    d = ImageDraw.Draw(grate)
    d.rectangle([0, 0, 15, 15], outline=(80, 86, 96, 255))
    for x in range(2, 15, 3):
        d.line([x, 1, x, 14], fill=(110, 116, 128, 255))
    d.line([1, 7, 14, 7], fill=(90, 96, 108, 255))
    save(grate, M, "csd_ship_duct_grate.png")
    hatch = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    d = ImageDraw.Draw(hatch)
    d.rectangle([0, 0, 15, 15], outline=(200, 160, 40, 255))
    d.rectangle([1, 1, 14, 14], outline=(40, 40, 40, 255))
    for y in range(3, 14, 3):
        d.line([2, y, 13, y], fill=(120, 126, 136, 255))
    save(hatch, M, "csd_ship_hatch.png")
    # Exposed air pipe running up walls / across ceilings
    pipe = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    for x in range(16):
        k = 0.65 + 0.35 * math.sin(math.pi * x / 15)
        for y in range(16):
            c = (150, 156, 166) if (y % 8) not in (0, 1) else (110, 114, 124)
            pipe.putpixel((x, y), shade(c, k))
    save(pipe, M, "csd_ship_air_pipe.png")
    vent = Image.new("RGBA", (16, 16), (70, 76, 88, 255))
    d = ImageDraw.Draw(vent)
    d.rectangle([0, 0, 15, 15], outline=(46, 50, 60, 255))
    for y in range(2, 14, 2):
        d.line([2, y, 13, y], fill=(24, 26, 30, 255))
    save(vent, M, "csd_ship_ceiling_vent.png")
    # Habitat glass: clear with a faint frame
    hg = Image.new("RGBA", (16, 16), (180, 220, 240, 22))
    d = ImageDraw.Draw(hg)
    d.line([3, 12, 6, 9], fill=(255, 255, 255, 70))
    d.line([9, 6, 10, 5], fill=(255, 255, 255, 60))
    save(hg, M, "csd_ship_habitat_glass.png")

    # Robot repair: sparks overlay for a disabled robot is reused from csd_ship
    M = "csd_robots"
    kit = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    d = ImageDraw.Draw(kit)
    d.rectangle([1, 5, 14, 14], fill=(200, 60, 40, 255), outline=(120, 30, 20, 255))
    d.rectangle([5, 2, 10, 5], outline=(120, 30, 20, 255))
    d.rectangle([6, 8, 9, 13], fill=(240, 240, 240, 255))
    d.rectangle([4, 9, 11, 12], fill=(240, 240, 240, 255))
    save(kit, M, "csd_robots_repair_kit.png")


if __name__ == "__main__":
    import sys
    if sys.argv[1:] == ["extras"]:
        extra_textures()
        raise SystemExit
    ship_textures()
    task_textures()
    event_textures()
    sky_textures()
    misc_textures()
    eva_textures()
    robot_textures()
    extra_textures()
    sounds()
    print("art done")
