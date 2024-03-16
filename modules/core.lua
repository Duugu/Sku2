--[[
to do
   - add dualspec values to settings>char
   - set up flavor specific UI from prototypes

]]
print("modules\\core.lua loading", SDL3)

local L = Sku2.L

---------------------------------------------------------------------------------------------------------------------------------------
-- set up modules code, settings, UI for current flavor 
do
   for moduleName, moduleObject in pairs(Sku2.modules) do
      if type(moduleObject) == "table" and moduleObject._prototypes then

         --set up flavor specific code
         for funcName, funcObject in pairs(moduleObject._prototypes.code) do
            if funcObject[Sku2.utility:GetClientFlavorString()] then
               moduleObject[funcName] = funcObject[Sku2.utility:GetClientFlavorString()]
            else
               moduleObject[funcName] = funcObject.default
            end
            if type(moduleObject[funcName]) == "table" then
               --remove the prototype metatable
               setmetatable(moduleObject[funcName], nil)
            end
         end
         
         --set up flavor specific settings
         local function settingsIteratorHelper(aSubgroup, aTab)
            local tChildrenFound = {}
            for settingName, settingObject in pairs(aSubgroup) do
               local tValid
               if settingObject.flavors ~= nil then
                  for _, clientFlavorName in pairs(settingObject.flavors) do
                     if clientFlavorName == Sku2.utility:GetClientFlavorString() then   
                        tValid = true
                     end
                  end
               else
                  tValid = true
               end
               if tValid == true then
                  tChildrenFound[settingName] = settingObject
                  if settingObject.children ~= nil then
                     tChildrenFound[settingName].children = settingsIteratorHelper(settingObject.children, aTab.." ")
                  end
                  if settingObject.defaultValue ~= nil then
                     tChildrenFound[settingName].defaultValue = settingObject.defaultValue[Sku2.utility:GetClientFlavorString()] or settingObject.defaultValue["default"]
                  else
                     tChildrenFound[settingName].defaultValue = nil
                  end
                  if settingObject.menu ~= nil then
                     tChildrenFound[settingName].menu = settingObject.menu[Sku2.utility:GetClientFlavorString()] or settingObject.menu["default"]
                  else
                     tChildrenFound[settingName].menu = nil
                  end
                  tChildrenFound[settingName].flavors = nil
               end
            end
            return tChildrenFound
         end

         moduleObject.settings = {}
         for settingTypeName, settingTypeObject in pairs(moduleObject._prototypes.settings) do
            moduleObject.settings[settingTypeName] = settingsIteratorHelper(settingTypeObject, "")
         end

         --set up flavor specific UI
















         --we don't need the prototypes anymore
         --is there any sense on deleting them?
         --moduleObject._prototypes = nil
      end
   end
end

---------------------------------------------------------------------------------------------------------------------------------------
-- modules events
---------------------------------------------------------------------------------------------------------------------------------------
function Sku2.modules:OnInitialize()
   print("modules"," OnInitialize", SDL3)

end

---------------------------------------------------------------------------------------------------------------------------------------
function Sku2.modules:OnEnable()
   -- Do more initialization here, that really enables the use of your addon. Register Events, Hook functions, Create Frames, Get information from the game that wasn't available in OnInitialize
   print("modules", "OnEnable", SDL3)
   
end