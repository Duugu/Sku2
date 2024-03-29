print("modules\\_sampleModule\\menu.lua loading", SDL3)
local moduleName = "_sampleModule"
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
prototype.sampleMenu1 = {
	flavors = {"classic", "era", "sod", "retail"},
	title = "sampleMenu1 title",
	desc = "sampleMenu1 desc",
	menuBuilder = {
		default = function(aParent)
			print("sampleMenu1 default")
		end,
		classic = function(aParent)
			print("sampleMenu1 classic")
		end,
	},
}
