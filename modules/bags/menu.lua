print("modules\\bags\\menu.lua loading", SDL3)
local moduleName = "bags"
local L = Sku2.L

Sku2.modules[moduleName]._prototypes = Sku2.modules[moduleName]._prototypes or {}
Sku2.modules[moduleName]._prototypes.UI = {}
local prototype = Sku2.modules[moduleName]._prototypes.UI

---------------------------------------------------------------------------------------------------------------------------------------
-- module UI
---------------------------------------------------------------------------------------------------------------------------------------
local module = Sku2.modules[moduleName]

---------------------------------------------------------------------------------------------------------------------------------------
prototype.bagsMainMenu = {
	flavors = {"classic", "era", "sod", "retail"},
	title = "bags title",
	desc = "bags desc",
	menuBuilder = {
		default = function(aParent)
			local tNewMenuEntry = Sku2.modules.audioMenu:InjectMenuItems(aParent, {"bags"}, Sku2.modules.audioMenu.genericMenuItem)
			tNewMenuEntry.buildChildrenFunc = function(self)
				for x = 1, 5 do
					local tNewMenuEntry = Sku2.modules.audioMenu:InjectMenuItems(self, {"bag "..x}, Sku2.modules.audioMenu.genericMenuItem)
					tNewMenuEntry.filteringAllowed = false
					tNewMenuEntry.buildChildrenFunc = function(self)
						for y = 1, 28 do
							local tNewMenuEntry = Sku2.modules.audioMenu:InjectMenuItems(self, {"slot "..y}, Sku2.modules.audioMenu.genericMenuItem)
							tNewMenuEntry.filteringAllowed = false
							tNewMenuEntry.onEnterCallbackFunc = function(self)
								print("slot "..y.."  onEnterCallbackFunc")
							end
							--[[
							tNewMenuEntry.actionFunc = function(self)
								print("bag "..x, "slot "..y, "actionFunc", self.name)
								--self:Update()
							end
							]]
						end
					end
				end
			end
		end,
	},
}
