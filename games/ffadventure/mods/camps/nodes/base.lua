
core.register_node("camps:base", {
    description = "The unbreakable foundation of a camp",
    tiles = { "camps_base.png" },
    is_ground_content = false,
    light_source = 4,
    sunlight_propagates = true,
    pointable = true,
    diggable = false,
    climbable = false,
    groups = {
        not_in_creative_inventory=1,
    },
    on_blast = function (pos, intensity)
        return nil
    end,
})
