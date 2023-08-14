if getActivatedMods():contains("ItemTweakerAPI") then
  require("ItemTweaker_Core");
else
  return
end

Events.OnGameBoot.Add(function()
  TweakItem("Base.Scalpel", "Tags", "SharpKnife");
end)
