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

   if tClientString == "wrath" then
      tClientString = "classic"
   end

   if not tClientString then
      Sku2.debug:Error("No valid client and flavor detected")
   end

   return tClientString
end

---------------------------------------------------------------------------------------------------------------------------------------
local escapes = {
	["|c%x%x%x%x%x%x%x%x"] = "", -- color start
	["|r"] = "", -- color end
	["|H.-|h(.-)|h"] = "%1", -- links
	["|T.-|t"] = "", -- textures
	["|A.-|a"] = "", -- textures
	["{.-}"] = "", -- raid target icons
}
local escapesChat = {
	["|c%x%x%x%x%x%x%x%x"] = "", -- color start
	["|r"] = "", -- color end
	["|H.-|h(.-)|h"] = "%1", -- links
	["|T.-|t"] = "", -- textures
	--["{.-}"] = "", -- raid target icons
}
function Sku2.utility:Unescape(str, aChatSpecific)
	if not str then return nil end

	local tEscapeStrings = escapes
	if aChatSpecific then
		tEscapeStrings = escapesChat
	end
	
	for k, v in pairs(tEscapeStrings) do
		str = string.gsub(str, k, v)
	end
	return str
end
