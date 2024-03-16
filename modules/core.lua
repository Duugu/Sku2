print("modules\\core.lua loading", SDL3)

local L = Sku2.L

Sku2.modules = {}

--[[
   code to add correct flavor code in modules
]]
---------------------------------------------------------------------------------------------------------------------------------------
Sku2.modules.MTs = {}

Sku2.modules.MTs.__index = {__index = function(table, key)
   --print("flavorCallMT", table, key, table["default"])
   return table["default"]
end}

Sku2.modules.MTs.__newindex = {
   __newindex = function(thisTable, newTable, func)
      --print("flavorAddMT thisTable", thisTable, "newTable", newTable, "drei", drei)
      rawset(thisTable, newTable, {})
      thisTable[newTable].default = func
      setmetatable(thisTable[newTable], Sku2.modules.MTs.__index)
   end
}

---------------------------------------------------------------------------------------------------------------------------------------
function Sku2.modules:SetModuleCodeForClientFlavor(aModule)
   for funcName, funcTable in pairs(aModule.code) do
      aModule[funcName] = funcTable[Sku2.clientFlavorString]
   end
   aModule.code = nil
end

--[[
   modules root core
]]
---------------------------------------------------------------------------------------------------------------------------------------
function Sku2.modules:OnInitialize()
   print("Sku2.modules:OnInitialize()", SDL3)
   --init all modules
   for i, v in pairs(Sku2.modules) do
      if type(v) == "table" then
         for i1, v1 in pairs(v) do
            if type(v1) == "table" then
               if v1.OnInitialize then
                  v1:OnInitialize()
               end
            end
         end
      end
   end
end

---------------------------------------------------------------------------------------------------------------------------------------
function Sku2.modules:OnEnable()
   -- Do more initialization here, that really enables the use of your addon. Register Events, Hook functions, Create Frames, Get information from the game that wasn't available in OnInitialize
   print("Sku2.modules:OnEnable()", SDL3)
   --enable all modules
   for i, v in pairs(Sku2.modules) do
      if type(v) == "table" then
         for i1, v1 in pairs(v) do
            if type(v1) == "table" then
               if v1.OnEnable then
                  v1:OnEnable()
               end
            end
         end
      end
   end


   -- --> test menu start
   print("add test menu")
   local tNewMenuEntry = Sku2.modules.core.audioMenu:InjectMenuItems(Sku2.modules.core.audioMenu.menu.root, {"eins"}, Sku2.modules.core.audioMenu.genericMenuItem)
   --tNewMenuEntry.isMultiselect = true
   --tNewMenuEntry.filterable = true
   tNewMenuEntry.buildChildrenFunc = function(self)
      local tNewMenuEntry = Sku2.modules.core.audioMenu:InjectMenuItems(self, {"Size"}, Sku2.modules.core.audioMenu.genericMenuItem)
      tNewMenuEntry.dynamic = true
      tNewMenuEntry.buildChildrenFunc = function(self)
         local tNewMenuEntry = Sku2.modules.core.audioMenu:InjectMenuItems(self, {"Small"}, Sku2.modules.core.audioMenu.genericMenuItem)
         tNewMenuEntry.onEnterFunc = function(self)
            print(" xxx Small onEnterFunc")
         end
         local tNewMenuEntry = Sku2.modules.core.audioMenu:InjectMenuItems(self, {"Large"}, Sku2.modules.core.audioMenu.genericMenuItem)
         tNewMenuEntry.onEnterFunc = function(self)
            print(" xxx Large onEnterFunc", self.name)
         end
         tNewMenuEntry.actionFunc = function(self)
            print(" xxx Large actionFunc", self.name)
            self:Update(self.name.." NEW")
         end
         local tNewMenuEntry = Sku2.modules.core.audioMenu:InjectMenuItems(self, {"Laroxx"}, Sku2.modules.core.audioMenu.genericMenuItem)
         tNewMenuEntry.onEnterFunc = function(self)
            print(" xxx Laroxx onEnterFunc", self.name)
         end
         tNewMenuEntry.actionFunc = function(self)
            print(" xxx Laroxx actionFunc", self.name)
            self:Update(self.name.." NEWXX")
         end
      end
      local tNewMenuEntry = Sku2.modules.core.audioMenu:InjectMenuItems(self, {"Quests"}, Sku2.modules.core.audioMenu.genericMenuItem)
      tNewMenuEntry.dynamic = true
      tNewMenuEntry.buildChildrenFunc = function(self)
         local tNewMenuEntry = Sku2.modules.core.audioMenu:InjectMenuItems(self, {"aaa", "bbb", "ccc"}, Sku2.modules.core.audioMenu.genericMenuItem)
      end
   end
   local tNewMenuEntry = Sku2.modules.core.audioMenu:InjectMenuItems(Sku2.modules.core.audioMenu.menu.root, {"zwei empty"}, Sku2.modules.core.audioMenu.genericMenuItem)
   tNewMenuEntry.empty = true
   local tNewMenuEntry = Sku2.modules.core.audioMenu:InjectMenuItems(Sku2.modules.core.audioMenu.menu.root, {"zwei aa empty"}, Sku2.modules.core.audioMenu.genericMenuItem)
   tNewMenuEntry.empty = true
   local tNewMenuEntry = Sku2.modules.core.audioMenu:InjectMenuItems(Sku2.modules.core.audioMenu.menu.root, {"zwei bb empty"}, Sku2.modules.core.audioMenu.genericMenuItem)
   tNewMenuEntry.empty = true
   local tNewMenuEntry = Sku2.modules.core.audioMenu:InjectMenuItems(Sku2.modules.core.audioMenu.menu.root, {"zwei bbc empty"}, Sku2.modules.core.audioMenu.genericMenuItem)
   tNewMenuEntry.empty = true
   local tNewMenuEntry = Sku2.modules.core.audioMenu:InjectMenuItems(Sku2.modules.core.audioMenu.menu.root, {"empty"}, Sku2.modules.core.audioMenu.genericMenuItem)
   tNewMenuEntry.empty = true
   local tNewMenuEntry = Sku2.modules.core.audioMenu:InjectMenuItems(Sku2.modules.core.audioMenu.menu.root, {"empty"}, Sku2.modules.core.audioMenu.genericMenuItem)
   tNewMenuEntry.empty = true
   local tNewMenuEntry = Sku2.modules.core.audioMenu:InjectMenuItems(Sku2.modules.core.audioMenu.menu.root, {"empty"}, Sku2.modules.core.audioMenu.genericMenuItem)
   tNewMenuEntry.empty = true
   local tNewMenuEntry = Sku2.modules.core.audioMenu:InjectMenuItems(Sku2.modules.core.audioMenu.menu.root, {"empty"}, Sku2.modules.core.audioMenu.genericMenuItem)
   tNewMenuEntry.empty = true
   local tNewMenuEntry = Sku2.modules.core.audioMenu:InjectMenuItems(Sku2.modules.core.audioMenu.menu.root, {"vier empty"}, Sku2.modules.core.audioMenu.genericMenuItem)
   -- <-- test menu end

end