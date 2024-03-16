print("modules\\_sampleModule\\core.lua loading", SDL3)

local _G = _G
local L = Sku2.L

local moduleName = "_sampleModule"
Sku2.modules[moduleName] = Sku2.modules:NewModule(moduleName)
local this = Sku2.modules[moduleName]

---------------------------------------------------------------------------------------------------------------------------------------
-- module events
---------------------------------------------------------------------------------------------------------------------------------------
function this:OnInitialize()
	print(moduleName, "OnInitialize", SDL3)
	
end

---------------------------------------------------------------------------------------------------------------------------------------
function this:OnEnable()
	print(moduleName, "OnEnable", SDL3)

end

---------------------------------------------------------------------------------------------------------------------------------------
function this:OnDisable()
	print(moduleName, "OnDisable", SDL3)

end