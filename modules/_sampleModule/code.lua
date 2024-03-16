print("modules\\_sampleModule\\code.lua loading", SDL3)

local _G = _G
local L = Sku2.L

local this = Sku2.modules._sampleModule

--[[
   module code
]]
---------------------------------------------------------------------------------------------------------------------------------------
this.code = {}
setmetatable(this.code, Sku2.modules.MTs.__newindex)

---------------------------------------------------------------------------------------------------------------------------------------
function this.code:testfunction(a, b, c)
	print("testfunction default", self, a, b, c)
end
function this.code.testfunction:classic(a, b, c)
	print("testfunction classic", self, a, b, c)
end


