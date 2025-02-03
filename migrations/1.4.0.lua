-- Force update and/or reset to new table system
if storage.visible_planets_renders_still then -- Planets exist that need cleaning
    -- Destroy sprites in each table
    for _, render in pairs(storage.visible_planets_renders_grow) do
        render.obj.destroy()
    end
    for _, render in pairs(storage.visible_planets_renders_still) do
        render.obj.destroy()
    end
    for _, render in pairs(storage.visible_planets_renders_shrink) do
        render.obj.destroy()
    end
    -- Reinitialize the tables
    storage.visible_planets_renders_grow = {}
    storage.visible_planets_renders_still = {}
    storage.visible_planets_renders_shrink = {}
    -- Regen planets with new system.
    for _, surface in pairs(game.surfaces) do
        if surface.platform then
            vp_render_planet_on_platform(surface.platform)
        end
    end
end