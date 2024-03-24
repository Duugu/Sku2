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
--upvalue to reference the final module inside the function definitions
local module = Sku2.modules[moduleName]

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:SetUpModule()
	-- frame to securely handeling global module key binds
	local tBagsSecureHandler = _G["Sku2ModulesBagsSecureHandler"] or CreateFrame("Button", "Sku2ModulesBagsSecureHandler", UIParent, "SecureActionButtonTemplate")
	tBagsSecureHandler.InsecureClickHandler = function(self, aKey, aDown)
		if _G["ContainerFrame1"]:IsVisible() then
			print("open bags")
		else
			print("close bags")
		end
	end
	tBagsSecureHandler:SetAttribute("type", "macro")
	tBagsSecureHandler:SetAttribute("macrotext", "/click MainMenuBarBackpackButton LeftButton\r\n/click Sku2ModulesBagsSecureHandlerMenuEnterHandler LeftButton\r\n/script _G[\"Sku2ModulesBagsSecureHandler\"].InsecureClickHandler(\"LeftButton\")")


	--we need this to show pre-defined menu enter handlers
	local tSku2ModulesBagsSecureHandlerMenuEnterHandler = _G["Sku2ModulesBagsSecureHandlerMenuEnterHandler"] or CreateFrame("Button", "Sku2ModulesBagsSecureHandlerMenuEnterHandler", UIParent, "SecureHandlerClickTemplate")
	tSku2ModulesBagsSecureHandlerMenuEnterHandler:SetFrameRef("Sku2ModulesAudioMenuSecureBindHandler", Sku2ModulesAudioMenuSecureBindHandler)
	local _onClickBody = [=[
		print("Sku2ModulesBagsSecureHandlerMenuEnterHandler clicked")
		
		self:GetFrameRef("Sku2ModulesAudioMenuSecureBindHandler"):SetAttribute("BagsIsOpen", true)
	]=]
	tSku2ModulesBagsSecureHandlerMenuEnterHandler:SetAttribute("_onclick", _onClickBody)


	--register secure frame for key binds
	--module.globalKeybinds["SKU_KEY_OPENBAGS"] = tBagsSecureHandler




	--to securely and insecurely trigger show/hide of ContainerFrame1
	local tBagsSecureAddFrame = _G["Sku2ModulesBagsContainer1SecureTriggerFrame"] or CreateFrame("Button", "Sku2ModulesBagsContainer1SecureTriggerFrame", ContainerFrame1, "SecureActionButtonTemplate")
	SecureHandlerWrapScript(_G["Sku2ModulesBagsContainer1SecureTriggerFrame"], "OnShow", _G["Sku2ModulesBagsContainer1SecureTriggerFrame"], [=[
		print("Sku2ModulesBagsContainer1SecureTriggerFrame OnShow secure")
		--set secure enter widgets repo to bags

	]=])
	SecureHandlerWrapScript(_G["Sku2ModulesBagsContainer1SecureTriggerFrame"], "OnHide", _G["Sku2ModulesBagsContainer1SecureTriggerFrame"], [=[
		print("Sku2ModulesBagsContainer1SecureTriggerFrame OnHide secure")
	]=])
	hooksecurefunc(ContainerFrame1, "Show", function()
		print("Sku2ModulesBagsContainer1SecureTriggerFrame OnShow INsecure")

		--open menu
		--set current menu item to bags
		Sku2.modules.audioMenu:OpenMenuItemByNamesBreadcrumbInsecure("eins,Size,Large")

	end)
	hooksecurefunc(ContainerFrame1, "Hide", function()
		print("Sku2ModulesBagsContainer1SecureTriggerFrame OnHide INsecure")
	end)
	



end


