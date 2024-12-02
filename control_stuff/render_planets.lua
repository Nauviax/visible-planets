-- Configurable constants for planet grow/shrink animations
local PLANET_POS_X = settings.global["visible-planets-planet-pos-x"].value
local PLANET_POS_Y = settings.global["visible-planets-planet-pos-y"].value
local PLANET_INIT_DIST = settings.global["visible-planets-planet-init-dist"].value
local PLANET_SCALE = settings.global["visible-planets-planet-scale"].value
local PLANET_ANIM_DUR = settings.global["visible-planets-planet-anim-dur"].value -- Ticks for growing and shrinking

-- Calculated values given the constants
local planet_initial_position = {PLANET_POS_X, PLANET_POS_Y - PLANET_INIT_DIST}
local planet_move_speed = PLANET_INIT_DIST / PLANET_ANIM_DUR
local planet_scale_speed = PLANET_SCALE / PLANET_ANIM_DUR

-- Parallax configs
local PARALLAX_ENABLED = settings.global["visible-planets-enable-parallax"].value
local PARALLAX_FACTOR = settings.global["visible-planets-parallax-factor"].value

-- on_runtime_mod_setting_changed, update constants. (Yes this technically gets called for each setting changed, but they all need updating anyway.)
script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
	PLANET_POS_X = settings.global["visible-planets-planet-pos-x"].value
	PLANET_POS_Y = settings.global["visible-planets-planet-pos-y"].value
	PLANET_INIT_DIST = settings.global["visible-planets-planet-init-dist"].value
	PLANET_SCALE = settings.global["visible-planets-planet-scale"].value
	PLANET_ANIM_DUR = settings.global["visible-planets-planet-anim-dur"].value
	planet_initial_position = {PLANET_POS_X, PLANET_POS_Y - PLANET_INIT_DIST}
	planet_move_speed = PLANET_INIT_DIST / PLANET_ANIM_DUR
	planet_scale_speed = PLANET_SCALE / PLANET_ANIM_DUR
	PARALLAX_ENABLED = settings.global["visible-planets-enable-parallax"].value -- If disabled midgame, only existing planets will be left offset. New ones should be fine.
	PARALLAX_FACTOR = settings.global["visible-planets-parallax-factor"].value
end)

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
				-- If a relevant planet is in the shrinking list, remove it first. Looks ugly, but better than leaving permanent planet orphans.
				if storage.visible_planets_renders_shrink[platform.index] then
					storage.visible_planets_renders_shrink[platform.index].destroy()
				end
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
					target = planet_initial_position,
					x_scale = 0,
					y_scale = 0,
					orientation_target = {planet_initial_position[1] + 0, planet_initial_position[2] - 10}, -- Pointing up
					oriented_offset = {0, 0}, -- Will be used for parallax effect.
				}
				storage.visible_planets_renders_grow[platform.index] = sprite
			end
		end
	end
end)

-- Every tick, 
-- -- Grow or shrink the planets in the background.
-- -- Apply parallax if enabled.
script.on_event(defines.events.on_tick, function(event)
	-- Grow planets
	for index, sprite in pairs(storage.visible_planets_renders_grow) do
		local scale = sprite.x_scale
		if scale < PLANET_SCALE then
			sprite.x_scale = scale + planet_scale_speed
			sprite.y_scale = scale + planet_scale_speed
			sprite.target = {sprite.target.position.x, sprite.target.position.y + planet_move_speed}
		else
			storage.visible_planets_renders_still[index] = sprite
			storage.visible_planets_renders_grow[index] = nil
		end
	end

	-- Shrink planets
	for index, sprite in pairs(storage.visible_planets_renders_shrink) do
		if not sprite.valid then -- Should solve an issue that someone had. Wasn't able toproduce, but this should be good.
			storage.visible_planets_renders_shrink[index] = nil
		else -- I wish lua had a continue statement. goto would work, but feels so wrong.
			local scale = sprite.x_scale
			if scale > 0 then
				sprite.x_scale = scale - planet_scale_speed
				sprite.y_scale = scale - planet_scale_speed
				sprite.target = {sprite.target.position.x, sprite.target.position.y + planet_move_speed}
			else
				sprite.destroy()
				storage.visible_planets_renders_shrink[index] = nil
			end
		end
	end

	-- on_tick parallax. Weird in multiplayer, but that's why it's disableable.
	if PARALLAX_ENABLED then
		for _, player in pairs(game.players) do
			if player.surface.platform then
				local p_index = player.surface.platform.index
				-- Get the render of the planet that is currently visible. Will only get one planet; Shrinking planets will be ignored if one is already growing.
				local planet_render = storage.visible_planets_renders_still[p_index] or storage.visible_planets_renders_grow[p_index] or storage.visible_planets_renders_shrink[p_index]
				if planet_render then
					local player_position = player.position
					local planet_position = planet_render.target.position
					local x_offset = (player_position.x - planet_position.x) / PARALLAX_FACTOR
					local y_offset = (player_position.y - planet_position.y) / PARALLAX_FACTOR
					planet_render.oriented_offset = {x_offset, y_offset} -- Will not affect literal position.
				end
			end
		end
	end
end)

-- AFTER a surface is deleted, check if any planet renders have become invalid. If so, remove them.
script.on_event(defines.events.on_surface_deleted, function(event)
	for index, sprite in pairs(storage.visible_planets_renders_still) do
		if not sprite.valid then
			storage.visible_planets_renders_still[index] = nil
		end
	end
	for index, sprite in pairs(storage.visible_planets_renders_grow) do
		if not sprite.valid then
			storage.visible_planets_renders_grow[index] = nil
		end
	end
	for index, sprite in pairs(storage.visible_planets_renders_shrink) do
		if not sprite.valid then
			storage.visible_planets_renders_shrink[index] = nil
		end
	end
end)