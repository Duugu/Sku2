print("settings\\profile\\navigation\\settings.lua loading", SDL3)

local L = Sku2.L

Sku2.settings.args.profile.args.navigation = {
	name = "navigation",
	type = "group",
	args = {
		enabled = {
			order = 1,
			name = "naviation enabled name",
			desc = "naviation enabled desc",
			type = "toggle",
			default = true,
		},
		enabled1 = {
			order = 2,
			name = "naviation enabled 1 name",
			desc = "naviation enabled 1 desc",
			type = "toggle",
			default = true,
		},
	}
}