-- Constants
local sprite_goal_size = 512 -- Sprites that have a different size will be scaled to this size.
local use_blacklist = not settings.startup["visible-planets-override-show-planets"].value -- If true, override and *DON'T* use blacklist. I got it backwards.

-- Create SpritePrototype for each planet
local planet_overrides = vp_get_planet_overrides() -- Defined in separate file
local function create_planet_sprite_prototype(planet)
    local icon = planet.starmap_icon
    local icon_size = planet.starmap_icon_size
    local scale_override = 1; -- Default change nothing.
    local overrides = planet_overrides[planet.name]
    if overrides then -- Handle overrides, if any.
        if overrides.filepath then
            log("Overriding filepath for " .. planet.name .. " to " .. overrides.filepath)
            icon = overrides.filepath
            icon_size = overrides.size
        end
        if overrides.scale then
            log("Overriding scale for " .. planet.name .. " to " .. overrides.scale)
            scale_override = overrides.scale
        end
    end
    if not icon then
        log("Skipping visible-planets for " .. planet.name .. "; Starmap icon missing.")
        return
    end
    -- Create SpritePrototype
    log("Adding visible-planets for " .. planet.name)
    local name = "visible-planets-" .. planet.name
    local sprite_prototype = {
        type = "sprite",
        name = name,
        filename = icon,
        size = icon_size,
        scale = scale_override * (sprite_goal_size/icon_size), -- Scale down large sprites. Shouldn't reduce resolution.
        -- mipmap_count = 1,
        flags = { "linear-minification", "linear-magnification" }, -- Prevent pixels showing.
    }
    data:extend { sprite_prototype }
end

-- Create SpritePrototypes for each planet not in the blacklist
local planet_blacklist = vp_get_planet_blacklist() -- Defined in separate file
local function create_for_each(planets)
    for _, planet in pairs(planets) do
        for _, blacklist in pairs(planet_blacklist) do
            if use_blacklist and planet.name == blacklist then
                log("Skipping visible-planets for " .. planet.name .. "; Blacklisted.")
                goto blacklist_skip -- goto feels so *wrong* though.
            end
        end
        create_planet_sprite_prototype(planet)
        ::blacklist_skip::
    end
end
create_for_each(data.raw["planet"])
create_for_each(data.raw["space-location"])