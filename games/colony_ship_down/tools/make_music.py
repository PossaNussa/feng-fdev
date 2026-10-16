#!/usr/bin/env python3
"""Compose and render Colony Ship Down's music, ambience loops and SFX.

    python3 games/colony_ship_down/tools/make_music.py [track ...]

Everything is synthesised here from scratch (no samples), so it's original
and royalty-free. Pure Python (no numpy), so a full render takes a few
minutes. Output: mods/csd/csd_audio/sounds/*.ogg (needs oggenc).

Tracks
  csd_music_lounge      slow brushed jazz: electric piano, upright bass, vibes
  csd_music_drift       ambient pads and bell twinkles
  csd_music_nightshift  mellow lo-fi groove
  csd_music_engine      low, pulsing engine-room ambience
Ambience loops (seamless)
  csd_amb_hull, csd_amb_reactor, csd_amb_vents, csd_amb_bridge
SFX
  csd_sfx_lift, csd_sfx_crate, csd_sfx_locker, csd_sfx_console, csd_sfx_sit, csd_sfx_suit
"""

import array
import math
import os
import random
import shutil
import struct
import subprocess
import sys
import tempfile
import wave

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(os.path.dirname(HERE), "mods", "csd", "csd_audio", "sounds")
SR = 22050
TAU = 2 * math.pi

# --- sine lookup (much faster than math.sin per sample) ----------------------
TBL_N = 4096
SIN = [math.sin(TAU * i / TBL_N) for i in range(TBL_N)]


def mtof(m):
    return 440.0 * 2 ** ((m - 69) / 12)


class Track:
    def __init__(self, seconds):
        self.n = int(seconds * SR)
        self.buf = array.array("f", bytes(4 * self.n))

    def add(self, start, samples, gain=1.0):
        i0 = int(start * SR)
        buf = self.buf
        n = min(len(samples), self.n - i0)
        for i in range(max(0, -i0), n):
            buf[i0 + i] += samples[i] * gain


# --- instruments --------------------------------------------------------------

def epiano(freq, dur, vel=1.0):
    """Rhodes-ish FM tine: sine carrier, decaying 1:1 modulator, bell attack."""
    n = int(dur * SR)
    out = array.array("f", bytes(4 * n))
    cinc = freq * TBL_N / SR
    minc = freq * TBL_N / SR
    binc = freq * 14 * TBL_N / SR
    cp = mp = bp = 0.0
    for i in range(n):
        t = i / SR
        env = math.exp(-t * 1.6) * min(1.0, t * 300)
        rel = 1.0 if t < dur - 0.25 else max(0.0, (dur - t) / 0.25)
        mod_idx = 1.2 * math.exp(-t * 4) + 0.15
        m = SIN[int(mp) & 4095] * mod_idx * TBL_N / TAU
        v = SIN[int(cp + m) & 4095] * env + SIN[int(bp) & 4095] * 0.12 * math.exp(-t * 30)
        out[i] = v * rel * vel * 0.32
        cp += cinc
        mp += minc
        bp += binc
    return out


def vibes(freq, dur, vel=1.0):
    """Vibraphone: two partials with slow tremolo."""
    n = int(dur * SR)
    out = array.array("f", bytes(4 * n))
    a = freq * TBL_N / SR
    b = freq * 4 * TBL_N / SR
    pa = pb = 0.0
    for i in range(n):
        t = i / SR
        env = math.exp(-t * 1.1) * min(1.0, t * 400)
        trem = 0.75 + 0.25 * SIN[int(t * 5.5 * TBL_N) & 4095]
        out[i] = (SIN[int(pa) & 4095] + 0.25 * SIN[int(pb) & 4095] * math.exp(-t * 6)) * env * trem * vel * 0.28
        pa += a
        pb += b
    return out


def bass(freq, dur, vel=1.0):
    """Upright-ish bass: sine + soft second harmonic, plucked envelope."""
    n = int(dur * SR)
    out = array.array("f", bytes(4 * n))
    a = freq * TBL_N / SR
    p = 0.0
    for i in range(n):
        t = i / SR
        env = math.exp(-t * 2.5) * min(1.0, t * 200)
        rel = 1.0 if t < dur - 0.05 else max(0.0, (dur - t) / 0.05)
        out[i] = (SIN[int(p) & 4095] + 0.35 * SIN[int(p * 2) & 4095] + 0.1 * SIN[int(p * 3) & 4095]) * env * rel * vel * 0.5
        p += a
    return out


def pad(freqs, dur, attack=3.0, release=4.0, vel=1.0, detune=0.4):
    """Soft pad: each note is a few detuned sines with gentle partials."""
    n = int(dur * SR)
    out = array.array("f", bytes(4 * n))
    voices = []
    for f in freqs:
        for d in (-detune, 0.0, detune):
            for h, amp in ((1, 1.0), (2, 0.25), (3, 0.08)):
                voices.append([(f + d) * h * TBL_N / SR, random.random() * TBL_N, amp / (3 * len(freqs))])
    for i in range(n):
        t = i / SR
        env = min(1.0, t / attack) * (1.0 if t < dur - release else max(0.0, (dur - t) / release))
        s = 0.0
        for v in voices:
            s += SIN[int(v[1]) & 4095] * v[2]
            v[1] += v[0]
        out[i] = s * env * vel * 0.8
    return out


def bell(freq, dur=3.0, vel=1.0):
    n = int(dur * SR)
    out = array.array("f", bytes(4 * n))
    parts = [(1, 1.0, 1.5), (2.76, 0.5, 3), (5.4, 0.25, 5)]
    ph = [0.0] * 3
    for i in range(n):
        t = i / SR
        s = 0.0
        for k, (m, a, d) in enumerate(parts):
            s += SIN[int(ph[k]) & 4095] * a * math.exp(-t * d)
            ph[k] += freq * m * TBL_N / SR
        out[i] = s * min(1.0, t * 500) * vel * 0.18
    return out


def noise_hit(dur, decay, lp, vel, seed):
    """Filtered noise burst (brush, hat, snare)."""
    rnd = random.Random(seed)
    n = int(dur * SR)
    out = array.array("f", bytes(4 * n))
    y = 0.0
    for i in range(n):
        t = i / SR
        y += (rnd.uniform(-1, 1) - y) * lp
        out[i] = y * math.exp(-t * decay) * vel
    return out


def brush_swish(dur, vel, seed):
    rnd = random.Random(seed)
    n = int(dur * SR)
    out = array.array("f", bytes(4 * n))
    y = 0.0
    for i in range(n):
        t = i / SR
        env = math.sin(math.pi * t / dur) ** 2
        y += (rnd.uniform(-1, 1) - y) * 0.18  # darker, softer brushes
        out[i] = y * env * vel
    return out


def kick(vel=1.0):
    n = int(0.35 * SR)
    out = array.array("f", bytes(4 * n))
    p = 0.0
    for i in range(n):
        t = i / SR
        f = 45 + 70 * math.exp(-t * 30)
        out[i] = SIN[int(p) & 4095] * math.exp(-t * 9) * vel * 0.7
        p += f * TBL_N / SR
    return out


# --- effects ------------------------------------------------------------------

def reverb(buf, mix=0.25, room=0.82):
    """Small Schroeder reverb: 4 combs + 2 allpasses."""
    n = len(buf)
    wet = array.array("f", bytes(4 * n))
    for delay_ms in (29.7, 37.1, 41.1, 43.7):
        d = int(delay_ms * SR / 1000)
        line = array.array("f", bytes(4 * d))
        idx = 0
        for i in range(n):
            y = line[idx]
            line[idx] = buf[i] + y * room
            wet[i] += y * 0.25
            idx += 1
            if idx == d:
                idx = 0
    for delay_ms, g in ((5.0, 0.7), (1.7, 0.7)):
        d = int(delay_ms * SR / 1000)
        line = array.array("f", bytes(4 * d))
        idx = 0
        for i in range(n):
            x = wet[i]
            y = line[idx]
            out = -g * x + y
            line[idx] = x + g * out
            wet[i] = out
            idx += 1
            if idx == d:
                idx = 0
    for i in range(n):
        buf[i] = buf[i] * (1 - mix) + wet[i] * mix * 1.6


def lowpass(buf, a):
    y = 0.0
    for i in range(len(buf)):
        y += (buf[i] - y) * a
        buf[i] = y


def fade(buf, fin=2.0, fout=4.0):
    n = len(buf)
    for i in range(min(n, int(fin * SR))):
        buf[i] *= i / (fin * SR)
    m = int(fout * SR)
    for i in range(min(n, m)):
        buf[n - 1 - i] *= i / m


# --- output -------------------------------------------------------------------

def write(name, buf, quality=2, normalize=0.85):
    os.makedirs(OUT, exist_ok=True)
    peak = max(1e-6, max(abs(v) for v in buf))
    k = normalize / peak
    with tempfile.TemporaryDirectory() as tmp:
        wav = os.path.join(tmp, "o.wav")
        with wave.open(wav, "wb") as w:
            w.setnchannels(1)
            w.setsampwidth(2)
            w.setframerate(SR)
            w.writeframes(array.array("h", (int(max(-1, min(1, v * k)) * 32000) for v in buf)).tobytes())
        subprocess.run(["oggenc", "-Q", "-q", str(quality), "-o", os.path.join(OUT, name + ".ogg"), wav], check=True)
    print("wrote", name, "%.1fs" % (len(buf) / SR))


# --- harmony helpers ----------------------------------------------------------

def chord(root, kind):
    shapes = {
        "maj7": [0, 4, 7, 11], "m7": [0, 3, 7, 10], "7": [0, 4, 7, 10], "m9": [0, 3, 7, 10, 14],
        "maj9": [0, 4, 7, 11, 14], "9": [0, 4, 7, 10, 14], "13": [0, 4, 10, 14, 21], "6": [0, 4, 7, 9],
        "m11": [0, 3, 7, 10, 17], "maj7#11": [0, 4, 7, 11, 18],
    }
    return [root + i for i in shapes[kind]]


def voicing(notes, low=52, high=72):
    """Rootless-ish close voicing in a comfortable register."""
    out = []
    for n in notes[1:]:
        while n < low:
            n += 12
        while n > high:
            n -= 12
        out.append(n)
    return sorted(out)


# =============================================================================
# Tracks
# =============================================================================

def track_lounge():
    random.seed(11)
    bpm = 70
    beat = 60 / bpm
    prog = [(55, "m9"), (60, "13"), (53, "maj9"), (50, "m9"),     # Gm9 C13 Fmaj9 Dm9
            (55, "m9"), (60, "13"), (58, "maj7#11"), (57, "7"),   # Gm9 C13 Bbmaj7#11 A7
            (50, "m11"), (55, "9"), (48, "m9"), (53, "maj9")]     # Dm11 G9 Cm9 Fmaj9
    bars = len(prog) * 4
    T = Track(bars * 4 * beat + 6)
    scale = [53, 55, 57, 58, 60, 62, 64, 65, 67, 69, 70, 72, 74]
    t = 0.0
    for rep in range(4):
        for root, kind in prog:
            notes = chord(root, kind)
            # Rhodes comping: chord on beat 1, a lighter stab on the "and" of 2 (swung)
            for f in voicing(notes):
                T.add(t, epiano(mtof(f), beat * 2.6, 0.55))
            if random.random() < 0.7:
                for f in voicing(notes):
                    T.add(t + beat * 1.66, epiano(mtof(f), beat * 1.6, 0.3))
            # walking bass: root, chord tone, chord tone, approach
            line = [notes[0] - 12, notes[2] - 12, notes[1] - 12 + random.choice([0, 12]), notes[0] - 13 + random.choice([0, 2])]
            for k, m in enumerate(line):
                while m < 33:
                    m += 12
                T.add(t + k * beat, bass(mtof(m), beat * 0.95, 0.9))
            # brushes: swish on every beat, a tap on 2 and 4, ride on the swing
            for k in range(4):
                T.add(t + k * beat, brush_swish(beat * 0.9, 0.022, rep * 100 + k))
                if k % 2 == 1:
                    T.add(t + k * beat, noise_hit(0.2, 25, 0.5, 0.12, k))
                T.add(t + k * beat + beat * 0.66, noise_hit(0.25, 18, 0.5, 0.018, k + 7))
            # vibes melody in the 2nd and 4th time through
            if rep in (1, 3):
                pos = 0.0
                while pos < 4:
                    if random.random() < 0.55:
                        m = random.choice([n for n in scale if (n - root) % 12 in [(x - root) % 12 for x in notes] or random.random() < 0.3])
                        T.add(t + pos * beat, vibes(mtof(m + 12), beat * 2.5, 0.6))
                    pos += random.choice([0.66, 1.0, 1.33, 2.0])
            t += 4 * beat
    buf = T.buf
    reverb(buf, mix=0.28)
    fade(buf, 1.0, 6.0)
    write("csd_music_lounge", buf)


def track_drift():
    random.seed(22)
    prog = [(48, "maj9"), (45, "m9"), (53, "maj7#11"), (55, "6"),
            (52, "m7"), (45, "m9"), (50, "m9"), (55, "9")]
    chord_len = 14.0
    T = Track(len(prog) * chord_len + 10)
    t = 0.0
    for root, kind in prog:
        notes = chord(root, kind)
        T.add(t, pad([mtof(n) for n in voicing(notes, 55, 76)], chord_len + 4, attack=4, release=5, vel=0.9))
        T.add(t, pad([mtof(notes[0] - 12)], chord_len + 4, attack=5, release=5, vel=0.7, detune=0.15))
        # sparse bell twinkles from the chord, high up
        k = 0.0
        while k < chord_len:
            if random.random() < 0.5:
                T.add(t + k, bell(mtof(random.choice(notes) + 24), 3.5, 0.5 + random.random() * 0.4))
            k += random.choice([1.5, 2.0, 3.0])
        t += chord_len
    buf = T.buf
    reverb(buf, mix=0.4, room=0.86)
    fade(buf, 4.0, 8.0)
    write("csd_music_drift", buf)


def track_nightshift():
    random.seed(33)
    bpm = 78
    beat = 60 / bpm
    prog = [(51, "maj9"), (48, "m9"), (56, "maj7"), (58, "13")]  # Ebmaj9 Cm9 Abmaj7 Bb13
    T = Track(len(prog) * 8 * 4 * beat + 6)
    t = 0.0
    for rep in range(8):
        for root, kind in prog:
            notes = chord(root, kind)
            for f in voicing(notes, 55, 74):
                T.add(t, epiano(mtof(f), beat * 3.6, 0.45))
                T.add(t + beat * 2.5, epiano(mtof(f), beat * 1.4, 0.2))
            for k, (off, m) in enumerate(((0, notes[0]), (1.5, notes[0]), (2.5, notes[2]), (3.5, notes[1]))):
                mm = m - 24
                while mm < 31:
                    mm += 12
                T.add(t + off * beat, bass(mtof(mm), beat * 0.9, 0.8))
            if rep >= 1:
                for k in range(4):
                    if k in (0, 2) or (k == 3 and random.random() < 0.3):
                        T.add(t + k * beat, kick(0.7))
                    if k in (1, 3):
                        T.add(t + k * beat, noise_hit(0.25, 16, 0.45, 0.16, k + rep))
                    for h in (0, 0.55):
                        T.add(t + (k + h) * beat, noise_hit(0.08, 50, 0.9, 0.04, k * 3 + rep))
            if rep in (3, 4, 6, 7) and random.random() < 0.8:
                T.add(t + beat * random.choice([1, 2]), vibes(mtof(random.choice(notes) + 12), beat * 3, 0.45))
            t += 4 * beat
    buf = T.buf
    lowpass(buf, 0.55)
    # a whisper of tape hiss
    rnd = random.Random(5)
    for i in range(len(buf)):
        buf[i] += rnd.uniform(-1, 1) * 0.004
    reverb(buf, mix=0.22)
    fade(buf, 2.0, 6.0)
    write("csd_music_nightshift", buf)


def track_engine():
    random.seed(44)
    T = Track(150)
    prog = [(38, "m9"), (34, "maj7"), (36, "m7"), (33, "7")]
    t = 0.0
    while t < 140:
        for root, kind in prog:
            notes = chord(root, kind)
            T.add(t, pad([mtof(n) for n in voicing(notes, 45, 64)], 20, attack=5, release=6, vel=0.7, detune=0.6))
            T.add(t, pad([mtof(notes[0] - 12)], 20, attack=4, release=6, vel=1.0, detune=0.1))
            for k in range(0, 16, 2):     # slow mechanical pulse
                T.add(t + k, kick(0.35))
            for k in range(3):
                T.add(t + random.random() * 14, bell(mtof(random.choice(notes) + 36), 2.5, 0.25))
            t += 16
            if t >= 140:
                break
    buf = T.buf
    reverb(buf, mix=0.35, room=0.88)
    fade(buf, 4.0, 8.0)
    write("csd_music_engine", buf)


# =============================================================================
# Ambience loops and SFX
# =============================================================================

def seamless(buf, xfade=1.0):
    """Crossfade the end into the start so the loop is seamless."""
    m = int(xfade * SR)
    n = len(buf) - m
    out = array.array("f", buf[:n])
    for i in range(m):
        a = i / m
        out[i] = buf[n + i] * (1 - a) + out[i] * a
    return out


def amb_hull():
    random.seed(55)
    T = Track(21)
    T.add(0, pad([55, 82.5, 110], 21, attack=0.01, release=0.01, vel=0.6, detune=0.3))
    buf = T.buf
    nz = noise_hit(21, 0, 0.03, 0.25, 1)
    for i in range(len(buf)):
        buf[i] += nz[i] * (0.8 + 0.2 * SIN[int(i / SR * 0.2 * TBL_N) & 4095])
    write("csd_amb_hull", seamless(buf), normalize=0.5)


def amb_reactor():
    T = Track(17)
    T.add(0, pad([41.2, 61.7, 82.4, 164.8], 17, attack=0.01, release=0.01, vel=0.8, detune=0.8))
    buf = T.buf
    for i in range(len(buf)):
        buf[i] *= 0.7 + 0.3 * SIN[int(i / SR * 0.5 * TBL_N) & 4095]   # slow throb
    write("csd_amb_reactor", seamless(buf), normalize=0.6)


def amb_vents():
    buf = noise_hit(13, 0, 0.12, 0.4, 3)
    for i in range(len(buf)):
        buf[i] *= 0.8 + 0.2 * SIN[int(i / SR * 0.3 * TBL_N) & 4095]
    write("csd_amb_vents", seamless(buf), normalize=0.4)


def amb_bridge():
    random.seed(66)
    T = Track(17)
    T.add(0, pad([110, 165], 17, attack=0.01, release=0.01, vel=0.3))
    t = 0.3
    while t < 15.5:
        T.add(t, bell(mtof(random.choice([84, 88, 91, 96, 100])), 0.4, 0.4))
        t += random.choice([0.3, 0.6, 1.2, 2.0])
    write("csd_amb_bridge", seamless(T.buf), normalize=0.4)


def sfx():
    # lift: rising airy whoosh
    rnd = random.Random(7)
    n = int(1.2 * SR)
    buf = array.array("f", bytes(4 * n))
    y = 0.0
    for i in range(n):
        t = i / SR
        a = 0.03 + 0.25 * t
        y += (rnd.uniform(-1, 1) - y) * a
        buf[i] = y * math.sin(math.pi * t / 1.2)
    write("csd_sfx_lift", buf, normalize=0.6)
    # crate: latch click + lid thunk
    c = noise_hit(0.05, 80, 0.9, 1.0, 9)
    th = kick(0.8)
    buf = array.array("f", bytes(4 * int(0.5 * SR)))
    for i, v in enumerate(c):
        buf[i] += v
    for i, v in enumerate(th):
        if i + 2000 < len(buf):
            buf[i + 2000] += v * 0.7
    write("csd_sfx_crate", buf, normalize=0.6)
    # locker / suit: hydraulic hiss
    write("csd_sfx_locker", noise_hit(0.9, 4, 0.6, 0.6, 11), normalize=0.5)
    s = noise_hit(1.2, 3, 0.8, 0.6, 12)
    for i in range(len(s)):
        s[i] *= min(1, i / 2000)
    write("csd_sfx_suit", s, normalize=0.5)
    # console: two soft rising blips
    buf = array.array("f", bytes(4 * int(0.35 * SR)))
    for k, f in enumerate((880, 1320)):
        b = bell(f, 0.2, 1.0)
        for i, v in enumerate(b):
            if i + k * 1800 < len(buf):
                buf[i + k * 1800] += v
    write("csd_sfx_console", buf, normalize=0.5)
    # laser: descending zap
    zap = array.array("f", [math.sin(TAU * (1600 - 5000 * (i / SR)) * (i / SR)) * math.exp(-(i / SR) * 14)
                            for i in range(int(0.25 * SR))])
    write("csd_sfx_laser", zap, normalize=0.5)
    # explosion: deep noisy boom
    boom = noise_hit(1.4, 3, 0.04, 1.0, 21)
    k = kick(1.0)
    for i, v in enumerate(k):
        boom[i] += v * 1.5
    write("csd_sfx_explosion", boom, normalize=0.8)
    # door: hydraulic slide
    d = noise_hit(0.7, 4, 0.15, 0.7, 22)
    for i in range(len(d)):
        d[i] += math.sin(TAU * (120 + 80 * i / len(d)) * i / SR) * 0.3 * math.exp(-i / SR * 3)
    write("csd_sfx_door", d, normalize=0.5)
    # sit: soft cushion thump
    write("csd_sfx_sit", noise_hit(0.25, 20, 0.08, 1.0, 13), normalize=0.5)


ALL = {
    "lounge": track_lounge, "drift": track_drift, "nightshift": track_nightshift, "engine": track_engine,
    "ambience": lambda: (amb_hull(), amb_reactor(), amb_vents(), amb_bridge()), "sfx": sfx,
}

if __name__ == "__main__":
    if not shutil.which("oggenc"):
        sys.exit("oggenc is needed")
    for key in (sys.argv[1:] or list(ALL)):
        ALL[key]()
