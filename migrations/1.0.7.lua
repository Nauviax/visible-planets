-- Force update and/or reset to new table system

-- If the old table exists, remove it
if storage.visible_planets_renders then
	storage.visible_planets_renders = nil
end

-- Function to destroy sprites in a table (Clean up old planet renders)
local function destroy_sprites(sprite_table)
	if sprite_table == nil then return end
    for _, sprite in pairs(sprite_table) do
        sprite.destroy()
    end
end

-- Destroy sprites in each table
destroy_sprites(storage.visible_planets_renders_grow)
destroy_sprites(storage.visible_planets_renders_still)
destroy_sprites(storage.visible_planets_renders_shrink)

-- Reinitialize the tables
storage.visible_planets_renders_grow = {}
storage.visible_planets_renders_still = {} -- This removes old planets, but is required due to new system.
storage.visible_planets_renders_shrink = {}