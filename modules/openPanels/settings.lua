print("modules\\openPanels\\settings.lua loading", SDL3)
local moduleName = "openPanels"
local L = Sku2.L

Sku2.modules[moduleName]._prototypes = Sku2.modules[moduleName]._prototypes or {}
Sku2.modules[moduleName]._prototypes.settings = {}
local prototype = Sku2.modules[moduleName]._prototypes.settings

---------------------------------------------------------------------------------------------------------------------------------------
-- module settings
---------------------------------------------------------------------------------------------------------------------------------------
--upvalue to reference the final module inside the function definitions
local module = Sku2.modules[moduleName]

---------------------------------------------------------------------------------------------------------------------------------------
-- char
prototype.char = {
	enabled = {
		flavors = {"classic", "era", "sod", "retail"},
		order = 1,
		title = "Sku2.modules.openPanels > char > enabled title",
		desc = "Sku2.modules.openPanels > char > enabled desc",
		type = "toggle",
		defaultValue = {
			default = true,
		},
	},
}

---------------------------------------------------------------------------------------------------------------------------------------
-- global
prototype.global = {}

---------------------------------------------------------------------------------------------------------------------------------------
-- profile
prototype.profile = {}
