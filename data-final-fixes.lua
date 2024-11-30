-- Removes shadows from asteroids
require("data_stuff/remove_asteroid_shadow.lua")


-- Create SpritePrototype for each planet
local function create_planet_sprite_prototype(planet)

    local name = "visible-planets-" .. planet.name
    -- existing
    if data.raw["sprite"][name] then
        return
    end
    if planet.name == "space-location-unknown" then
        return
    end
    
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
for k, planet in pairs(planets) do
    log("Adding visible-planets for planet " .. planet.name .. "")
    create_planet_sprite_prototype(planet)

end
local planets = data.raw["space-location"]
for k, planet in pairs(planets) do
    log("Adding visible-planets for planet " .. planet.name .. "")
    create_planet_sprite_prototype(planet)
end
