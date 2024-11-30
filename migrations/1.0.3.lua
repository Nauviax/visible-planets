-- Update to new table system
if storage.visible_planets_renders_still == nil or storage.visible_planets_renders then
	storage.visible_planets_renders_grow = {}
	storage.visible_planets_renders_still = storage.visible_planets_renders or {}
	storage.visible_planets_renders_shrink = {}
	storage.visible_planets_renders = nil
end