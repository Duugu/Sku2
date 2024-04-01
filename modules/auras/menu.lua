print("modules\\auras\\menu.lua loading", SDL3)
local moduleName = "auras"
local L = Sku2.L

Sku2.modules[moduleName]._prototypes = Sku2.modules[moduleName]._prototypes or {}
Sku2.modules[moduleName]._prototypes.UI = {}
local prototype = Sku2.modules[moduleName]._prototypes.UI

---------------------------------------------------------------------------------------------------------------------------------------
-- module UI
---------------------------------------------------------------------------------------------------------------------------------------
local module = Sku2.modules[moduleName]

---------------------------------------------------------------------------------------------------------------------------------------
-- locals
local slower = string.lower


---------------------------------------------------------------------------------------------------------------------------------------
prototype.aurasEditAura = {
	flavors = {"classic", "era", "sod", "retail"},
	title = "aurasEditAura title",
	desc = "aurasEditAura desc",
	menuBuilder = {
		default = function(self)
			local audioMenu = Sku2.modules.audioMenu

			--name
			local tEntry = audioMenu:InjectMenuItems(self, {"name: "..(self.auraToEdit.name or "name missing")}, audioMenu.genericMenuItem)
			tEntry.buildChildrenFunc = function(self)
				local tEntry = audioMenu:InjectMenuItems(self, {"edit name"}, audioMenu.genericMenuItem)
				tEntry.actionFunc = function(self)
					local tCurrentEntry = self
					Sku2.utility.copyPasteDataHelpers:EditBoxShow(
						self.parent.parent.auraToEdit.name, 
						function(self, aText) --ok script
							tCurrentEntry.parent.parent.auraToEdit.name = aText
							tCurrentEntry = tCurrentEntry.parent:Update(true)
							if tCurrentEntry.name == audioMenu.currentMenuPosition.name then
								tCurrentEntry.parent:OnEnter()
							end
						end,
						false, 
						function(self, aText) --esc script
							tCurrentEntry.parent:OnEnter()
						end
					)
				end
			end

			--existing conditions
			local tGlobalConditionNumber = 1
			for attributeName, data in pairs(self.auraToEdit.attributes) do
				for conditionNumber, conditionData in pairs(data) do
					local tEntry = audioMenu:InjectMenuItems(self, {"condition "..tGlobalConditionNumber..": "..attributeName.." " ..conditionData[1].." "..conditionData[2]}, audioMenu.genericMenuItem)
					tEntry.buildChildrenFunc = function(self)
						local tEntry = audioMenu:InjectMenuItems(self, {"Delete"}, audioMenu.genericMenuItem)
						tEntry.actionFunc = function(self)
							table.remove(self.parent.parent.auraToEdit.attributes[attributeName], conditionNumber)
							if #self.parent.parent.auraToEdit.attributes[attributeName] == 0 then
								self.parent.parent.auraToEdit.attributes[attributeName] = nil
							end
							local tNewSelf = self.parent:Update(true)
							tNewSelf.parent:OnEnter()
						end
					end
					tGlobalConditionNumber = tGlobalConditionNumber + 1
				end
			end

			--add condition
			local tEntry = audioMenu:InjectMenuItems(self, {"add condition"}, audioMenu.genericMenuItem)
			local function getEmptyConditionalDataHelper()
				return {
					attribute = nil,
					operator = nil,
					value = nil,
				}
			end
			local tNewConditionData = getEmptyConditionalDataHelper()
			tEntry.buildChildrenFunc = function(self)
				local tEntry = audioMenu:InjectMenuItems(self, {"attribute: "..(tNewConditionData.attribute or "not selected")}, audioMenu.genericMenuItem)
				tEntry.onBackCallbackFunc = function(self)
					tNewConditionData = getEmptyConditionalDataHelper()
				end
				tEntry.buildChildrenFunc = function(self)
					for attributeName, attributeData in pairs(module.attributes) do
						local tEntry = audioMenu:InjectMenuItems(self, {attributeData.friendlyName}, audioMenu.genericMenuItem)
                  tEntry.onEnterCallbackFunc = function(self)
                  end
                  tEntry.actionFunc = function(self)
							tNewConditionData.attribute = attributeName
							--we're calling Update() with true, because we know the overall parent menu structure won't change. There will be just single menu items updated. That way we are save to call parent:OnEntet() below, to get back to the parent item.
							local tNewSelf = self.parent:Update(true)
							if self.name == audioMenu.currentMenuPosition.name then
								tNewSelf.parent:OnEnter()
							end
                  end
					end
				end

				if tNewConditionData.attribute then
					local tEntry = audioMenu:InjectMenuItems(self, {"operator: "..(tNewConditionData.operator or "not selected")}, audioMenu.genericMenuItem)
					tEntry.onBackCallbackFunc = function(self)
						tNewConditionData = getEmptyConditionalDataHelper()
					end
					tEntry.buildChildrenFunc = function(self)
						local attrType = module.attributes[tNewConditionData.attribute].type or "CATEGORY"
						local operators = module.operatorsForAttributeType[attrType]
						local tSortedList = module:TableSortByIndex(operators)
						for x = 1, #tSortedList do
							local operatorName, operatorData = tSortedList[x], module.Operators[tSortedList[x]]
							local tEntry = audioMenu:InjectMenuItems(self, {operatorData.friendlyName}, audioMenu.genericMenuItem)
							tEntry.onEnterCallbackFunc = function(self)
							end
							tEntry.actionFunc = function(self)
								tNewConditionData.operator = operatorName
								local tNewSelf = self.parent:Update(true)
								if self.name == audioMenu.currentMenuPosition.name then
									tNewSelf.parent:OnEnter()
								end
							end
						end
					end
	
					if tNewConditionData.operator then
						local tEntry = audioMenu:InjectMenuItems(self, {"value: "..(tNewConditionData.value or "not selected")}, audioMenu.genericMenuItem)
						tEntry.onBackCallbackFunc = function(self)
							tNewConditionData = getEmptyConditionalDataHelper()
						end
						tEntry.buildChildrenFunc = function(self)
							local tSortedList = {}
							for k, v in Sku2.utility.tableHelpers:SkuSpairs(module.attributes[tNewConditionData.attribute].values, 
								function(t, a, b) 
									if module.actions[module.attributes[tNewConditionData.attribute].values[b]] then
										return slower(module.actions[module.attributes[tNewConditionData.attribute].values[b]].friendlyName) > slower(module.actions[module.attributes[tNewConditionData.attribute].values[a]].friendlyName)
									else
										return slower(module.values[module.attributes[tNewConditionData.attribute].values[b]].friendlyName) > slower(module.values[module.attributes[tNewConditionData.attribute].values[a]].friendlyName)
									end
								end) 
							do
								tSortedList[#tSortedList+1] = v
							end
							for x = 1, #tSortedList do
								local i, v = tSortedList[x], tSortedList[x]
								local tEntry = audioMenu:InjectMenuItems(self, {module.values[v].friendlyName}, audioMenu.genericMenuItem)
								tEntry.onEnterCallbackFunc = function(self)
								end
								tEntry.actionFunc = function(self)
									tNewConditionData.value = v
									local tNewSelf = self.parent:Update(true)
									if self.name == audioMenu.currentMenuPosition.name then
										tNewSelf.parent:OnEnter()
									end
								end
							end
						end

						if tNewConditionData.value then
							local tEntry = audioMenu:InjectMenuItems(self, {"Add"}, audioMenu.genericMenuItem)
							tEntry.onBackCallbackFunc = function(self)
								tNewConditionData = getEmptyConditionalDataHelper()
							end
							tEntry.actionFunc = function(self)
								if self.parent.parent.auraToEdit.attributes[tNewConditionData.attribute] == nil then
									self.parent.parent.auraToEdit.attributes[tNewConditionData.attribute] = {}
								end
								self.parent.parent.auraToEdit.attributes[tNewConditionData.attribute][#self.parent.parent.auraToEdit.attributes[tNewConditionData.attribute] + 1] = {
									tNewConditionData.operator, -- [1]
									tNewConditionData.value, -- [2]
								}
								local tNewSelf = self.parent:Update(true)
								tNewSelf:OnEnter()
								tNewConditionData = getEmptyConditionalDataHelper()
							end
						end
					end
				end
			end

			--action
			local tEntry = audioMenu:InjectMenuItems(self, {"action: "..(self.auraToEdit.actions[1] or "not selected")}, audioMenu.genericMenuItem)
			tEntry.buildChildrenFunc = function(self)
				for actionName, actionData in pairs(module.actions) do
					local tEntry = audioMenu:InjectMenuItems(self, {actionData.friendlyName}, audioMenu.genericMenuItem)
					tEntry.onEnterCallbackFunc = function(self)
					end
					tEntry.actionFunc = function(self)
						self.parent.parent.auraToEdit.actions[1] = actionName
						--we're calling Update() with true, because we know the overall parent menu structure won't change. There will be just single menu items updated. That way we are save to call parent:OnEntet() below, to get back to the parent item.
						local tNewSelf = self.parent:Update(true)
						if self.name == audioMenu.currentMenuPosition.name then
							tNewSelf.parent:OnEnter()
						end
					end

				end




			end

			--existing outputs
			for outputNumber, outputName in pairs(self.auraToEdit.outputs) do
				local tEntry = audioMenu:InjectMenuItems(self, {"output "..outputNumber..": "..outputName}, audioMenu.genericMenuItem)
				tEntry.buildChildrenFunc = function(self)
					local tEntry = audioMenu:InjectMenuItems(self, {"Delete"}, audioMenu.genericMenuItem)
					tEntry.actionFunc = function(self)
						table.remove(self.parent.parent.auraToEdit.outputs, outputNumber)
						local tNewSelf = self.parent:Update(true)
						tNewSelf.parent:OnEnter()
					end
				end
			end

			--add output
			local tEntry = audioMenu:InjectMenuItems(self, {"add output"}, audioMenu.genericMenuItem)
			tEntry.buildChildrenFunc = function(self)
				local tSortedList = module:TableSortByIndex(module.outputs)
				for x = 1, #tSortedList do
					local outputName, outputData = tSortedList[x], module.outputs[tSortedList[x]]
					local tAttributeEntry = audioMenu:InjectMenuItems(self, {outputData.friendlyName}, audioMenu.genericMenuItem)					
					tAttributeEntry.buildChildrenFunc = function(self)
						local tEntry = audioMenu:InjectMenuItems(self, {"Add"}, audioMenu.genericMenuItem)
						tEntry.actionFunc = function(self)
							self.parent.parent.parent.auraToEdit.outputs[#self.parent.parent.parent.auraToEdit.outputs + 1] = outputName
							local tNewSelf = self.parent.parent:Update(true)
							if self.name == audioMenu.currentMenuPosition.name then
								tNewSelf.parent.parent:OnEnter()
							end
						end
					end
				end
			end
		end,
	},
}

prototype.aurasMainMenu = {
	flavors = {"classic", "era", "sod", "retail"},
	title = "auras title",
	desc = "auras desc",
	menuBuilder = {
		default = function(self)
			local audioMenu = Sku2.modules.audioMenu

			local tEntry = audioMenu:InjectMenuItems(self, {"Neue aura"}, audioMenu.genericMenuItem)
			tEntry.onEnterCallbackFunc = function(self)
				self.auraToEdit = {
					name = "unnamed",
					enabled = false,
					type = "if",
					attributes = {},
					used = false,
					actions = {},
					outputs = {},
					--[[ --test aura
					name = "Wenn;zauber name;ungleich;(DND) Ride Vehicle;und;aura stacks;gleich;100;und;buff/debuff;gleich;buff;dann;audio ausgabe einmal;;und;sound;dang;;und;sound;axe 01;",
					enabled = true,
					type = "if",
					attributes = {
						["spellName"] = {
							{
								"isNot", -- [1]
								"spell:(DND) Ride Vehicle", -- [2]
							}, -- [1]
						},
						["auraAmount"] = {
							{
								"is", -- [1]
								"100", -- [2]
							}, -- [1]
						},
						["auraType"] = {
							{
								"is", -- [1]
								"BUFF", -- [2]
							}, -- [1]
						},
					},
					used = false,
					actions = {
						"notifyAudioSingle", -- [1]
					},
					outputs = {
						"output:sound-error_dang", -- [1]
						"output:sound-axe01", -- [2]
					},
					]]
				}
			end
			tEntry.buildChildrenFunc = Sku2.modules.auras.uiStruct.aurasEditAura.menuBuilder

			local tEntry = audioMenu:InjectMenuItems(self, {"Manage Auras"}, audioMenu.genericMenuItem)
			tEntry.buildChildrenFunc = function(self)
				local tEntry = audioMenu:InjectMenuItems(self, {"Enabled Auras"}, audioMenu.genericMenuItem)



				local tEntry = audioMenu:InjectMenuItems(self, {"Disabled Auras"}, audioMenu.genericMenuItem)



				local tEntry = audioMenu:InjectMenuItems(self, {"All Auras"}, audioMenu.genericMenuItem)



			end
			local tEntry = audioMenu:InjectMenuItems(self, {"Import and Export Auras"}, audioMenu.genericMenuItem)
			tEntry.buildChildrenFunc = function(self)
				local tEntry = audioMenu:InjectMenuItems(self, {"Import"}, audioMenu.genericMenuItem)
				tEntry.buildChildrenFunc = function(self)



				end
				local tEntry = audioMenu:InjectMenuItems(self, {"Export"}, audioMenu.genericMenuItem)



				
			end

			--[[
				Sku2.db.char.auras
				--more menus
				Manage Aura Sets
			]]
		end,
	},
}


prototype.aurasMainMenu1 = {
	flavors = {"classic", "era", "sod", "retail"},
	title = "auras title",
	desc = "auras desc",
	menuBuilder = {
		default = function(self)
			local audioMenu = Sku2.modules.audioMenu

			local tNewMenuEntry = audioMenu:InjectMenuItems(self, {"Neue aura"}, audioMenu.genericMenuItem)
			tNewMenuEntry.buildChildrenFunc = function(self)
				local tNewMenuEntry = audioMenu:InjectMenuItems(self, {"Neue aura"}, audioMenu.genericMenuItem)
				local tNewMenuEntry = audioMenu:InjectMenuItems(self, {"Neue aura"}, audioMenu.genericMenuItem)
				


				--add condition
					--attribute:
					--operator:
					--value:
				--add output
					--type
					--value
				--condition1-x
					--delete
				--output1-x
					--delete

				for i, v in pairs(module.Types) do 
					print("-----------------i, v", i, v, v.friendlyName)
					local tTypeItem = audioMenu:InjectMenuItems(self, {v.friendlyName}, audioMenu.genericMenuItem)
					tTypeItem.internalName = i
					tTypeItem.isSelect = true
					tTypeItem.collectValuesFrom = self
					tTypeItem.usedAttributes = {}
					tTypeItem.elementType = "type"
					tTypeItem.actionFunc = function(self, aValue, aName)
						local tMenuItem = self.collectValuesFrom
						local tFinalAttributes = {}
						while tMenuItem.internalName ~= self.internalName do
							if string.find(tMenuItem.internalName, "output:") then
								table.insert(tFinalAttributes, 1, {tMenuItem.internalName,})
								tMenuItem = tMenuItem.parent
							else
								table.insert(tFinalAttributes, 1, {tMenuItem.parent.parent.internalName, tMenuItem.internalName, tMenuItem.parent.internalName, })
								tMenuItem = tMenuItem.parent.parent.parent
							end
						end

						if module:CreateAura(self.internalName, tFinalAttributes) == true then
							--SkuOptions.Voice:OutputStringBTtts("Aura erstellt", false, true, 0.1, true)

							module:UpdateAttributesListWithCurrentAuras()
						else
							--SkuOptions.Voice:OutputStringBTtts("Aura nicht erstellt", false, true, 0.1, true)
						end
											
					end
					tTypeItem.onEnterCallbackFunc = function(self, aValue, aName)
						print("onEnterCallbackFunc", self, aValue, aName)
						self.collectValuesFrom = self
						self.usedAttributes = {}
						self.buildChildrenFunc = module:NewAuraAttributeBuilder(self)
						module:BuildAuraTooltip(self)
					end
					tTypeItem.buildChildrenFunc = function(self)
						--dprint("generic build content of", self.name, "this should not happen")
					end
				end		
			end
			local tNewMenuEntry = audioMenu:InjectMenuItems(self, {"Auren verwalten"}, audioMenu.genericMenuItem)
			tNewMenuEntry.isSelect = true
			tNewMenuEntry.actionFunc = function(self, aValue, aName)
				--print("OnAction Auren verwalten", aValue, aName, self.targetAuraName)
				if not self.targetAuraName then return end
				if not Sku2.db.char.auras.Auras[self.targetAuraName] then return end
				if aName == "Deaktivieren" or aName == "Aktivieren" then
					if Sku2.db.char.auras.Auras[self.targetAuraName].enabled == true then
						Sku2.db.char.auras.Auras[self.targetAuraName].enabled = false
						--SkuOptions.Voice:OutputStringBTtts("deaktiviert", false, true, 0.1, true)
					else
						Sku2.db.char.auras.Auras[self.targetAuraName].enabled = true
						--SkuOptions.Voice:OutputStringBTtts("aktiviert", false, true, 0.1, true)
					end			
				elseif aName == "Löschen" then
					Sku2.db.char.auras.Auras[self.targetAuraName] = nil
					--SkuOptions.Voice:OutputStringBTtts("gelöscht", false, true, 0.1, true)
				elseif aName == "Exportieren" then				
					module:ExportAuraData({self.targetAuraName})

				elseif aName == "Set name to auto generated" then		
					local tData = Sku2.db.char.auras.Auras[self.targetAuraName]
					local tAutoName = module:BuildAuraName(tData.type, tData.attributes, tData.actions, tData.outputs)
					if tAutoName ~= self.targetAuraName then
						Sku2.db.char.auras.Auras[tAutoName] = TableCopy(Sku2.db.char.auras.Auras[self.targetAuraName], true)
						Sku2.db.char.auras.Auras[tAutoName].customName = nil
						Sku2.db.char.auras.Auras[self.targetAuraName] = nil










						module:UpdateAttributesWithUpdatedAuraName(tAutoName, tAutoName)














					end

				elseif aName == "Umbenennen" then			
					--[[
					local tCurrentName = self.targetAuraName
					SkuOptions:EditBoxShow(
						"",
						function(self)
							local tNewName = SkuOptionsEditBoxEditBox:GetText()
							if tNewName and tNewName ~= "" then
								if Sku2.db.char.auras.Auras[tNewName] then
									--SkuOptions.Voice:OutputStringBTtts("name already exists", false, false, 0.2, true, nil, nil, 2)
									--SkuOptions.Voice:OutputStringBTtts("Auren verwalten", false, false, 0.2, true, nil, nil, 2)
									PlaySound(88)
									return
								end

								Sku2.db.char.auras.Auras[tNewName] = TableCopy(Sku2.db.char.auras.Auras[tCurrentName], true)
								Sku2.db.char.auras.Auras[tNewName].customName = true
								Sku2.db.char.auras.Auras[tCurrentName] = nil








								module:UpdateAttributesWithUpdatedAuraName(tCurrentName, tNewName)











								PlaySound(88)
								C_Timer.After(0.01, function()
									--SkuOptions.Voice:OutputStringBTtts("Renamed", false, false, 0.2, true, nil, nil, 2)
									--SkuOptions.Voice:OutputStringBTtts("Auren verwalten", false, false, 0.2, true, nil, nil, 2)
								end)
							end
						end,
						nil
					)
					PlaySound(89)
					C_Timer.After(0.1, function()
						--SkuOptions.Voice:OutputStringBTtts("Enter name and press ENTER key", true, true, 1, true)
					end)
			

					]]	
				end

				module:UpdateAttributesListWithCurrentAuras()
			end
			tNewMenuEntry.buildChildrenFunc = function(self)
				local tTypeItem = audioMenu:InjectMenuItems(self, {"Aktivierte"}, audioMenu.genericMenuItem)
				tTypeItem.buildChildrenFunc = function(self)
					local tHasEntries = false
					for i, v in pairs(Sku2.db.char.auras.Auras) do 
						if v.enabled == true then
							tHasEntries = true
							module:BuildManageSubMenu(self, {i})
						end
					end
					if tHasEntries == false then
						local tEmpty = audioMenu:InjectMenuItems(self, {"leer"}, audioMenu.genericMenuItem)
					end
				end
				local tTypeItem = audioMenu:InjectMenuItems(self, {"Deaktivierte"}, audioMenu.genericMenuItem)
				tTypeItem.buildChildrenFunc = function(self)
					local tHasEntries = false
					for i, v in pairs(Sku2.db.char.auras.Auras) do 
						if v.enabled ~= true then
							tHasEntries = true
							module:BuildManageSubMenu(self, {i})
						end
					end
					if tHasEntries == false then
						local tEmpty = audioMenu:InjectMenuItems(self, {"leer"}, audioMenu.genericMenuItem)
					end
				end
				local tTypeItem = audioMenu:InjectMenuItems(self, {"Alle"}, audioMenu.genericMenuItem)
				tTypeItem.buildChildrenFunc = function(self)
					local tHasEntries = false
					for i, v in pairs(Sku2.db.char.auras.Auras) do 
						tHasEntries = true
						module:BuildManageSubMenu(self, {i})
					end
					if tHasEntries == false then
						local tEmpty = audioMenu:InjectMenuItems(self, {"leer"}, audioMenu.genericMenuItem)
					end
				end
			end

			local tdel = audioMenu:InjectMenuItems(self, {"Aura importieren"}, audioMenu.genericMenuItem)
			tdel.isSelect = true
			tdel.actionFunc = function(self, aValue, aName)
				module:ImportAuraData()
				module:UpdateAttributesListWithCurrentAuras()
			end		

			local tdel = audioMenu:InjectMenuItems(self, {"Alle Auren löschen"}, audioMenu.genericMenuItem)
			tdel.isSelect = true
			tdel.actionFunc = function(self, aValue, aName)
				--[[
				Sku2.db.char.auras.Auras = {}
				--SkuOptions.Voice:OutputStringBTtts("Alle auren gelöscht", true, true, 0.1, true)
				module:UpdateAttributesListWithCurrentAuras()
				]]
			end

			local tdel = audioMenu:InjectMenuItems(self, {"Alle Auren exportieren"}, audioMenu.genericMenuItem)
			tdel.isSelect = true
			tdel.actionFunc = function(self, aValue, aName)
				--[[
				local aAuraNamesTable = {}
				for i, v in pairs(SkuOptions.db.char["SkuAuras"].Auras) do 
					table.insert(aAuraNamesTable, i)
				end 
				module:ExportAuraData(aAuraNamesTable)
				]]
			end


			local tTypeItem = audioMenu:InjectMenuItems(self, {"Aura Sets verwalten"}, audioMenu.genericMenuItem)
			tTypeItem.isSelect = true
			tTypeItem.actionFunc = function(self, aValue, aName)
				--[[
				--dprint("OnAction Sets verwalten", self, aValue, aName)
				--dprint(self.selectedSetInternalName)
				if aName == "Übernehmen überschreiben" then
					Sku2.db.char.auras.Auras = {}
					tSetData = SkuAuras.AuraSets[self.selectedSetInternalName]
					for tAuraName, tAuraData in pairs(tSetData.auras) do
						Sku2.db.char.auras.Auras[tAuraData.friendlyNameShort] = tAuraData
					end
					--SkuOptions.Voice:OutputStringBTtts("Set angewendet", false, true, 0.3, true)	
					module:UpdateAttributesListWithCurrentAuras()
				elseif aName == "Übernehmen hinzufügen" then
					tSetData = SkuAuras.AuraSets[self.selectedSetInternalName]
					for tAuraName, tAuraData in pairs(tSetData.auras) do
						Sku2.db.char.auras.Auras[tAuraData.friendlyNameShort] = tAuraData
					end
					--SkuOptions.Voice:OutputStringBTtts("Set hinzugefügt", false, true, 0.3, true)	
					module:UpdateAttributesListWithCurrentAuras()
				elseif aName == "Bearbeiten" then
					--SkuOptions.Voice:OutputStringBTtts("noch nicht implementiert", false, true, 0.1, true)

				elseif aName == "Exportieren" then
					--SkuOptions.Voice:OutputStringBTtts("noch nicht implementiert", false, true, 0.1, true)

				elseif aName == "Löschen" then
					SkuAuras.AuraSets[self.selectedSetInternalName] = nil

				end
				]]
			end
			tTypeItem.buildChildrenFunc = function(self)
				--[[
				local tHasEntries = false
				for tIntName, tData in pairs(SkuAuras.AuraSets) do 
					--dprint(tIntName, tData, tData.friendlyName)
					tHasEntries = true
					local tSet = audioMenu:InjectMenuItems(self, {tData.friendlyName}, audioMenu.genericMenuItem)
					tSet.internalName = tIntName
					tSet.onEnterCallbackFunc = function(self, aValue, aName)
						--dprint(self, aValue, aName)
						self.parent.selectedSetInternalName = self.internalName
						self.textFull = SkuAuras.AuraSets[self.internalName].tooltip
					end
					tSet.buildChildrenFunc = function(self)
						local tNewMenuEntry = audioMenu:InjectMenuItems(self, {"Übernehmen überschreiben"}, audioMenu.genericMenuItem)
						local tNewMenuEntry = audioMenu:InjectMenuItems(self, {"Übernehmen hinzufügen"}, audioMenu.genericMenuItem)
						--local tNewMenuEntry = audioMenu:InjectMenuItems(self, {"Bearbeiten"}, audioMenu.genericMenuItem)
						local tNewMenuEntry = audioMenu:InjectMenuItems(self, {"Exportieren"}, audioMenu.genericMenuItem)
						local tNewMenuEntry = audioMenu:InjectMenuItems(self, {"Löschen"}, audioMenu.genericMenuItem)
					end
				end
				if tHasEntries == false then
					local tEmpty = audioMenu:InjectMenuItems(self, {"leer"}, audioMenu.genericMenuItem)
				end
				]]
			end
			local tTypeItem = audioMenu:InjectMenuItems(self, {"Aura Set importieren"}, audioMenu.genericMenuItem)
			tTypeItem.isSelect = true
			tTypeItem.actionFunc = function(self, aValue, aName)
				--dprint("OnAction Set importieren")
				--SkuOptions.Voice:OutputStringBTtts("noch nicht implementiert", false, true, 0.1, true)
			end
			
		end
	},
}