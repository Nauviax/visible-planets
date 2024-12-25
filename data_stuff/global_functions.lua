-- Planet Blacklist

-- Space location names in this list will not have a sprite prototype generated for them, effectively preventing them from showing a sprite.
local planet_blacklist = {
	"space-location-unknown", -- By default, always blacklist this location.
}

function vp_add_planets_to_blacklist(names)
	for _, name in pairs(names) do
		table.insert(planet_blacklist, name)
	end
end

function vp_get_planet_blacklist()
	return planet_blacklist
end


-- Planet Overrides

-- Space locations can have a specified scale, multiplied by the default scale. (2.0 results in 2x scale of other planets)
-- Space locations can use a custom sprite file path, overriding the default usage of the starmap_icon.
local planet_overrides = {} -- Keyed by location internal name, value is a table of overrides.

function vp_override_planet_scale(name, scale)
	if not planet_overrides[name] then
		planet_overrides[name] = {}
	end
	planet_overrides[name].scale = scale
end

function vp_override_planet_sprite(name, filepath, size)
	if not planet_overrides[name] then
		planet_overrides[name] = {}
	end
	planet_overrides[name].filepath = filepath
	planet_overrides[name].size = size
end

function vp_get_planet_overrides()
	return planet_overrides
end
