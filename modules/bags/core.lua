print("modules\\bags\\core.lua loading", SDL3)
local moduleName = "bags"
local L = Sku2.L

Sku2.modules[moduleName] = Sku2.modules[moduleName] or Sku2.modules:NewModule(moduleName)

---------------------------------------------------------------------------------------------------------------------------------------
-- module data
---------------------------------------------------------------------------------------------------------------------------------------
local module = Sku2.modules[moduleName]

---------------------------------------------------------------------------------------------------------------------------------------
module.name = moduleName
module.isSkuModule = true
module.canBeDisabled = true
module.dependencies = {
	"audioMenu",
	"openPanels"
}
module.globalKeybinds = {
}

---------------------------------------------------------------------------------------------------------------------------------------
-- module events
---------------------------------------------------------------------------------------------------------------------------------------
function module:OnInitialize()
	print(moduleName, "OnInitialize", SDL3)
	
end

---------------------------------------------------------------------------------------------------------------------------------------
function module:OnEnable()
	print(moduleName, "OnEnable", SDL3)
	if InCombatLockdown() == true then
		Sku2.debug:Error(module.name.." OnEnable in combat! this should not happen")
		return
	end	

	module:SetUpModule()

	--set all global key binds for module
	for skuKeyBindName, frame in pairs(module.globalKeybinds) do
		SetOverrideBindingClick(frame, true, Sku2.db.global.keyBindings.skuKeyBinds[skuKeyBindName], frame:GetName(), Sku2.db.global.keyBindings.skuKeyBinds[skuKeyBindName])
	end

	Sku2.modules.openPanels:RegisterModule(module, module.uiStruct.bagsMainMenu, module.IsPanelOpen, "ContainerFrame1")
end

---------------------------------------------------------------------------------------------------------------------------------------
function module:OnDisable()
	print(moduleName, "OnDisable", SDL3)
	if InCombatLockdown() == true then
		Sku2.debug:Error(module.name.." OnDisable in combat! this should not happen")
		return
	end	

	Sku2.modules.openPanels:UnregisterModule(module)
	
	--remove all global key binds for module
	for skuKeyBindName, frame in pairs(module.globalKeybinds) do
		ClearOverrideBindings(frame)
	end
	
end

---------------------------------------------------------------------------------------------------------------------------------------
-- module members
---------------------------------------------------------------------------------------------------------------------------------------
