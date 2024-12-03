-- Use new method of storing luaRenderObjects
local stills = {}
for key, sprite in pairs(storage.visible_planets_renders_still) do
	stills[key] = {obj = sprite, animation_progress = 1, player = nil}
end
storage.visible_planets_renders_still = stills

-- Remove growing and shrinking planets. Too much effort to corectly convert them, and should regenerate in most cases anyway.
for _, sprite in pairs(storage.visible_planets_renders_grow) do
	sprite.obj.destroy()
end
storage.visible_planets_renders_grow = {}
for _, sprite in pairs(storage.visible_planets_renders_shrink) do
	sprite.obj.destroy()
end
storage.visible_planets_renders_shrink = {}