-- Create SpritePrototype for each planet
local function create_planet_sprite_prototype(name, filename)
	local sprite_prototype = {
		type = "sprite",
		name = "visible-planets-" .. name,
		filename = filename,
		size = 512,
		scale = 1,
		mipmap_count = 1,
		flags = {"linear-minification", "linear-magnification"}, -- Prevent pixels showing.
		-- Sprite priority?
	}
	data:extend{sprite_prototype}
end

create_planet_sprite_prototype("nauvis", "__base__/graphics/icons/starmap-planet-nauvis.png")
create_planet_sprite_prototype("vulcanus", "__space-age__/graphics/icons/starmap-planet-vulcanus.png")
create_planet_sprite_prototype("fulgora", "__space-age__/graphics/icons/starmap-planet-fulgora.png")
create_planet_sprite_prototype("gleba", "__space-age__/graphics/icons/starmap-planet-gleba.png")
create_planet_sprite_prototype("aquilo", "__space-age__/graphics/icons/starmap-planet-aquilo.png")

-- Manual mod support. May look into automatic support later. (Would reduce file size too)
if mods["naufulglebunusilo"] then
	create_planet_sprite_prototype("naufulglebunusilo", "__naufulglebunusilo__/graphics/starmap-planet-naufulglebunusilo.png")
end

if mods["tenebris"] then
	create_planet_sprite_prototype("tenebris", "__tenebris__/graphics/icons/starmap-planet-tenebris.png")
end

if mods["terrapalus"] then
	create_planet_sprite_prototype("terrapalus", "__terrapalus__/graphics/icons/starmap-planet-terrapalus.png")
end

if mods["real-starry-universe"] then
	create_planet_sprite_prototype("asteroid-belt-inner", "__real-starry-universe__/graphics/asteroid-belt-inner.png")
	create_planet_sprite_prototype("asteroid-belt-outer", "__real-starry-universe__/graphics/asteroid-belt-outer.png")
	create_planet_sprite_prototype("ceres", "__real-starry-universe__/graphics/ceres.png")
	create_planet_sprite_prototype("earth", "__real-starry-universe__/graphics/earth.png")
	create_planet_sprite_prototype("eris", "__real-starry-universe__/graphics/eris.png")
	create_planet_sprite_prototype("gonggong", "__real-starry-universe__/graphics/gonggong.png")
	create_planet_sprite_prototype("haumea", "__real-starry-universe__/graphics/haumea.png")
	create_planet_sprite_prototype("hygiea", "__real-starry-universe__/graphics/hygiea.png")
	create_planet_sprite_prototype("jupiter", "__real-starry-universe__/graphics/jupiter.png")
	create_planet_sprite_prototype("luna", "__real-starry-universe__/graphics/luna.png")
	create_planet_sprite_prototype("makemake", "__real-starry-universe__/graphics/makemake.png")
	create_planet_sprite_prototype("mars", "__real-starry-universe__/graphics/mars.png")
	create_planet_sprite_prototype("mercury", "__real-starry-universe__/graphics/mercury.png")
	create_planet_sprite_prototype("neptune", "__real-starry-universe__/graphics/neptune.png")
	create_planet_sprite_prototype("pallas", "__real-starry-universe__/graphics/pallas.png")
	create_planet_sprite_prototype("planet", "__real-starry-universe__/graphics/planet.png")
	create_planet_sprite_prototype("pluto", "__real-starry-universe__/graphics/pluto.png")
	create_planet_sprite_prototype("saturn", "__real-starry-universe__/graphics/saturn.png")
	create_planet_sprite_prototype("uranus", "__real-starry-universe__/graphics/uranus.png")
	create_planet_sprite_prototype("venus", "__real-starry-universe__/graphics/venus.png")
	create_planet_sprite_prototype("vesta", "__real-starry-universe__/graphics/vesta.png")
end

if mods["maraxsis"] then
	create_planet_sprite_prototype("maraxsis", "__maraxsis__/graphics/planets/maraxsis-starmap-icon.png")
end