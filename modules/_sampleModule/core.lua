print("modules\\_sampleModule\\core.lua loading", SDL3)

local _G = _G
local L = Sku2.L

Sku2.modules._sampleModule = {}
local this = Sku2.modules._sampleModule

--[[
   module core
]]
---------------------------------------------------------------------------------------------------------------------------------------
function this:OnInitialize()
	print("Sku2.modules._sampleModule", "OnInitialize", SDL3)
	Sku2.modules:SetModuleCodeForClientFlavor(this)
	
end

---------------------------------------------------------------------------------------------------------------------------------------
function this:OnEnable()
	print("Sku2.modules._sampleModule", "OnEnable", SDL3)

end