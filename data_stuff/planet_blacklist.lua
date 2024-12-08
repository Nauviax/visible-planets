-- Space location names in this list will not have a sprite prototype generated for them, effectively preventing them from showing a sprite.
local planet_blacklist = {
	"space-location-unknown", -- By default, always blacklist this location.
}

-- Global function that other mods can use to add names to the blacklist. (Blacklist is used by this mod in data-final-fixes stage)
function vp_add_planets_to_blacklist(names)
	for _, name in pairs(names) do
		table.insert(planet_blacklist, name)
	end
end

-- And another global function to GET the blacklist.
function vp_get_planet_blacklist()
	return planet_blacklist
end