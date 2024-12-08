-- Constants
local sprite_goal_size = 512 -- Sprites larger than this will be scaled down to this size.
local use_blacklist = not settings.startup["visible-planets-override-show-planets"].value -- If true, override and *DON'T* use blacklist. I got it backwards.

-- Create SpritePrototype for each planet
local function create_planet_sprite_prototype(planet)
    local size = planet.starmap_icon_size or planet.icon_size
    if not size then
        log("Skipping visible-planets for location " .. planet.name .. " because it has no sprite. (starmap_icon_size or icon_size missing)")
        return
    end
    log("Adding visible-planets for location " .. planet.name)
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
    data:extend { sprite_prototype }
end

-- Create SpritePrototypes for each planet not in the blacklist
local planet_blacklist = vp_get_planet_blacklist() -- Defined in separate file
local function create_for_each(planets)
    for _, planet in pairs(planets) do
        for _, blacklist in pairs(planet_blacklist) do
            if use_blacklist and planet.name == blacklist then
                log("Skipping visible-planets for location " .. planet.name .. " because it is in the blacklist.")
                goto blacklist_skip -- goto feels so *wrong* though.
            end
        end
        create_planet_sprite_prototype(planet)
        ::blacklist_skip::
    end
end
create_for_each(data.raw["planet"])
create_for_each(data.raw["space-location"])