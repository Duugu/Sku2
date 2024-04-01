print("modules\\audioMenu\\menu.lua loading", SDL3)
local moduleName = "audioMenu"
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
prototype.defaultItemButtonSubmenu = {
	flavors = {"classic", "era", "sod", "retail"},
	title = "defaultItemButtonSubmenu",
	desc = "defaultItemButtonSubmenu desc",
   inCombatAvailable = false,
	menuBuilder = {
		default = function(self)
			print("create defaultItemButtonSubmenu default")
         local audioMenu = Sku2.modules.audioMenu

         --left click
         local tNewMenuEntry = audioMenu:InjectMenuItems(self, {"Left Click"}, audioMenu.genericMenuItem)
         tNewMenuEntry.inCombatAvailable = false
         tNewMenuEntry.onEnterCallbackFunc = function(self)
            Sku2.modules.audioMenu:SetOutOfCombatActionButton(self.parent.clickFrame, "LeftButton", self)
         end            
         tNewMenuEntry.onLeaveCallbackFunc = function(self)
            Sku2.modules.audioMenu:ClearOutOfCombatActionButton()
         end            
         tNewMenuEntry.actionFunc = function(self)
            print("menu Left Click actionFunc", self.name)
            self.parent:Update()
         end

         --right click
         local tNewMenuEntry = audioMenu:InjectMenuItems(self, {"Right Click"}, audioMenu.genericMenuItem)
         tNewMenuEntry.inCombatAvailable = false
         tNewMenuEntry.onEnterCallbackFunc = function(self)
            Sku2.modules.audioMenu:SetOutOfCombatActionButton(self.parent.clickFrame, "RightButton", self)
         end            
         tNewMenuEntry.onLeaveCallbackFunc = function(self)
            Sku2.modules.audioMenu:ClearOutOfCombatActionButton()
         end            
         tNewMenuEntry.actionFunc = function(self)
            print("RightButton actionFunc", self.name)
            --self.parent:Update()
         end

         --socketing



         --add link to chat



         --flag for auto sell



         --destroy



		end,
	},
}
