-- This SHOULD run after all other migrations due to alphabetical order.
-- Generates new planets for all platforms that need one.
for _, surface in pairs(game.surfaces) do
	if surface.platform then
		vp_render_planet_on_platform(surface.platform)
	end
end