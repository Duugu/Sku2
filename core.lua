Sku2 = LibStub("AceAddon-3.0"):NewAddon("Sku2")
Sku2.addonLoaded = nil
SkuDispatcher:RegisterEventCallback("ADDON_LOADED", function()
   Sku2.addonLoaded = true
end, true)

---------------------------------------------------------------------------------------------------------------------------------------
-- core
function Sku2:OnInitialize()
   print("core.lua OnInitialize", SDL3)
   Sku2.clientFlavorString = Sku2.utility:GetClientFlavorString()
   if not Sku2.clientFlavorString then
      Sku2.debug:Error("Sku2 not initialized")
      return
   end

   -- register events
   SkuDispatcher:RegisterEventCallback("ADDON_LOADED", Sku2.ADDON_LOADED)
   SkuDispatcher:RegisterEventCallback("PLAYER_ENTERING_WORLD", Sku2.PLAYER_ENTERING_WORLD)

   --create defaults and settings

   --create menu structure



--[[
   --create default value table from Sku2.settings
   Sku2.defaults = {}
   local function buildDefaultsFromSettingsTableHelper(aChildTable, aDefaultsTable)
      for i, v in pairs(aChildTable) do
         if v.type == "group" then
            aDefaultsTable[i] = {}
            buildDefaultsFromSettingsTableHelper(v.args, aDefaultsTable[i])
         else
            aDefaultsTable[i] = v.default
            v.default = nil
         end
      end
   end
   buildDefaultsFromSettingsTableHelper(Sku2.settings.args, Sku2.defaults)
]]
   --create settings db
	Sku2.db = LibStub("AceDB-3.0"):New("Sku2DB", Sku2.defaults, true)
   --https://www.curseforge.com/wow/addons/libdualspec-1-0
	--Sku2.AceConfig = LibStub("AceConfig-3.0")
	--Sku2.AceConfig:RegisterOptionsTable("Sku2", Sku2.settings, {"sku2"})
	--Sku2.AceConfigDialog = LibStub("AceConfigDialog-3.0")
	--Sku2.AceConfigDialog:AddToBlizOptions("Sku2")
   
   --Sku2.db:ResetDB()

   --[[
   local dumpProfile = function()
      print("Current Profile", Sku2.db:GetCurrentProfile())
      local t = {"profile", "char", "faction"}
      for _, part in pairs(t) do
         print(" ", part)
         for index, value in pairs(Sku2.db[part]) do
            if type(value) ~= "table" then
               print("   ", index, value)
            end
         end
      end
   end
   dumpProfile()
   Sku2.db:SetProfile("default1")
   ]]

   --init all modules
   Sku2.modules:OnInitialize()
end

---------------------------------------------------------------------------------------------------------------------------------------
function Sku2:OnEnable()
   print("core.lua OnEnable", SDL3)
   -- Do more initialization here, that really enables the use of your addon. Register Events, Hook functions, Create Frames, Get information from the game that wasn't available in OnInitialize
   if not Sku2.clientFlavorString then
      Sku2.debug:Error("Sku2.clientFlavorString nil; OnEnable return")
      return
   end


   --enable all modules
   Sku2.modules:OnEnable()
end

--[[
   event handlers
]]
---------------------------------------------------------------------------------------------------------------------------------------
function Sku2:ADDON_LOADED(aEvent, aAddonName)
   if aAddonName == "Sku2" then
      print(aEvent, SDL3)


   end
end

---------------------------------------------------------------------------------------------------------------------------------------
function Sku2:PLAYER_ENTERING_WORLD(aEvent, aIsInitialLogin, aIsReloadingUi)
   print(aEvent, aIsInitialLogin, aIsReloadingUi, SDL3)
   print("Version", GetAddOnMetadata("Sku2", "Version"), SDL3)
   print("Flavor", Sku2.clientFlavorString, SDL3)
   

end
