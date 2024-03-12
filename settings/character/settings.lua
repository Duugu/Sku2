print("settings\\character\\settings.lua loading", SDL3)

local L = Sku2.L

Sku2.settings.args.char = {
	name = "char",
	type = "group",
	args = {
		enabled = {
			order = 1,
			name = "character enabled name",
			desc = "character enabled desc",
			type = "toggle",
			default = true,
		},
		enabled1 = {
			order = 2,
			name = "character enabled 1 name",
			desc = "character enabled 1 desc",
			type = "toggle",
			default = false,
		},
	}
}