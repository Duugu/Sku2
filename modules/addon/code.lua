print("modules\\addon\\code.lua loading", SDL3)
local moduleName = "addon"
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
--locals; not flavor specific; will be available as upvalues in all functions



---------------------------------------------------------------------------------------------------------------------------------------
--every module should have a SetUpModule function that is called on modules OnInitilize
function prototype:SetUpModule()
	print(moduleName, "SetUpModule", self)
	
end

---------------------------------------------------------------------------------------------------------------------------------------
--remaining module specific functions
---------------------------------------------------------------------------------------------------------------------------------------
function prototype:TranscriptPanelHide()
	if module.TranscriptPanelFrame:IsVisible() then
		module.TranscriptPanelFrame:Hide()
	end
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:TranscriptPanelOutput(aString)
	if Sku2.db.global.addon.transcriptPanel.enabled ~= true then
		return
	end

	if not module.TranscriptPanelFrame then
		module:TranscriptPanelCreate()
	end
	
	module.TranscriptPanelFrame.FS:SetText(aString)
	module.TranscriptPanelFrame:Show()
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:TranscriptPanelCreate()
	local f = CreateFrame("Frame", "Sku2ModulesAddonTranscriptPanel", UIParent, BackdropTemplateMixin and "BackdropTemplate")
	module.TranscriptPanelFrame = f

	local ttime = 0
	f:SetScript("OnUpdate", function(self, time) 
		ttime = ttime + time 
		if ttime > 0.25 then 
			if module.TranscriptPanelFrame:IsVisible() then
				if GetTime() - module.TranscriptPanelFrame.lastUpdate > Sku2.db.global.addon.transcriptPanel.hideAfter then
					module.TranscriptPanelFrame:Hide()
					module.TranscriptPanelFrame.lastUpdate = GetTime()
				end
			end
			ttime = 0
		end
	end)
	f:SetFrameStrata("TOOLTIP")
	f:SetFrameLevel(129)
	f:SetSize(1000, 50)
	f:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)

	f:SetBackdrop({
		bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
		edgeFile = "",
		tile = false,
		tileSize = 0,
		edgeSize = 32,
		insets = {left = 0, right = 0, top = 0, bottom = 0}
	})
	f:SetBackdropColor(0, 0, 0, 0.75)
	f:SetClampedToScreen(true)
	
	module.TranscriptPanelFrame:Hide()
	
	local fs = f:CreateFontString("Sku2ModulesAddonTranscriptPanelFS")
	fs:SetFontObject(GameFontNormalSmall)
	fs:SetFont("Fonts\\FRIZQT__.TTF", 14)
	
	fs:SetTextColor(1, 1, 1, 1)
	fs:SetJustifyH("LEFT")
	fs:SetJustifyV("TOP")
	fs:SetAllPoints()
	module.TranscriptPanelFrame.FS = fs

	module.TranscriptPanelFrame.lastUpdate = GetTime()
end