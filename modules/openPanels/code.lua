print("modules\\openPanels\\code.lua loading", SDL3)
local moduleName = "openPanels"
local L = Sku2.L

Sku2.modules[moduleName]._prototypes = Sku2.modules[moduleName]._prototypes or {}
Sku2.modules[moduleName]._prototypes.code = {}
local prototype = Sku2.modules[moduleName]._prototypes.code
setmetatable(prototype, Sku2.modules.MTs.__newindex)

---------------------------------------------------------------------------------------------------------------------------------------
--prototype definition
---------------------------------------------------------------------------------------------------------------------------------------
--upvalue to reference the final module inside the function definitions
local module = Sku2.modules[moduleName]

---------------------------------------------------------------------------------------------------------------------------------------
--locals



---------------------------------------------------------------------------------------------------------------------------------------
--flavor specific module tables
prototype.registeredModules = {}

---------------------------------------------------------------------------------------------------------------------------------------
--every module should have a SetUpModule function that is called on modules OnInitilize
function prototype:SetUpModule()
	print(moduleName, "SetUpModule", self)
	--add keys & frame refs to module.globalKeybinds here (ex. module.globalKeybinds["SOME_SKU_KEY_CONST"] = somesecureframeref)
	
end

---------------------------------------------------------------------------------------------------------------------------------------
--remaining module specific functions
---------------------------------------------------------------------------------------------------------------------------------------
function prototype:RegisterModule(aModuleObject, aMenuBuilderFunc, aIsPanelOpenFunc)
	module.registeredModules[#module.registeredModules + 1] = {moduleObject = aModuleObject, menuBuilder = aMenuBuilderFunc, isPanelOpenFunc = aIsPanelOpenFunc}
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:MenuBuilder(self)
	local audioMenu = Sku2.modules.audioMenu

	local hasContent
	if #module.registeredModules > 0 then
		for _, module in pairs(module.registeredModules) do
			if module.isPanelOpenFunc() then
				hasContent = true
			end
		end
	end
	
	if hasContent then
		for _, module in pairs(module.registeredModules) do
			local moduleObject = module.moduleObject
			if module.isPanelOpenFunc() then
				local tMenu = module.menuBuilder
				local tNewMenuEntry = audioMenu:InjectMenuItems(self, {tMenu.title}, audioMenu.genericMenuItem)
				tNewMenuEntry.inCombatAvailable = tMenu.inCombatAvailable
				tNewMenuEntry.buildChildrenFunc = tMenu.menuBuilder
			end
		end
	else
		local tNewMenuEntry = audioMenu:InjectMenuItems(self, {"Empty"}, audioMenu.genericMenuItem)
		tNewMenuEntry.inCombatAvailable = true
	end
end