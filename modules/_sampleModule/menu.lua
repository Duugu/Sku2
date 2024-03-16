print("modules\\_sampleModule\\menu.lua loading", SDL3)

local _G = _G
local L = Sku2.L

local moduleName = "_sampleModule"
Sku2.modules[moduleName]._prototypes = Sku2.modules[moduleName]._prototypes or {}
Sku2.modules[moduleName]._prototypes.UI = {}
local prototype = Sku2.modules[moduleName]._prototypes.UI
local this = Sku2.modules[moduleName]

---------------------------------------------------------------------------------------------------------------------------------------
-- module UI
---------------------------------------------------------------------------------------------------------------------------------------
prototype.sampleMenu1 = {
	flavors = {"classic", "era", "sod", "retail"},
	title = "sampleMenu1 title",
	desc = "sampleMenu1 desc",
	menu = {
		default = function(aParent)

		end,
		classic = function(aParent)

		end,
	},
}
