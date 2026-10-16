"""Tiny mesh builder + binary glTF (.glb) writer for Luanti models.

Geometry is built in node units (1.0 = one node, origin at the node centre,
+Y up). Every face maps a whole rectangle of a texture atlas, so models look
pixel-crisp without UV unwrapping.

A model is a list of parts. A part is a Mesh plus an optional animation:
    ("spin", axis)        quarter-turn keys at t = 0..4 (forward) and 4..8 (reverse)
    ("stroke", (dx,dy,dz)) translation keys 0 -> offset -> 0 at t = 0, 1, 2
    ("dial", axis, deg)   rotation from -deg to +deg over t = 0..100 (gauge needles)
Luanti uses keyframe times directly as animation frames.
"""

import json
import math
import struct


class Atlas:
    """Named rectangles in a square texture, in pixels."""

    def __init__(self, size):
        self.size = size
        self.rects = {}

    def add(self, name, x, y, w, h):
        self.rects[name] = (x, y, w, h)

    def uv(self, name):
        x, y, w, h = self.rects[name]
        s = float(self.size)
        # Inset half a texel so neighbouring rects never bleed in.
        return ((x + 0.5) / s, (y + 0.5) / s, (x + w - 0.5) / s, (y + h - 0.5) / s)


class Mesh:
    def __init__(self, atlas):
        self.atlas = atlas
        self.pos, self.nrm, self.uvs, self.idx = [], [], [], []

    # -- low level -----------------------------------------------------------
    def quad(self, a, b, c, d, mat, normal=None):
        """a b c d counter-clockwise seen from the front; uv a=(u0,v1) b=(u1,v1) c=(u1,v0) d=(u0,v0)."""
        u0, v0, u1, v1 = self.atlas.uv(mat)
        if normal is None:
            normal = _normalize(_cross(_sub(b, a), _sub(d, a)))
        base = len(self.pos)
        for p, uv in ((a, (u0, v1)), (b, (u1, v1)), (c, (u1, v0)), (d, (u0, v0))):
            self.pos.append(p)
            self.nrm.append(normal)
            self.uvs.append(uv)
        self.idx += [base, base + 1, base + 2, base, base + 2, base + 3]

    def tri(self, a, b, c, mat, uvs=None):
        u0, v0, u1, v1 = self.atlas.uv(mat)
        normal = _normalize(_cross(_sub(b, a), _sub(c, a)))
        base = len(self.pos)
        uvs = uvs or ((0, 1), (1, 1), (0.5, 0))
        for p, (fu, fv) in zip((a, b, c), uvs):
            self.pos.append(p)
            self.nrm.append(normal)
            self.uvs.append((u0 + (u1 - u0) * fu, v0 + (v1 - v0) * fv))
        self.idx += [base, base + 1, base + 2]

    # -- shapes --------------------------------------------------------------
    def box(self, x0, y0, z0, x1, y1, z1, mat, side=None, top=None, bottom=None, front=None, back=None,
            transform=None):
        """Axis-aligned box. front = -Z face (towards the viewer of an unrotated node)."""
        side = side or mat
        faces = [
            # +Y
            ((x0, y1, z0), (x1, y1, z0), (x1, y1, z1), (x0, y1, z1), top or mat),
            # -Y
            ((x0, y0, z1), (x1, y0, z1), (x1, y0, z0), (x0, y0, z0), bottom or mat),
            # +X
            ((x1, y0, z0), (x1, y0, z1), (x1, y1, z1), (x1, y1, z0), side),
            # -X
            ((x0, y0, z1), (x0, y0, z0), (x0, y1, z0), (x0, y1, z1), side),
            # +Z (back)
            ((x1, y0, z1), (x0, y0, z1), (x0, y1, z1), (x1, y1, z1), back or side),
            # -Z (front)
            ((x0, y0, z0), (x1, y0, z0), (x1, y1, z0), (x0, y1, z0), front or side),
        ]
        for a, b, c, d, m in faces:
            if transform:
                a, b, c, d = (transform(p) for p in (a, b, c, d))
            self.quad(a, b, c, d, m)

    def cylinder(self, r, z0, z1, mat, cap=None, seg=12, axis="z", center=(0, 0, 0), caps=True):
        cap = cap or mat
        ring = [(math.cos(2 * math.pi * i / seg) * r, math.sin(2 * math.pi * i / seg) * r) for i in range(seg)]
        to3 = _axis_mapper(axis, center)
        for i in range(seg):
            (ax, ay), (bx, by) = ring[i], ring[(i + 1) % seg]
            self.quad(to3(ax, ay, z0), to3(bx, by, z0), to3(bx, by, z1), to3(ax, ay, z1), mat)
        if caps:
            for i in range(seg):
                (ax, ay), (bx, by) = ring[i], ring[(i + 1) % seg]
                uva = (0.5 + ax / (2 * r), 0.5 + ay / (2 * r))
                uvb = (0.5 + bx / (2 * r), 0.5 + by / (2 * r))
                self.tri(to3(0, 0, z1), to3(ax, ay, z1), to3(bx, by, z1), cap, ((0.5, 0.5), uva, uvb))
                self.tri(to3(0, 0, z0), to3(bx, by, z0), to3(ax, ay, z0), cap, ((0.5, 0.5), uvb, uva))

    def ring(self, r0, r1, z0, z1, mat, face=None, seg=24, axis="z", center=(0, 0, 0)):
        face = face or mat
        to3 = _axis_mapper(axis, center)
        pts = [(math.cos(2 * math.pi * i / seg), math.sin(2 * math.pi * i / seg)) for i in range(seg)]
        for i in range(seg):
            (ca, sa), (cb, sb) = pts[i], pts[(i + 1) % seg]
            # outer and inner walls
            self.quad(to3(ca * r1, sa * r1, z0), to3(cb * r1, sb * r1, z0), to3(cb * r1, sb * r1, z1), to3(ca * r1, sa * r1, z1), mat)
            self.quad(to3(cb * r0, sb * r0, z0), to3(ca * r0, sa * r0, z0), to3(ca * r0, sa * r0, z1), to3(cb * r0, sb * r0, z1), mat)
            # faces
            self.quad(to3(ca * r0, sa * r0, z1), to3(ca * r1, sa * r1, z1), to3(cb * r1, sb * r1, z1), to3(cb * r0, sb * r0, z1), face)
            self.quad(to3(cb * r0, sb * r0, z0), to3(cb * r1, sb * r1, z0), to3(ca * r1, sa * r1, z0), to3(ca * r0, sa * r0, z0), face)

    def gear(self, r_root, r_tip, teeth, z0, z1, mat, face=None, axis="z", center=(0, 0, 0)):
        """Spur gear: star outline extruded along the axis, faces fanned from the centre."""
        face = face or mat
        to3 = _axis_mapper(axis, center)
        outline = []
        for t in range(teeth):
            a = 2 * math.pi * t / teeth
            step = 2 * math.pi / teeth
            outline += [
                (r_root, a), (r_tip, a + step * 0.2), (r_tip, a + step * 0.45), (r_root, a + step * 0.65),
            ]
        pts = [(r * math.cos(a), r * math.sin(a)) for r, a in outline]
        n = len(pts)
        for i in range(n):
            (ax, ay), (bx, by) = pts[i], pts[(i + 1) % n]
            self.quad(to3(ax, ay, z0), to3(bx, by, z0), to3(bx, by, z1), to3(ax, ay, z1), mat)
            uva = (0.5 + ax / (2 * r_tip), 0.5 + ay / (2 * r_tip))
            uvb = (0.5 + bx / (2 * r_tip), 0.5 + by / (2 * r_tip))
            self.tri(to3(0, 0, z1), to3(ax, ay, z1), to3(bx, by, z1), face, ((0.5, 0.5), uva, uvb))
            self.tri(to3(0, 0, z0), to3(bx, by, z0), to3(ax, ay, z0), face, ((0.5, 0.5), uvb, uva))


def rot_z(deg):
    c, s = math.cos(math.radians(deg)), math.sin(math.radians(deg))
    return lambda p: (p[0] * c - p[1] * s, p[0] * s + p[1] * c, p[2])


def rot_x(deg):
    c, s = math.cos(math.radians(deg)), math.sin(math.radians(deg))
    return lambda p: (p[0], p[1] * c - p[2] * s, p[1] * s + p[2] * c)


def compose(*fs):
    def f(p):
        for g in fs:
            p = g(p)
        return p
    return f


def _axis_mapper(axis, center):
    cx, cy, cz = center
    if axis == "z":
        return lambda a, b, h: (cx + a, cy + b, cz + h)
    if axis == "x":
        return lambda a, b, h: (cx + h, cy + a, cz + b)
    return lambda a, b, h: (cx + b, cy + h, cz + a)  # y


def _sub(a, b):
    return (a[0] - b[0], a[1] - b[1], a[2] - b[2])


def _cross(a, b):
    return (a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0])


def _normalize(v):
    l = math.sqrt(v[0] ** 2 + v[1] ** 2 + v[2] ** 2) or 1.0
    return (v[0] / l, v[1] / l, v[2] / l)


# -- glTF writer ---------------------------------------------------------------

def _quat(axis, deg):
    h = math.radians(deg) / 2
    s = math.sin(h)
    x, y, z = {"x": (1, 0, 0), "y": (0, 1, 0), "z": (0, 0, 1)}[axis]
    return (x * s, y * s, z * s, math.cos(h))


def write_glb(path, parts):
    """parts: list of (Mesh, anim or None). One glTF node per part under a root."""
    bin_chunks = bytearray()
    buffer_views, accessors, meshes, nodes = [], [], [], []
    samplers, channels = [], []

    def add_view(data, target=None):
        while len(bin_chunks) % 4:
            bin_chunks.append(0)
        off = len(bin_chunks)
        bin_chunks.extend(data)
        bv = {"buffer": 0, "byteOffset": off, "byteLength": len(data)}
        if target:
            bv["target"] = target
        buffer_views.append(bv)
        return len(buffer_views) - 1

    def add_accessor(view, ctype, count, typ, mn=None, mx=None):
        acc = {"bufferView": view, "componentType": ctype, "count": count, "type": typ}
        if mn is not None:
            acc["min"], acc["max"] = mn, mx
        accessors.append(acc)
        return len(accessors) - 1

    for mesh, anim in parts:
        n = len(mesh.pos)
        assert n < 65536, "too many vertices for uint16 indices"
        pos = struct.pack("<%df" % (3 * n), *[c for p in mesh.pos for c in p])
        nrm = struct.pack("<%df" % (3 * n), *[c for p in mesh.nrm for c in p])
        uvs = struct.pack("<%df" % (2 * n), *[c for p in mesh.uvs for c in p])
        idx = struct.pack("<%dH" % len(mesh.idx), *mesh.idx)
        mn = [min(p[i] for p in mesh.pos) for i in range(3)]
        mx = [max(p[i] for p in mesh.pos) for i in range(3)]
        a_pos = add_accessor(add_view(pos, 34962), 5126, n, "VEC3", mn, mx)
        a_nrm = add_accessor(add_view(nrm, 34962), 5126, n, "VEC3")
        a_uv = add_accessor(add_view(uvs, 34962), 5126, n, "VEC2")
        a_idx = add_accessor(add_view(idx, 34963), 5123, len(mesh.idx), "SCALAR")
        meshes.append({"primitives": [{"attributes": {"POSITION": a_pos, "NORMAL": a_nrm, "TEXCOORD_0": a_uv},
                                       "indices": a_idx, "mode": 4}]})
        node = {"mesh": len(meshes) - 1, "translation": [0, 0, 0], "rotation": [0, 0, 0, 1], "scale": [1, 1, 1]}
        nodes.append(node)
        node_index = len(nodes) - 1  # root is appended last, so child indices are stable

        if anim:
            kind = anim[0]
            if kind == "spin":
                axis = anim[1]
                times = [0, 1, 2, 3, 4, 5, 6, 7, 8]
                angles = [0, 90, 180, 270, 360, 270, 180, 90, 0]
                vals = [c for a in angles for c in _quat(axis, a)]
                path_name, typ, comps = "rotation", "VEC4", 4
            elif kind == "stroke":
                d = anim[1]
                times = [0, 1, 2]
                vals = [0, 0, 0, d[0], d[1], d[2], 0, 0, 0]
                path_name, typ, comps = "translation", "VEC3", 3
            elif kind == "dial":
                axis, deg = anim[1], anim[2]
                times = [0, 25, 50, 75, 100]
                vals = [c for t in times for c in _quat(axis, -deg + 2 * deg * t / 100)]
                path_name, typ, comps = "rotation", "VEC4", 4
            else:
                raise ValueError(kind)
            t_acc = add_accessor(add_view(struct.pack("<%df" % len(times), *times)), 5126, len(times), "SCALAR",
                                 [float(min(times))], [float(max(times))])
            v_acc = add_accessor(add_view(struct.pack("<%df" % len(vals), *vals)), 5126, len(times), typ)
            samplers.append({"input": t_acc, "output": v_acc, "interpolation": "LINEAR"})
            channels.append({"sampler": len(samplers) - 1, "target": {"node": node_index, "path": path_name}})

    child_ids = list(range(len(nodes)))
    nodes.append({"name": "root", "children": child_ids})
    gltf = {
        "asset": {"version": "2.0", "generator": "csd meshlib"},
        "scene": 0,
        "scenes": [{"nodes": [len(nodes) - 1]}],
        "nodes": nodes,
        "meshes": meshes,
        "accessors": accessors,
        "bufferViews": buffer_views,
        "buffers": [{"byteLength": len(bin_chunks)}],
    }
    if channels:
        gltf["animations"] = [{"name": "main", "samplers": samplers, "channels": channels}]
    js = json.dumps(gltf, separators=(",", ":")).encode()
    while len(js) % 4:
        js += b" "
    while len(bin_chunks) % 4:
        bin_chunks.append(0)
    total = 12 + 8 + len(js) + 8 + len(bin_chunks)
    with open(path, "wb") as f:
        f.write(struct.pack("<III", 0x46546C67, 2, total))
        f.write(struct.pack("<II", len(js), 0x4E4F534A))
        f.write(js)
        f.write(struct.pack("<II", len(bin_chunks), 0x004E4942))
        f.write(bin_chunks)
