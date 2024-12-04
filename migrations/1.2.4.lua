-- Add new render table entry to all planets.
for index, render in pairs(storage.visible_planets_renders_still) do
	storage.visible_planets_renders_still[index] = {
		obj = render.obj,
		animation_progress = render.animation_progress,
		depart_y_offset = 0, -- New
		player = render.player,
	}
end
for index, render in pairs(storage.visible_planets_renders_grow) do
	storage.visible_planets_renders_grow[index] = {
		obj = render.obj,
		animation_progress = render.animation_progress,
		depart_y_offset = 0, -- New
		player = render.player,
	}
end -- Test just shrink too 
for index, render in pairs(storage.visible_planets_renders_shrink) do
	storage.visible_planets_renders_shrink[index] = {
		obj = render.obj,
		animation_progress = render.animation_progress,
		depart_y_offset = 0, -- New (Technically this can cause a jump in VERY edge cases, but it's already shrinking so eh.)
		player = render.player,
	}
end