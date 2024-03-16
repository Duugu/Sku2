print("ultility\\core.lua core loading", SDL3)

local L = Sku2.L
Sku2.utility = {}

---------------------------------------------------------------------------------------------------------------------------------------
function Sku2.utility:GetClientFlavorString()
   local tClientString

   local wowProjectValues = {
      [1] = "retail",
      [2] = "era",
      [5] = "tbc",
      [11] = "wrath",
   }

   tClientString = wowProjectValues[WOW_PROJECT_ID]

   if tClientString == "era" then
      if C_Seasons and C_Seasons.GetActiveSeason and C_Seasons:GetActiveSeason() then
         tClientString = "sod"
      elseif C_GameRules and C_GameRules.IsHardcoreActive and C_GameRules:IsHardcoreActive() == true then
         tClientString = "hardcore"
      end
   end

   if not tClientString then
      Sku2.debug:Error("No valid client and flavor detected")
   end

   print("Sku2.utility:GetClientFlavorString() > tClientString", tClientString, SDL3)
   return tClientString
end
