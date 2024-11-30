local function create_planet_sprite_prototype(name, filename, layers)
	local sprite_prototype = {
		type = "sprite",
		name = "visible-planets-" .. name,
		size = 512,
		scale = 1,
		mipmap_count = 1,
		flags = { "linear-minification", "linear-magnification" }, -- Prevent pixels showing.
		-- Sprite priority?
	}
	if filename then
		sprite_prototype.filename = filename
		sprite_prototype.size = 512
	else
		sprite_prototype.layers = {}
		for _, icon in pairs(layers) do
			table.insert(sprite_prototype.layers, {
				filename = icon.icon,
				size = icon.ison_size,
				scale = icon.scale,
				shift = icon.shift,
				tint = icon.tint,
				mipmap_count = 1,
				flags = { "linear-minification", "linear-magnification" },
			})
		end
	end
	data:extend { sprite_prototype }
	return sprite_prototype
end

for _, planet in pairs(data.raw.planet) do
	create_planet_sprite_prototype(planet.name, planet.starmap_icon, planet.starmap_icons)
end
