print("modules\\core\\core.lua loading", SDL3)

local L = Sku2.L

Sku2.modules.core = {}
local this = Sku2.modules.core

--[[
   module core
]]
---------------------------------------------------------------------------------------------------------------------------------------
function this:OnInitialize()
   print("this:OnInitialize()", SDL3)
   --init all modules
   for i, v in pairs(this) do
      if type(v) == "table" then
         if v.OnInitialize then
            v:OnInitialize()
         end
      end
   end
end

---------------------------------------------------------------------------------------------------------------------------------------
function this:OnEnable()
   -- Do more initialization here, that really enables the use of your addon. Register Events, Hook functions, Create Frames, Get information from the game that wasn't available in OnInitialize
   print("this:OnEnable()", SDL3)
   --enable all modules
   for i, v in pairs(this) do
      if type(v) == "table" then
         if v.OnEnable then
            v:OnEnable()
         end
      end
   end


   -- --> test menu start
   print("add test menu")
   local tNewMenuEntry = this.audioMenu:InjectMenuItems(this.audioMenu.menu.root, {"eins"}, this.audioMenu.genericMenuItem)
   --tNewMenuEntry.isMultiselect = true
   --tNewMenuEntry.filterable = true
   tNewMenuEntry.buildChildrenFunc = function(self)
      local tNewMenuEntry = this.audioMenu:InjectMenuItems(self, {"Size"}, this.audioMenu.genericMenuItem)
      tNewMenuEntry.dynamic = true
      tNewMenuEntry.buildChildrenFunc = function(self)
         local tNewMenuEntry = this.audioMenu:InjectMenuItems(self, {"Small"}, this.audioMenu.genericMenuItem)
         tNewMenuEntry.onEnterFunc = function(self)
            print(" xxx Small onEnterFunc")
         end
         local tNewMenuEntry = this.audioMenu:InjectMenuItems(self, {"Large"}, this.audioMenu.genericMenuItem)
         tNewMenuEntry.onEnterFunc = function(self)
            print(" xxx Large onEnterFunc", self.name)
         end
         tNewMenuEntry.actionFunc = function(self)
            print(" xxx Large actionFunc", self.name)
            self:Update(self.name.." NEW")
         end
         local tNewMenuEntry = this.audioMenu:InjectMenuItems(self, {"Laroxx"}, this.audioMenu.genericMenuItem)
         tNewMenuEntry.onEnterFunc = function(self)
            print(" xxx Laroxx onEnterFunc", self.name)
         end
         tNewMenuEntry.actionFunc = function(self)
            print(" xxx Laroxx actionFunc", self.name)
            self:Update(self.name.." NEWXX")
         end
      end
      local tNewMenuEntry = this.audioMenu:InjectMenuItems(self, {"Quests"}, this.audioMenu.genericMenuItem)
      tNewMenuEntry.dynamic = true
      tNewMenuEntry.buildChildrenFunc = function(self)
         local tNewMenuEntry = this.audioMenu:InjectMenuItems(self, {"aaa", "bbb", "ccc"}, this.audioMenu.genericMenuItem)
      end
   end
   local tNewMenuEntry = this.audioMenu:InjectMenuItems(this.audioMenu.menu.root, {"zwei empty"}, this.audioMenu.genericMenuItem)
   tNewMenuEntry.empty = true
   local tNewMenuEntry = this.audioMenu:InjectMenuItems(this.audioMenu.menu.root, {"zwei aa empty"}, this.audioMenu.genericMenuItem)
   tNewMenuEntry.empty = true
   local tNewMenuEntry = this.audioMenu:InjectMenuItems(this.audioMenu.menu.root, {"zwei bb empty"}, this.audioMenu.genericMenuItem)
   tNewMenuEntry.empty = true
   local tNewMenuEntry = this.audioMenu:InjectMenuItems(this.audioMenu.menu.root, {"zwei bbc empty"}, this.audioMenu.genericMenuItem)
   tNewMenuEntry.empty = true
   local tNewMenuEntry = this.audioMenu:InjectMenuItems(this.audioMenu.menu.root, {"empty"}, this.audioMenu.genericMenuItem)
   tNewMenuEntry.empty = true
   local tNewMenuEntry = this.audioMenu:InjectMenuItems(this.audioMenu.menu.root, {"empty"}, this.audioMenu.genericMenuItem)
   tNewMenuEntry.empty = true
   local tNewMenuEntry = this.audioMenu:InjectMenuItems(this.audioMenu.menu.root, {"empty"}, this.audioMenu.genericMenuItem)
   tNewMenuEntry.empty = true
   local tNewMenuEntry = this.audioMenu:InjectMenuItems(this.audioMenu.menu.root, {"empty"}, this.audioMenu.genericMenuItem)
   tNewMenuEntry.empty = true
   local tNewMenuEntry = this.audioMenu:InjectMenuItems(this.audioMenu.menu.root, {"vier empty"}, this.audioMenu.genericMenuItem)
   -- <-- test menu end

end