print("modules\\_sampleModule\\core.lua loading", SDL3)
local moduleName = "_sampleModule"
local L = Sku2.L

Sku2.modules[moduleName] = Sku2.modules[moduleName] or Sku2.modules:NewModule(moduleName)

---------------------------------------------------------------------------------------------------------------------------------------
-- module data
---------------------------------------------------------------------------------------------------------------------------------------
--upvalue to reference the final module inside the function definitions
local module = Sku2.modules[moduleName]

---------------------------------------------------------------------------------------------------------------------------------------
module.name = moduleName
module.isSkuModule = true
module.canBeDisabled = true
module.dependencies = {
	"audioMenu",
}
module.globalKeybinds = { --["SOME SKU KEY CONST"] = some frame,
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

	--every module for Open Panels needs to register at openPanels module with its main buildChildrenFunc to be considered by openPanels module
	--Sku2.modules.openPanels:RegisterModule(module, module.uiStruct.<some menu>, module.IsPanelOpen, <someUIframeRef>)
end

---------------------------------------------------------------------------------------------------------------------------------------
function module:OnDisable()
	print(moduleName, "OnDisable", SDL3)
	if InCombatLockdown() == true then
		Sku2.debug:Error(module.name.." OnDisable in combat! this should not happen")
		return
	end	

	--every module for Open Panels needs to unregister at openPanels module on disable
	--Sku2.modules.openPanels:UnregisterModule(module)

	--remove all global key binds for module
	for skuKeyBindName, frame in pairs(module.globalKeybinds) do
		ClearOverrideBindings(frame)
	end
	
end