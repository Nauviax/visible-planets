-- Constants for planet grow/shrink animations
local initial_scale = 0.05
local rest_scale = 8
local scale_speed = 0.075
local rest_position = {-50, 20}
local move_speed = 1 -- Moving downwards
local ticks_needed = math.ceil((rest_scale - initial_scale) / scale_speed)
local initial_position = {rest_position[1], rest_position[2] - move_speed * ticks_needed} -- Calculated based on ticks_needed.

-- On init, create a table to store the renders of the planets in the background.
script.on_init(function()
	storage.visible_planets_renders_grow = {} -- Add new planets here, to be grown and put into still.
	storage.visible_planets_renders_still = {} -- Waiting bay for planets.
	storage.visible_planets_renders_shrink = {} -- Planets put here will be shrunk then removed.
end)

-- When a platform changes state, render or derender the planet in the background.
script.on_event(defines.events.on_space_platform_changed_state, function(event)
	local platform = event.platform
	if platform.surface then -- Check platform exists first
		local location = platform.space_location -- Can be nil
		local render_exists = storage.visible_planets_renders_still[platform.index] ~= nil or storage.visible_planets_renders_grow[platform.index] ~= nil

		if location == nil then -- If no location, begin shrinking planet
			if render_exists then
				storage.visible_planets_renders_shrink[platform.index] = storage.visible_planets_renders_still[platform.index] or storage.visible_planets_renders_grow[platform.index]
				storage.visible_planets_renders_still[platform.index] = nil
				storage.visible_planets_renders_grow[platform.index] = nil
			end
		else -- Render planet, if not already rendered
			if not render_exists and helpers.is_valid_sprite_path("visible-planets-" .. location.name) then
				local sprite = rendering.draw_sprite {
					sprite = "visible-planets-" .. location.name,
					surface = platform.surface,
					render_layer = "zero",
					target = initial_position,
					x_scale = initial_scale,
					y_scale = initial_scale,
				}
				storage.visible_planets_renders_grow[platform.index] = sprite
			end
		end
	end
end)

-- Every tick, grow or shrink the planets in the background.
script.on_event(defines.events.on_tick, function(event)
	for index, sprite in pairs(storage.visible_planets_renders_grow) do
		local scale = sprite.x_scale
		if scale < rest_scale then
			sprite.x_scale = scale + scale_speed
			sprite.y_scale = scale + scale_speed
			sprite.target = {sprite.target.position.x, sprite.target.position.y + move_speed}
		else
			storage.visible_planets_renders_still[index] = sprite
			storage.visible_planets_renders_grow[index] = nil
		end
	end

	for index, sprite in pairs(storage.visible_planets_renders_shrink) do
		local scale = sprite.x_scale
		if scale > initial_scale then
			sprite.x_scale = scale - scale_speed
			sprite.y_scale = scale - scale_speed
			sprite.target = {sprite.target.position.x, sprite.target.position.y + move_speed}
		else
			sprite.destroy()
			storage.visible_planets_renders_shrink[index] = nil
		end
	end
end)