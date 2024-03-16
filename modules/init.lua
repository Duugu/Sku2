print("modules\\init.lua loading", SDL3)

local L = Sku2.L

Sku2.modules = Sku2:NewModule("modules")

---------------------------------------------------------------------------------------------------------------------------------------
Sku2.modules.MTs = {}

Sku2.modules.MTs.__index = {__index = function(table, key)
   --print("flavorCallMT", table, key, table["default"])
   if rawget(table, "default") then
      return table["default"]
   else
      return table
   end
end}

Sku2.modules.MTs.__newindex = {
   __newindex = function(thisTable, newTable, func)
      --print("flavorAddMT thisTable", thisTable, "newTable", newTable, "drei", drei)
      rawset(thisTable, newTable, {})
      thisTable[newTable].default = func
      setmetatable(thisTable[newTable], Sku2.modules.MTs.__index)
   end
}
