print("modules\\characterFrame\\code.lua loading", SDL3)
local moduleName = "characterFrame"
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
--locals; not flavor specific; will be available as upvalues in all functions



---------------------------------------------------------------------------------------------------------------------------------------
--every module should have a SetUpModule function that is called on modules OnInitilize
function prototype:SetUpModule()
	print(moduleName, "SetUpModule", self)
	
end

---------------------------------------------------------------------------------------------------------------------------------------
--remaining module specific functions
