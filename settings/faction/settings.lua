print("settings\\faction\\settings.lua loading", SDL3)

local L = Sku2.L

Sku2.settings.args.faction = {
	name = "faction",
	type = "group",
	args = {
		enabled = {
			order = 1,
			name = "faction enabled name",
			desc = "faction enabled desc",
			type = "toggle",
			default = false,
		},
		enabled1 = {
			order = 2,
			name = "faction enabled 1 name",
			desc = "faction enabled 1 desc",
			type = "toggle",
			default = true,
		},
	}
}