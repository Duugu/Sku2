print("modules\\_sampleModule\\settings.lua loading", SDL3)

local _G = _G
local L = Sku2.L

local this = Sku2.modules._sampleModule

--[[
   module settings
	{
		order
		title
		desc
		type
			boolean
			string
			toggle
			select
			group
		defaultValue
		clients
		menu
			default
			<client>
	}
]]
---------------------------------------------------------------------------------------------------------------------------------------
this.settings = {}

---------------------------------------------------------------------------------------------------------------------------------------
-- char
this.settings.char = {
	enabled = {
		order = 1,
		title = "Sku2.modules._sampleModule > char > enabled title",
		desc = "Sku2.modules._sampleModule > char > enabled desc",
		type = "toggle",
		clients = {"classic", "era", "sod", "retail"},
		defaultValue = {
			default = "defaultValue default for Sku2.modules._sampleModule > char > enabled",
			classic = "defaultValue classic for Sku2.modules._sampleModule > char > enabled",
		},
		menu = {
			default = function(aParent)

			end,
			classic = function(aParent)

			end,
		},
	},
}

---------------------------------------------------------------------------------------------------------------------------------------
-- global
this.settings.global = {

}

---------------------------------------------------------------------------------------------------------------------------------------
-- profile
this.settings.profile = {
	enabled = {
		order = 3,
		title = "Sku2.modules._sampleModule > profile > enabled title",
		desc = "Sku2.modules._sampleModule > profile > enabled desc",
		type = "toggle",
		clients = {"classic", "era", "sod", "retail"},
		defaultValue = {
			default = "defaultValue default for Sku2.modules._sampleModule > profile > enabled",
			classic = "defaultValue classic for Sku2.modules._sampleModule > profile > enabled",
		},
		menu = {
			default = function(aParent)

			end,
			classic = function(aParent)

			end,
		},
	},
	subGroupOne = {
		title = "sub Group One title",
		type = "group",
		clients = {"classic", "era", "sod", "retail"},
		menu = {
			default = function(aParent)

			end,
			classic = function(aParent)

			end,
		},
		children = {
			subGroupOneEnabled = {
				order = 3,
				title = "Sku2.modules._sampleModule > profile > subGroupOneEnabled > enabled title",
				desc = "Sku2.modules._sampleModule > profile > subGroupOneEnabled > enabled desc",
				type = "toggle",
				clients = {"classic", "era", "sod", "retail"},
				defaultValue = {
					default = "defaultValue for default Sku2.modules._sampleModule > profile > subGroupOneEnabled > enabled",
					classic = "defaultValue classic for Sku2.modules._sampleModule > profile > subGroupOneEnabled > enabled",
				},
				menu = {
					default = function(aParent)
	
					end,
					classic = function(aParent)
	
					end,
				},
			},
		},
	},		
}
