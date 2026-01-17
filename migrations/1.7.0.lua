-- Add overrides to existing renders
local overrides = prototypes.mod_data["visible-planets-overrides"].data.planets
for _, render in pairs(storage.visible_planets_renders_grow) do
    local override = overrides[render.location_name]
    render.overrides = override or {}
end
for _, render in pairs(storage.visible_planets_renders_still) do
    local override = overrides[render.location_name]
    render.overrides = override or {}
end
for _, render in pairs(storage.visible_planets_renders_shrink) do
    local override = overrides[render.location_name]
    render.overrides = override or {}
end