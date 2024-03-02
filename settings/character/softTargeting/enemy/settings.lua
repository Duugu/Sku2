_, Sku2 = ...

local tNode = "enemySettings"
skuLoaderParentSettingsTable[tNode] = {
	name = "enemy Settings label",
   desc = "enemy Settings desc",
	type = "group",
	args = {},
}
skuLoaderParentSettingsTable = skuLoaderParentSettingsTable[tNode].args

local tLeaf = "enabled"
skuLoaderParentSettingsTable[tLeaf] = {
   --order = tOrder,
   name = "enabled name",
   desc = "enabled desc",
   type = "toggle",
}

local tLeaf = "arc"
skuLoaderParentSettingsTable[tLeaf] = {
   --order = tOrder,
   name = "arc name",
   desc = "arc desc",
   type = "toggle",
}
