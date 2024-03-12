print("modules\\core.lua loading", SDL3)

local L = Sku2.L

Sku2.modules = {}

---------------------------------------------------------------------------------------------------------------------------------------
function Sku2.modules:OnInitialize()
   print("Sku2.modules:OnInitialize()", SDL3)
   --init all modules
   for i, v in pairs(Sku2.modules) do
      if type(v) == "table" then
         v:OnInitialize()
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
         v:OnEnable()
      end
   end



   -- --> test menu start
   print("add test menu")
   local tNewMenuEntry = Sku2.modules.audioMenu:InjectMenuItems(Sku2.modules.audioMenu.menu.root, {"eins"}, Sku2.modules.audioMenu.genericMenuItem)
   --tNewMenuEntry.isMultiselect = true
   --tNewMenuEntry.filterable = true
   tNewMenuEntry.buildChildrenFunc = function(self)
      local tNewMenuEntry = Sku2.modules.audioMenu:InjectMenuItems(self, {"Size"}, Sku2.modules.audioMenu.genericMenuItem)
      tNewMenuEntry.dynamic = true
      tNewMenuEntry.buildChildrenFunc = function(self)
         local tNewMenuEntry = Sku2.modules.audioMenu:InjectMenuItems(self, {"Small"}, Sku2.modules.audioMenu.genericMenuItem)
         tNewMenuEntry.onEnterFunc = function(self)
            print(" xxx Small onEnterFunc")
         end
         local tNewMenuEntry = Sku2.modules.audioMenu:InjectMenuItems(self, {"Large"}, Sku2.modules.audioMenu.genericMenuItem)
         tNewMenuEntry.onEnterFunc = function(self)
            print(" xxx Large onEnterFunc", self.name)
         end
         tNewMenuEntry.actionFunc = function(self)
            print(" xxx Large actionFunc", self.name)
            self:Update(self.name.." NEW")
         end
         local tNewMenuEntry = Sku2.modules.audioMenu:InjectMenuItems(self, {"Laroxx"}, Sku2.modules.audioMenu.genericMenuItem)
         tNewMenuEntry.onEnterFunc = function(self)
            print(" xxx Laroxx onEnterFunc", self.name)
         end
         tNewMenuEntry.actionFunc = function(self)
            print(" xxx Laroxx actionFunc", self.name)
            self:Update(self.name.." NEWXX")
         end
      end
      local tNewMenuEntry = Sku2.modules.audioMenu:InjectMenuItems(self, {"Quests"}, Sku2.modules.audioMenu.genericMenuItem)
      tNewMenuEntry.dynamic = true
      tNewMenuEntry.buildChildrenFunc = function(self)
         local tNewMenuEntry = Sku2.modules.audioMenu:InjectMenuItems(self, {"aaa", "bbb", "ccc"}, Sku2.modules.audioMenu.genericMenuItem)
      end
   end
   local tNewMenuEntry = Sku2.modules.audioMenu:InjectMenuItems(Sku2.modules.audioMenu.menu.root, {"zwei empty"}, Sku2.modules.audioMenu.genericMenuItem)
   tNewMenuEntry.empty = true
   local tNewMenuEntry = Sku2.modules.audioMenu:InjectMenuItems(Sku2.modules.audioMenu.menu.root, {"zwei aa empty"}, Sku2.modules.audioMenu.genericMenuItem)
   tNewMenuEntry.empty = true
   local tNewMenuEntry = Sku2.modules.audioMenu:InjectMenuItems(Sku2.modules.audioMenu.menu.root, {"zwei bb empty"}, Sku2.modules.audioMenu.genericMenuItem)
   tNewMenuEntry.empty = true
   local tNewMenuEntry = Sku2.modules.audioMenu:InjectMenuItems(Sku2.modules.audioMenu.menu.root, {"zwei bbc empty"}, Sku2.modules.audioMenu.genericMenuItem)
   tNewMenuEntry.empty = true
   local tNewMenuEntry = Sku2.modules.audioMenu:InjectMenuItems(Sku2.modules.audioMenu.menu.root, {"empty"}, Sku2.modules.audioMenu.genericMenuItem)
   tNewMenuEntry.empty = true
   local tNewMenuEntry = Sku2.modules.audioMenu:InjectMenuItems(Sku2.modules.audioMenu.menu.root, {"empty"}, Sku2.modules.audioMenu.genericMenuItem)
   tNewMenuEntry.empty = true
   local tNewMenuEntry = Sku2.modules.audioMenu:InjectMenuItems(Sku2.modules.audioMenu.menu.root, {"empty"}, Sku2.modules.audioMenu.genericMenuItem)
   tNewMenuEntry.empty = true
   local tNewMenuEntry = Sku2.modules.audioMenu:InjectMenuItems(Sku2.modules.audioMenu.menu.root, {"empty"}, Sku2.modules.audioMenu.genericMenuItem)
   tNewMenuEntry.empty = true
   local tNewMenuEntry = Sku2.modules.audioMenu:InjectMenuItems(Sku2.modules.audioMenu.menu.root, {"vier empty"}, Sku2.modules.audioMenu.genericMenuItem)
   -- <-- test menu end

end

