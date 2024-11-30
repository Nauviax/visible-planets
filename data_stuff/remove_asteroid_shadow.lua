local function patch_shadow_shift(fragment)
  if fragment.shadow_shift then fragment.shadow_shift = { 0.0, 0.0 } end
end

local function patch_asteroid(prototype)
  if not prototype.graphics_set then return end
  if not prototype.graphics_set.variations then return end
  if prototype.graphics_set.variations[1] then
    for _, variation in ipairs(prototype.graphics_set.variations) do
      patch_shadow_shift(variation)
    end
  else
    patch_shadow_shift(prototype.graphics_set.variations)
  end
end

local types = { "asteroid-chunk", "asteroid" }
for _, type in ipairs(types) do
  for _, prototype in pairs(data.raw[type]) do
    patch_asteroid(prototype)
  end
end
