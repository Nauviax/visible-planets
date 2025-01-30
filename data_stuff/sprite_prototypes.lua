-- Constants
local sprite_goal_size = 512 -- Sprites that have a different size will be scaled to this size.
local use_blacklist = not settings.startup["visible-planets-override-show-planets"].value -- If true, override and *DON'T* use blacklist. I got it backwards.
local use_planetslib_compat = settings.startup["visible-planets-planetslib-compat"].value -- If true, add PlanetsLib layers to planets and moons.
local planetslib_scale = settings.startup["visible-planets-planetslib-scale"].value
local planetslib_x = settings.startup["visible-planets-planetslib-x"].value
local planetslib_y = settings.startup["visible-planets-planetslib-y"].value
local planetslib_tint = settings.startup["visible-planets-planetslib-tint"].value

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
        layers = {}, -- Added below
    }
    local main_layer = { -- Large planet render
        filename = icon,
        size = icon_size,
        scale = scale_override * (sprite_goal_size/icon_size), -- Scale down large sprites. Shouldn't reduce resolution.
        flags = { "linear-minification", "linear-magnification" }, -- Prevent pixels showing.
    }

    -- PlanetLib compat, if it exists and is enabled.
    if use_planetslib_compat and mods["PlanetsLib"] and planet.surface_properties then
        -- Get the planet this "moon" is orbiting, if any.
        local parent_planet_str = planet.surface_properties["parent-planet-str"]
        -- Add parent layer if moon, or moon layer if parent of a moon.
        if parent_planet_str then -- Is a moon
            for _, other_planet in pairs(data.raw["planet"]) do
                if other_planet.surface_properties and other_planet.surface_properties["planet-str"] == parent_planet_str then
                    -- Add layer
                    log("Adding PlanetsLib compat for moon " .. planet.name .. " orbiting " .. other_planet.name)
                    table.insert(sprite_prototype.layers, {
                        filename = other_planet.starmap_icon,
                        size = other_planet.starmap_icon_size,
                        scale = 0.2 * (sprite_goal_size/other_planet.starmap_icon_size),
                        flags = { "linear-minification", "linear-magnification" },
                        tint = { r = 0.5, g = 0.5, b = 0.5, a = 1 }, -- Darken
                    })
                end
            end
        else -- Is a planet, might have moon(s)
            local planet_str = planet.surface_properties["planet-str"]
            for _, other_planet in pairs(data.raw["planet"]) do
                if other_planet.surface_properties and other_planet.surface_properties["parent-planet-str"] == planet_str then
                    -- Add layer
                    log("Adding PlanetsLib compat for " .. planet.name .. " with moon " .. other_planet.name)
                    table.insert(sprite_prototype.layers, {
                        filename = other_planet.starmap_icon,
                        size = other_planet.starmap_icon_size,
                        scale = planetslib_scale * (sprite_goal_size/other_planet.starmap_icon_size),
                        flags = { "linear-minification", "linear-magnification" },
                        tint = { r = planetslib_tint, g = planetslib_tint, b = planetslib_tint, a = 1 }, -- Darken
                    })
                end
            end
        end
        -- Arrange bodies around main body.
        local num_children = #sprite_prototype.layers
        local shift_x = planetslib_x -- Initial shift, top left corner.
        local shift_y = planetslib_y
        for _,child in pairs(sprite_prototype.layers) do -- Rotate background bodies about main body.
            child.shift = {shift_x, shift_y}
            shift_x = (shift_x * math.cos(math.pi/num_children)) - (shift_y * math.sin(math.pi/num_children))
            shift_y = (shift_x * math.sin(math.pi/num_children)) - (shift_y * math.cos(math.pi/num_children))
        end
    end

    -- Add main planet as top layer
    table.insert(sprite_prototype.layers, main_layer)
    data:extend{sprite_prototype}
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