print("modules\\auras\\settings.lua loading", SDL3)
local moduleName = "auras"
local L = Sku2.L

Sku2.modules[moduleName]._prototypes = Sku2.modules[moduleName]._prototypes or {}
Sku2.modules[moduleName]._prototypes.settings = {}
local prototype = Sku2.modules[moduleName]._prototypes.settings

---------------------------------------------------------------------------------------------------------------------------------------
-- module settings
---------------------------------------------------------------------------------------------------------------------------------------
local module = Sku2.modules[moduleName]

---------------------------------------------------------------------------------------------------------------------------------------
-- char
prototype.char = {
	enabled = {
		flavors = {"classic", "era", "sod", "retail"},
		order = 1,
		title = "Sku2.modules.auras > char > enabled title",
		desc = "Sku2.modules.auras > char > enabled desc",
		type = "toggle",
		defaultValue = {
			default = true,
		},
		menuBuilder = {
			default = function(aParent)

			end,
		},
	},
	Auras = {
		flavors = {"classic", "era", "sod", "retail"},
		order = 2,
		title = "Sku2.modules.auras > char > Auras title",
		desc = "Sku2.modules.auras > char > Auras desc",
		type = "table",
		defaultValue = {
			default = {},
		},
		menuBuilder = false,
	},	
}

---------------------------------------------------------------------------------------------------------------------------------------
-- global
prototype.global = {
}

---------------------------------------------------------------------------------------------------------------------------------------
-- profile
prototype.profile = {
}
