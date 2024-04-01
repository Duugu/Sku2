print("modules\\bags\\code.lua loading", SDL3)
local moduleName = "bags"
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




---------------------------------------------------------------------------------------------------------------------------------------
function prototype:SetUpModule()
	print(moduleName, "SetUpModule", self)

	--[[
	local tBagsSecureBindHandler = _G["Sku2ModulesBagsSecureBindHandler"]
	local _onClickBody = [=[
		print("Sku2ModulesBagsSecureBindHandler", "button:", button, SDL3)
		if self:GetAttribute("MenuIsOpen") ~= true then
			
		else

		end

	]=]
	local skuKeyBindings = Sku2.modules.keyBindings:GetCurrentSkuBindings()
	_onClickBody = Sku2.utility.tableHelpers.AddStringIndexTableToSecureHandlerBody(tBagsSecureBindHandler, "skuKeyBindings", skuKeyBindings, _onClickBody)
	tBagsSecureBindHandler:SetAttribute("_onclick", _onClickBody)
	
	--register secure frame for key binds
	module.globalKeybinds["SKU_KEY_OPENMENU"] = tBagsSecureBindHandler
]]










end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:IsPanelOpen()
	print(moduleName, "IsPanelOpen", self)
	if _G["ContainerFrame1"] and _G["ContainerFrame1"]:IsVisible() then
		return true
	end
end

---------------------------------------------------------------------------------------------------------------------------------------
