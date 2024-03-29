print("modules\\openPanels\\menu.lua loading", SDL3)
local moduleName = "openPanels"
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
prototype.openPanelsMain = {
	flavors = {"classic", "era", "sod", "retail"},
	title = "Open Panels",
	desc = "Open Panels desc",
	inCombatAvailable = true,
	menuBuilder = {
		default = function(self)
			module:MenuBuilder(self)
		end,
	}
}