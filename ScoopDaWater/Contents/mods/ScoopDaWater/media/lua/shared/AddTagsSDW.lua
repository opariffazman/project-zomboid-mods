local itemData = {
  ["Base.MayonnaiseWaterFull"] = {
    Tags = "SlowScoop"
  },
  ["Base.RemouladeWaterFull"] = {
    Tags = "SlowScoop"
  },
  ["Base.WaterPopBottle"] = {
    Tags = "SlowScoop"
  },
  ["Base.WaterBottleFull"] = {
    Tags = "SlowScoop"
  },
  ["Base.WhiskeyWaterFull"] = {
    Tags = "SlowScoop"
  },
  ["Base.WineWaterFull"] = {
    Tags = "SlowScoop"
  },
  ["Base.BeerWaterFull"] = {
    Tags = "SlowScoop"
  },
  ["Base.WaterBleachBottle"] = {
    Tags = "SlowScoop"
  },
  ["Base.FullKettle"] = {
    Tags = "SlowScoop"
  },
  ["Base.WaterBowl"] = {
    Tags = "FastScoop"
  },
  ["Base.BucketWaterFull"] = {
    Tags = "FastScoop"
  },
  ["Base.WaterSaucepan"] = {
    Tags = "FastScoop"
  },
  ["Base.WaterMug"] = {
    Tags = "FastScoop"
  },
  ["Base.WaterMugRed"] = {
    Tags = "FastScoop"
  },
  ["Base.WaterMugWhite"] = {
    Tags = "FastScoop"
  },
  ["Base.WaterMugSpiffo"] = {
    Tags = "FastScoop"
  },
  ["Base.WaterPot"] = {
    Tags = "FastScoop"
  },
  ["Base.WaterPaintbucket"] = {
    Tags = "FastScoop"
  },
  ["Base.WateredCanFull"] = {
    Tags = "FastScoop"
  },
  ["Base.GardeningSprayFull"] = {
    Tags = "FastScoop"
  },
  ["Base.PlasticCupWater"] = {
    Tags = "FastScoop"
  },
  ["Base.GlassTumblerWater"] = {
    Tags = "FastScoop"
  },
  ["Base.GlassWineWater"] = {
    Tags = "FastScoop"
  },
  ["Base.WaterTeacup"] = {
    Tags = "FastScoop"
  },
}

for itemName, data in pairs(itemData) do
  local item = ScriptManager.instance:getItem(itemName)
  if item then
    item:DoParam("Tags = " .. data.Tags)
    -- local tagsArrayList = item:getTags()
    -- local concatenatedTags = ""

    -- for i = 1, tagsArrayList:size() do
    --   local tag = tagsArrayList:get(i - 1) -- Lua arrays are 1-based
    --   concatenatedTags = concatenatedTags .. tag
    --   if i < tagsArrayList:size() then
    --     concatenatedTags = concatenatedTags .. ", "
    --   end
    -- end
    -- print("ScoopThatWater Tag added to item " .. itemName .. "Tags = " .. concatenatedTags)
  end
end
