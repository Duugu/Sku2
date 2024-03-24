print("modules\\init.lua loading", SDL3)

local L = Sku2.L

Sku2.modules = Sku2:NewModule("modules")

---------------------------------------------------------------------------------------------------------------------------------------
--[[
   we're using these mts to be able to 'overload' our protoypes contents for specific flavors
   see modules\_sampleModule\code.lua for details
]]
Sku2.modules.MTs = {}
Sku2.modules.MTs.__index = {__index = function(table, key)
   if rawget(table, "default") then
      return table["default"]
   else
      return table
   end
end}
Sku2.modules.MTs.__newindex = {
   __newindex = function(thisTable, newTable, func)
      rawset(thisTable, newTable, {})
      thisTable[newTable].default = func
      setmetatable(thisTable[newTable], Sku2.modules.MTs.__index)
   end
}