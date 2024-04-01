print("modules\\_sampleModule\\code.lua loading", SDL3)
local moduleName = "_sampleModule"
local L = Sku2.L

Sku2.modules[moduleName]._prototypes = Sku2.modules[moduleName]._prototypes or {}
Sku2.modules[moduleName]._prototypes.code = Sku2.modules[moduleName]._prototypes.code or {}
local prototype = Sku2.modules[moduleName]._prototypes.code

--[[
Adding metatable for easier 'overloading' the prototypes function definitions.
The __newindex metatable actually is building a table prototype.testfunction with the flavors as keys and the functions as values.
Example:
	function prototype:testfunction() - will be the default function for all favors w/o a specific overload
	function prototype.testfunction:classic() - overload for classic flavor
	function prototype.testfunction:retail() - overload for retail flavor
	This would result in prototype.testfunction = {default = <func>, classic = <func>, retail = <func>}
The module loader will build the real module for the current flavor from this.
]]
setmetatable(prototype, Sku2.modules.MTs.__newindex)

---------------------------------------------------------------------------------------------------------------------------------------
--prototype definition
---------------------------------------------------------------------------------------------------------------------------------------
--upvalue to reference the final module inside the function definitions
local module = Sku2.modules[moduleName]

---------------------------------------------------------------------------------------------------------------------------------------
--locals; not flavor specific; will be available as upvalues in all functions
local testvar = true



---------------------------------------------------------------------------------------------------------------------------------------
--example on a flavor specific module table
prototype.testtable = {
	"default"
}
prototype.testtable.retail = {
	"retail"
}

---------------------------------------------------------------------------------------------------------------------------------------
--every module needs have a SetUpModule function that is called on modules OnInitilize
function prototype:SetUpModule()
	print(moduleName, "SetUpModule", self)

	--add keys & frame refs to module.globalKeybinds here (ex. module.globalKeybinds["SOME_SKU_KEY_CONST"] = somesecureframeref)
	
end

---------------------------------------------------------------------------------------------------------------------------------------
--for use with Sku2.modules.openPanels:RegisterModule. Is called on Open Panels menu updates
--[[
function prototype:IsPanelOpen()
	print(moduleName, "IsPanelOpen", self)

	return true
end
]]

---------------------------------------------------------------------------------------------------------------------------------------
--remaining module specific functions
function prototype:testfunction(a, b, c)
	print("testfunction default", self, a, b, c)
	for i, v in pairs(module.testtable) do
		print(i, v)
	end

end
--'overload' for specific flavors
function prototype.testfunction:classic(a, b, c)
	print("testfunction classic", self, a, b, c)
	for i, v in pairs(module.testtable) do
		print(i, v)
	end
	
end


