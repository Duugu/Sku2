----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
--TESTING
function tt1()
	local BagsHandler = CreateFrame("Button", "BagsHandler", UIParent, "SecureActionButtonTemplate,SecureHandlerClickTemplate")
	BagsHandler.InsecureHandler = function()
		print("BagsHandler.InsecureHandler", BagsHandler:GetAttribute("cFrame"))
	end
	BagsHandler:SetAttribute("_onclick", [=[
		print(button)
		local cFrame = self:GetAttribute("cFrame")
		if button == "DOWN" then
			cFrame = cFrame + 1
		elseif button == "UP" then
			cFrame = cFrame - 1
		end
		if cFrame < 1 then cFrame = 1 end
		if cFrame > 4 then cFrame = 4 end
		self:SetAttribute("cFrame", cFrame)
		--print(cFrame)
		self:SetBindingClick(true, "SPACE", self:GetFrameRef("cFrame"..cFrame):GetName(), "BUTTON1")
		self:CallMethod("InsecureHandler", button, cFrame)
	]=])
	BagsHandler:SetAttribute("cFrame", 1)
	BagsHandler:SetFrameRef("cFrame1", ContainerFrame1Item1)
	BagsHandler:SetFrameRef("cFrame2", ContainerFrame1Item2)
	BagsHandler:SetFrameRef("cFrame3", ContainerFrame1Item3)
	BagsHandler:SetFrameRef("cFrame4", ContainerFrame1Item4)
	BagsHandler:SetFrameRef("cFrame5", ContainerFrame1Item5)


	local ContainerFrame1Item1OnShowWrapper = CreateFrame("Button", "ContainerFrame1Item1OnShowWrapper", ContainerFrame1Item1, "SecureActionButtonTemplate,SecureHandlerClickTemplate")
	ContainerFrame1Item1OnShowWrapper:SetAllPoints()

	SecureHandlerWrapScript(ContainerFrame1Item1OnShowWrapper, "OnShow", ContainerFrame1Item1OnShowWrapper, [[
		print("GossipFrame.GreetingPanel.ScrollBox.ScrollTarget 4 OnShow")
		--print(self:GetFrameRef("ttest"))
		--print(self:GetFrameRef("ttest"):GetName())
		self:GetFrameRef("BagsHandler"):SetAttribute("cFrame", 1)
		--self:SetBindingClick(true, "SPACE", self:GetFrameRef("ttest"):GetName(), "BUTTON1")
		self:SetBindingClick(true, "UP", self:GetFrameRef("BagsHandler"):GetName(), "UP")
		self:SetBindingClick(true, "DOWN", self:GetFrameRef("BagsHandler"):GetName(), "DOWN")
		self:SetBindingClick(true, "SPACE", "ContainerFrame1Item1", "SPACE")
	]])
	SecureHandlerWrapScript(ContainerFrame1Item1OnShowWrapper, "OnHide", ContainerFrame1Item1OnShowWrapper, [[
		print("GossipFrame.GreetingPanel.ScrollBox.ScrollTarget 4 OnHide")
		self:GetFrameRef("BagsHandler"):SetAttribute("cFrame", 1)
		self:ClearBinding("SPACE")
		self:ClearBinding("UP")
		self:ClearBinding("DOWN")
		self:GetFrameRef("BagsHandler"):ClearBinding("SPACE")
		self:GetFrameRef("BagsHandler"):ClearBinding("UP")
		self:GetFrameRef("BagsHandler"):ClearBinding("DOWN")
		
	]])
	--testsec:SetFrameRef("ttest", ContainerFrame1Item1)
	ContainerFrame1Item1OnShowWrapper:SetFrameRef("BagsHandler", BagsHandler)

end

function tt()
	--GossipFrame.GreetingPanel.ScrollBox.ScrollTarget:SetID(98)
	--_G["Sku2ModulesAudioMenuSecureBindHandler"]:SetFrameRef("ttest", GossipFrame.GreetingPanel.ScrollBox.ScrollTarget)
	--



	--local GetNumAvailableQuests = C_GossipInfo.GetNumAvailableQuests
	--hooksecurefunc(C_GossipInfo, "GetNumAvailableQuests", function() print("GetNumAvailableQuests", GetNumAvailableQuests()) end)
	--/dump C_GossipInfo.GetNumAvailableQuests()
	--/script tt()


	--for i,v in pairs({GossipFrame.GreetingPanel.ScrollBox.ScrollTarget:GetChildren()}) do 
		--print(i, v, v.GreetingText) 
		--if i == 4 then
			print(QuestFrame:GetID(), QuestFrame:GetName(), QuestFrame:GetDebugName())

			--_G["ttnamed"] = QuestFrame
			--_G["ttnamed"].SetName("ttnamed")

			local testsec = CreateFrame("Button", "testsec", QuestFrame, "SecureActionButtonTemplate,SecureHandlerClickTemplate")
			testsec:SetAllPoints()
		
			SecureHandlerWrapScript(testsec, "OnShow", testsec, [[
				print("GossipFrame.GreetingPanel.ScrollBox.ScrollTarget 4 OnShow")
				print(self:GetFrameRef("ttest"))
				print(self:GetFrameRef("ttest"):GetName())
				self:SetBindingClick(true, "SPACE", self:GetFrameRef("ttest"):GetName(), "BUTTON1")
			]])
			SecureHandlerWrapScript(testsec, "OnHide", testsec, [[
				print("GossipFrame.GreetingPanel.ScrollBox.ScrollTarget 4 OnHide")
			]])
			testsec:SetFrameRef("ttest", QuestFrameAcceptButton)
			--tAudioMenuSecureHandler:SetFrameRef("Sku2ModulesAudioMenuControlFrame", tAudioMenuControlFrame)

			--_G["Sku2ModulesAudioMenuSecureBindHandler"]:SetFrameRef("ttest", {QuestFrame})
			--_G["Sku2ModulesAudioMenuSecureBindHandler"]:SetFrameRef("ttest", _G["Sku2ModulesAudioMenuSecureBindHandler"])
			--print("QuestFrame.SetText", QuestFrame.SetText)
			--QuestFrame:SetText("test")
			--hooksecurefunc(QuestFrame, "GetData", function() print("SetText") end)	
			--QuestFrame:SetText("test1")

		--end
	--end
	
end

--[[

	SecureOnSkuOptionsMainOption1Macro = CreateFrame("Button", "SecureOnSkuOptionsMainOption1Macro", UIParent, "SecureActionButtonTemplate")
	SecureOnSkuOptionsMainOption1Macro:SetAttribute("type", "macro") -- left click causes macro
	SecureOnSkuOptionsMainOption1Macro:SetAttribute("macrotext", "/click PlayerFrame LeftButton")
	

   local tFrame = CreateFrame("Button", "SecureOnSkuOptionsMainOption1", UIParent, "SecureActionButtonTemplate")
	--tFrame:SetText("SecureOnSkuOptionsMainOption1")
	--tFrame:SetPoint("TOP", _G["OnSkuOptionsMain"], "BOTTOM", 0, 0)
	tFrame:SetScript("OnShow", function(self)
		print("SHOW")
		SetOverrideBindingClick(self, true, "F1", "SecureOnSkuOptionsMainOption1", "F1")
	end)
	tFrame:SetScript("OnHide", function(self)
		--ClearOverrideBindings(self)
	end)
	tFrame:HookScript("OnClick", _G["Sku2ModulesAudioMenuControlFrame"]:GetScript("OnClick"))
	tFrame:Hide()
	tFrame:Show()


]]
