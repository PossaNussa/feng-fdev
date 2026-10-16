# Offline tests

`shallow_spec.lua` runs the real `shallow.lua` against a stubbed Luanti API and a
fake voxel world, so the flow logic can be checked without booting a server.

What it is actually guarding: **water must never be created or destroyed.** Every
test re-counts the total volume after every tick and fails the moment it changes.

The one exception is a puddle merging into a lake, a river or the sea, which has
to round to a whole node — there is no way to store "the lake is 3/8 of a node
deeper". Those roundings are not free-floating: `shallow.lua` writes each one to
`dynamic_liquid.shallow_merge_delta`, and the tests hold `volume - ledger`
constant, so a merge is allowed but nothing may go missing quietly.

It also checks that a body of water is left completely alone, that water joins
water rather than pooling beside it at its own depth, that a puddle cannot dam a
full node in place, and that puddles stop running timers once they settle. Note
that "settled" means the *puddles* stopped: a lone source with an open cell
beside it wanders for as long as you watch it, which is plain dynamic_liquid
behaviour and not what this file tests.

There is no standalone Lua interpreter on this machine, but LuaJIT's headers and
shared library are installed, so build a ten-line runner:

```sh
cat > /tmp/runner.c <<'EOF'
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
#include <stdio.h>
int main(int argc, char **argv) {
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    if (luaL_dofile(L, argv[1])) {
        fprintf(stderr, "ERROR: %s\n", lua_tostring(L, -1));
        return 1;
    }
    lua_close(L);
    return 0;
}
EOF
gcc -I/usr/include/luajit-2.1 -o /tmp/lrun /tmp/runner.c -lluajit-5.1
```

Then, from this directory:

```sh
/tmp/lrun shallow_spec.lua
```

The stubs mirror the engine where it matters — in particular `get_node_level` /
`set_node_level` follow `mapnode.cpp`, where a `leveled` node reads `param2 & 0x7F`
and a stored level of 0 falls back to the nodedef's static `leveled` value.

The harness also models the parts of `dynamic_liquids.lua`'s movement ABM that
shallow water hands off to and receives from: the whole-column drop, the sideways
source move, and the stranded-source check — including the fact that the latter
looks a full cell in every direction, diagonals included, so that water at the
edge of a lake is never mistaken for a stranded block. Without those the tunnel and slope
cases do nothing, because water travels between puddles as ordinary sources.
