-- VP Overrides - Mod Data

-- Other mods can edit this prototype directly if wanted, but helper functions are provided below.
data:extend({
	{
		type = "mod-data",
		name = "visible-planets-overrides",
		data = {
			planets = { -- Extra nested table to avoid IDE complaining about types /shrug
				["space-location-unknown"] = {
					enabled = false -- By default, always blacklist this location.
				},
			},
		},
	},
})

local overrides = data.raw["mod-data"]["visible-planets-overrides"].data.planets
local function ensure_planet_entry(name)
	if not overrides[name] then
		overrides[name] = {}
	end
end

-- Functions for other mods to call during data stage to modify visible planets

-- Space location names to not generate a sprite prototype for, effectively preventing them from showing a sprite.
function vp_add_planets_to_blacklist(names)
	for _, name in pairs(names) do
		ensure_planet_entry(name)
		overrides[name].enabled = false
	end
end

-- Space locations can have a specified scale, multiplied by the default scale. (2.0 results in 2x scale of other planets)
function vp_override_planet_scale(name, scale)
	ensure_planet_entry(name)
	overrides[name].scale = scale
end

-- Space locations can use a custom sprite file path, overriding the default usage of the starmap_icon.
function vp_override_planet_sprite(name, filepath, size)
	ensure_planet_entry(name)
	overrides[name].filepath = filepath
	overrides[name].size = size
end

-- Space locations can have their rotation disabled, even if rotation is enabled in settings.
function vp_disable_planet_rotation(name)
	ensure_planet_entry(name)
	overrides[name].rotate = false
end

-- Space locations can have their rotation speed multiplied.
function vp_set_planet_rotation_mult(name, mult)
	ensure_planet_entry(name)
	overrides[name].rotate_mult = mult
end

-- Helper for getting the overrides table.
function vp_get_planet_overrides()
	return overrides
end