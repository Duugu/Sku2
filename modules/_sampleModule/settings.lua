print("modules\\_sampleModule\\settings.lua loading", SDL3)
local moduleName = "_sampleModule"
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
		title = "Sku2.modules._sampleModule > char > enabled title",
		desc = "Sku2.modules._sampleModule > char > enabled desc",
		type = "toggle",
		defaultValue = {
			default = "defaultValue default for Sku2.modules._sampleModule > char > enabled",
			classic = "defaultValue classic for Sku2.modules._sampleModule > char > enabled",
		},
		--menuBuilder = false,
		menuBuilder = {
			default = function(aParent)

			end,
			classic = function(aParent)

			end,
		},
	},
}

---------------------------------------------------------------------------------------------------------------------------------------
-- global
prototype.global = {
	enabled = {
		flavors = {"classic", "era", "sod", "retail"},
		order = 1,
		title = "Sku2.modules._sampleModule > global > enabled title",
		desc = "Sku2.modules._sampleModule > global > enabled desc",
		type = "toggle",
		defaultValue = {
			default = "defaultValue default for Sku2.modules._sampleModule > global > enabled",
			classic = "defaultValue classic for Sku2.modules._sampleModule > global > enabled",
		},
		--menuBuilder = false,
		menuBuilder = {
			default = function(aParent)

			end,
			classic = function(aParent)

			end,
		},
	},
}

---------------------------------------------------------------------------------------------------------------------------------------
-- profile
prototype.profile = {
	enabled = {
		flavors = {"classic", "era", "sod", "retail"}, --flavors can be omitted > for all flavors
		order = 3,
		title = "Sku2.modules._sampleModule > profile > enabled title",
		desc = "Sku2.modules._sampleModule > profile > enabled desc",
		type = "toggle",
		defaultValue = {
			default = "defaultValue default for Sku2.modules._sampleModule > profile > enabled", --default is required > used of there is no flavor specific value
			classic = "defaultValue classic for Sku2.modules._sampleModule > profile > enabled",
		},
		menuBuilder = { --can be omitted > standard ace-type handler used OR = false to omitt module setting from the menu
			default = function(aParent) --default is required > used of there is no flavor specific value

			end,
			classic = function(aParent)

			end,
		},
	},
	subGroupOne = {
		flavors = {"classic", "era", "sod", "retail"},
		title = "sub Group One title",
		desc = "sub Group One title desc",
		menuBuilder = {
			default = function(aParent)

			end,
			classic = function(aParent)

			end,
		},
		children = {
			subGroupOneEnabled = {
				--flavors = {"classic", "era", "sod", "retail"},
				order = 3,
				title = "Sku2.modules._sampleModule > profile > subGroupOneEnabled > enabled title",
				desc = "Sku2.modules._sampleModule > profile > subGroupOneEnabled > enabled desc",
				type = "toggle",
				defaultValue = {
					default = "defaultValue for default Sku2.modules._sampleModule > profile > subGroupOneEnabled > enabled",
					classic = "defaultValue classic for Sku2.modules._sampleModule > profile > subGroupOneEnabled > enabled",
				},
				menuBuilder = {
					default = function(aParent)
	
					end,
					classic = function(aParent)
	
					end,
				},
			},
			subGroupOneTWO = {
				flavors = {"classic", "era", "sod", "retail"},
				order = 3,
				title = "Sku2.modules._sampleModule > profile > subGroupOneEnabled > subGroupOneTWO title",
				desc = "Sku2.modules._sampleModule > profile > subGroupOneEnabled > subGroupOneTWO desc",
				type = "toggle",
				defaultValue = {
					default = "defaultValue for default Sku2.modules._sampleModule > profile > subGroupOneTWO > enabled",
					classic = "defaultValue classic for Sku2.modules._sampleModule > profile > subGroupOneTWO > enabled",
				},
				menuBuilder = {
					default = function(aParent)
	
					end,
					classic = function(aParent)
	
					end,
				},
			},
			hideAfter = {
				flavors = {"classic", "era", "sod", "retail"},
				order = 1,
				title = "Sku2.modules._sampleModule > hideAfter title",
				desc = "Sku2.modules._sampleModule > hideAfter desc",
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
