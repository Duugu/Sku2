print("modules\\addon\\settings.lua loading", SDL3)
local moduleName = "addon"
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
}

---------------------------------------------------------------------------------------------------------------------------------------
-- global
prototype.global = {
	transcriptPanel = {
		flavors = {"classic", "era", "sod", "retail"},
		title = "transcriptPanel title",
		desc = "transcriptPanel desc",
		children = {
			enabled = {
				flavors = {"classic", "era", "sod", "retail"},
				order = 1,
				title = "transcriptPanel > enabled title",
				desc = "transcriptPanel > enabled desc",
				type = "toggle",
				defaultValue = {
					default = true,
				},
			},
			hideAfter = {
				flavors = {"classic", "era", "sod", "retail"},
				order = 1,
				title = "transcriptPanel > hideAfter title",
				desc = "transcriptPanel > hideAfter desc",
            type = "range",
            min = 1,
            max = 100,
				defaultValue = {
					default = 10,
				},
			},
      },
   },
}

---------------------------------------------------------------------------------------------------------------------------------------
-- profile
prototype.profile = {
}
