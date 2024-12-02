data:extend({
    -- Runtime settings
    {
        type = "double-setting",
        name = "visible-planets-planet-scale",
        setting_type = "runtime-global",
        default_value = 6.0,
        minimum_value = 0.0,
        order = "a"
    },
    {
        type = "int-setting",
        name = "visible-planets-planet-pos-x",
        setting_type = "runtime-global",
        default_value = -50,
        order = "b"
    },
    {
        type = "int-setting",
        name = "visible-planets-planet-pos-y",
        setting_type = "runtime-global",
        default_value = 20,
        order = "c"
    },
    {
        type = "int-setting",
        name = "visible-planets-planet-init-dist",
        setting_type = "runtime-global",
        default_value = 75,
        minimum_value = 0, -- Always in front of platform, so players don't get confused with whether or not to use a negative number here.
        order = "d"
    },
    {
        type = "int-setting",
        name = "visible-planets-planet-anim-dur",
        setting_type = "runtime-global",
        default_value = 180,
        minimum_value = 1, -- Avoid division by zero
        order = "e"
    },
    {
        type = "double-setting",
        name = "visible-planets-parallax-factor",
        setting_type = "runtime-global",
        default_value = 2,
        minimum_value = 0.1,
        order = "f"
    },
    -- Startup settings
    {
        type = "bool-setting",
        name = "visible-planets-enable-parallax",
        setting_type = "startup",
        default_value = true,
        order = "a"
    },
    {
        type = "bool-setting",
        name = "visible-planets-enable-hd1",
        setting_type = "startup",
        default_value = false,
        order = "b"
    },
})