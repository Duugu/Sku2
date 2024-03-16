print("modules\\_sampleModule\\code.lua loading", SDL3)

local _G = _G
local L = Sku2.L

local moduleName = "_sampleModule"
Sku2.modules[moduleName]._prototypes = Sku2.modules[moduleName]._prototypes or {}
Sku2.modules[moduleName]._prototypes.code = {}
local prototype = Sku2.modules[moduleName]._prototypes.code
setmetatable(prototype, Sku2.modules.MTs.__newindex)
local this = Sku2.modules[moduleName]

---------------------------------------------------------------------------------------------------------------------------------------
--module code
---------------------------------------------------------------------------------------------------------------------------------------
local testvar = true
this.testtable = {}

---------------------------------------------------------------------------------------------------------------------------------------
--functions
---------------------------------------------------------------------------------------------------------------------------------------
function prototype:testfunction(a, b, c)
	print("testfunction default", self, a, b, c)
	print(this.testtable)

end
function prototype.testfunction:classic(a, b, c)
	print("testfunction classic", self, a, b, c)
	print(this.testtable)
	
end


