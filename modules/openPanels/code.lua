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

	--we need this controler to hook show for panel frames that are not available on registering modules
	local f = _G["Sku2OpenPanelsControl"] or CreateFrame("Frame", "Sku2OpenPanelsControl")
	f.tLast = 0
	f:SetScript("OnUpdate", function(self, time)
		self.tLast = self.tLast + time
		if self.tLast > 0.2 then
			self.tLast = 0
			module:TryToHookUIFramesForPanels()
		end
	end)
end

---------------------------------------------------------------------------------------------------------------------------------------
--remaining module specific functions
---------------------------------------------------------------------------------------------------------------------------------------
function prototype:TryToHookUIFramesForPanels()
	for tModuleName, tModuleData in pairs(module.registeredModules) do
		if tModuleData.registered == true and tModuleData.isHooked ~= true then
			if tModuleData.blizzardFrameNameToHook and _G[tModuleData.blizzardFrameNameToHook] then
				print("-------------hooking", tModuleName)
				hooksecurefunc(_G[tModuleData.blizzardFrameNameToHook], "Show", function()
					if InCombatLockdown() == true then
						return
					end
					print("panel hookfunction for", tModuleName, _G["Sku2ModulesAudioMenuSecureBindHandler"]:GetAttribute("MenuIsOpen"))
					if _G["Sku2ModulesAudioMenuSecureBindHandler"]:GetAttribute("MenuIsOpen") == false then
						SecureHandlerExecute(_G["Sku2ModulesAudioMenuSecureBindHandler"], [=[
							self:RunAttribute("_onClick")
						]=])
					end
				end)
				--hooksecurefunc(_G[SkuCore.interactFramesList[x]], "Hide", SkuCore.GENERIC_OnClose)
				tModuleData.isHooked = true
			end
		end
	end
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:RegisterModule(aModuleObject, aMenuBuilderFunc, aIsPanelOpenFunc, ablizzardFrameNameToHook)
	if not module.registeredModules[aModuleObject.name] then
		module.registeredModules[aModuleObject.name] = {
			isHooked = false,
		}
	end

	module.registeredModules[aModuleObject.name].registered = true
	module.registeredModules[aModuleObject.name].moduleObject = aModuleObject
	module.registeredModules[aModuleObject.name].menuBuilder = aMenuBuilderFunc
	module.registeredModules[aModuleObject.name].isPanelOpenFunc = aIsPanelOpenFunc
	module.registeredModules[aModuleObject.name].blizzardFrameNameToHook = ablizzardFrameNameToHook

	module:TryToHookUIFramesForPanels()
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:UnregisterModule(aModuleObject)
	if not module.registeredModules[aModuleObject.name] then
		Sku2.debug:Error("Module "..aModuleObject.name.." is not registered")
		return
	end
	module.registeredModules[aModuleObject.name].registered = false
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:MenuBuilder(self)
	local audioMenu = Sku2.modules.audioMenu

	local hasContent
	for tModuleName, tModuleData in pairs(module.registeredModules) do
		if tModuleData.isPanelOpenFunc() then
			hasContent = true
		end
	end
	
	if hasContent then
		for tModuleName, tModuleData in pairs(module.registeredModules) do
			local tModuleObject = tModuleData.moduleObject
			if tModuleData.isPanelOpenFunc() then
				local tMenu = tModuleData.menuBuilder
				local tNewMenuEntry = audioMenu:InjectMenuItems(self, {tMenu.title}, audioMenu.genericMenuItem)
				tNewMenuEntry.inCombatAvailable = tMenu.inCombatAvailable
				tNewMenuEntry.buildChildrenFunc = tMenu.menuBuilder
			end
		end
	end
end