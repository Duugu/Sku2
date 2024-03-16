print("modules\\_sampleModule\\menu.lua loading", SDL3)

local _G = _G
local L = Sku2.L

local this = Sku2.modules._sampleModule

--[[
   module UI
]]
---------------------------------------------------------------------------------------------------------------------------------------
this.UI = {}
this.UI._sampleModuleMenu1 = {
	clients = {"classic", "era", "sod", "retail"},
	title = "sampleModuleMenu1 title",
	desc = "sampleModuleMenu1 desc",
	menu = {
		default = function(aParent)

		end,
		classic = function(aParent)

		end,
	},
}
