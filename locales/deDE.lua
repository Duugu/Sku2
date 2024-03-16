print("locales\\deDE.lua loading", SDL3)

local L = LibStub("AceLocale-3.0"):NewLocale("Sku2", "deDE")	
if not L then return end
L["OBJECT"] = "OBJEKT" --
L["Filter"] ="Filter" -- noun