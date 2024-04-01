print("ultility\\copyPasteDataHelpers.lua loading", SDL3)

local L = Sku2.L
Sku2.utility.copyPasteDataHelpers = {}

---------------------------------------------------------------------------------------------------------------------------------------
--[[
   This is the default control to copy or edit/paste any string
]]
---@param aText string --this is the string the editbox will show
---@param aOkScript function --this will be called when the user press enter; aOkScript is getting the text from the editbox as first parameter
---@param aMultilineFlag boolean --if true, the editbox will be multiline
---@param aEscScript function --this will be called when the user press escape; aEscScript is getting the text from the editbox as first parameter
function Sku2.utility.copyPasteDataHelpers:EditBoxShow(aText, aOkScript, aMultilineFlag, aEscScript)
   aOkScript = aOkScript or function() end
   aEscScript = aEscScript or function() end

   --these two empty helpers are to have something to hook on frame creation; they will be replaced by the actual provided functions when the editbox is shown
   local function okScriptHelper(...) end
   local function escScriptHelper(...) end   

	if not _G["Sku2EditBox"] then
		local f = CreateFrame("Frame", "Sku2EditBox", UIParent, "DialogBoxFrame")
		f:SetPoint("CENTER")
		f:SetSize(200, 200)

		f:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", edgeSize = 16, insets = { left = 8, right = 6, top = 8, bottom = 8 },})
		f:SetBackdropBorderColor(0, .44, .87, 0.5)

		-- Movable
		f:SetMovable(true)
		f:SetClampedToScreen(true)
		f:SetScript("OnMouseDown", function(self, button)
			if button == "LeftButton" then
				self:StartMoving()
			end
		end)
		f:SetScript("OnMouseUp", f.StopMovingOrSizing)

		-- ScrollFrame
		local sf = CreateFrame("ScrollFrame", "Sku2EditBoxScrollFrame", Sku2EditBox, "UIPanelScrollFrameTemplate")
		sf:SetPoint("LEFT", 16, 0)
		sf:SetPoint("RIGHT", -32, 0)
		sf:SetPoint("TOP", 0, -16)
		sf:SetPoint("BOTTOM", Sku2EditBoxButton, "TOP", 0, 0)

		-- EditBox
		local eb = CreateFrame("EditBox", "Sku2EditBoxEditBox", Sku2EditBoxScrollFrame)
		eb:SetSize(sf:GetSize())

		eb:SetAutoFocus(false) -- dont automatically focus
		eb:SetFontObject("ChatFontNormal")
		eb:SetScript("OnEscapePressed", function() 
			PlaySound(89)
			f:Hide()
		end)
		eb:SetScript("OnTextSet", function(self)
			self:HighlightText()
		end)

		sf:SetScrollChild(eb)

		-- Resizable
		f:SetResizable(true)
      f:SetResizeBounds(150, 100)

		local rb = CreateFrame("Button", "Sku2EditBoxResizeButton", Sku2EditBox)
		rb:SetPoint("BOTTOMRIGHT", -6, 7)
		rb:SetSize(16, 16)

		rb:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
		rb:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
		rb:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")

		rb:SetScript("OnMouseDown", function(self, button)
			if button == "LeftButton" then
				f:StartSizing("BOTTOMRIGHT")
				self:GetHighlightTexture():Hide() -- more noticeable
			end
		end)
		rb:SetScript("OnMouseUp", function(self, button)
			f:StopMovingOrSizing()
			self:GetHighlightTexture():Show()
			eb:SetWidth(sf:GetWidth())
		end)

		Sku2EditBoxEditBox:HookScript("OnEnterPressed", function(...)
			if aMultilineFlag ~= true then
				local tText = Sku2EditBoxEditBox:GetText()
				if string.find(tText, "\n") then
					tText = string.gsub(tText, "\n", " ")
					Sku2EditBoxEditBox:SetText(tText)
				end
			end
			okScriptHelper(..., Sku2EditBoxEditBox:GetText())
			Sku2EditBox:Hide()
		end)
		Sku2EditBoxEditBox:HookScript("OnEscapePressed", function(...)
			escScriptHelper(..., Sku2EditBoxEditBox:GetText())
			Sku2EditBox:Hide()
		end)
		Sku2EditBoxButton:HookScript("OnClick", okScriptHelper)

		f:Show()
	end

	Sku2EditBoxEditBox:SetMultiLine(true)
	
	if aMultilineFlag == true then
		Sku2EditBoxEditBox:SetMultiLine(true)
	else
		Sku2EditBoxEditBox:SetMultiLine(false)
	end
	
	Sku2EditBoxEditBox:Hide()
	Sku2EditBoxEditBox:SetText("")
	if aText then
		Sku2EditBoxEditBox:SetText(aText)
		Sku2EditBoxEditBox:HighlightText()
	end
	Sku2EditBoxEditBox:Show()
	if aOkScript then
		okScriptHelper = aOkScript
	end
	if aEscScript then
		escScriptHelper = aEscScript
	end
	

	Sku2EditBox:Show()

	Sku2EditBoxEditBox:SetFocus()
end

---------------------------------------------------------------------------------------------------------------------------------------
--[[
   This is a special fake custom editbox only for pasting very large strings. The default editbox isn't working with large strings, it will lagging and freezing the game.
   Returns pasted text as first parameter to aOkScript
]]
function Sku2.utility.copyPasteDataHelpers:EditBoxPasteShow(aText, aOkScript)
   aOkScript = aOkScript or function() end

   --this empty helper is to have something to hook on frame creation; they will be replaced by the actual provided function when the editbox is shown
   local function okScriptHelper(...) end
      
	if not _G["Sku2EditBoxPaste"] then
		local f = CreateFrame('frame', "Sku2EditBoxPaste", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)

		f:SetBackdrop({bgFile = 'Interface/Tooltips/UI-Tooltip-Background',edgeFile = 'Interface/Tooltips/UI-Tooltip-Border', edgeSize = 16,insets = {left = 4, right = 4, top = 4, bottom = 4}	})
		f:SetBackdropColor(0.2, 0.2, 0.2)
		f:SetBackdropBorderColor(0.2, 0.2, 0.2)
		f:SetPoint('CENTER')
		f:SetSize(400, 300)
		
		local cursor = f:CreateTexture() -- make a fake blinking cursor, not really necessary
		cursor:SetTexture(1, 1, 1)
		cursor:SetSize(4, 8)
		cursor:SetPoint('TOPLEFT', 8, -8)
		cursor:Hide()
		
		local editbox = CreateFrame('editbox', nil, f)
		f.EB = editbox
		editbox:SetMaxBytes(1) -- limit the max length of anything entered into the box, this is what prevents the lag
		editbox:SetAutoFocus(true)
		
		local timeSince = 0
		local function UpdateCursor(self, elapsed)
			timeSince = timeSince + elapsed
			if timeSince >= 0.5 then
				timeSince = 0
				cursor:SetShown(not cursor:IsShown())
			end
		end
		
		local fontstring = f:CreateFontString(nil, nil, 'GameFontHighlightSmall')
		f.FS = fontstring
		fontstring:SetPoint('TOPLEFT', 8, -8)
		fontstring:SetPoint('BOTTOMRIGHT', -8, 8)
		fontstring:SetJustifyH('LEFT')
		fontstring:SetJustifyV('TOP')
		fontstring:SetWordWrap(true)
		fontstring:SetNonSpaceWrap(true)
		fontstring:SetText('Click me!')
		fontstring:SetTextColor(0.6, 0.6, 0.6)
		f.Sku2TextBuffer = {}
		local i, lastPaste = 0, 0
		
		local function clearBuffer(self)
			self:SetScript('OnUpdate', nil)
			if i > 10 then -- ignore shorter strings
				local paste = strtrim(table.concat(_G["Sku2EditBoxPaste"].Sku2TextBuffer))
				-- the longer this font string, the more it will lag trying to draw it
				fontstring:SetText(strsub(paste, 1, 2500))
				editbox:ClearFocus()
				okScriptHelper(fontstring:GetText())
				_G["Sku2EditBoxPaste"]:Hide()
			end
		end
		
		editbox:SetScript('OnChar', function(self, c) -- runs for every character being pasted
			if lastPaste ~= GetTime() then -- a timestamp can be used to track how many characters have been added within the same frame
				_G["Sku2EditBoxPaste"].Sku2TextBuffer, i, lastPaste = {}, 0, GetTime()
				self:SetScript('OnUpdate', clearBuffer)
			end
			
			i = i + 1
			_G["Sku2EditBoxPaste"].Sku2TextBuffer[i] = c -- store entered characters in a table to concat into a string later
		end)
		
		editbox:SetScript('OnEditFocusGained', function(self)
			fontstring:SetText('')
			timeSince = 0
			cursor:Show()
			f:SetScript('OnUpdate', UpdateCursor)
		end)
		
		editbox:SetScript('OnEditFocusLost', function(self)
			f:SetScript('OnUpdate', nil)
			cursor:Hide()
		end)


		editbox:SetScript("OnEscapePressed", function() _G["Sku2EditBoxPaste"]:Hide() end)

	end
	
	if aOkScript then
		okScriptHelper = aOkScript
	end

	_G["Sku2EditBoxPaste"].Sku2TextBuffer = {}

	_G["Sku2EditBoxPaste"].EB:HookScript("OnEnterPressed", function(...) okScriptHelper(...) _G["Sku2EditBoxPaste"]:Hide() end)

	_G["Sku2EditBoxPaste"]:Show()
end