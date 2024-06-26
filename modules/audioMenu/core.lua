print("modules\\audioMenu\\core.lua loading", SDL3)
local moduleName = "audioMenu"
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
module.canBeDisabled = false
module.dependencies = {
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
end

---------------------------------------------------------------------------------------------------------------------------------------
function module:OnDisable()
	print(moduleName, "OnDisable", SDL3)
	if InCombatLockdown() == true then
		Sku2.debug:Error(module.name.." OnDisable in combat! this should not happen")
		return
	end	

	--remove all global key binds for module
	for skuKeyBindName, frame in pairs(module.globalKeybinds) do
		ClearOverrideBindings(frame)
	end
end