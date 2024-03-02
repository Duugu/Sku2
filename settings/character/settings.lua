_, Sku2 = ...

local tNode = "characterSettings"
Sku2.settings[tNode] = {
	name = "Character label",
   desc = "Character desc",
	type = "group",
	args = {},
}
skuLoaderParentSettingsTable = Sku2.settings[tNode].args

local tLeaf = "vocalizeMenuNumbers"
skuLoaderParentSettingsTable[tLeaf] = {
   --order = tOrder,
   name = "vocalize MenuNumbers name",
   desc = "vocalize MenuNumbers desc",
   type = "toggle",
}

local tLeaf = "vocalizeSubmenus"
skuLoaderParentSettingsTable[tLeaf] = {
   --order = tOrder,
   name = "vocalize Submenus name",
   desc = "vocalize Submenus desc",
   type = "toggle",
}


