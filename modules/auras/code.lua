print("modules\\auras\\code.lua loading", SDL3)
local moduleName = "auras"
local L = Sku2.L

Sku2.modules[moduleName]._prototypes = Sku2.modules[moduleName]._prototypes or {}
Sku2.modules[moduleName]._prototypes.code = Sku2.modules[moduleName]._prototypes.code or {}
local prototype = Sku2.modules[moduleName]._prototypes.code
setmetatable(prototype, Sku2.modules.MTs.__newindex)

---------------------------------------------------------------------------------------------------------------------------------------
--prototype definition
---------------------------------------------------------------------------------------------------------------------------------------
local module = Sku2.modules[moduleName]

---------------------------------------------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:SetUpModule()
	print(moduleName, "SetUpModule", self)
	module:SetUpData()

	--frame to trigger custom "keypress" event
	local f = _G["SkuAurasKeypressTrigger"] or CreateFrame("Frame", "SkuAurasKeypressTrigger", UIParent)
	f:EnableKeyboard(true)
	f:SetPropagateKeyboardInput(true)
	f:SetPoint("TOP", _G["SkuAurasControl"], "BOTTOM", 0, 0)
	f:SetScript("OnKeyDown", function(self, aKey)
		local aEventData =  {
			GetTime(),
			"KEY_PRESS",
			nil,
			UnitGUID("player"),
			UnitName("player"),
			nil,
			nil,
			UnitGUID("playertarget"),
			UnitName("playertarget"),
			nil,
			nil,
			nil,
			nil,
			nil,
		}
		aEventData[50] = aKey

		module:COMBAT_LOG_EVENT_UNFILTERED("customCLEU", aEventData)
	end)

	local ttime = 0
	local f = _G["SkuAurasControl"] or CreateFrame("Frame", "SkuAurasControl", UIParent)
	f:SetScript("OnUpdate", function(self, time)
		ttime = ttime + time
		if ttime < 0.25 then return end

		module:COOLDOWN_TICKER()
		module:UNIT_TICKER("player")
		--module:UNIT_TICKER("playertarget")
		module:UNIT_TICKER("focus")
		--module:UNIT_TICKER("focustarget")
		module:UNIT_TICKER("target")
		--module:UNIT_TICKER("targettarget")
		module:UNIT_TICKER("pet")
		--module:UNIT_TICKER("pettarget")
		for x = 1, 4 do
			module:UNIT_TICKER("party"..x)
			--module:UNIT_TICKER("party"..x.."target")
		end
		for x = 1, 40 do
			module:UNIT_TICKER("raid"..x)
		end

		ttime = 0
	end)
	f:Show()

	SkuDispatcher:RegisterEventCallback("PLAYER_ENTERING_WORLD", module.PLAYER_ENTERING_WORLD)
	SkuDispatcher:RegisterEventCallback("COMBAT_LOG_EVENT_UNFILTERED", module.COMBAT_LOG_EVENT_UNFILTERED)
	SkuDispatcher:RegisterEventCallback("BAG_UPDATE_COOLDOWN", module.BAG_UPDATE_COOLDOWN)
	SkuDispatcher:RegisterEventCallback("UNIT_INVENTORY_CHANGED", module.UNIT_INVENTORY_CHANGED)

	SkuDispatcher:RegisterEventCallback("GROUP_FORMED", module.GROUP_FORMED)
	SkuDispatcher:RegisterEventCallback("GROUP_JOINED", module.GROUP_JOINED)
	SkuDispatcher:RegisterEventCallback("UNIT_OTHER_PARTY_CHANGED", module.UNIT_OTHER_PARTY_CHANGED)
	SkuDispatcher:RegisterEventCallback("GROUP_ROSTER_UPDATE", module.GROUP_ROSTER_UPDATE)
end

---------------------------------------------------------------------------------------------------------------------------------------
--menu handling

---------------------------------------------------------------------------------------------------------------------------------------
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
	--setmetatable(nt, getmetatable(t), deep, seen))
	seen[t] = nt
	return nt
end

------------------------------------------------------------------------------------------------------------------
local function NoIndexTableGetn(aTable)
	local tCount = 0
	for _, _ in pairs(aTable) do
		tCount = tCount + 1
	end
	return tCount
end

------------------------------------------------------------------------------------------------------------------
local function RemoveTagFromValue(aValue)
   if not aValue then
      return
   end
   local tCleanValue = string.gsub(aValue, "item:", "")
   tCleanValue = string.gsub(tCleanValue, "spell:", "")
   tCleanValue = string.gsub(tCleanValue, "output:", "")
   return tCleanValue
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:TableSortByIndex(aTable)
	local tSortedList = {}
	for k, v in Sku2.utility.tableHelpers:SkuSpairs(aTable, 
		function(t, a, b) 
			return string.lower(t[b].friendlyName) > string.lower(t[a].friendlyName)
		end) 
	do
		tSortedList[#tSortedList+1] = k
	end
	return tSortedList
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:BuildAuraTooltip(aCurrentMenuItem, aAuraName)
	--print("prototype:BuildAuraTooltip(", aCurrentMenuItem, aAuraName)	
	local tMenuItem = aCurrentMenuItem
	local tSections = {}

	local tType = ""
	local tConditions = {}
	local tAction = ""
	local tOutputs = {}
	local tCurrent = {elementType = tMenuItem.elementType, name = tMenuItem.name, internalName = tMenuItem.internalName}

	local tItemsRev = {}

	while tMenuItem.internalName do
		table.insert(tItemsRev, 1, {internalName = tMenuItem.internalName, elementType = tMenuItem.elementType, name = tMenuItem.name})
		tMenuItem = tMenuItem.parent
	end

	local x = 1
	while tItemsRev[x] do
		if tItemsRev[x].elementType == "type" then
			tType = tItemsRev[x].name
			x = x + 1
		elseif tItemsRev[x].elementType == "attribute" and tItemsRev[x].internalName ~= "action" then
			local tCondNo = #tConditions + 1
			tConditions[tCondNo] = {attribute = tItemsRev[x].name}
			x = x + 1
			if not tItemsRev[x] then break end
			tConditions[tCondNo].operator = tItemsRev[x].name
			x = x + 1
			if not tItemsRev[x] then break end
			tConditions[tCondNo].value = tItemsRev[x].name
			x = x + 1
		elseif tItemsRev[x].elementType == "attribute" and tItemsRev[x].internalName == "action" then
			x = x + 2
			if not tItemsRev[x] then tAction = "nicht festgelegt" break end
			tAction = tItemsRev[x].name
			x = x + 1
		elseif tItemsRev[x].elementType == "output" then
			tOutputs[#tOutputs + 1] = tItemsRev[x].name
			x = x + 1
		else
			x = x + 1
		end
	end

	if #tOutputs == 0 then
		tOutputs[#tOutputs + 1] = "nicht festgelegt"
	end
	if #tConditions == 0 then
		tConditions[#tConditions + 1] = {attribute = "nicht festgelegt"}
	end
	if tType == "" then
		tType = "nicht festgelegt"
	end
	if tAction == "" then
		tAction = "nicht festgelegt"
	end

	if tCurrent.elementType then
		local tText = "Aktuelles Element: "..module.itemTypes[tCurrent.elementType].friendlyName.."\r\nAuswählter Wert: "..tCurrent.name.." "
		if tCurrent.elementType == "type" then
			if module.Types[tCurrent.internalName].tooltip then
				tText = tText.."("..module.Types[tCurrent.internalName].tooltip..")"
			end
		elseif tCurrent.elementType == "attribute" then
			--print("tCurrent.internalName", tCurrent.internalName)			
			if module.attributes[tCurrent.internalName].tooltip then
				tText = tText.."("..module.attributes[tCurrent.internalName].tooltip..")"
			end
		elseif tCurrent.elementType == "operator" then
			if module.Operators[tCurrent.internalName].tooltip then
				tText = tText.."("..module.Operators[tCurrent.internalName].tooltip..")"
			end
		elseif tCurrent.elementType == "value" then
			if module.values[tCurrent.internalName] then
				if module.values[tCurrent.internalName].tooltip then
					tText = tText.."("..module.values[tCurrent.internalName].tooltip..")"
				end
			end
		elseif tCurrent.elementType == "action" then
			if module.actions[tCurrent.internalName].tooltip then
				tText = tText.."("..module.actions[tCurrent.internalName].tooltip..")"
			end
		elseif tCurrent.elementType == "output" then
			if module.outputs[RemoveTagFromValue(tCurrent.internalName)].tooltip then
				tText = tText.."("..module.outputs[RemoveTagFromValue(tCurrent.internalName)].tooltip..")"
			end
		end
		table.insert(tSections, tText)
	end


	if aAuraName and Sku2.db.char.auras.Auras[aAuraName] then
		if Sku2.db.char.auras.Auras[aAuraName].type then
			tType = module.Types[Sku2.db.char.auras.Auras[aAuraName].type].friendlyName
		end
		tConditions = {}
		for tName, tData in pairs(Sku2.db.char.auras.Auras[aAuraName].attributes) do
			if module.attributes[tName] then
				for tDataIndex, tDataData in pairs(tData) do
					local tFname = tDataData[2]
					if  module.values[tDataData[2]] then
						tFname = module.values[tDataData[2]].friendlyName
					end
					tFname = module:RemoveTags(tFname)					
					tConditions[#tConditions + 1] = {attribute = module.attributes[tName].friendlyName, operator = module.Operators[tDataData[1]].friendlyName, value = tFname}
				end
			end
		end
		tAction = module.actions[Sku2.db.char.auras.Auras[aAuraName].actions[1]].friendlyName
		tOutputs = {}
		for tIndex, tData in pairs(Sku2.db.char.auras.Auras[aAuraName].outputs) do
			local tString = string.gsub(module.outputs[RemoveTagFromValue(tData)].friendlyName, "sound".."#", ";")
			tOutputs[#tOutputs + 1] = tString
		end
		table.insert(tSections, "Aura Elemente\r\n")
	else
		table.insert(tSections, "Bisherige Aura Elemente\r\n")
	end

	table.insert(tSections, "Aura Typ: "..(tType or ""))
	
	local tString = "Aura Bedingungen:\r\n"
	for x = 1, #tConditions do
		tString = tString..x..": "..tConditions[x].attribute.." "..(tConditions[x].operator or "").." "..(tConditions[x].value or "").."\r\n"
	end
	table.insert(tSections, tString)

	table.insert(tSections, "Aura Aktion: "..(tAction or ""))

	tString = "Aura Ausgaben:\r\n"
	for x = 1, #tOutputs do
		tString = tString..x..": "..(tOutputs[x] or "").."\r\n"
	end
	table.insert(tSections, tString)

	--SkuOptions.currentMenuPosition.textFull = tSections
end

---------------------------------------------------------------------------------------------------------------------------------------
local function RebuildUsedOutputsHelper(aCurrentMenuItem)
	local tUsed = {}
	local tCurrentItem = aCurrentMenuItem.parent

	tUsed[RemoveTagFromValue(aCurrentMenuItem.internalName)] = true

	while tCurrentItem.parent.parent.internalName ~= "action" do
		tUsed[RemoveTagFromValue(tCurrentItem.internalName)] = true
		tCurrentItem = tCurrentItem.parent
	end

	tUsed[RemoveTagFromValue(tCurrentItem.parent.internalName)] = true

	return tUsed
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:NewAuraAttributeBuilder(self)
	local audioMenu = Sku2.modules.audioMenu

	local tSelectTarget = nil
	if self.isSelect then
		tSelectTarget = self
	elseif self.parent.selectTarget then
		tSelectTarget = self.parent.selectTarget
	elseif self.parent.isSelect then
		tSelectTarget = self.parent
	end
	
	local tBuildChildrenFunc = function(self)
		if not tSelectTarget then
			local tAttributeEntry = audioMenu:InjectMenuItems(self, {"empty no tSelectTarget"}, audioMenu.genericMenuItem)
			return
		end

		if self.parent.parent.internalName == "action" and not tSelectTarget.newOrChanged then
			local tSortedList = module:TableSortByIndex(module.outputs)
			for x = 1, #tSortedList do
				local i, v = tSortedList[x], module.outputs[tSortedList[x]]
				if not tSelectTarget.usedOutputs[i] then
					tItemCount = true
					local tAttributeEntry = audioMenu:InjectMenuItems(self, {v.friendlyName}, audioMenu.genericMenuItem)
					tAttributeEntry.internalName = "output:"..i
					tAttributeEntry.dynamic = true
					tAttributeEntry.filterable = true
					tAttributeEntry.actionOnEnter = true
					tAttributeEntry.elementType = "output"
					tAttributeEntry.onEnterCallbackFunc = function(self, aValue, aName)
						tSelectTarget.collectValuesFrom = self
						tSelectTarget.usedOutputs = RebuildUsedOutputsHelper(self)
						self.buildChildrenFunc = module:NewAuraOutputBuilder(self)		
						module:BuildAuraTooltip(self)
						audioMenu.genericMenuItem.onEnterCallbackFunc(self, aValue, aName)
					end
					tAttributeEntry.buildChildrenFunc = function(self)
						--dprint("build content of", self.name)
						--dprint("self.internalName", self.internalName)
					end
				end
			end
		
		else
			local tItemCount
			if module.Types[tSelectTarget.internalName] then
				local tSortedList = module:TableSortByIndex(module.attributes)
				for x = 1, #tSortedList do
					local i, v = tSortedList[x], tSortedList[x]
					
					local tIsInvalid
					if string.find(i , "skuAura") ~= nil and module:AuraUsedInOtherAuras(self.parent.parent.parent.name) ~= nil then
						tIsInvalid = true
					else
						if module.attributes["skuAura"..i] ~= nil then
							tIsInvalid = true
						else
							if i ~= "skuAura"..self.parent.parent.parent.name then
								if module:AuraHasOtherAuras(string.gsub(i, "skuAura", "")) ~= true then
								else
									tIsInvalid = true
								end
							else
								tIsInvalid = true
							end
						end
					end

					if tIsInvalid ~= true then
						tItemCount = true

						local tAttributeEntry = audioMenu:InjectMenuItems(self, {module.attributes[v].friendlyName}, audioMenu.genericMenuItem)
						tAttributeEntry.internalName = v
						tAttributeEntry.dynamic = true
						tAttributeEntry.filterable = true
						tAttributeEntry.vocalizeAsIs = true
						tAttributeEntry.elementType = "attribute"
						tAttributeEntry.onEnterCallbackFunc = function(self, aValue, aName)
							self.buildChildrenFunc = module:NewAuraOperatorBuilder(self)		
							module:BuildAuraTooltip(self)
						end
						tAttributeEntry.buildChildrenFunc = function(self)
							--dprint("build content of", self.name)
							--dprint("self.internalName", self.internalName)
						end
					end
				end

				if not tItemCount then
					self.dynamic = false
				end
			else
				local tAttributeEntry = audioMenu:InjectMenuItems(self, {"this should not happen - empty not module.Types[tSelectTarget.name.internalName]"}, audioMenu.genericMenuItem)
			end
		end
	end

	return tBuildChildrenFunc
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:NewAuraOutputBuilder(self)
	local audioMenu = Sku2.modules.audioMenu

	local tSelectTarget = nil
	if self.isSelect then
		tSelectTarget = self
	elseif self.parent.selectTarget then
		tSelectTarget = self.parent.selectTarget
	elseif self.parent.isSelect then
		tSelectTarget = self.parent
	end

	local tBuildChildrenFunc = function(self)
		if not tSelectTarget then
			local tAttributeEntry = audioMenu:InjectMenuItems(self, {"this should not happen - empty no tSelectTarget"}, audioMenu.genericMenuItem)
			return
		end

		tItemCount = 0

		local tSortedList = module:TableSortByIndex(module.outputs)
		for x = 1, #tSortedList do
			local i, v = tSortedList[x], module.outputs[tSortedList[x]]
			if not tSelectTarget.usedOutputs[i] then
				tItemCount = tItemCount + 1
				local tAttributeEntry = audioMenu:InjectMenuItems(self, {v.friendlyName}, audioMenu.genericMenuItem)
				tAttributeEntry.internalName = "output:"..i
				tAttributeEntry.dynamic = true
				tAttributeEntry.filterable = true
				tAttributeEntry.actionOnEnter = true
				tAttributeEntry.vocalizeAsIs = true
				tAttributeEntry.elementType = "output"
				tAttributeEntry.onEnterCallbackFunc = function(self, aValue, aName)
					tSelectTarget.collectValuesFrom = self
					tSelectTarget.usedOutputs = RebuildUsedOutputsHelper(self)
					if tItemCount > 0 then
						self.buildChildrenFunc = module:NewAuraOutputBuilder(self)		
					end
					if tItemCount == 1 then
						self.dynamic = false
					end
					module:BuildAuraTooltip(self)
					audioMenu.genericMenuItem.onEnterCallbackFunc(self, aValue, aName)
				end
				tAttributeEntry.buildChildrenFunc = function(self)
					--dprint("build content of", self.name)
					--dprint("self.internalName", self.internalName)
				end
			end
		end
	end

	return tBuildChildrenFunc
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:NewAuraOperatorBuilder(self)
	local audioMenu = Sku2.modules.audioMenu
	
	local tSelectTarget = nil
	if self.isSelect then
		tSelectTarget = self
	elseif self.parent.selectTarget then
		tSelectTarget = self.parent.selectTarget
	elseif self.parent.isSelect then
		tSelectTarget = self.parent
	end
	
	local tBuildChildrenFunc = function(self)
		if not tSelectTarget then
			local tAttributeEntry = audioMenu:InjectMenuItems(self, {"empty"}, audioMenu.genericMenuItem)
			return
		end

		if module.attributes[self.internalName] and module.attributes[self.internalName].updateValues then
			module.attributes[self.internalName]:updateValues()
		end

		if self.internalName == "action" then
			local tAttributeEntry = audioMenu:InjectMenuItems(self, {"then"}, audioMenu.genericMenuItem)
			tAttributeEntry.internalName = "then"
			tAttributeEntry.dynamic = true
			tAttributeEntry.filterable = true
			tAttributeEntry.elementType = "then"
			tAttributeEntry.onEnterCallbackFunc = function(self, aValue, aName)
				self.buildChildrenFunc = module:NewAuraValueBuilder(self)
				module:BuildAuraTooltip(self)
			end
			tAttributeEntry.buildChildrenFunc = function(self)
				--dprint("build content of", self.name)
			end
		else
			local attrType = module.attributes[self.internalName].type or "CATEGORY"
			local operators = module.operatorsForAttributeType[attrType]
			local tSortedList = module:TableSortByIndex(operators)
			for x = 1, #tSortedList do
				local i, v = tSortedList[x], module.Operators[tSortedList[x]]
				if i ~= "then" then
					local tAttributeEntry = audioMenu:InjectMenuItems(self, {v.friendlyName}, audioMenu.genericMenuItem)
					tAttributeEntry.internalName = i
					tAttributeEntry.dynamic = true
					tAttributeEntry.filterable = true
					tAttributeEntry.vocalizeAsIs = true
					tAttributeEntry.elementType = "operator"
					tAttributeEntry.onEnterCallbackFunc = function(self, aValue, aName)
						self.buildChildrenFunc = module:NewAuraValueBuilder(self)
						module:BuildAuraTooltip(self)
					end
					tAttributeEntry.buildChildrenFunc = function(self)
						--dprint("build content of", self.name)
					end
				end
			end
		end
	end

	return tBuildChildrenFunc
end

---------------------------------------------------------------------------------------------------------------------------------------
local slower = string.lower
function prototype:NewAuraValueBuilder(self)
	local audioMenu = Sku2.modules.audioMenu
	
	local tSelectTarget = nil
	if self.isSelect then
		tSelectTarget = self
	elseif self.parent.parent.selectTarget then
		tSelectTarget = self.parent.parent.selectTarget
	elseif self.parent.parent.isSelect then
		tSelectTarget = self.parent.parent
	end
	
	tSelectTarget.usedOutputs = {}

	local tBuildChildrenFunc = function(self)
		if not tSelectTarget then
			local tAttributeValueEntry = audioMenu:InjectMenuItems(self, {"empty"}, audioMenu.genericMenuItem)
			return
		end

		if module.Types[tSelectTarget.internalName] then
			local tSortedList = {}
			for k, v in Sku2.utility.tableHelpers:SkuSpairs(module.attributes[self.parent.internalName].values, 
				function(t, a, b) 
					if module.actions[module.attributes[self.parent.internalName].values[b]] then
						return slower(module.actions[module.attributes[self.parent.internalName].values[b]].friendlyName) > slower(module.actions[module.attributes[self.parent.internalName].values[a]].friendlyName)
					else
						return slower(module.values[module.attributes[self.parent.internalName].values[b]].friendlyName) > slower(module.values[module.attributes[self.parent.internalName].values[a]].friendlyName)
					end
				end) 
			do
				tSortedList[#tSortedList+1] = v
			end

			--for i, v in pairs(module.attributes[self.parent.internalName].values) do
			for x = 1, #tSortedList do
				local i, v = tSortedList[x], tSortedList[x]
				local tAttributeValueEntryName = ""
				if self.internalName == "then" then
					tAttributeValueEntryName = module.actions[v].friendlyName
				else
					tAttributeValueEntryName = module.values[v].friendlyName
				end
				local tAttributeValueEntry = audioMenu:InjectMenuItems(self, {tAttributeValueEntryName}, audioMenu.genericMenuItem)
				tAttributeValueEntry.internalName = v
				if not tSelectTarget.single then
					tAttributeValueEntry.dynamic = true
				end
				tAttributeValueEntry.filterable = true
				--tAttributeValueEntry.actionOnEnter = true
				tAttributeValueEntry.vocalizeAsIs = true
				tAttributeValueEntry.elementType = "value"
				tAttributeValueEntry.onEnterCallbackFunc = function(self, aValue, aName)
					tSelectTarget.collectValuesFrom = self
					tSelectTarget.usedAttributes[self.parent.parent.internalName] = true
					if not tSelectTarget.single then
						self.buildChildrenFunc = module:NewAuraAttributeBuilder(self)
					end
					module:BuildAuraTooltip(self)
				end
				if not tSelectTarget.single then
					tAttributeValueEntry.buildChildrenFunc = function(self)
						--dprint("build content of", self.name)
					end
				end
			end
		else
			local tAttributeValueEntry = audioMenu:InjectMenuItems(self, {"empty"}, audioMenu.genericMenuItem)
		end
	end

	return tBuildChildrenFunc
end


---------------------------------------------------------------------------------------------------------------------------------------
function prototype:BuildAuraName(aNewType, aNewAttributes, aNewActions, aNewOutputs)
	--print("BuildAuraName(", aNewType, aNewAttributes, aNewActions, aNewOutputs)
	local tAuraName = module.Types[aNewType].friendlyName..";"
	local tOuterCount = 0
	for tAttributeName, tAttributeValue in pairs(aNewAttributes) do
		if tOuterCount > 0 then
			tAuraName = tAuraName.."und;"
		end
		if #tAttributeValue > 1 then
			local tCount = 0
			for tInd, tLocalValue in pairs(tAttributeValue) do
				local tFname = tLocalValue[2]
				if module.values[tLocalValue[2]] then
					tFname = module.values[tLocalValue[2]].friendlyName
				end
				tFname = module:RemoveTags(tFname)

				if tCount > 0 then
					tAuraName = tAuraName.."oder;"..module.attributes[tAttributeName].friendlyName..";"..module.Operators[tLocalValue[1]].friendlyName..";"..tFname..";"
				else
					tAuraName = tAuraName..module.attributes[tAttributeName].friendlyName..";"..module.Operators[tLocalValue[1]].friendlyName..";"..tFname..";"
				end
				tCount = tCount + 1
			end
		else
			tAuraName = tAuraName..module.attributes[tAttributeName].friendlyName..";"..module.Operators[tAttributeValue[1][1]].friendlyName..";"..module.values[tAttributeValue[1][2]].friendlyName..";"
		end
		tOuterCount = tOuterCount + 1
	end				

	tAuraName = tAuraName.."dann;"..module.actions[aNewActions[1]].friendlyName..";"

	for tOutputIndex, tOutputName in pairs(aNewOutputs) do
		tAuraName = tAuraName..";und;"..module.outputs[string.gsub(tOutputName, "output:", "")].friendlyName..";"
		tAuraName = string.gsub(tAuraName, "aura;sound#", "sound;")
	end

	return tAuraName
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:UpdateAura(aAuraNameToUpdate, aNewType, aEnabled, aNewAttributes, aNewActions, aNewOutputs)
	--print("UpdateAura", aAuraNameToUpdate)
	--build the new name
	local audioMenu = Sku2.modules.audioMenu
	local tAuraName = module:BuildAuraName(aNewType, aNewAttributes, aNewActions, aNewOutputs)
	if Sku2.db.char.auras.Auras[aAuraNameToUpdate].customName == true then
		tAuraName = aAuraNameToUpdate
	end

	--update aura
	local tBackTo = audioMenu.currentMenuPosition.selectTarget.backTo
	C_Timer.After(0.01, function()
		--remove old aura
		local tIsCustomName = Sku2.db.char.auras.Auras[aAuraNameToUpdate].customName
		Sku2.db.char.auras.Auras[aAuraNameToUpdate] = nil

		--add new aura
		Sku2.db.char.auras.Auras[tAuraName] = {
			type = aNewType,
			enabled = aEnabled,
			attributes = aNewAttributes,
			actions = aNewActions,
			outputs = aNewOutputs,
			customName = tIsCustomName,
		}

		--SkuOptions.Voice:OutputStringBTtts(L["Aktualisiert"], true, true, 0.3, true)		

		--[[
		C_Timer.After(0.01, function()
			SkuOptions:SlashFunc(L["short"]..L[",SkuAuras,Auren,Auren verwalten,"]..SkuOptions.currentMenuPosition.parent.parent.parent.name..","..tAuraName)
			SkuOptions.currentMenuPosition:OnBack(SkuOptions.currentMenuPosition)
			SkuOptions:VocalizeCurrentMenuName()
		end)
		]]
	end)

end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:BuildManageSubMenu(aParentEntry, aNewEntry)
	local audioMenu = Sku2.modules.audioMenu
	
	local tTypeItem = audioMenu:InjectMenuItems(aParentEntry, aNewEntry, audioMenu.genericMenuItem)
	tTypeItem.dynamic = true
	tTypeItem.internalName = "action"
	tTypeItem.onEnterCallbackFunc = function(self)
		self.selectTarget.targetAuraName = self.name
		module:BuildAuraTooltip(self, self.name)
	end
	tTypeItem.buildChildrenFunc = function(self)
		local tNewMenuEntry = audioMenu:InjectMenuItems(self, {"Umbenennen"}, audioMenu.genericMenuItem)
		tNewMenuEntry.onEnterCallbackFunc = function(self)
			self.selectTarget.targetAuraName = self.parent.name
		end
		if Sku2.db.char.auras.Auras[self.selectTarget.targetAuraName] and Sku2.db.char.auras.Auras[self.selectTarget.targetAuraName].customName then
			if module:AuraUsedInOtherAuras(self.selectTarget.targetAuraName) ~= true then
				local tNewMenuEntry = audioMenu:InjectMenuItems(self, {"Set name to auto generated"}, audioMenu.genericMenuItem)
				tNewMenuEntry.onEnterCallbackFunc = function(self)
					self.selectTarget.targetAuraName = self.parent.name
				end
			end
		end

		if module:AuraUsedInOtherAuras(self.selectTarget.targetAuraName) ~= true then
			if self.parent.name == "Aktivierte" then
				local tNewMenuEntry = audioMenu:InjectMenuItems(self, {"Deaktivieren"}, audioMenu.genericMenuItem)
				tNewMenuEntry.onEnterCallbackFunc = function(self)
					self.selectTarget.targetAuraName = self.parent.name
				end
			else
				local tNewMenuEntry = audioMenu:InjectMenuItems(self, {"Aktivieren"}, audioMenu.genericMenuItem)
				tNewMenuEntry.onEnterCallbackFunc = function(self)
					self.selectTarget.targetAuraName = self.parent.name
				end			
			end
		end
		local tNewMenuEntry = audioMenu:InjectMenuItems(self, {"Bearbeiten"}, audioMenu.genericMenuItem)
		tNewMenuEntry.onEnterCallbackFunc = function(self)
			self.selectTarget.targetAuraName = self.parent.name
		end		
		tNewMenuEntry.dynamic = true
		tNewMenuEntry.internalName = "action"
		tNewMenuEntry.buildChildrenFunc = function(self)
			local tNewMenuEntryCond = audioMenu:InjectMenuItems(self, {"Bedingungen"}, audioMenu.genericMenuItem)
			tNewMenuEntryCond.dynamic = true
			tNewMenuEntryCond.isSelect = true
			tNewMenuEntryCond.auraName = self.parent.name
			tNewMenuEntryCond.backTo = self.parent.parent
			tNewMenuEntryCond.usedAttributes = {}
			tNewMenuEntryCond.single = true
			tNewMenuEntryCond.internalName = Sku2.db.char.auras.Auras[self.parent.name].type
			tNewMenuEntryCond.actionFunc = function(self, aValue, aName)
				local tType = Sku2.db.char.auras.Auras[self.auraName].type
				local tEnabled = Sku2.db.char.auras.Auras[self.auraName].enabled
				local tAttributes = Sku2.db.char.auras.Auras[self.auraName].attributes
				local tActions = Sku2.db.char.auras.Auras[self.auraName].actions
				local tOutputs = Sku2.db.char.auras.Auras[self.auraName].outputs

				local function tAddConditionHelper(aParent)
					if not tAttributes[aParent.collectValuesFrom.parent.parent.internalName] then
						tAttributes[aParent.collectValuesFrom.parent.parent.internalName] = {}
					end
					table.insert(tAttributes[aParent.collectValuesFrom.parent.parent.internalName], {
						[1] = aParent.collectValuesFrom.parent.internalName,
						[2] = aParent.collectValuesFrom.internalName,
					})
				end
				
				local function tDeleteConditionHelper(aParent)
					local tDeleteAttribute
					for i, v in pairs(tAttributes) do
						if i == aParent.selectedCond[1] then
							local tFoundX
							if #v > 1 then
								for x = 1, #v do
									if v[x][1] == aParent.selectedCond[2] and v[x][2] == aParent.selectedCond[3] then
										tFoundX = x
									end
								end
								if tFoundX then
									table.remove(v, tFoundX)
								end
							else
								if v[1][1] == aParent.selectedCond[2] and v[1][2] == aParent.selectedCond[3] then
									table.remove(v, tFoundX)
								end
							end
							if #v == 0 then
								tDeleteAttribute = i
							end
						end
					end
					if tDeleteAttribute then
						tAttributes[tDeleteAttribute] = nil
					end
				end

				if aName == "Löschen" then
					tDeleteConditionHelper(self)

				elseif self.newOrChanged == "new" then
					tAddConditionHelper(self)

				elseif self.newOrChanged == "changed" then
					tDeleteConditionHelper(self)
					tAddConditionHelper(self)
				end

				module:UpdateAura(self.auraName, tType, tEnabled, tAttributes, tActions, tOutputs)
			end

			tNewMenuEntryCond.buildChildrenFunc = function(self)
				local tNewMenuEntryCondVal = audioMenu:InjectMenuItems(self, {"Bedingung hinzufügen"}, audioMenu.genericMenuItem)
				tNewMenuEntryCondVal.dynamic = true
				tNewMenuEntryCondVal.onEnterCallbackFunc = function(self, aValue, aName)
					self.selectTarget.newOrChanged = "new"
				end
				tNewMenuEntryCondVal.buildChildrenFunc = module:NewAuraAttributeBuilder(tNewMenuEntryCondVal)
				for i, v in pairs(Sku2.db.char.auras.Auras[self.parent.parent.name].attributes) do
					for x = 1, #v do
						local tNewMenuEntryCondValCon = audioMenu:InjectMenuItems(self, {module.attributes[i].friendlyName..";"..module.Operators[v[x][1]].friendlyName ..";"..module.values[v[x][2]].friendlyName}, audioMenu.genericMenuItem)
						tNewMenuEntryCondValCon.dynamic = true
						tNewMenuEntryCondValCon.onEnterCallbackFunc = function(self, aValue, aName)
							self.selectTarget.selectedCond = {[1] = i, [2] = v[x][1], [3] = v[x][2]}
						end
						tNewMenuEntryCondValCon.buildChildrenFunc = function(self)
							local tNewMenuEntryCondValOptions = audioMenu:InjectMenuItems(self, {"Ändern"}, audioMenu.genericMenuItem)
							tNewMenuEntryCondValOptions.dynamic = true
							tNewMenuEntryCondValOptions.onEnterCallbackFunc = function(self, aValue, aName)
								self.selectTarget.newOrChanged = "changed"
							end
							tNewMenuEntryCondValOptions.buildChildrenFunc = module:NewAuraAttributeBuilder(tNewMenuEntryCondValOptions)

							if NoIndexTableGetn(Sku2.db.char.auras.Auras[self.parent.parent.parent.name].attributes) > 1 then
								local tNewMenuEntryCondValOptions = audioMenu:InjectMenuItems(self, {"Löschen"}, audioMenu.genericMenuItem)
								tNewMenuEntryCondValOptions.actionOnEnter = true
							end
						end
					end
				end
			end

			local tNewMenuEntryOutp = audioMenu:InjectMenuItems(self, {"Ausgaben"}, audioMenu.genericMenuItem)
			tNewMenuEntryOutp.filterable = true
			tNewMenuEntryOutp.dynamic = true
			tNewMenuEntryOutp.isSelect = true
			tNewMenuEntryOutp.auraName = self.parent.name
			tNewMenuEntryOutp.usedOutputs = {}
			tNewMenuEntryOutp.backTo = self.parent.parent
			tNewMenuEntryOutp.single = true
			tNewMenuEntryOutp.internalName = "action"
			tNewMenuEntryOutp.actionFunc = function(self, aValue, aName)
				--dprint("---- actionFunc Ausgaben ", aValue, aName)
				--dprint("     self.auraName", self.auraName)
				--dprint("     self.collectValuesFrom.name", self.collectValuesFrom.name)

				local tType = Sku2.db.char.auras.Auras[self.auraName].type
				local tEnabled = Sku2.db.char.auras.Auras[self.auraName].enabled
				local tAttributes = Sku2.db.char.auras.Auras[self.auraName].attributes
				local tActions = Sku2.db.char.auras.Auras[self.auraName].actions
				local tOutputs = Sku2.db.char.auras.Auras[self.auraName].outputs

				local tTmpOutputs = {}
				local tCurrent = self.collectValuesFrom
				while tCurrent.name ~= "Ausgaben" do
					tTmpOutputs[#tTmpOutputs + 1] = tCurrent.internalName
					tCurrent = tCurrent.parent
				end
				
				local tNewOutputs = {}
				for x = #tTmpOutputs, 1, -1 do
					tNewOutputs[#tNewOutputs + 1] = tTmpOutputs[x]
				end

				module:UpdateAura(self.auraName, tType, tEnabled, tAttributes, tActions, tNewOutputs)
			end
			tNewMenuEntryOutp.buildChildrenFunc = module:NewAuraAttributeBuilder(tNewMenuEntryOutp)
		end
		local tNewMenuEntry = audioMenu:InjectMenuItems(self, {"Duplizieren"}, audioMenu.genericMenuItem)
		tNewMenuEntry.dynamic = true
		tNewMenuEntry.isSelect = true
		tNewMenuEntry.actionFunc = function(self, aValue, aName)
			--dprint("actionFunc Duplizieren")
			local tCopyCounter = 1
			local tTestNewName = "Kopie;"..tCopyCounter..";"..self.parent.name
			while Sku2.db.char.auras.Auras[tTestNewName] do
				tCopyCounter = tCopyCounter + 1
				tTestNewName = "Kopie;"..tCopyCounter..";"..self.parent.name
			end
			Sku2.db.char.auras.Auras[tTestNewName] = TableCopy(Sku2.db.char.auras.Auras[self.parent.name], true)
			--SkuOptions.Voice:OutputStringBTtts(L["Dupliziert"], true, true, 0.3, true)		

			--[[
			C_Timer.After(0.01, function()
				SkuOptions:SlashFunc(L["short"]..L[",SkuAuras,Auren,Auren verwalten,"]..self.parent.parent.name..","..tTestNewName)
				SkuOptions.currentMenuPosition:OnBack(SkuOptions.currentMenuPosition)
				SkuOptions:VocalizeCurrentMenuName()
			end)
			]]
		end
		tNewMenuEntry.buildChildrenFunc = function(self)
			local tNewMenuEntry = audioMenu:InjectMenuItems(self, {"Wirklich duplizieren?"}, audioMenu.genericMenuItem)
		end

		if module:AuraUsedInOtherAuras(self.selectTarget.targetAuraName) ~= true then
			local tNewMenuEntry = audioMenu:InjectMenuItems(self, {"Löschen"}, audioMenu.genericMenuItem)
		end
		local tNewMenuEntry = audioMenu:InjectMenuItems(self, {"Exportieren"}, audioMenu.genericMenuItem)
	end
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:ExportAuraData(aAuraNamesTable)
	if not aAuraNamesTable then
		return
	end

	local tExportDataTable = {
		version = GetAddOnMetadata("Sku", "Version"),
		auraData = {},
	}

	for i, v in pairs(aAuraNamesTable) do
		if Sku2.db.char.auras.Auras[v] then
			tExportDataTable.auraData[v] = Sku2.db.char.auras.Auras[v]
		end
	end

	PlaySound(88)
	print("Aura exportiert")
	--SkuOptions.Voice:OutputStringBTtts(L["Jetzt Export Daten mit Steuerung plus C kopieren und Escape drücken"], false, true, 0.3)		
	--SkuOptions:EditBoxShow(SkuOptions:Serialize(tExportDataTable.version, tExportDataTable.auraData), function(self) PlaySound(89) end)
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:ImportAuraData()
	PlaySound(88)
	--SkuOptions.Voice:OutputStringBTtts(L["Paste data to import now"], false, true, 0.2)

	--[[
	SkuOptions:EditBoxPasteShow("", function(self)
		PlaySound(89)
		local tSerializedData = strtrim(table.concat(_G["SkuOptionsEditBoxPaste"].SkuOptionsTextBuffer))

		if tSerializedData ~= "" then
			local tSuccess, version, auraName, auraData = SkuOptions:Deserialize(tSerializedData)
			if type(auraName) == "string" then
				if auraName and auraData and version then
					if version < 22.8 then
						--SkuOptions.Voice:OutputStringBTtts(L["Aura version zu alt"], false, true, 0.3)		
						return
					end
					auraData.enabled = true
					Sku2.db.char.auras.Auras[auraName] = auraData
					print(L["Aura importiert:"])
					print(auraName)
					--SkuOptions.Voice:OutputStringBTtts(L["Aura importiert"], false, true, 0.3)		
				else
					--SkuOptions.Voice:OutputStringBTtts(L["Aura daten defekt"], false, true, 0.3)		
					return
				end

			elseif type(auraName) == "table" then
				auraData = auraName
				for i, v in pairs(auraData) do
					print(i)
					v.enabled = true
					Sku2.db.char.auras.Auras[i] = v
				end
				--SkuOptions.Voice:OutputStringBTtts(L["Aura importiert"], false, true, 0.3)		
			end
		end
	end)
	]]
end

---------------------------------------------------------------------------------------------------------------------------------------
--feature handling
local sgsub = string.gsub
local sfind = string.find
local smatch = string.match
local GetTime = GetTime
local UnitGUID = UnitGUID
local UnitName = UnitName
local mfloor = math.floor

---------------------------------------------------------------------------------------------------------------------------------------
local CleuBase = {
	timestamp = 1,
	subevent = 2,
	hideCaster =3 ,
	sourceGUID = 4,
	sourceName = 5,
	sourceFlags = 6,
	sourceRaidFlags = 7,
	destGUID = 8,
	destName = 9,
	destFlags = 10,
	destRaidFlags = 11,
	spellId = 12,
	spellName = 13,
	spellSchool = 14,
	unitHealthPlayer = 35,
	unitPowerPlayer = 36,
	buffListTarget = 37,
	dbuffListTarget = 38,
	itemID = 40,
	missType = 41,
--key = 50
--combo = 51
}

prototype.ItemCDRepo = {}
prototype.SpellCDRepo = {}
prototype.UnitRepo = {}
prototype.thingsNamesOnCd = {}

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:GetBaseAuraName(aAuraName)
	local tF = string.find(aAuraName, "dann;")
	if tF then
		return string.sub(aAuraName, 1, tF - 1)
	end

	return aAuraName

end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:GetBestUnitId(aUnitGUID)

	if not aUnitGUID then
		return {}
	end
	if aUnitGUID == "" then
		return {}
	end

	local tUnitIds = {}

	local function checkUnit(unit)
		if aUnitGUID == UnitGUID(unit) then
			tUnitIds[#tUnitIds + 1] = unit
		end
	end

	if IsInRaid() then
		for x = 1, 40 do
			checkUnit("raid" .. x)
		end
	end
	if IsInGroup() then
		checkUnit("party0")
		for x = 1, 4 do
			checkUnit("party" .. x)
			checkUnit("party" .. x .. "target")
		end
	end
	checkUnit("target")
	checkUnit("player")
	checkUnit("pet")
	checkUnit("focus")
	checkUnit("focustarget")
	checkUnit("targettarget")

	return tUnitIds
end

---------------------------------------------------------------------------------------------------------------------------------------
local function GetItemCooldownLeft(start, duration)
	-- Before restarting the GetTime() will always be greater than [start]
	-- After the restart, [start] is technically always bigger because of the 2^32 offset thing
	if start < GetTime() then
		 local cdEndTime = start + duration
		 local cdLeftDuration = cdEndTime - GetTime()
		 
		 return cdLeftDuration
	end

	local time = time()
	local startupTime = time - GetTime()
	-- just a simplification of: ((2^32) - (start * 1000)) / 1000
	local cdTime = (2 ^ 32) / 1000 - start
	local cdStartTime = startupTime - cdTime
	local cdEndTime = cdStartTime + duration
	local cdLeftDuration = cdEndTime - time
	
	return cdLeftDuration
end

---------------------------------------------------------------------------------------------------------------------------------------
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
	--setmetatable(nt, getmetatable(t), deep, seen))
	seen[t] = nt
	return nt
end

---------------------------------------------------------------------------------------------------------------------------------------
local tItemHook
function prototype:PLAYER_ENTERING_WORLD(aEvent, aIsInitialLogin, aIsReloadingUi)
	--print("PLAYER_ENTERING_WORLD", aEvent, aIsInitialLogin, aIsReloadingUi)
	local seen = {}
	module.values = TableCopy(module.valuesDefault, true, seen)

	module.attributes.itemId.values = {}
	module.attributes.itemName.values = {}
	--[[
	for itemId, itemName in pairs(SkuDB.itemLookup[Sku.Loc]) do
		module.attributes.itemId.values[#module.attributes.itemId.values + 1] = "item:"..tostring(itemId)
		module.values["item:"..tostring(itemId)] = {friendlyName = itemId.." ("..itemName..")",}

		if not module.values["item:"..tostring(itemName)] then
			module.attributes.itemName.values[#module.attributes.itemName.values + 1] = "item:"..tostring(itemName)
			module.values["item:"..tostring(itemName)] = {friendlyName = itemName,}
		end
	end
	]]
	module.attributes.spellId.values = {}
	module.attributes.spellNameOnCd.values = {}
	module.attributes.spellName.values = {}
	module.attributes.buffListTarget.values = {}
	module.attributes.debuffListTarget.values = {}
	--[[
	for spellId, spellData in pairs(SkuDB.SpellDataTBC) do
		local spellName = spellData[Sku.Loc][SkuDB.spellKeys["name_lang"]]
	--[[
		module.attributes.spellId.values[#module.attributes.spellId.values + 1] = "spell:"..tostring(spellId)
		module.values["spell:"..tostring(spellId)] = {friendlyName = spellId.." ("..spellName..")",}
		if not module.values["spell:"..tostring(spellName)] then
			module.attributes.spellNameOnCd.values[#module.attributes.spellName.values + 1] = "spell:"..tostring(spellName)
			module.attributes.spellName.values[#module.attributes.spellName.values + 1] = "spell:"..tostring(spellName)
			module.attributes.buffListTarget.values[#module.attributes.buffListTarget.values + 1] = "spell:"..tostring(spellName)
			module.attributes.debuffListTarget.values[#module.attributes.debuffListTarget.values + 1] = "spell:"..tostring(spellName)
			module.values["spell:"..tostring(spellName)] = {friendlyName = spellName,}
		end
	end
	]]
	module.attributes.buffListPlayer.values = module.attributes.buffListTarget.values
	module.attributes.debuffListPlayer.values = module.attributes.debuffListTarget.values
	
	if not tItemHook then
		hooksecurefunc("UseContainerItem", function(aBagID, aSlot, aTarget, aReagentBankAccessible) 
			dprint("UseContainerItem", aBagID, aSlot, aTarget, aReagentBankAccessible) 
			local icon, itemCount, locked, quality, readable, lootable, itemLink, isFiltered, noValue, itemID, isBound = GetContainerItemInfo(aBagID, aSlot)
			if itemID then	
				local aEventData =  {
					GetTime(),
					"ITEM_USE",
					nil,
					UnitGUID("player"),
					UnitName("player"),
					nil,
					nil,
					nil,
					nil,
					nil,
					nil,
					nil,
					nil,
					nil,
				}
				aEventData[40] = itemID
				module:COMBAT_LOG_EVENT_UNFILTERED("customCLEU", aEventData)
			end
		end)
		hooksecurefunc("UseAction", function(aSlot, aCheckCursor, aOnSelf) 
			local actionType, id, subType = GetActionInfo(aSlot)
			--dprint("to implement UseAction", aSlot, aCheckCursor, aOnSelf, actionType, id, subType) 
			if actionType == "item" then
				local aEventData =  {
					GetTime(),
					"ITEM_USE",
					nil,
					UnitGUID("player"),
					UnitName("player"),
					nil,
					nil,
					nil,
					nil,
					nil,
					nil,
					nil,
					nil,
					nil,
				}
				aEventData[40] = id
				module:COMBAT_LOG_EVENT_UNFILTERED("customCLEU", aEventData)
			end
		end)
		hooksecurefunc("RunMacro", function(aMacroIdOrName) 
			--dprint("to implement RunMacro", aMacroIdOrName) 





		end)
		hooksecurefunc("RunMacroText", function(aMacroText) 
			--dprint("to implement RunMacroText", aMacroText) 




		end)
		
		tItemHook = true
	end

	--add existing auras to attributes list
	module:UpdateAttributesListWithCurrentAuras()
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:UpdateAttributesListWithCurrentAuras()
	for tName, tData in pairs(module.attributes) do
		if string.find(tName, "skuAura") then
			module.attributes[tName] = nil
		end
	end

	for tName, tData in pairs(Sku2.db.char.auras.Auras) do
		if tData.customName == true then
			local tBaseName = module:GetBaseAuraName(tName)
			if not module.attributes["skuAura"..tBaseName] then
				--print("INSERT", tBaseName)
				module.attributes["skuAura"..tBaseName] = {
					tooltip = "sku aura "..tBaseName,
					friendlyName = "sku aura "..tBaseName,
					type = "BINARY",
					evaluate = function(self, aEventData, aOperator, aValue, aRawData)
						local tResult = module:EvaluateAllAuras(aRawData, tName)
						local tEvaluation = module.Operators[aOperator].func(tResult, module:RemoveTags(aValue))
						if tEvaluation == true then
							--print("tEvaluation", true)
							return true
						end
						return false
					end,
					values = {
						"true",
						"false",
					},    
				}
			end
		end
	end
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:AuraUsedInOtherAuras(aAuraName)
	local tBaseName = "skuAura"..module:GetBaseAuraName(aAuraName)
	for tName, tData in pairs (Sku2.db.char.auras.Auras) do
		if tName ~= aAuraName then
			for tAttName, tAttData in pairs(tData.attributes) do
				if tAttName == tBaseName then
					return true
				end
			end
		end
	end
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:AuraHasOtherAuras(aAuraName)
	--print("AuraHasOtherAuras", aAuraName)
	if not Sku2.db.char.auras.Auras[aAuraName] then
		return
	end
	for tAttName, tAttData in pairs(Sku2.db.char.auras.Auras[aAuraName].attributes) do
		if string.find(tAttName, "skuAura") ~= nil then
			return true
		end
	end
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:UpdateAttributesWithUpdatedAuraName(aOldAuraName, aNewAuraName)
	local aOldAuraNameBaseName = "skuAura"..module:GetBaseAuraName(aOldAuraName)
	local aNewAuraNameBaseName = "skuAura"..module:GetBaseAuraName(aNewAuraName)

	for tName, tData in pairs (Sku2.db.char.auras.Auras) do
		local tUpdated
		if tData.attributes[aOldAuraNameBaseName] ~= nil then
			local tExistingData = tData.attributes[aOldAuraNameBaseName]
			tData.attributes[aOldAuraNameBaseName] = nil
			tData.attributes[aNewAuraNameBaseName] = tExistingData
			tUpdated = true
		end

		if tUpdated == true and tData.customName ~= true then
			module:UpdateAttributesListWithCurrentAuras()
			local tAutoName = module:BuildAuraName(tData.type, tData.attributes, tData.actions, tData.outputs)
			if tAutoName ~= tName then
				Sku2.db.char.auras.Auras[tAutoName] = TableCopy(Sku2.db.char.auras.Auras[tName], true)
				Sku2.db.char.auras.Auras[tAutoName].customName = nil
				Sku2.db.char.auras.Auras[tName] = nil
				module:UpdateAttributesWithUpdatedAuraName(tName, tAutoName)
			end
		end

	end
	module:UpdateAttributesListWithCurrentAuras()
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:SPELL_COOLDOWN_START(aEventData)
	if aEventData[CleuBase.sourceName] == UnitName("player") then
		if aEventData[CleuBase.subevent] == "SPELL_CAST_SUCCESS" then
			if aEventData[CleuBase.spellId] then
				local start, duration, enabled, modRate = GetSpellCooldown(aEventData[CleuBase.spellId])
				if not start or start == 0 then
					return
				end

				for x = 15, 100 do
					aEventData[x] = nil
				end

				if module.SpellCDRepo[aEventData[CleuBase.spellId]] then
					module:SPELL_COOLDOWN_END(module.SpellCDRepo[aEventData[CleuBase.spellId]].eventData)
				end

				aEventData[CleuBase.subevent] = "SPELL_COOLDOWN_START"
				module.SpellCDRepo[aEventData[CleuBase.spellId]] = {
					sourceName = aEventData[CleuBase.sourceName], 
					spellId = aEventData[CleuBase.spellId], 
					spellname = aEventData[CleuBase.spellName], 
					start = start, 
					duration = duration, 
					enabled = enabled, 
					modRate = modRate,
					eventData = aEventData,
				}

				if aEventData[CleuBase.spellName] then
					module.thingsNamesOnCd["spell:"..aEventData[CleuBase.spellName]] = "spell:"..aEventData[CleuBase.spellName]
				end
			end
		end
	end
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:UNIT_TICKER(aUnitId)
	local tUnitId = aUnitId

	if tUnitId and UnitHealthMax(tUnitId) > 0 then
		local tHealth
		if UnitHealthMax(tUnitId) and UnitHealthMax(tUnitId) > 0 then
			tHealth = mfloor(UnitHealth(tUnitId) / (UnitHealthMax(tUnitId) / 100))
		end
		local tPower
		if UnitPowerMax(tUnitId) and UnitPowerMax(tUnitId) > 0 then
			tPower = mfloor(UnitPower(tUnitId) / (UnitPowerMax(tUnitId) / 100))
		end

		if not module.UnitRepo[tUnitId] then
			module.UnitRepo[tUnitId] = {unitPower = 0, unitHealth = 0, unitTargetName = nil}
			module.UnitRepo[tUnitId].unitHealth = tHealth
			module.UnitRepo[tUnitId].unitPower = tPower
		end

		local unitTargetGUID = UnitGUID(tUnitId.."target")
		if module.UnitRepo[tUnitId].unitTargetName ~= unitTargetGUID then
			module.UnitRepo[tUnitId].unitTargetName = unitTargetGUID

			if UnitName(tUnitId.."target") then
				local tEventData = {
					GetTime(),
					"UNIT_TARGETCHANGE",
					nil,
					UnitGUID(tUnitId),
					UnitName(tUnitId),
					nil,
					nil,
					unitTargetGUID,
					UnitName(tUnitId.."target"),
					nil,
					nil,
					nil,
					nil,
					nil,
				}
				module:COMBAT_LOG_EVENT_UNFILTERED("customCLEU", tEventData)
			end
		end



		if module.UnitRepo[tUnitId].unitHealth ~= tHealth then
			module.UnitRepo[tUnitId].unitHealth = tHealth
			local tEventData = {
				GetTime(),
				"UNIT_HEALTH",
				nil,
				UnitGUID(tUnitId),
				UnitName(tUnitId),
				nil,
				nil,
				UnitGUID(tUnitId),
				UnitName(tUnitId),
				nil,
				nil,
				nil,
				nil,
				nil,
			}
			tEventData[35] = module.UnitRepo[tUnitId].unitHealth
			module:COMBAT_LOG_EVENT_UNFILTERED("customCLEU", tEventData)
		end
		if UnitPowerMax(tUnitId) > 0 then
			if module.UnitRepo[tUnitId].unitPower ~= tPower then
				module.UnitRepo[tUnitId].unitPower = tPower
				local tEventData = {
					GetTime(),
					"UNIT_POWER",
					nil,
					UnitGUID(tUnitId),
					UnitName(tUnitId),
					nil,
					nil,
					UnitGUID(tUnitId),
					UnitName(tUnitId),
					nil,
					nil,
					nil,
					nil,
					nil,
					nil,
				}
				tEventData[36] = module.UnitRepo[tUnitId].unitPower
				module:COMBAT_LOG_EVENT_UNFILTERED("customCLEU", tEventData)		
			end
		end

		if tUnitId == "player" then
			if module.UnitRepo[tUnitId].unitCombo ~= GetComboPoints("player", "target") then
				module.UnitRepo[tUnitId].unitCombo = GetComboPoints("player", "target") or 0
				local tEventData = {
					GetTime(),
					"UNIT_POWER",
					nil,
					UnitGUID(tUnitId),
					UnitName(tUnitId),
					nil,
					nil,
					UnitGUID(tUnitId),
					UnitName(tUnitId),
					nil,
					nil,
					nil,
					nil,
					nil,
					nil,
				}
				tEventData[51] = module.UnitRepo[tUnitId].unitCombo
				module:COMBAT_LOG_EVENT_UNFILTERED("customCLEU", tEventData)		
			end
		end			
	end
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:COOLDOWN_TICKER()
	for spellId, cooldownData in pairs(module.SpellCDRepo) do
		local start, duration, enabled, modRate = GetSpellCooldown(spellId)
		if start == 0 or ((GetTime() - cooldownData.start) >= cooldownData.duration) then
			cooldownData.subevent = "SPELL_COOLDOWN_END"
			module:SPELL_COOLDOWN_END(cooldownData.eventData)
			module.SpellCDRepo[spellId] = nil
		end
	end

	for itemId, cooldownData in pairs(module.ItemCDRepo) do
		if GetItemCooldownLeft(cooldownData.start, cooldownData.duration) <= 0 then
			cooldownData.subevent = "ITEM_COOLDOWN_END"
			module:ITEM_COOLDOWN_END(cooldownData.eventData)
			module.ItemCDRepo[itemId] = nil
		end
	end
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:SPELL_COOLDOWN_END(aEventData)
	--dprint("SPELL_COOLDOWN_END", aEventData[CleuBase.subevent], aEventData[13])
	aEventData[CleuBase.subevent] = "SPELL_COOLDOWN_END"
	aEventData[CleuBase.timestamp] = GetTime()
	module.thingsNamesOnCd["spell:"..aEventData[13]] = nil
	module:COMBAT_LOG_EVENT_UNFILTERED("customCLEU", aEventData)
end

---------------------------------------------------------------------------------------------------------------------------------------
local tAddFunc = function(itemID, startTime, duration, isEnabled, event)
	local tCdTimeLeft = GetItemCooldownLeft(startTime, duration)
	if tCdTimeLeft > 1.5 then
		module.ItemCDRepo[itemID] = {
			subevent = "ITEM_COOLDOWN_START",
			sourceName = UnitName("player"), 
			itemId = itemID, 
			start = startTime, 
			duration = duration, 
			enabled = isEnabled, 
			eventData =  {
				GetTime(),
				event,
				nil,
				UnitGUID("player"),
				UnitName("player"),
				nil,
				nil,
				nil,
				nil,
				nil,
				nil,
				nil,
				nil,
				nil,
			},
		}
		module.ItemCDRepo[itemID].eventData[40] = itemID
	end
end

function prototype:BAG_UPDATE_COOLDOWN(aEventName, a, b, c, d)
	for bagId = 0, 4 do
		local tNumberOfSlots = GetContainerNumSlots(bagId)
		for slotId = 1, tNumberOfSlots do
			local icon, itemCount, locked, quality, readable, lootable, itemLink, isFiltered, noValue, itemID, isBound = GetContainerItemInfo(bagId, slotId)
			if itemID then
				local startTime, duration, isEnabled = GetContainerItemCooldown(bagId, slotId)
				tAddFunc(itemID, startTime, duration, isEnabled, "ITEM_COOLDOWN_START")
			end
		end
	end

	for _, slotId in pairs(Enum.InventoryType) do
		local itemID = GetInventoryItemID("player", slotId)
		if itemID then
			local startTime, duration, isEnabled = GetInventoryItemCooldown("player", slotId)
			tAddFunc(itemID, startTime, duration, isEnabled, "ITEM_COOLDOWN_START")
		end
	end
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:UNIT_INVENTORY_CHANGED(aEventName, a, b, c, d)
	--dprint("UNIT_INVENTORY_CHANGED", aEventName, a, b, c, d)
	for bagId = 0, 4 do
		local tNumberOfSlots = GetContainerNumSlots(bagId)
		for slotId = 1, tNumberOfSlots do
			local icon, itemCount, locked, quality, readable, lootable, itemLink, isFiltered, noValue, itemID, isBound = GetContainerItemInfo(bagId, slotId)
			if itemID then
				local startTime, duration, isEnabled = GetContainerItemCooldown(bagId, slotId)
				if not module.ItemCDRepo[itemId] then
					tAddFunc(itemID, startTime, duration, isEnabled, "ITEM_COOLDOWN_START")
				end
			end
		end
	end

	for _, slotId in pairs(Enum.InventoryType) do
		local itemID = GetInventoryItemID("player", slotId)
		if itemID then
			local startTime, duration, isEnabled = GetInventoryItemCooldown("player", slotId)
			if not module.ItemCDRepo[itemId] then
				tAddFunc(itemID, startTime, duration, isEnabled, "ITEM_COOLDOWN_START")
			end
		end
	end
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:ITEM_COOLDOWN_END(aEventData)
	--dprint("ITEM_COOLDOWN_END")
	aEventData[CleuBase.subevent] = "ITEM_COOLDOWN_END"
	aEventData[CleuBase.timestamp] = GetTime()
	module:COMBAT_LOG_EVENT_UNFILTERED("customCLEU", aEventData)
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:COMBAT_LOG_EVENT_UNFILTERED(aEventName, aCustomEventData)
	local tEventData = aCustomEventData or {CombatLogGetCurrentEventInfo()}
	--print("COMBAT_LOG_EVENT_UNFILTERED", tEventData[CleuBase.subevent])
	--module:LogRecorder(aEventName, tEventData)

	module:RoleChecker(aEventName, tEventData)

	if tEventData[CleuBase.subevent] == "UNIT_DIED" then
		SkuDispatcher:TriggerSkuEvent("SKU_UNIT_DIED", tEventData[8], tEventData[9])
	end

	if tEventData[CleuBase.subevent] == "SPELL_CAST_START" then
		SkuDispatcher:TriggerSkuEvent("SKU_SPELL_CAST_START", tEventData)
	end


	if tEventData[CleuBase.subevent] == "SPELL_CAST_SUCCESS" then
		C_Timer.After(0.1, function()
			module:SPELL_COOLDOWN_START(tEventData)
			module:EvaluateAllAuras(tEventData)
		end)
	else
		module:EvaluateAllAuras(tEventData)
	end
end

---------------------------------------------------------------------------------------------------------------------------------------
local CombatLogFilterAttackable =  bit.bor(
	COMBATLOG_FILTER_HOSTILE_UNITS,
	COMBATLOG_FILTER_HOSTILE_PLAYERS,
	COMBATLOG_FILTER_NEUTRAL_UNITS
)
function prototype:EvaluateAllAuras(tEventData, tSpecificAuraToTestIndex)
	local beginTime = debugprofilestop()

	if not Sku2.db.char.auras.Auras then
		Sku2.db.char.auras.Auras = {}
	end

	local tRawEventData = tEventData

	--build non event related data to evaluate
	local tSourceUnitID = module:GetBestUnitId(tEventData[CleuBase.sourceGUID])
	local tDestinationUnitID = module:GetBestUnitId(tEventData[CleuBase.destGUID])
	
	local tDestinationUnitIDCannAttack
	if tDestinationUnitID and tDestinationUnitID[1] then
		if tDestinationUnitID ~= "party0" then
			tDestinationUnitIDCannAttack = UnitCanAttack("player", tDestinationUnitID[1])
		end
	elseif tEventData[CleuBase.destFlags] then
		tDestinationUnitIDCannAttack = CombatLog_Object_IsA(tEventData[CleuBase.destFlags], CombatLogFilterAttackable)
	end

	local tTargetTargetUnitId = {}
	if UnitName("playertargettarget") then
		tTargetTargetUnitId = module:GetBestUnitId(UnitGUID("playertargettarget"))
	end

	local tSourceUnitIDCannAttack
	if tSourceUnitID and tSourceUnitID[1] then
		if tSourceUnitID ~= "party0" then
			tSourceUnitIDCannAttack = UnitCanAttack("player", tSourceUnitID[1])
		end
	elseif tEventData[CleuBase.sourceFlags] then
		tSourceUnitIDCannAttack = CombatLog_Object_IsA(tEventData[CleuBase.sourceFlags], CombatLogFilterAttackable)
	end

	local function getAuraList(unit, filter, durationForAuraName)
		filter = filter or "HELPFUL|HARMFUL"
		local tBuffList = {}
		for x = 1, 40  do
			local name, icon, count, dispelType, duration, expirationTime = UnitAura(unit, x, filter)
			if name then
				if durationForAuraName then
					if name == durationForAuraName then
						return (expirationTime or GetTime()) - GetTime()
					end
				end
				tBuffList[name] = name
			end
		end

		--add weapon enchants
		
		if unit == "player" and filter == "HELPFUL" then
		--[[ tmp removed until SkuDB is availab
		
		
		
		
		
		
		
		
		]]
		end

		if not durationForAuraName then
			return tBuffList
		end
	end

	local subevent = tEventData[CleuBase.subevent]

	--build event related data to evaluate
	local tEvaluateData = {
		sourceUnitId = tSourceUnitID,
		sourceName = tEventData[CleuBase.sourceName],
		destUnitId = tDestinationUnitID,
		targetTargetUnitId = tTargetTargetUnitId,
		destName = tEventData[CleuBase.destName],
		event = subevent,
		spellId = tEventData[CleuBase.spellId],
		spellName = tEventData[CleuBase.spellName],
		unitHealthPlayer = mfloor(UnitHealth("player") / (UnitHealthMax("player") / 100)),
		unitPowerPlayer = mfloor(UnitPower("player") / (UnitPowerMax("player") / 100)),
		unitComboPlayer = tEventData[51],
		unitHealthTarget = UnitName("target") and mfloor(UnitHealth("target") / (UnitHealthMax("target") / 100)),
		unitHealthOrPowerUpdate = tEventData[35] or tEventData[36],
		buffListTarget = getAuraList("target", "HELPFUL"),
		debuffListTarget = getAuraList("target", "HARMFUL"),
		buffListPlayer = getAuraList("player", "HELPFUL"),
		debuffListPlayer = getAuraList("player", "HARMFUL"),
		tSourceUnitIDCannAttack = tSourceUnitIDCannAttack,
		tDestinationUnitIDCannAttack = tDestinationUnitIDCannAttack,
		targetCanAttack = UnitCanAttack("player", "target"),
		--tInCombat = SkuCore.inCombat,
		tInCombat = false,
		pressedKey = tEventData[50],
		spellNameOnCd = module.thingsNamesOnCd,
		spellNameUsable = module:GetSpellNamesUsable(),
	}		
	if UnitPowerMax("target") > 0 then
		tEvaluateData.unitPowerTarget = UnitName("target") and mfloor(UnitPower("target") / (UnitPowerMax("target") / 100))
	end	
	tEvaluateData.spellId = tEventData[CleuBase.spellId]
	tEvaluateData.spellName = tEventData[CleuBase.spellName]

	if UnitName("target") then
   	--local tMaxRange, tMinRange = SkuOptions.RangeCheck:GetRange("target")
		local tMaxRange, tMinRange = 0, 0
		if tMinRange then
			tEvaluateData.targetUnitDistance = tMinRange
		end
	end

	if sfind(subevent, "_AURA_") then
		tEvaluateData.auraType = tEventData[15]
		tEvaluateData.auraAmount = tEventData[16]
	end
	if sfind(subevent, "_MISSED") then
		tEvaluateData.missType = tEventData[12]
	elseif subevent == "SWING_DAMAGE" then
		tEvaluateData.critical = tEventData[18]
		tEvaluateData.damageAmount = tEventData[12]
	elseif smatch(subevent, "_DAMAGE$") then
		tEvaluateData.critical = tEventData[21]
		tEvaluateData.damageAmount = tEventData[15]
	elseif smatch(subevent, "_HEAL$") then
		tEvaluateData.critical = tEventData[18]
		tEvaluateData.healAmount = tEventData[15]
		tEvaluateData.overhealingAmount = tEventData[16]
		if tEvaluateData.healAmount and tEvaluateData.overhealingAmount then
			tEvaluateData.overhealingPercentage = mfloor((tEvaluateData.overhealingAmount / tEvaluateData.healAmount) * 100)
		end
	end

	tEvaluateData.itemId = tEventData[40]
	if tEventData[40] then
		--tEvaluateData.itemName = SkuDB.itemLookup[Sku.Loc][tEventData[40]]
		for bagId = 0, 4 do
			local tNumberOfSlots = GetContainerNumSlots(bagId)
			for slotId = 1, tNumberOfSlots do
				local icon, itemCount, locked, quality, readable, lootable, itemLink, isFiltered, noValue, itemID, isBound = GetContainerItemInfo(bagId, slotId)
				if itemCount then
					if itemID == tEvaluateData.itemId then
						if not tEvaluateData.itemCount then
							tEvaluateData.itemCount = itemCount - 1
						else
							tEvaluateData.itemCount = tEvaluateData.itemCount + itemCount
						end
					end
				end
			end
		end					
	end

	if tEventData[CleuBase.subevent] == "UNIT_DESTROYED" then
		tEvaluateData.spellName = tEventData[9]
	end

	tEvaluateData.class = nil

	local toBuffListTarget = tEvaluateData.buffListTarget
	local toDebuffListTarget = tEvaluateData.debuffListTarget
	local toSpellNameOnCd = tEvaluateData.spellNameOnCd

	--evaluate all auras
	local tFirst = true
	for tAuraName, tAuraData in pairs(Sku2.db.char.auras.Auras) do
		if tSpecificAuraToTestIndex == nil or (tSpecificAuraToTestIndex ~= nil and tSpecificAuraToTestIndex == tAuraName) then
			if tAuraData.enabled == true then
				tEvaluateData.buffListTarget = toBuffListTarget
				tEvaluateData.debuffListTarget = toDebuffListTarget
				tEvaluateData.spellNameOnCd = toSpellNameOnCd

				local tOverallResult = true
				local tHasApplicableAttributes = false

				local tSingleBuffListTargetValue
				local tSingleDebuffListTargetValue

				local tHasCountCondition_NumConditions = 0
				local tHasCountCondition_NumCountConditions = 0
				local tHasCountCondition_NumCountConditionsTrue = 0
				local tHasCountCondition_NumConditionsWoCountIsTrue = 0

				--add tEvaluateData for durations of buff/debuff list conditions
				local tAtts = {
					buffListPlayer = {"player", "HELPFUL"},
					debuffListPlayer = {"player", "HARMFUL"},
					buffListTarget = {"target", "HELPFUL"},
					debuffListTarget = {"target", "HARMFUL"},
				}
				for tAttsI, tAttsV in pairs(tAtts) do
					if tAuraData.attributes[tAttsI] and tAuraData.attributes[tAttsI.."Duration"] then
						local tduration = getAuraList(tAttsV[1], tAttsV[2], tEvaluateData[tAttsI][module:RemoveTags(tAuraData.attributes[tAttsI][1][2])])
						if tduration then
							tEvaluateData[tAttsI.."Duration"] = tduration
						end
					end
				end
				
				--evaluate all attributes
				for tAttributeName, tAttributeValue in pairs(tAuraData.attributes) do
					if tAttributeValue[1][1] == "bigger" or tAttributeValue[1][1] == "smaller" then
						tHasCountCondition_NumCountConditions = tHasCountCondition_NumCountConditions + 1
					end
					tHasCountCondition_NumConditions = tHasCountCondition_NumConditions + 1

					tHasApplicableAttributes = true
					if #tAttributeValue > 1 then
						local tLocalResult = false
						for tInd, tLocalValue in pairs(tAttributeValue) do
							local tResult = module.attributes[tAttributeName]:evaluate(tEvaluateData, tLocalValue[1], tLocalValue[2], tRawEventData)
							if tResult == true then
								tLocalResult = true
								if tAttributeValue[1][1] == "bigger" or tAttributeValue[1][1] == "smaller" then
									tHasCountCondition_NumCountConditionsTrue = tHasCountCondition_NumCountConditionsTrue + 1
								else
									tHasCountCondition_NumConditionsWoCountIsTrue = tHasCountCondition_NumConditionsWoCountIsTrue + 1
								end							
							end
						end
						if tLocalResult ~= true then
							tOverallResult = false
							break
						end
					else
						local tResult = module.attributes[tAttributeName]:evaluate(tEvaluateData, tAttributeValue[1][1], tAttributeValue[1][2], tRawEventData)
						for tInd, tLocalValue in pairs(tAttributeValue) do
							local tResult = module.attributes[tAttributeName]:evaluate(tEvaluateData, tLocalValue[1], tLocalValue[2], tRawEventData)
							if tResult == true then
								tLocalResult = true
								if tAttributeValue[1][1] == "bigger" or tAttributeValue[1][1] == "smaller" then
									tHasCountCondition_NumCountConditionsTrue = tHasCountCondition_NumCountConditionsTrue + 1
								else
									tHasCountCondition_NumConditionsWoCountIsTrue = tHasCountCondition_NumConditionsWoCountIsTrue + 1
								end							
							end
						end

						if tResult ~= true then
							tOverallResult = false
							break
						end
					end

					if tAttributeName == "buffListTarget" then
						tSingleBuffListTargetValue = sgsub(tAttributeValue[1][2], "spell:", "")
					end
					if tAttributeName == "debuffListTarget" then
						tSingleDebuffListTargetValue = sgsub(tAttributeValue[1][2], "spell:", "")
					end
					if tAttributeName == "spellNameOnCd" then
						tSpellNameOnCdValue = sgsub(tAttributeValue[1][2], "spell:", "")
					end
				end				

				--add data for outputs
				tEvaluateData.buffListTarget = tSingleBuffListTargetValue
				tEvaluateData.debuffListTarget = tSingleDebuffListTargetValue
				tEvaluateData.spellNameOnCd = tSpellNameOnCdValue

				--overall result
				if tAuraData.type == "if" then
					if tOverallResult == true and tHasApplicableAttributes == true then
						if ((tAuraData.used ~= true and module.actions[tAuraData.actions[1]].single == true) or module.actions[tAuraData.actions[1]].single ~= true) then
							tAuraData.used = true

							if tSpecificAuraToTestIndex ~= nil then
								return true
							end

							for i, v in pairs(tAuraData.outputs) do
								if module.outputs[sgsub(v, "output:", "")] then
									local tAction = tAuraData.actions[1]
									if tAction ~= "notifyAudioAndChatSingle" then
										if tAction == "notifyAudioSingle" or tAction == "notifyAudioSingleInstant" then
											tAction = "notifyAudio"
										end
										if tAction == "notifyChatSingle" then
											tAction = "notifyChat"
										end

										module.outputs[sgsub(v, "output:", "")].functs[tAction](tAuraName, tEvaluateData, tFirst, module.actions[tAuraData.actions[1]].instant)
									else
										module.outputs[sgsub(v, "output:", "")].functs["notifyAudio"](tAuraName, tEvaluateData, tFirst, module.actions[tAuraData.actions[1]].instant)
										module.outputs[sgsub(v, "output:", "")].functs["notifyChat"](tAuraName, tEvaluateData, tFirst, module.actions[tAuraData.actions[1]].instant)
									end

									tFirst = false
								end
							end
						end
					else
						--set aura to unused
						if tHasCountCondition_NumCountConditions > 0 then --es großer oder kleiner hat 
							if (tHasCountCondition_NumConditionsWoCountIsTrue - tHasCountCondition_NumCountConditionsTrue == tHasCountCondition_NumConditions - tHasCountCondition_NumCountConditions) and ( tHasCountCondition_NumCountConditionsTrue < tHasCountCondition_NumCountConditions) then--alles außer größer oder kleiner = true und größer kleiner = false
								tAuraData.used = false
							end
						else
							tAuraData.used = false
						end

					end		
				else
					if tOverallResult == false and tHasApplicableAttributes == true then
						if ((tAuraData.used ~= true and module.actions[tAuraData.actions[1]].single == true) or module.actions[tAuraData.actions[1]].single ~= true) then					
							--set aura to used
							tAuraData.used = true

							if tSpecificAuraToTestIndex ~= nil then
								return true
							end

							for i, v in pairs(tAuraData.outputs) do
								if module.outputs[sgsub(v, "output:", "")] then
									local tAction = tAuraData.actions[1]
									if tAction ~= "notifyAudioAndChatSingle" then
										if tAction == "notifyAudioSingle" then
											tAction = "notifyAudio"
										end
										if tAction == "notifyChatSingle" then
											tAction = "notifyChat"
										end							
										module.outputs[sgsub(v, "output:", "")].functs[tAction](tAuraName, tEvaluateData, tFirst, module.actions[tAuraData.actions[1]].instant)
									else
										module.outputs[sgsub(v, "output:", "")].functs["notifyAudio"](tAuraName, tEvaluateData, tFirst, module.actions[tAuraData.actions[1]].instant)
										module.outputs[sgsub(v, "output:", "")].functs["notifyChat"](tAuraName, tEvaluateData, tFirst, module.actions[tAuraData.actions[1]].instant)
									end
									
									tFirst = false
								end
							end
						end
					else
						--set aura to unused
						tAuraData.used = false
					end	
				end
			end
		end
	end
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:CreateAura(aType, aAttributes)
	--print("module:CreateAura")
	if not aType or not aAttributes then
		return false
	end

	local tAttributes = {}
	local tActions = {}
	local tOutputs = {}
	for x = 1, #aAttributes do
		if aAttributes[x][2] then
			if aAttributes[x][1] ~= "action" then
				if not tAttributes[aAttributes[x][1]] then
					tAttributes[aAttributes[x][1]] = {}
				end
				tAttributes[aAttributes[x][1]][#tAttributes[aAttributes[x][1]] + 1] = {
					aAttributes[x][3],
					aAttributes[x][2]
				}
			else
				tActions[#tActions + 1] = aAttributes[x][2]
			end
		else
			tOutputs[#tOutputs + 1] = aAttributes[x][1]
		end
	end
	
	--build the name
	local tAuraName = module:BuildAuraName(aType, tAttributes, tActions, tOutputs)

	--add aura
	Sku2.db.char.auras.Auras[tAuraName] = {
		type = aType,
		enabled = true,
		attributes = tAttributes,
		actions = tActions,
		outputs = tOutputs,
		customName = nil,
	}

	return true
end

---------------------------------------------------------------------------------------------------------------------------------------
local tUnitRoles = {}
function prototype:RoleCheckerIsUnitGUIDInPartyOrRaid(aUnitGUID)
	if not aUnitGUID then
		return
	end
	if not UnitInRaid("player") then
		if aUnitGUID == UnitGUID("player") then
			return "player"
		end
		for x = 1, 4 do
			if aUnitGUID == UnitGUID("party"..x) then
				return "party"..x
			end
		end
	end
	if UnitInRaid("player") then
		for x = 1, 25 do
			if aUnitGUID == UnitGUID("raid"..x) then
				return "raid"..x
			end
		end
	end
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:RoleChecker(aEventName, tEventData)
	if aEventName == "COMBAT_LOG_EVENT_UNFILTERED" then
		local tSourceUnitID, tTargetUnitID = module:RoleCheckerIsUnitGUIDInPartyOrRaid(tEventData[4]), module:RoleCheckerIsUnitGUIDInPartyOrRaid(tEventData[8])
		--print("RoleChecker", tSourceUnitID, tTargetUnitID, tEventData[4], tEventData[8])

		if tTargetUnitID then
			--print("  tTargetUnitID", tEventData[8])
			if not tUnitRoles[tEventData[8]] then
				tUnitRoles[tEventData[8]] = {dmg = 0, heal = 0,}
			end
			tUnitRoles[tEventData[8]].maxHealth = UnitHealthMax(tTargetUnitID)
			if tEventData[2] == "SWING_DAMAGE" then
				tUnitRoles[tEventData[8]].dmg = tUnitRoles[tEventData[8]].dmg + tEventData[12]
			elseif tEventData[2] == "RANGE_DAMAGE" then
				tUnitRoles[tEventData[8]].dmg = tUnitRoles[tEventData[8]].dmg + tEventData[12]
			elseif tEventData[2] == "SPELL_DAMAGE" then
				tUnitRoles[tEventData[8]].dmg = tUnitRoles[tEventData[8]].dmg + tEventData[15]
			elseif tEventData[2] == "SPELL_PERIODIC_DAMAGE" then
				tUnitRoles[tEventData[8]].dmg = tUnitRoles[tEventData[8]].dmg + tEventData[15]
			end
		end
		
		if tSourceUnitID then
			--print("  tSourceUnitID", tEventData[4])
			if not tUnitRoles[tEventData[4]] then
				tUnitRoles[tEventData[4]] = {dmg = 0, heal = 0,}
			end
			tUnitRoles[tEventData[4]].maxHealth = UnitHealthMax(tSourceUnitID)			
			if tEventData[2] == "SPELL_HEAL" and tSourceUnitID ~= tTargetUnitID then
				tUnitRoles[tEventData[4]].heal = tUnitRoles[tEventData[4]].heal + tEventData[15]
			elseif tEventData[2] == "SPELL_PERIODIC_HEAL" and tSourceUnitID ~= tTargetUnitID then
				tUnitRoles[tEventData[4]].heal = tUnitRoles[tEventData[4]].heal + tEventData[15]
			end
		end
	end
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:GROUP_FORMED()
	module:RoleCheckerUpdateRoster()
end
function prototype:GROUP_JOINED()
	module:RoleCheckerUpdateRoster()
end
function prototype:UNIT_OTHER_PARTY_CHANGED()
	module:RoleCheckerUpdateRoster()
end
function prototype:GROUP_ROSTER_UPDATE()
	module:RoleCheckerUpdateRoster()
end
function prototype:RoleCheckerUpdateRoster()
	--print("------------RoleCheckerUpdateRoster")
	tUnitRoles = {}
end

function prototype:RoleCheckerGetRoster()
	--[[
	for x = 1, #SkuCore.Monitor.UnitNumbersIndexedRaid do
		local tUnitGUID = UnitGUID(SkuCore.Monitor.UnitNumbersIndexedRaid[x])
		if tUnitGUID then
			local tRoleId, tUnitId = module:RoleCheckerGetUnitRole(tUnitGUID)
			print(x, tRoleId, tUnitId, UnitName(tUnitId))
		end
	end
	]]
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:RoleCheckerResetData()
	module:RoleCheckerUpdateRoster()
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:RoleCheckerGetUnitRole(aUnitGUID)

	if UnitInRaid("player") or UnitInParty("player") then
		for x = 1, MAX_RAID_MEMBERS do
			local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML, combatRole = GetRaidRosterInfo(x) 
			local tUnitGUID = UnitGUID("raid"..x)
			if tUnitGUID and tUnitGUID == aUnitGUID then
				--[[
				for y = 1, #SkuCore.Monitor.UnitNumbersIndexedRaid do
					if SkuCore.Monitor.UnitNumbersIndexedRaid[y] ~= nil and SkuCore.Monitor.UnitNumbersIndexedRaid[y] == "raid"..x then
						if SkuOptions.db.char["SkuCore"].aq[SkuCore.talentSet].raid.health2.roleAssigments[y] ~= 0 then
							return SkuOptions.db.char["SkuCore"].aq[SkuCore.talentSet].raid.health2.roleAssigments[y], "raid"..x
						end
					end
				end
				]]
				if role == "MAINTANK" then
					return 5, "raid"..x
				elseif combatRole == "TANK" then
					return 1, "raid"..x
				elseif combatRole == "HEALER" then
					return 2, "raid"..x
				elseif combatRole == "DAMAGER" then
					return 3, "raid"..x
				end
			end
		end
	end

	if tUnitRoles[aUnitGUID] then
		local tDmgAvg, tHealAvg = 0, 0
		local tGroupMemberCount = 0
		local tUnitID

		--calculate averages and remove non-group units
		local tMaxHealth
		for i, v in pairs(tUnitRoles) do
			local tThisUnitID = module:RoleCheckerIsUnitGUIDInPartyOrRaid(i)
			if not tThisUnitID then
				tUnitRoles[i] = nil
			else
				if aUnitGUID == i then
					tUnitID = tThisUnitID
				end
				tGroupMemberCount = tGroupMemberCount + 1
				tDmgAvg = tDmgAvg + v.dmg
				tHealAvg = tHealAvg + v.heal
				if not tMaxHealth or UnitHealthMax(tThisUnitID) > tMaxHealth then
					tMaxHealth = UnitHealthMax(tThisUnitID)
				end
			end
		end

		if tGroupMemberCount > 0 then
			tDmgAvg = tDmgAvg / tGroupMemberCount
			tHealAvg = tHealAvg / tGroupMemberCount
			if tUnitRoles[aUnitGUID].heal > 0 and (tUnitRoles[aUnitGUID].heal) >= (tHealAvg * 2) then --if the healing done is > the groups average healing done we assume the unit is a healer
				return 2, tUnitID
			elseif tUnitRoles[aUnitGUID].dmg > 0 and (tUnitRoles[aUnitGUID].dmg * (UnitHealthMax(tUnitID) / tMaxHealth)) >= ((tDmgAvg * 1.5)) then --if the damage taken is > the groups average damage taken we assume the unit is a tank
				return 1, tUnitID
			else --if the unit is not a tank or healer it must be dps
				return 3, tUnitID
			end
		end
	end

	--found nothing, must be non-group or no action so far
	return 4, tUnitID
end

--[[
---------------------------------------------------------------------------------------------------------------------------------------
function prototype:LogRecorder(aEventName, aEventData)
	if SkuOptions.db.global[MODULE_NAME].log then
		if SkuOptions.db.global[MODULE_NAME].log.enabled == true then
			SkuOptions.db.global[MODULE_NAME].log.data[#SkuOptions.db.global[MODULE_NAME].log.data + 1] = {event = aEventName, data = aEventData,}
		end
	end
end
]]

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:GetSpellNamesUsable()
	local tResult = {}
	for x = 1, 132 do
		local type, id = GetActionInfo(x)
		if (type == "spell" and id ~= nil) then
			local abilityName = GetSpellInfo(id)
			local tUsable = module:ActionButtonUsable(x)

			if tUsable == true then
				tResult["spell:"..abilityName] = "spell:"..abilityName
			end
		end
	end

	--[[
	for i, v in pairs(tResult) do
		print(i)
	end
	]]

	return tResult
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:ActionButton_UpdateUsable(self, aActionID)
	local isUsable, notEnoughMana = IsUsableAction(aActionID)
	
	if ( isUsable ) then
		return true
	elseif ( notEnoughMana ) then
		return false
	else
		return false
	end
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:ActionButton_CheckColor(self, aActionID)
	if not self then
		return false
	end

	local r, g, b, a = self.icon:GetVertexColor()
	if r < 1 or g < 1 or b < 1 or a < 1 then
		return false
	end

	return true
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:ActionButton_CheckRangeIndicator(self, aActionID)
	local valid = IsActionInRange(aActionID)
	local checksRange = (valid ~= nil)
	local inRange = checksRange and valid

	if (self and self.HotKey:GetText() == RANGE_INDICATOR ) then
		if ( checksRange ) then
			if ( inRange ) then
				return true
			else
				return false
			end
		end
	else
		if ( checksRange and not inRange ) then
			return false
		else
			return true
		end
	end

	return true
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:ActionButton_IsOnCooldown(self, aActionID)
	local start, duration, enable, charges, maxCharges, chargeStart, chargeDuration
	local modRate = 1.0
	local chargeModRate = 1.0

	local type, id = GetActionInfo(aActionID)
	
	if (type == "spell" and id ~= nil) then
		start, duration, enable, modRate = GetSpellCooldown(id)
		charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetSpellCharges(id)
	else
		start, duration, enable, modRate = GetActionCooldown(aActionID)
		charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetActionCharges(aActionID)
	end

	if ( charges and maxCharges and maxCharges > 1 and charges < maxCharges ) then
		return true
	end

	if enable and enable ~= 0 and start > 0 and duration > 0 then
		return true
	end

	return false
end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:ActionButtonUsable(aActionID)
	if not aActionID then
		return false
	end

	local DRUID, WARRIOR, ROGUE, PRIEST, SHAMAN, WARLOCK = 11, 1, 4, 5, 7, 9
	local _, _, tClassId = UnitClass("player")

	local self
	--additional bars
	if aActionID >= 61 and aActionID <= 72 then
		self = _G["MultiBarBottomLeftButton"..aActionID - 60]
	elseif aActionID >= 49 and aActionID <= 60 then
		self = _G["MultiBarBottomRightButton"..aActionID - 48]
	elseif aActionID >= 25 and aActionID <= 36 then
		self = _G["MultiBarRightButton"..aActionID - 24]
	elseif aActionID >= 37 and aActionID <= 48 then
		self = _G["MultiBarLeftButton"..aActionID - 36]

	--action bar page 1
	elseif aActionID >= 1 and aActionID <= 12 and GetActionBarPage() == 1 and 
		(
			((GetShapeshiftFormID() ~= CAT_FORM and GetShapeshiftFormID() ~= 2 and GetShapeshiftFormID() ~= MOONKIN_FORM and GetShapeshiftFormID() ~= BEAR_FORM  and GetShapeshiftFormID() ~= 8 and tClassId == DRUID))
			or
			((GetShapeshiftFormID() ~= 17 and GetShapeshiftFormID() ~= 18 and GetShapeshiftFormID() ~= 19 and tClassId == WARRIOR))
			or
			((GetShapeshiftFormID() ~= 30 and tClassId == ROGUE))
			or
			((GetShapeshiftFormID() ~= 28 and tClassId == PRIEST))
			or GetShapeshiftFormID() == nil
		)
	then
		self = _G["ActionButton"..aActionID]

	--stance bars		
	elseif 	aActionID >= 73 and aActionID <= 84  and GetActionBarPage() ~= 2
		and (
			(GetShapeshiftFormID() == CAT_FORM and tClassId == DRUID)
			or
			(GetShapeshiftFormID() == 17 and tClassId == WARRIOR)
			or
			(GetShapeshiftFormID() == 30 and tClassId == ROGUE)
			or
			(GetShapeshiftFormID() == 28 and tClassId == PRIEST)
		)
	then
		self = _G["ActionButton"..aActionID - 72]
	elseif aActionID >= 85 and aActionID <= 96 and GetActionBarPage() ~= 2
		and (
			(GetShapeshiftFormID() == 2 and tClassId == DRUID)
			or
			(GetShapeshiftFormID() == 18 and tClassId == WARRIOR)
		)
	then
		self = _G["ActionButton"..aActionID - 84]
	elseif aActionID >= 97 and aActionID <= 108 and GetActionBarPage() ~= 2
		and (
			((GetShapeshiftFormID() == BEAR_FORM or GetShapeshiftFormID() == 8) and tClassId == DRUID)
			or
			(GetShapeshiftFormID() == 19 and tClassId == WARRIOR)
		)
	then
		self = _G["ActionButton"..aActionID - 96]
	elseif aActionID >= 109 and aActionID <= 120  and GetActionBarPage() ~= 2
		and (
			((GetShapeshiftFormID() == MOONKIN_FORM) and tClassId == DRUID)
		)
	then
		self = _G["ActionButton"..aActionID - 108]

	--action bar page 2
	elseif aActionID >= 13 and aActionID <= 24 and GetActionBarPage() == 2 then
		self = _G["ActionButton"..aActionID - 12]
	end

	local action = aActionID

	if not ( HasAction(action) ) then
		return false
	end

	local type, id = GetActionInfo(action)

	--[[
		local abilityName = GetSpellInfo(id)
		print("abilityName", abilityName)
		print("IsHarmfulSpell", IsHarmfulSpell(abilityName))
		print("IsHelpfulSpell", IsHelpfulSpell(abilityName))
		print("IsUsableSpell", IsUsableSpell(abilityName))
		print("IsPassiveSpell", IsPassiveSpell(abilityName))
		print("SpellIsSelfBuff", SpellIsSelfBuff(id))
	]]

	if self and self.icon and self.icon:IsDesaturated() == true then
		return false
	end

	if ((type == "spell" or type == "companion") and ZoneAbilityFrame and ZoneAbilityFrame.baseName and not HasZoneAbility()) then
		local name = GetSpellInfo(ZoneAbilityFrame.baseName)
		local abilityName = GetSpellInfo(id)
		if (name == abilityName) then
			return false
		end
	end

	if module:ActionButton_UpdateUsable(self, aActionID) ~= true then
		return false
	end
	if module:ActionButton_IsOnCooldown(self, aActionID) == true then
		return false
	end
	if module:ActionButton_CheckColor(self, aActionID) ~= true then
		return false
	end
	
	if module:ActionButton_CheckRangeIndicator(self, aActionID) ~= true then
		return false
	end

	return true
end