print("core.lua loading", SDL3)

---------------------------------------------------------------------------------------------------------------------------------------
--event handlers
function Sku2:OnInitialize()
   print("core OnInitialize", SDL3)

   --create defaults to use with AceDB
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




   --create final settings for use with settings menu






   --create menu






   --create settings db
	Sku2.db = LibStub("AceDB-3.0"):New("Sku2DB", Sku2.defaults, true)
end

---------------------------------------------------------------------------------------------------------------------------------------
function Sku2:OnEnable()
   print("core.lua OnEnable", SDL3)
   -- Do more initialization here, that really enables the use of your addon. Register Events, Hook functions, Create Frames, Get information from the game that wasn't available in OnInitialize
   
   -- register events
   SkuDispatcher:RegisterEventCallback("PLAYER_ENTERING_WORLD", Sku2.PLAYER_ENTERING_WORLD)


end

---------------------------------------------------------------------------------------------------------------------------------------
function Sku2:PLAYER_ENTERING_WORLD(aEvent, aIsInitialLogin, aIsReloadingUi)
   print("Sku2:PLAYER_ENTERING_WORLD", aEvent, aIsInitialLogin, aIsReloadingUi, SDL3)
   print("Version", GetAddOnMetadata("Sku2", "Version"), SDL3)
   print("Flavor", Sku2.utility:GetClientFlavorString(), SDL3)

end
