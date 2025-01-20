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
        layers = {}, --Layers will be added later
    }
    local main_layer =
        {
            filename = icon,
            size = icon_size,
            scale = scale_override * (sprite_goal_size/icon_size), -- Scale down large sprites. Shouldn't reduce resolution.
            flags = { "linear-minification", "linear-magnification" }, -- Prevent pixels showing.
            -- mipmap_count = 1,
        }
    local parent_planet_str
    if planet["surface_properties"] then
        parent_planet_str = planet["surface_properties"]["parent-planet-str"]
    end
    local parent_scaling = settings.startup["visible-planets-parent-planets-scale"].value
    if planet["surface_properties"] and  planet["surface_properties"]["parent-planet-str"] ~= nil then --If body is a moon, add planet to background
        --assert(1==0)
        for _,other_planet in pairs(data.raw["planet"]) do
            if other_planet.surface_properties and PlanetsLib.planet_str.get_planet_str_double(other_planet) == parent_planet_str then
                if other_planet.starmap_icon then
                    --local moon_layer = sprite_prototype.layers[1]
                    --sprite_prototype.layers[2] = sprite_prototype.layers[1]
                    table.insert(sprite_prototype.layers,
                    {
                        filename = other_planet.starmap_icon,
                        size = other_planet.starmap_icon_size,
                        scale = parent_scaling* (sprite_goal_size/other_planet.starmap_icon_size), -- Scale down large sprites. Shouldn't reduce resolution.
                        shift={settings.startup["visible-planets-parent-planet-shift-x"].value,-settings.startup["visible-planets-parent-planet-shift-y"].value},
                        flags = { "linear-minification", "linear-magnification" }, -- Prevent pixels showing.
                        -- mipmap_count = 1,
                    })
                end
                
            end
        end
    end

    --If body has any moons, add them to background
    local shift_x = settings.startup["visible-planets-parent-planet-shift-x"].value
    local shift_y=-settings.startup["visible-planets-parent-planet-shift-y"].value
    for _,other_planet in pairs(data.raw["planet"]) do --Search for moons
        if other_planet["surface_properties"] and  other_planet["surface_properties"]["parent-planet-str"] ~= nil then 
            if planet["surface_properties"] and other_planet["surface_properties"] and planet["surface_properties"]["planet-str"] == other_planet["surface_properties"]["parent-planet-str"] then --If this other planet is a moon of this planet
                if other_planet.starmap_icon then
                    table.insert(sprite_prototype.layers,
                        {
                            filename = other_planet.starmap_icon,
                            size = other_planet.starmap_icon_size,
                            scale = parent_scaling* (sprite_goal_size/other_planet.starmap_icon_size), -- Scale down large sprites. Shouldn't reduce resolution.
                            shift={shift_x,shift_y},
                            flags = { "linear-minification", "linear-magnification" }, -- Prevent pixels showing.
                            -- mipmap_count = 1,
                        })
                end
            end
        end
    end
    local num_children=#sprite_prototype.layers --Number of background bodies
    for _,child in pairs(sprite_prototype.layers) do --Rotate background bodies about main body.
    
        child.shift = {shift_x,shift_y}
        shift_x = shift_x*math.cos(math.pi/num_children)-shift_y*math.sin(math.pi/num_children)
        shift_y = shift_x*math.sin(math.pi/num_children)-shift_y*math.cos(math.pi/num_children)
        child.tint = {0.5,0.5,0.5}
    end

    table.insert(sprite_prototype.layers, --Planet sprite on top of all background bodies.
        main_layer
    )

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