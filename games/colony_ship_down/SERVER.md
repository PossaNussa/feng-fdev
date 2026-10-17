# Running the official server (45.143.196.182)

The launcher connects to `45.143.196.182:30000` by default. On that machine:

1. Build or copy the **feng-fdev** engine (`luantiserver`), with this repo as
   `games/colony_ship_down` inside it.
2. Create a world for the game:

       mkdir -p worlds/csd
       printf 'gameid = colony_ship_down\nbackend = sqlite3\nplayer_backend = sqlite3\nauth_backend = sqlite3\nmod_storage_backend = sqlite3\n' > worlds/csd/world.mt

3. Put this in the server's `minetest.conf` (next to the binary):

       server_name = Colony Ship Down - Official
       server_description = Hang out aboard the CSV Meridian. Tasks, malfunctions, robots, rooms to claim.
       server_address = 45.143.196.182
       port = 30000
       server_announce = true        # lists it in the public list; the launcher shows CSD servers only
       name = <your admin name>      # this account gets the builder privilege automatically
       max_users = 64
       enable_pvp = false

4. Start it: `bin/luantiserver --world worlds/csd --port 30000`

   Open UDP port 30000 in the firewall. The ship is generated on first start.

Players don't need the game installed: the server sends all mods, textures
and sounds when they join.

## Updating the ship after a layout change

The ship is generated once per world. When an update changes the layout (for
example the zoo deck and air ducts in csd-v1.0.1), either start a fresh world
or type `/regenship confirm` as an admin. That rebuilds the whole ship
volume, so anything builders changed by hand is lost.
