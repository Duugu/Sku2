print("modules\\keyBindings\\code.lua loading", SDL3)
local moduleName = "keyBindings"
local L = Sku2.L

Sku2.modules[moduleName]._prototypes = Sku2.modules[moduleName]._prototypes or {}
Sku2.modules[moduleName]._prototypes.code = {}
local prototype = Sku2.modules[moduleName]._prototypes.code
setmetatable(prototype, Sku2.modules.MTs.__newindex)

---------------------------------------------------------------------------------------------------------------------------------------
--prototype definition
---------------------------------------------------------------------------------------------------------------------------------------
--upvalue to reference the final module inside the function definitions
local module = Sku2.modules[moduleName]

---------------------------------------------------------------------------------------------------------------------------------------
--[[
prototype.testtable = {
	"default"
}
]]

---------------------------------------------------------------------------------------------------------------------------------------
--every module should have a SetUpModule function that is called on modules OnInitilize
function prototype:SetUpModule()
	print(moduleName, "SetUpModule", self)

end

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:GetCurrentSkuBindings()
	local tSkuBindings = {}
	for skuKeyBindName, binding in pairs(Sku2.db.global.keyBindings.skuKeyBinds) do
		tSkuBindings[skuKeyBindName] = binding
	end
	return tSkuBindings
end
