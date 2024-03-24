print("modules\\_sampleModule\\code.lua loading", SDL3)
local moduleName = "audioMenu"
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
	print(moduleName, "SetUpModule", self)
	module:SetUpMenu()
	module:UpdateMenuSettings()
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:SetUpMenu()
	module.menu = {}
	module.currentMenuPosition = nil
	module.filterString = ""
	module.menuAccessKeysChars = {" ", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "ö", "ü", "ä", "ß", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "Ä", "Ö", "Ü", "shift-,",}
	for i, v in pairs(module.menuAccessKeysChars) do
		module.menuAccessKeysChars[v] = v
	end
	module.menuAccessKeysNumbers = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}
	for i, v in pairs(module.menuAccessKeysNumbers) do
		module.menuAccessKeysNumbers[v] = v
	end

	--generic menu item template
	module.genericMenuItem = {
		--properties
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
		inCombatAvailable = true,
		--toParentAllowed = true, --module value is to avoid the user is going to the parent menu in fixed secure in combat menus
		--filteringAllowed = true, --module value is to avoid the user is filering in in fixed secure in combat menus

		--function handlers
		Update = function(self, aNewName)
			C_Timer.After(0.001, function()
				self.name = aNewName
				self:OnUpdate()
				self:OnEnter()
			end)
		end,
		Action = function(self)
			if self.actionFunc then
				self:actionFunc()
				self:OnAction()
			end
		end,
		Prev = function(self, aToNonEmpty)
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
			if self.parent and self.parent.children[1].name ~= self.name then
				self:OnLeave()
				self.parent.children[1]:OnEnter()
			end
		end,
		Last = function(self)
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
						if InCombatLockdown() == true and self.children[1].inCombatAvailable ~= false then
							Sku2.debug:Error("Generic Right: menu item not available ic: "..self.children[1].name)
							return false
						end
						if self.filteringAllowed ~= false then
							module.filterString = ""
							module:ApplyFilter()
						end
						self:OnLeave()
						self.children[1]:OnEnter()
					end
				end
			end
		end,
		Back = function(self)
			if self.parent and self.parent.name and self.parent.name ~= "root" then
				if self.toParentAllowed ~= false then
					self:OnLeave()
					self.parent:OnEnter()
				end
			end
		end,
		SelectItemByName = function(self, aItemName)
			print("SelectItemByName", self, aItemName)
			for x = 1, #self.parent.children do
				print("  test", self.parent.children[x].name)
				if self.parent.children[x].name == aItemName then
					module.currentMenuPosition:OnLeave()
					self.parent.children[x]:OnEnter()
					if self.parent.children[x].buildChildrenFunc then
						self.parent.children[x]:buildChildrenFunc()
					end
					return
				end		
			end
		end,


		----event handlers
		OnKey = function(self, aKey)
			if not self.parent.children then
				return
			end
			local tNewMenuItem
			if module.menuAccessKeysChars[aKey] then
				for x= 1, #self.parent.children do
					if not tNewMenuItem then
						if string.lower(string.sub(self.parent.children[x].name, 1, 1)) == string.lower(aKey) then
							tNewMenuItem = self.parent.children[x]
						end
					end
				end
			elseif module.menuAccessKeysNumbers[aKey] then
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
			
		end,
		OnEnter = function(self)
			print("OnEnter generic", self, self.index, self.name, SDL3)
			module.currentMenuPosition = self
			if self.onEnterCallbackFunc then
				self:onEnterCallbackFunc()
			end
		end,
		OnBuildChildren = function(self)
			
		end,
		OnUpdate = function(self)
			
		end,
		OnAction = function(self)
			
		end,
	}
	setmetatable(module.genericMenuItem, {
		__add = function(moduleTable, newTable)
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
			table.insert(moduleTable, tTable)
			return moduleTable
		end,
		}
	)

	function module:InjectMenuItems(aParentMenu, aNewItems, aItemTemplate)
		print("InjectMenuItems", aParentMenu, aNewItems, aItemTemplate, SDL3)
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

	if _G["Sku2ModulesAudioMenuControlFrame"] then
		print("audioMenu CreateMenu() Sku2ModulesAudioMenuControlFrame already there", SDL3)
		return
	end

	--frame to handle menu key binds
	local tAudioMenuControlFrame = _G["Sku2ModulesAudioMenuControlFrame"] or CreateFrame("Button", "Sku2ModulesAudioMenuControlFrame", UIParent, "SecureActionButtonTemplate,SecureHandlerClickTemplate")
	tAudioMenuControlFrame.Open = function()
		module:OpenMenu() 
	end
	tAudioMenuControlFrame.Close = function()
		module.filterString = ""
		module:ApplyFilter()
		module:CloseMenu()
	end
	tAudioMenuControlFrame.FilterLastInputTime = GetTime()
	tAudioMenuControlFrame.FilterLastInputTimeout = 0.5
	tAudioMenuControlFrame.OnKeyPressTimer = GetTimePreciseSec()
	tAudioMenuControlFrame.InsecureClickHandler = function(self, aKey, aDown)
		print("Sku2ModulesAudioMenuControlFrame OnClick", self, self:GetName(), aKey, aDown, SDL3)
		local skuKeyBinds = Sku2.db.global.keyBindings.skuKeyBinds

		if aKey == "SPACE" then
			aKey = " "
		end
		if module.menuAccessKeysChars[aKey] then
			aKey = string.lower(aKey)
		end

		--spell current menu item name
		if aKey == skuKeyBinds.SKU_KEY_MENUITEMSPELLCURRENT then
			if module.currentMenuPosition then
				if module.currentMenuPosition.name ~= "" then
					--SkuOptions.Voice:OutputStringBTtts(module.currentMenuPosition.name, false, true, 0, false, nil, nil, 2, true) -- for strings with lookup in string index
					print(module.currentMenuPosition.name)
				end
			end
			return
		end

		--double down
		local tIsDouble
		local tSecondTime = GetTimePreciseSec() - self.OnKeyPressTimer
		if tSecondTime < 0.25 then
			tIsDouble = true
		end
		self.OnKeyPressTimer = GetTimePreciseSec()

		--generic menu control key binds
		if aKey == skuKeyBinds.SKU_KEY_MENUITEMUP then
			module.currentMenuPosition:Prev(tIsDouble)
		end
		if aKey == skuKeyBinds.SKU_KEY_MENUITEMDOWN then
			module.currentMenuPosition:Next(tIsDouble)
		end
		if aKey == skuKeyBinds.SKU_KEY_MENUITEMRIGHT then
			module.currentMenuPosition:Right()
		end
		if aKey == skuKeyBinds.SKU_KEY_MENUITEMLEFT then
			if module.currentMenuPosition.toParentAllowed ~= false then
				if module.currentMenuPosition.filteringAllowed ~= false then
					module.filterString = ""
					module:ApplyFilter()
				end
				module.currentMenuPosition:Back()
			end
		end
		if aKey == skuKeyBinds.SKU_KEY_MENUITEMFIRST then
			module.currentMenuPosition:First()
		end
		if aKey == skuKeyBinds.SKU_KEY_MENUITEMLAST then
			module.currentMenuPosition:Last()
		end		
		if aKey == skuKeyBinds.SKU_KEY_MENUITEMEXECUTE then
			module.currentMenuPosition:Action()
		end
		if aKey == skuKeyBinds.SKU_KEY_MENUITEMCLEARFILTER then
			if module.currentMenuPosition.filteringAllowed ~= false then
				if string.len(module.filterString) > 1  then
					module.filterString = ""
					module:ApplyFilter()
				end
			end
		end

		if module.menuAccessKeysChars[aKey] or (module.menuAccessKeysNumbers[aKey]) then
			module.currentMenuPosition:OnKey(aKey)
		end

		--filter
		if module.currentMenuPosition.filteringAllowed ~= false then
			module.filterString = module.filterString or ""
			if module.currentMenuPosition then
				if module.currentMenuPosition.parent then
					if module.menuAccessKeysChars[aKey] or module.menuAccessKeysNumbers[aKey] then
						if aKey == "shift-," then aKey = ";" end
						if module.filterString == "" then
							module.filterString = aKey
						elseif string.len(module.filterString) == 1 and ((GetTime() - self.FilterLastInputTime) < self.FilterLastInputTimeout) then
							module.filterString = module.filterString..aKey
							aKey = ""
						elseif  string.len(module.filterString) > 1  then
							module.filterString = module.filterString..aKey
							aKey = ""
						else
							module.filterString = aKey
						end
						self.FilterLastInputTime = GetTime()

						if string.len(module.filterString) > 1  then
							module:ApplyFilter()
						end
					end
				end
			end
		end

		--more key handlers







		local currentMenuBreadcrumbString = Sku2.modules.audioMenu:GetCurrentBreadcrumbAsName(" > ")
		Sku2.modules.addon:TranscriptPanelOutput(currentMenuBreadcrumbString)
		PlaySound(811)
	end
	tAudioMenuControlFrame:SetAttribute("_onclick", [=[
		--print("Sku2ModulesAudioMenuControlFrame _onClick", button, SDL3)
		-- do stuff for secure menu keys


		-- do stuff for insecure menu keys
		self:CallMethod("InsecureClickHandler", button, down)
	]=])
	
	-- frame to securely set menu key binds on open/close menu
	local tAudioMenuSecureBindHandler = _G["Sku2ModulesAudioMenuSecureBindHandler"] or CreateFrame("Button", "Sku2ModulesAudioMenuSecureBindHandler", UIParent, "SecureHandlerClickTemplate")
	tAudioMenuSecureBindHandler:SetFrameRef("Sku2ModulesAudioMenuControlFrame", tAudioMenuControlFrame)

	--add an empty root menu item
	module.menu.root = module:InjectMenuItems(module.menu, {"root"}, module.genericMenuItem)
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:UpdateMenuSettings()
	print("audioMenu CreateMenu()", SDL3)
	local tAudioMenuControlFrame = _G["Sku2ModulesAudioMenuControlFrame"]
	local tAudioMenuSecureBindHandler = _G["Sku2ModulesAudioMenuSecureBindHandler"]
	local _onClickBody = [=[
		--print("button", button, SDL3)
		if self:GetAttribute("MenuIsOpen") ~= true then
			self:GetFrameRef("Sku2ModulesAudioMenuControlFrame"):CallMethod("Open")
			
			--menu navigation key binds
			self:SetBindingClick(true, skuKeyBindings.SKU_KEY_MENUCLOSE, self:GetName(), skuKeyBindings.SKU_KEY_MENUCLOSE)
			self:SetBindingClick(true, skuKeyBindings.SKU_KEY_MENUITEMSPELLCURRENT, self:GetFrameRef("Sku2ModulesAudioMenuControlFrame"):GetName(), skuKeyBindings.SKU_KEY_MENUITEMSPELLCURRENT)
			--self:SetBindingClick(true, skuKeyBindings.SKU_KEY_MENUITEMEXECUTE, self:GetFrameRef("Sku2ModulesAudioMenuControlFrame"):GetName(), skuKeyBindings.SKU_KEY_MENUITEMEXECUTE)
			self:SetBindingClick(true, skuKeyBindings.SKU_KEY_MENUITEMFIRST, self:GetFrameRef("Sku2ModulesAudioMenuControlFrame"):GetName(), skuKeyBindings.SKU_KEY_MENUITEMFIRST)
			self:SetBindingClick(true, skuKeyBindings.SKU_KEY_MENUITEMLAST, self:GetFrameRef("Sku2ModulesAudioMenuControlFrame"):GetName(), skuKeyBindings.SKU_KEY_MENUITEMLAST)
			self:SetBindingClick(true, skuKeyBindings.SKU_KEY_MENUITEMUP, self:GetFrameRef("Sku2ModulesAudioMenuControlFrame"):GetName(), skuKeyBindings.SKU_KEY_MENUITEMUP)
			self:SetBindingClick(true, skuKeyBindings.SKU_KEY_MENUITEMDOWN, self:GetFrameRef("Sku2ModulesAudioMenuControlFrame"):GetName(), skuKeyBindings.SKU_KEY_MENUITEMDOWN)
			self:SetBindingClick(true, skuKeyBindings.SKU_KEY_MENUITEMLEFT, self:GetFrameRef("Sku2ModulesAudioMenuControlFrame"):GetName(), skuKeyBindings.SKU_KEY_MENUITEMLEFT)
			self:SetBindingClick(true, skuKeyBindings.SKU_KEY_MENUITEMRIGHT, self:GetFrameRef("Sku2ModulesAudioMenuControlFrame"):GetName(), skuKeyBindings.SKU_KEY_MENUITEMRIGHT)
			self:SetBindingClick(true, skuKeyBindings.SKU_KEY_MENUITEMCLEARFILTER, self:GetFrameRef("Sku2ModulesAudioMenuControlFrame"):GetName(), skuKeyBindings.SKU_KEY_MENUITEMCLEARFILTER)

			--single keys for filtering
			self:SetBindingClick(true, "SPACE", self:GetFrameRef("Sku2ModulesAudioMenuControlFrame"):GetName(), "SPACE")
			for x = 1, #menuAccessKeysChars do
				self:SetBindingClick(true, tostring(menuAccessKeysChars[x]), self:GetFrameRef("Sku2ModulesAudioMenuControlFrame"):GetName(), menuAccessKeysChars[x])
			end
			for x = 1, #menuAccessKeysNumbers do
				self:SetBindingClick(true, tostring(menuAccessKeysNumbers[x]), self:GetFrameRef("Sku2ModulesAudioMenuControlFrame"):GetName(),tostring(menuAccessKeysNumbers[x]))
			end
			self:SetAttribute("MenuIsOpen", true)
		else
			--menu navigation key binds
			self:GetFrameRef("Sku2ModulesAudioMenuControlFrame"):CallMethod("Close")
			self:ClearBinding(skuKeyBindings.SKU_KEY_MENUCLOSE)
			self:ClearBinding(skuKeyBindings.SKU_KEY_MENUITEMSPELLCURRENT)
			--self:ClearBinding(skuKeyBindings.SKU_KEY_MENUITEMEXECUTE)
			self:ClearBinding(skuKeyBindings.SKU_KEY_MENUITEMFIRST)
			self:ClearBinding(skuKeyBindings.SKU_KEY_MENUITEMLAST)
			self:ClearBinding(skuKeyBindings.SKU_KEY_MENUITEMUP)
			self:ClearBinding(skuKeyBindings.SKU_KEY_MENUITEMDOWN)
			self:ClearBinding(skuKeyBindings.SKU_KEY_MENUITEMLEFT)
			self:ClearBinding(skuKeyBindings.SKU_KEY_MENUITEMRIGHT)
			self:ClearBinding(skuKeyBindings.SKU_KEY_MENUITEMCLEARFILTER)

			--single keys for filtering
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
	--add some data as tables to the _onclick secure code body
	_onClickBody = Sku2.utility.tableHelpers.AddNumberIndexTableToSecureHandlerBody(tAudioMenuSecureBindHandler, "menuAccessKeysChars", module.menuAccessKeysChars, _onClickBody)
	_onClickBody = Sku2.utility.tableHelpers.AddNumberIndexTableToSecureHandlerBody(tAudioMenuSecureBindHandler, "menuAccessKeysNumbers", module.menuAccessKeysNumbers, _onClickBody)
	local skuKeyBindings = Sku2.modules.keyBindings:GetCurrentSkuBindings()
	_onClickBody = Sku2.utility.tableHelpers.AddStringIndexTableToSecureHandlerBody(tAudioMenuSecureBindHandler, "skuKeyBindings", skuKeyBindings, _onClickBody)
	tAudioMenuSecureBindHandler:SetAttribute("_onclick", _onClickBody)

	tAudioMenuSecureBindHandler:SetAttribute("MenuIsOpen", false)
	
	--register secure frame for key binds
	module.globalKeybinds["SKU_KEY_OPENMENU"] = tAudioMenuSecureBindHandler
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:OpenMenu(aSilent)
	print("audioMenu:OpenMenu()", SDL2)
	if not aSilent then
		module:StartStopBackgroundSound(true)
		PlaySound(88)
	end

	module.currentMenuPosition = module.menu.root.children[1]
	module.currentMenuPosition:OnEnter()
	module.menuOpen = true

	local currentMenuBreadcrumbString = Sku2.modules.audioMenu:GetCurrentBreadcrumbAsName(" > ")
	Sku2.modules.addon:TranscriptPanelOutput(currentMenuBreadcrumbString)
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:CloseMenu(aSilent)
	print("audioMenu:CloseMenu()", SDL2)
	module.menuOpen = false
	module:StartStopBackgroundSound(false)
	if not aSilent then
		PlaySound(89)
	end

	module.currentMenuPosition = nil

	Sku2.modules.addon:TranscriptPanelHide()
end

---------------------------------------------------------------------------------------------------------------------------------------
local tOldChildren = false
function prototype:ApplyFilter()
	print("audioMenu:ApplyFilter afilterString", module.filterString, tOldChildren, SDL3)
	local afilterString = module.filterString

	if not module.currentMenuPosition.parent.children then
		module.filterString = ""
		return
	end

	if not afilterString then
		return
	end

	afilterString = string.lower(afilterString)

	if afilterString ~= "" then
		if tOldChildren ~= false then
			--SkuCore:Debug("ApplyFilter: is already filtered; will unfilter first", tOldChildren)
			local tFilter = module.filterString
			module.filterString = ""
			module:ApplyFilter()
			module.filterString = tFilter
		end

		tOldChildren = module.currentMenuPosition.parent.children

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
			print("ApplyFilter: error, module should not happen, no results for filter, showing entry 1")
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

		module.currentMenuPosition.parent.children = tChildrenFiltered
		module.currentMenuPosition:First()
	
	elseif afilterString == "" then
		if tOldChildren ~= false then
			module.currentMenuPosition.parent.children = tOldChildren
			for x = 1, #module.currentMenuPosition.parent.children do
				if module.currentMenuPosition.parent.children[x+1] then
					module.currentMenuPosition.parent.children[x].next = module.currentMenuPosition.parent.children[x+1]
				else
					module.currentMenuPosition.parent.children[x].next = nil
				end
				if module.currentMenuPosition.parent.children[x-1] then
					module.currentMenuPosition.parent.children[x].prev = module.currentMenuPosition.parent.children[x-1]
				else
					module.currentMenuPosition.parent.children[x].prev = nil
				end
			end
			if string.find(module.currentMenuPosition.name, L["Filter"]..";") then
				module.currentMenuPosition:First()
			else
				module.currentMenuPosition:OnEnter()
			end
			tOldChildren = false
			module.filterString = ""
		end
	end
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:OpenBreadcrumbByName(aNamesString, aExecute)
	if not aNamesString or aNamesString == "" then
		Sku2.debug:Error("IsBreadcrumbByNameSecure: aNamesString empty")
		return
	end

	local tNames = {strsplit(",", aNamesString)}
	
	module:OpenMenu(aExecute)

	for x = 1, #tNames do
		module.currentMenuPosition:SelectItemByName(tNames[x])
		if module.currentMenuPosition.name ~= tNames[x] then
			Sku2.debug:Error("OpenMenuItemByNamesBreadcrumb: menu item not found: "..tNames[x])
			return false
		else
			if x < #tNames then
				if module.currentMenuPosition:Right() == false then
					module:CloseMenu(aExecute)
					return  false
				end
			else
				if aExecute == true then
					module.currentMenuPosition:Action()
					module:CloseMenu(aExecute)
					return
				end
			end
		end
	end
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:GetCurrentBreadcrumbAsName(aSeparator)
	aSeparator = aSeparator or ","
	if module.menuOpen ~= true then
		Sku2.debug:Error("GetCurrentMenuItemNameBreadcrumb: menu not open")
		return
	end
	local inCombatAvailable = true
	local namesString = module.currentMenuPosition.name
	if module.currentMenuPosition.inCombatAvailable == false then
		inCombatAvailable = false
	end
	local tParentItem = module.currentMenuPosition.parent
	while tParentItem and tParentItem.name and tParentItem.name ~= "root" do
		namesString = tParentItem.name..aSeparator..namesString
		if tParentItem.inCombatAvailable == false then
			inCombatAvailable = false
		end
		tParentItem = tParentItem.parent
	end

	return namesString, inCombatAvailable
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:StartStopBackgroundSound(aStart)
	print("audioMenu:StartStopBackgroundSound(aStart)", aStart, SDL3)
	
end