print("modules\\characterFrame\\code.lua loading", SDL3)
local moduleName = "characterFrame"
local L = Sku2.L

Sku2.modules[moduleName]._prototypes = Sku2.modules[moduleName]._prototypes or {}
Sku2.modules[moduleName]._prototypes.code = {}
local prototype = Sku2.modules[moduleName]._prototypes.code
setmetatable(prototype, Sku2.modules.MTs.__newindex)

---------------------------------------------------------------------------------------------------------------------------------------
--prototype definition
---------------------------------------------------------------------------------------------------------------------------------------
local module = Sku2.modules[moduleName]

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:SetUpModule()
	print(moduleName, "SetUpModule", self)
	
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:IsPanelOpen()
	print(moduleName, "IsPanelOpen", self)
	if _G["CharacterFrame"]:IsVisible() then
		return true
	end
end

---------------------------------------------------------------------------------------------------------------------------------------
