FlashEng Colored Lighting — End-to-End Pipeline (Drop-in Files)

What these do:
- Parse `light_colour` / `light_color` from nodedefs (Lua) into ContentFeatures
- Serialize `light_colour` with ContentFeatures from server to client (length-safe)
- De-serialize on client (optional read if present; defaults to white)
- Compute a per-mapblock tint from nearby light emitters (gamma-aware)
- Multiply the tint into the vertex colour blend (applies near + far)
- UI entries for enabling and tuning the effect (and particle cap defaults)

Client settings (Advanced Settings or minetest.conf):
  enable_colored_lighting_tint = true
  colored_lighting_samples = 8
  colored_lighting_max_distance = 2
  max_particles = 20000

Nodedef example:
  minetest.register_node("mymod:warm_lamp", {
      description = "Warm Lamp",
      tiles = {"mymod_warm_lamp.png"},
      paramtype    = "light",
      light_source = 14,
      light_colour = "#ffcc66", -- or light_color
  })
