data:extend({
    -- Runtime settings
    {
        type = "bool-setting",
        name = "visible-planets-regen-renders",
        setting_type = "runtime-global",
        default_value = false,
        order = "a[main]-a"
    },
    {
        type = "double-setting",
        name = "visible-planets-planet-scale",
        setting_type = "runtime-global",
        default_value = 6.0,
        minimum_value = 0.0,
        order = "b[sprite]-a"
    },
    {
        type = "int-setting",
        name = "visible-planets-planet-pos-x",
        setting_type = "runtime-global",
        default_value = -50,
        order = "b[sprite]-b"
    },
    {
        type = "int-setting",
        name = "visible-planets-planet-pos-y",
        setting_type = "runtime-global",
        default_value = 20,
        order = "b[sprite]-c"
    },
    {
        type = "int-setting",
        name = "visible-planets-planet-init-dist",
        setting_type = "runtime-global",
        default_value = 75,
        minimum_value = 0, -- Always in front of platform, so players don't get confused with whether or not to use a negative number here.
        order = "b[sprite]-d"
    },
    {
        type = "int-setting",
        name = "visible-planets-planet-anim-dur",
        setting_type = "runtime-global",
        default_value = 180,
        minimum_value = 1, -- Avoid division by zero
        order = "b[sprite]-e"
    },
    {
        type = "int-setting",
        name = "visible-planets-planet-angle",
        setting_type = "runtime-global",
        default_value = 0,
        minimum_value = 0,
        maximum_value = 359,
        order = "b[sprite]-f"
    },
    {
        type = "bool-setting",
        name = "visible-planets-enable-parallax",
        setting_type = "runtime-global",
        default_value = true,
        order = "c[parallax]-a"
    },
    {
        type = "double-setting",
        name = "visible-planets-parallax-factor",
        setting_type = "runtime-global",
        default_value = 2,
        minimum_value = 0.1,
        order = "c[parallax]-b"
    },
    {
        type = "bool-setting",
        name = "visible-planets-enable-rotation",
        setting_type = "runtime-global",
        default_value = true,
        order = "d[rotation]-a"
    },
    {
        type = "double-setting",
        name = "visible-planets-rotation-speed",
        setting_type = "runtime-global",
        default_value = 0.02,
        minimum_value = -180,
        maximum_value = 180,
        order = "d[rotation]-b"
    }
})