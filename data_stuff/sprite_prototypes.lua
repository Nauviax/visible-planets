-- Create SpritePrototype for each planet
local function create_planet_sprite_prototype(planet)
    if planet.name == "space-location-unknown" then
        log("Skipping visible-planets for planet space-location-unknown")
        return
    end
    if not (planet.starmap_icon_size or planet.icon_size) then
        log("Skipping visible-planets for planet " .. planet.name .. " because it has no sprite. (starmap_icon_size or icon_size missing)")
        return
    end
    log("Adding visible-planets for planet " .. planet.name)
    local name = "visible-planets-" .. planet.name
    local sprite_prototype = {
        type = "sprite",
        name = name,
        filename = planet.starmap_icon or planet.icon,
        size = planet.starmap_icon_size or planet.icon_size,
        scale = 1,
        mipmap_count = 1,
        flags = { "linear-minification", "linear-magnification" }, -- Prevent pixels showing.
        -- Sprite priority?
    }
    data:extend { sprite_prototype }
end

local planets = data.raw["planet"]
for _, planet in pairs(planets) do
    create_planet_sprite_prototype(planet)

end
local planets_locations = data.raw["space-location"]
for _, planet in pairs(planets_locations) do
    create_planet_sprite_prototype(planet)
end