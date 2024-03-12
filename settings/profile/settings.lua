print("settings\\profile\\settings.lua loading", SDL3)

local L = Sku2.L

Sku2.settings.args.profile = {
	name = "profile",
	type = "group",
	args = {
		enabled = {
			order = 1,
			name = "account enabled name",
			desc = "account enabled desc",
			type = "toggle",
			default = true,
		},
		enabled1 = {
			order = 2,
			name = "account enabled 1 name",
			desc = "account enabled 1 desc",
			type = "toggle",
			default = true,
		},
	},
}