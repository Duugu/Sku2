print("core.lua loading", SDL3)

---------------------------------------------------------------------------------------------------------------------------------------
--event handlers
function Sku2:OnInitialize()
   print("core OnInitialize", SDL3)
end

---------------------------------------------------------------------------------------------------------------------------------------
function Sku2:OnEnable()
   print("core.lua OnEnable", SDL3)
   --register Events, Hook functions, Create Frames
      
   --create defaults from each modules settingsStruct to use with AceDB
   Sku2.defaults = {
      char = {},
      global = {},
      profile = {},
   }

   local function insertSubSettingsHelper(aParent, aSettingName, aSettingData)
      if aSettingData.children ~= nil then
         aParent[aSettingName] = {}
         for settingName, settingData in pairs(aSettingData.children) do
            insertSubSettingsHelper(aParent[aSettingName], settingName, settingData)
         end
      else
         aParent[aSettingName] = aSettingData.defaultValue
      end
   end

   for moduleName, moduleObject in pairs(Sku2.modules) do
      if type(moduleObject) == "table" and moduleObject.isSkuModule then
         if moduleObject.settingsStruct then
            for settingName, settingData in pairs(moduleObject.settingsStruct.char) do
               Sku2.defaults.char[moduleName] = Sku2.defaults.char[moduleName] or {}
               insertSubSettingsHelper(Sku2.defaults.char[moduleName], settingName, settingData)
            end
            for settingName, settingData in pairs(moduleObject.settingsStruct.profile) do
               Sku2.defaults.profile[moduleName] = Sku2.defaults.profile[moduleName] or {}
               insertSubSettingsHelper(Sku2.defaults.profile[moduleName], settingName, settingData)
            end
            for settingName, settingData in pairs(moduleObject.settingsStruct.global) do
               Sku2.defaults.global[moduleName] = Sku2.defaults.global[moduleName] or {}
               insertSubSettingsHelper(Sku2.defaults.global[moduleName], settingName, settingData)
            end
         end
      end
   end

   --create settings db
   Sku2.db = LibStub("AceDB-3.0"):New("Sku2DB", Sku2.defaults, "Default Profile")
   Sku2.db:RegisterDefaults(Sku2.defaults)

   -- register events
   SkuDispatcher:RegisterEventCallback("PLAYER_ENTERING_WORLD", Sku2.PLAYER_ENTERING_WORLD)
end

---------------------------------------------------------------------------------------------------------------------------------------
function Sku2:PLAYER_ENTERING_WORLD(aEvent, aIsInitialLogin, aIsReloadingUi)
   --print("Sku2:PLAYER_ENTERING_WORLD", aEvent, aIsInitialLogin, aIsReloadingUi, SDL3)
   print("Version", GetAddOnMetadata("Sku2", "Version"), SDL3)
   print("Flavor", Sku2.utility:GetClientFlavorString(), SDL3)
end
