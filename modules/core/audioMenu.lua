print("modules\\core\\audiomenu.lua loading", SDL3)

local _G = _G
local L = Sku2.L

Sku2.modules.core.audioMenu = {}
local this = Sku2.modules.core.audioMenu

this.menu = {}
this.currentMenuPosition = nil
this.filterString = ""

--[[
	locals
]]
---------------------------------------------------------------------------------------------------------------------------------------
local menuAccessKeysChars = {" ", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "ö", "ü", "ä", "ß", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "Ä", "Ö", "Ü", "shift-,",}
for i, v in pairs(menuAccessKeysChars) do
	menuAccessKeysChars[v] = v
end
local menuAccessKeysNumbers = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}
for i, v in pairs(menuAccessKeysNumbers) do
	menuAccessKeysNumbers[v] = v
end

--[[
	module core
]]
---------------------------------------------------------------------------------------------------------------------------------------
function this:OnInitialize()
	print("Sku2.modules.core.audioMenu:OnInitialize()", SDL3)
	this:CreateMenuFrame()
	this.menu.root = this:InjectMenuItems(this.menu, {"root"}, this.genericMenuItem)
end

---------------------------------------------------------------------------------------------------------------------------------------
function this:OnEnable()
	print("Sku2.modules.core.audioMenu:OnEnable()", SDL3)
end

--[[
	generic menu
]]
---------------------------------------------------------------------------------------------------------------------------------------
-- generic menu item template
this.genericMenuItem = {
	name = "generic name",
	index = nil,
	empty = false,
	parent = nil,
	children = {},
	prev = nil,
	next = nil,
	buildChildrenFunc = nil,
	actionFunc = nil,
	onEnterCallbackFunc = nil,
	--isSelect = false,
	--selectTarget = nil,
	--dynamic = false,
	--filterable = false,

	----function handlers
	Update = function(self, aNewName)
		C_Timer.After(0.001, function()
			self.name = aNewName
			self:OnUpdate()
			self:OnEnter()
		end)
	end,
	Action = function(self)
		--print("--- Action generic", self, self.name)
		if self.actionFunc then
			self:actionFunc()
			self:OnAction()
		end
	end,
	Prev = function(self, aToNonEmpty)
		--print("--- Prev generic", self, self.index, self.name, aToNonEmpty)
		if self.prev then
			if aToNonEmpty and self.prev.empty == true then
				local out = false
				local tNewItem = self
				local tNextItem = self.prev
				while tNextItem and tNextItem.empty == true and tNextItem.prev ~= nil do
					tNewItem = tNextItem
					tNextItem = tNewItem.prev
				end
				if tNewItem.prev ~= nil then
					tNewItem = tNewItem.prev
				end
				self:OnLeave()
				tNewItem:OnEnter()
			else
				self:OnLeave()
				self.prev:OnEnter()
			end		
		end
	end,
	Next = function(self, aToNonEmpty)
		--print("--- Next generic", self, self.index, self.name, aToNonEmpty)
		if self.next then
			if aToNonEmpty and self.next.empty == true then
				local out = false
				local tNewItem = self
				local tNextItem = self.next
				while tNextItem and tNextItem.empty == true and tNextItem.next ~= nil do
					tNewItem = tNextItem
					tNextItem = tNewItem.next
				end
				self:OnLeave()
				tNextItem:OnEnter()
			else
				self:OnLeave()
				self.next:OnEnter()
			end		
		end
   end,
	First = function(self)
		--print("--- First generic", self, self.index, self.name)
		if self.parent and self.parent.children[1].name ~= self.name then
			self:OnLeave()
			self.parent.children[1]:OnEnter()
		end
   end,
	Last = function(self)
		--print("--- Last generic", self, self.index, self.name)
		if self.parent and self.parent.children[#self.parent.children].name ~= self.name then
			self:OnLeave()
			self.parent.children[#self.parent.children]:OnEnter()
		end
   end,
	Right = function(self)
		if string.find(self.name, L["Filter"]..";") == nil then
			if self.buildChildrenFunc then
				self.children = {}
				self:buildChildrenFunc()
				self:OnBuildChildren()
				if self.children and self.children[1] then
					this.filterString = ""
					this:ApplyFilter()
					self:OnLeave()
					self.children[1]:OnEnter()
				end
			end
		end
   end,
	Back = function(self)
		--print("--- Back generic", self, self.name)
		if self.parent and self.parent.name and self.parent.name ~= "root" then
			self:OnLeave()
			self.parent:OnEnter()
		end
   end,

	----event handlers
	OnKey = function(self, aKey)
		--print("   OnKey", aKey)
		if not self.parent.children then
			return
		end
		local tNewMenuItem
		if menuAccessKeysChars[aKey] then
			for x= 1, #self.parent.children do
				if not tNewMenuItem then
					if string.lower(string.sub(self.parent.children[x].name, 1, 1)) == string.lower(aKey) then
						tNewMenuItem = self.parent.children[x]
					end
				end
			end
		elseif menuAccessKeysNumbers[aKey] then
			if not tNewMenuItem then
				aKey = tonumber(aKey)
				if self.parent.children[aKey] then
					tNewMenuItem = self.parent.children[aKey]
				end
			end
		end
		if tNewMenuItem then
			self:OnLeave()
			tNewMenuItem:OnEnter()
		end
   end,
	OnLeave = function(self)
		--print("   OnLeave generic", self, self.index, self.name)
   end,
	OnEnter = function(self)
		print("   OnEnter generic", self, self.index, self.name)
		this.currentMenuPosition = self
		if self.onEnterCallbackFunc then
			self:onEnterCallbackFunc()
		end
   end,
	OnBuildChildren = function(self)
		--print("   OnBuildChildren generic", self, self.name)
	end,
	OnUpdate = function(self)
		--print("   OnUpdate generic", self, self.name)
	end,
	OnAction = function(self)
		--print("   OnAction generic", self, self.name)
	end,
}

setmetatable(this.genericMenuItem, {
	__add = function(thisTable, newTable)
		local function TableCopy(t, deep, seen)
			seen = seen or {}
			if t == nil then return nil end
			if seen[t] then return seen[t] end
			local nt = {}
			for k, v in pairs(t) do
				if type(v) ~= "userdata" and k ~= "frame" and k ~= 0  then
					if deep and type(v) == 'table' then
						nt[k] = TableCopy(v, deep, seen)
					else
						nt[k] = v
					end
				end
			end
			seen[t] = nt
			return nt
		end
		local seen = {}
		local tTable = TableCopy(newTable, true, seen)
		table.insert(thisTable, tTable)
		return thisTable
	end,
	}
)

---------------------------------------------------------------------------------------------------------------------------------------
function this:InjectMenuItems(aParentMenu, aNewItems, aItemTemplate)
	local rValue = nil
	if aItemTemplate then
		local tParentMenu = aParentMenu.children or aParentMenu
		for x = 1, #aNewItems do
			tParentMenu = tParentMenu + aItemTemplate
			tParentMenu[#tParentMenu].name = aNewItems[x]
			tParentMenu[#tParentMenu].index = #tParentMenu
			tParentMenu[#tParentMenu].parent = aParentMenu
			if tParentMenu[#tParentMenu - 1] then
				tParentMenu[#tParentMenu].prev = tParentMenu[#tParentMenu - 1]
				tParentMenu[#tParentMenu - 1].next = tParentMenu[#tParentMenu]
			end
			rValue = tParentMenu[#tParentMenu]
		end
	else
		aParentMenu.children = aNewItems
		for x = 1, #aNewItems do
			aNewItems[x].parent = aParentMenu
		end
	end
	return rValue
end

---------------------------------------------------------------------------------------------------------------------------------------
function this:CreateMenuFrame()
	print("Sku2.modules.core.audioMenu:CreateMenuFrame()", SDL3)
	--frame to insecure handle menu key binds
	local tFrame = CreateFrame("Button", "Sku2ModulesAudioMenuControlFrame", UIParent, "SecureActionButtonTemplate")
	tFrame.Open = function()
		this:OpenMenu()
	end
	tFrame.Close = function()
		this.filterString = ""
		this:ApplyFilter()
		this:CloseMenu()
	end
	tFrame.FilterLastInputTime = GetTime()
	tFrame.FilterLastInputTimeout = 0.5
	tFrame.OnKeyPressTimer = GetTimePreciseSec()
	tFrame:SetScript("OnClick", function(self, aKey, aDown)
		print("Sku2ModulesAudioMenuControlFrame OnClick", self, aKey, aDown, SDL3)
		if aKey == "SPACE" then
			aKey = " "
		end
		if menuAccessKeysChars[aKey] then
			aKey = string.lower(aKey)
		end

		if aKey == "CTRL-RIGHT" then
			if this.currentMenuPosition then
				if this.currentMenuPosition.name ~= "" then
					--SkuOptions.Voice:OutputStringBTtts(this.currentMenuPosition.name, false, true, 0, false, nil, nil, 2, true) -- for strings with lookup in string index
					print(this.currentMenuPosition.name)
				end
			end
			return
		end

		local tIsDouble
		local tSecondTime = GetTimePreciseSec() - self.OnKeyPressTimer
		if tSecondTime < 0.25 then
			tIsDouble = true
		end
		self.OnKeyPressTimer = GetTimePreciseSec()

		--generic menu control key binds
		if aKey == "UP" then
			this.currentMenuPosition:Prev(tIsDouble)
		end
		if aKey == "DOWN" then
			this.currentMenuPosition:Next(tIsDouble)
		end
		if aKey == "RIGHT" then
			this.currentMenuPosition:Right()
		end
		if aKey == "LEFT" then --or aKey == "BACKSPACE" then
			this.filterString = ""
			this:ApplyFilter()
			this.currentMenuPosition:Back()
		end
		if aKey == "HOME" then
			this.currentMenuPosition:First()
		end
		if aKey == "END" then
			this.currentMenuPosition:Last()
		end		
		if aKey == "ENTER" then
			this.currentMenuPosition:Action()
		end
		if aKey == "BACKSPACE" then
			if string.len(this.filterString) > 1  then
				this.filterString = ""
				this:ApplyFilter()
			end
		end

		if menuAccessKeysChars[aKey] or (menuAccessKeysNumbers[aKey]) then
			this.currentMenuPosition:OnKey(aKey)
		end

		--filter
		this.filterString = this.filterString or ""
		if this.currentMenuPosition then
			if this.currentMenuPosition.parent then
				if menuAccessKeysChars[aKey] or menuAccessKeysNumbers[aKey] then
					if aKey == "shift-," then aKey = ";" end
					if this.filterString == "" then
						--SkuCore:Debug("empty = rep")
						this.filterString = aKey
					elseif string.len(this.filterString) == 1 and ((GetTime() - self.FilterLastInputTime) < self.FilterLastInputTimeout) then
						--SkuCore:Debug("1 and in time = add")
						this.filterString = this.filterString..aKey
						aKey = ""
					elseif  string.len(this.filterString) > 1  then
						--SkuCore:Debug("> 1 = add")
						this.filterString = this.filterString..aKey
						aKey = ""
					else
						--SkuCore:Debug("1 and out of time = rep")
						this.filterString = aKey
					end
					self.FilterLastInputTime = GetTime()

					if string.len(this.filterString) > 1  then
						this:ApplyFilter()
					end
				end
			end
		end






		PlaySound(811)
	end)
	
	-- frame to securely open/close menu and set up menu key binds
	local b = _G["Sku2ModulesAudioMenuSecureHandler"] or CreateFrame("Button", "Sku2ModulesAudioMenuSecureHandler", UIParent, "SecureHandlerClickTemplate")
	local _onClickBody = [=[
		if self:GetAttribute("MenuIsOpen") ~= true then
			self:GetFrameRef("Sku2ModulesAudioMenuControlFrame"):CallMethod("Open")
			self:SetBindingClick(true, "ESCAPE", self:GetName(), "ESCAPE")
			self:SetBindingClick(true, "CTRL-RIGHT", self:GetFrameRef("Sku2ModulesAudioMenuControlFrame"):GetName(), "CTRL-RIGHT")
			self:SetBindingClick(true, "ENTER", self:GetFrameRef("Sku2ModulesAudioMenuControlFrame"):GetName(), "ENTER")
			self:SetBindingClick(true, "HOME", self:GetFrameRef("Sku2ModulesAudioMenuControlFrame"):GetName(), "HOME")
			self:SetBindingClick(true, "END", self:GetFrameRef("Sku2ModulesAudioMenuControlFrame"):GetName(), "END")
			self:SetBindingClick(true, "UP", self:GetFrameRef("Sku2ModulesAudioMenuControlFrame"):GetName(), "UP")
			self:SetBindingClick(true, "DOWN", self:GetFrameRef("Sku2ModulesAudioMenuControlFrame"):GetName(), "DOWN")
			self:SetBindingClick(true, "LEFT", self:GetFrameRef("Sku2ModulesAudioMenuControlFrame"):GetName(), "LEFT")
			self:SetBindingClick(true, "RIGHT", self:GetFrameRef("Sku2ModulesAudioMenuControlFrame"):GetName(), "RIGHT")
			self:SetBindingClick(true, "BACKSPACE", self:GetFrameRef("Sku2ModulesAudioMenuControlFrame"):GetName(), "BACKSPACE")
			self:SetBindingClick(true, "SPACE", self:GetFrameRef("Sku2ModulesAudioMenuControlFrame"):GetName(), "SPACE")
			for x = 1, #menuAccessKeysChars do
				self:SetBindingClick(true, tostring(menuAccessKeysChars[x]), self:GetFrameRef("Sku2ModulesAudioMenuControlFrame"):GetName(), menuAccessKeysChars[x])
			end
			for x = 1, #menuAccessKeysNumbers do
				self:SetBindingClick(true, tostring(menuAccessKeysNumbers[x]), self:GetFrameRef("Sku2ModulesAudioMenuControlFrame"):GetName(),tostring(menuAccessKeysNumbers[x]))
			end
			self:SetAttribute("MenuIsOpen", true)
		else
			self:GetFrameRef("Sku2ModulesAudioMenuControlFrame"):CallMethod("Close")
			self:ClearBinding("ESCAPE")
			self:ClearBinding("CTRL-RIGHT")
			self:ClearBinding("ENTER")
			self:ClearBinding("HOME")
			self:ClearBinding("END")
			self:ClearBinding("UP")
			self:ClearBinding("DOWN")
			self:ClearBinding("LEFT")
			self:ClearBinding("RIGHT")
			self:ClearBinding("BACKSPACE")
			self:ClearBinding("SPACE")
			for x = 1, #menuAccessKeysChars do
				self:ClearBinding(menuAccessKeysChars[x])
			end
			for x = 1, #menuAccessKeysNumbers do
				self:ClearBinding(tostring(menuAccessKeysNumbers[x]))
			end
			self:SetAttribute("MenuIsOpen", false)
		end
	]=]
	_onClickBody = Sku2.utility.tableHelpers.AddTableToSecureHandlerBody(b, "menuAccessKeysChars", menuAccessKeysChars, _onClickBody)
	_onClickBody = Sku2.utility.tableHelpers.AddTableToSecureHandlerBody(b, "menuAccessKeysNumbers", menuAccessKeysNumbers, _onClickBody)
	b:SetAttribute("MenuIsOpen", false)
	b:SetFrameRef("Sku2ModulesAudioMenuControlFrame", tFrame)
	b:SetAttribute("_onclick", _onClickBody)

	SetOverrideBindingClick(b, true, "SHIFT-F1", "Sku2ModulesAudioMenuSecureHandler", "SHIFT-F1")
end

---------------------------------------------------------------------------------------------------------------------------------------
function this:OpenMenu()
	print("Sku2.modules.core.audioMenu:OpenMenu()", SDL3)
	--_G["Sku2ModulesAudioMenuControlFrame"]:Show()
	this:StartStopBackgroundSound(true)
	PlaySound(88)

	this.currentMenuPosition = this.menu.root.children[1]
	this.currentMenuPosition:OnEnter()
end

---------------------------------------------------------------------------------------------------------------------------------------
function this:CloseMenu()
	print("Sku2.modules.core.audioMenu:CloseMenu()", SDL3)
	--_G["Sku2ModulesAudioMenuControlFrame"]:Hide()
	this:StartStopBackgroundSound(false)
	PlaySound(89)

	this.currentMenuPosition = nil
end

---------------------------------------------------------------------------------------------------------------------------------------
local tOldChildren = false
function this:ApplyFilter()
	local afilterString = this.filterString
	print("Sku2.modules.core.audioMenu:ApplyFilter afilterString", afilterString, tOldChildren, SDL3)

	if not this.currentMenuPosition.parent.children then
		this.filterString = ""
		return
	end

	if not afilterString then
		return
	end

	afilterString = string.lower(afilterString)

	if afilterString ~= "" then
		if tOldChildren ~= false then
			--SkuCore:Debug("ApplyFilter: is already filtered; will unfilter first", tOldChildren)
			local tFilter = this.filterString
			this.filterString = ""
			this:ApplyFilter()
			this.filterString = tFilter
		end

		tOldChildren = this.currentMenuPosition.parent.children

		local tChildrenFiltered = {}
		local tFilterEntry = Sku2.utility.tableHelpers:TableCopy(tOldChildren[1])
		tFilterEntry.name = L["Filter"]..";"..afilterString
		table.insert(tChildrenFiltered, tFilterEntry)
		for x = 1, #tOldChildren do
			local tHayStack = string.lower(tOldChildren[x].name)
			tHayStack = string.gsub(tHayStack, Sku2.L["OBJECT"]..";%d+;", Sku2.L["OBJECT"]..";")
			tHayStack = string.gsub(tHayStack, ";", " ")
			tHayStack = string.gsub(tHayStack, "#", " ")

			local tTempHayStack = tHayStack
			for i, v in pairs({strsplit(tHayStack, " ")}) do
				local tNumberTest = tonumber(v)
				if tNumberTest then
					local tFloat = math.floor(tNumberTest)
					if (tNumberTest > 20000) or (tNumberTest - tFloat > 0) then
						tTempHayStack = string.gsub(tTempHayStack, v)
					end
				end
			end
			tHayStack = tTempHayStack

			if string.find(string.lower(tHayStack), string.lower(afilterString))  then
				table.insert(tChildrenFiltered, tOldChildren[x])
			end
		end

		if #tChildrenFiltered == 0 then
			table.insert(tChildrenFiltered, tOldChildren[1])
			print("ApplyFilter: error, this should not happen, no results for filter, showing entry 1")
		end

		for x = 1, #tChildrenFiltered do
			if tChildrenFiltered[x+1] then
				tChildrenFiltered[x].next = tChildrenFiltered[x+1]
			else
				tChildrenFiltered[x].next = nil
			end
			if tChildrenFiltered[x-1] then
				tChildrenFiltered[x].prev = tChildrenFiltered[x-1]
			else
				tChildrenFiltered[x].prev = nil
			end
		end

		this.currentMenuPosition.parent.children = tChildrenFiltered
		this.currentMenuPosition:First()
	
	elseif afilterString == "" then
		if tOldChildren ~= false then
			this.currentMenuPosition.parent.children = tOldChildren
			for x = 1, #this.currentMenuPosition.parent.children do
				if this.currentMenuPosition.parent.children[x+1] then
					this.currentMenuPosition.parent.children[x].next = this.currentMenuPosition.parent.children[x+1]
				else
					this.currentMenuPosition.parent.children[x].next = nil
				end
				if this.currentMenuPosition.parent.children[x-1] then
					this.currentMenuPosition.parent.children[x].prev = this.currentMenuPosition.parent.children[x-1]
				else
					this.currentMenuPosition.parent.children[x].prev = nil
				end
			end
			if string.find(this.currentMenuPosition.name, L["Filter"]..";") then
				this.currentMenuPosition:First()
			else
				this.currentMenuPosition:OnEnter()
			end
			tOldChildren = false
			this.filterString = ""
		end
	end
end

---------------------------------------------------------------------------------------------------------------------------------------
function this:StartStopBackgroundSound(aStart)
	print("Sku2.modules.core.audioMenu:StartStopBackgroundSound(aStart)", aStart, SDL3)
	
end

