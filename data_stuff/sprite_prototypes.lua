-- Settings
local HD1_ENABLED = settings.startup["visible-planets-enable-hd1"].value

-- Constants
local sprite_goal_size = 512 -- Sprites larger than this will be scaled down to this size.

-- Create SpritePrototype for each planet
local function create_planet_sprite_prototype(planet)
    if planet.name == "space-location-unknown" then
        log("Skipping visible-planets for planet space-location-unknown")
        return
    end
    local size = planet.starmap_icon_size or planet.icon_size
    if HD1_ENABLED then
        size = 2160
    end
    if not size then
        log("Skipping visible-planets for planet " .. planet.name .. " because it has no sprite. (starmap_icon_size or icon_size missing)")
        return
    end
    log("Adding visible-planets for planet " .. planet.name)
    local name = "visible-planets-" .. planet.name
    local sprite_prototype = {
        type = "sprite",
        name = name,
        filename = planet.starmap_icon or planet.icon,
        size = size,
        scale = math.min(1, sprite_goal_size/size), -- Scale down large sprites. Shouldn't reduce resolution.
        mipmap_count = 1,
        flags = { "linear-minification", "linear-magnification" }, -- Prevent pixels showing.
        -- Sprite priority?
    }
    if HD1_ENABLED then
        sprite_prototype = {
            type = "sprite",
            name = name,
            filename = "__visible-planets__/graphics/hd1/".. planet.name .. ".png",
            size = size,
            scale = math.min(1, sprite_goal_size/size), -- Scale down large sprites. Shouldn't reduce resolution.
            mipmap_count = 1,
            flags = { "linear-minification", "linear-magnification" }, -- Prevent pixels showing.
            -- Sprite priority?
        }
    end
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