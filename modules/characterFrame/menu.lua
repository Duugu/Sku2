print("modules\\characterFrame\\menu.lua loading", SDL3)
local moduleName = "characterFrame"
local L = Sku2.L

Sku2.modules[moduleName]._prototypes = Sku2.modules[moduleName]._prototypes or {}
Sku2.modules[moduleName]._prototypes.UI = {}
local prototype = Sku2.modules[moduleName]._prototypes.UI

---------------------------------------------------------------------------------------------------------------------------------------
-- module UI
---------------------------------------------------------------------------------------------------------------------------------------
--upvalue to reference the final module inside the function definitions
local module = Sku2.modules[moduleName]

---------------------------------------------------------------------------------------------------------------------------------------
prototype.characterFrameMain = {
	flavors = {"classic", "era", "sod", "retail"},
	title = "Character Panel",
	desc = "Character Panel desc",
   inCombatAvailable = true,
	menuBuilder = {
		default = function(self)
			print("create characterFrameMain default")
         local audioMenu = Sku2.modules.audioMenu

         --equipment
         local tNewMenuEntry = audioMenu:InjectMenuItems(self, {"Equipment"}, audioMenu.genericMenuItem)
         tNewMenuEntry.inCombatAvailable = false
         tNewMenuEntry.buildChildrenFunc = function(self)
            local equipmentSlots = {
               [1] = "CharacterHeadSlot",
               [2] = "CharacterNeckSlot",
               [3] = "CharacterShoulderSlot",
               [4] = "CharacterShirtSlot",
               [5] = "CharacterChestSlot",
               [6] = "CharacterWaistSlot",
               [7] = "CharacterLegsSlot",
               [8] = "CharacterFeetSlot",
               [9] = "CharacterWristSlot",
               [10] = "CharacterHandsSlot",
               [11] = "CharacterFinger0Slot",
               [12] = "CharacterFinger0Slot",
               [13] = "CharacterTrinket0Slot",
               [14] = "CharacterTrinket1Slot",
               [15] = "CharacterBackSlot",
               [16] = "CharacterMainHandSlot",
               [17] = "CharacterSecondaryHandSlot",
            }
            for x = 1, #equipmentSlots do
               local firstLine, fullBody, itemData = Sku2.utility.tooltipHelpers:GetTooltipDataFromItemButton(_G[equipmentSlots[x]])
               firstLine = firstLine or equipmentSlots[x]
               if firstLine then
                  local tNewMenuEntry = audioMenu:InjectMenuItems(self, {firstLine}, audioMenu.genericMenuItem)
                  tNewMenuEntry.inCombatAvailable = false
                  tNewMenuEntry.clickFrame = _G[equipmentSlots[x]]
                  tNewMenuEntry.onEnterCallbackFunc = function(self)

                  end
                  tNewMenuEntry.buildChildrenFunc = audioMenu.uiStruct.defaultItemButtonSubmenu.menuBuilder
               end
            end
         end

         --stats
         local tNewMenuEntry = audioMenu:InjectMenuItems(self, {"Stats"}, audioMenu.genericMenuItem)
         tNewMenuEntry.inCombatAvailable = true
         tNewMenuEntry.buildChildrenFunc = function(self)
         end

         --skills
         local tNewMenuEntry = audioMenu:InjectMenuItems(self, {"Skills"}, audioMenu.genericMenuItem)
         tNewMenuEntry.inCombatAvailable = true
         tNewMenuEntry.buildChildrenFunc = function(self)
         end
      

   

		end,
	},
}