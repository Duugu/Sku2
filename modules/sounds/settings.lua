print("modules\\sounds\\settings.lua loading", SDL3)
local moduleName = "sounds"
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
}

---------------------------------------------------------------------------------------------------------------------------------------
-- global
prototype.global = {
	enabled = {
		flavors = {"classic", "era", "sod", "retail"},
		order = 1,
		title = "Sku2.modules.sounds > char > enabled title",
		desc = "Sku2.modules.sounds > char > enabled desc",
		type = "toggle",
		defaultValue = {
			default = "defaultValue default for Sku2.modules.sounds > global > enabled",
		},
		menuBuilder = false,
	},
}

---------------------------------------------------------------------------------------------------------------------------------------
-- profile
prototype.profile = {
}
