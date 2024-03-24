--[[
to do
   - add dualspec values to settings>char

]]
print("modules\\moduleLoader.lua loading", SDL3)

local L = Sku2.L

---------------------------------------------------------------------------------------------------------------------------------------
--moduleLoader events
---------------------------------------------------------------------------------------------------------------------------------------
function Sku2.modules:OnInitialize()
   print("moduleLoader"," OnInitialize", SDL3)
   Sku2.modules:CreateModulesFromPrototypes()
end

---------------------------------------------------------------------------------------------------------------------------------------
function Sku2.modules:OnEnable()
   -- Do more initialization here, that really enables the use of your addon. Register Events, Hook functions, Create Frames, Get information from the game that wasn't available in OnInitialize
   print("moduleLoader", "OnEnable", SDL3)
end

---------------------------------------------------------------------------------------------------------------------------------------
function Sku2.modules:OnDisable()
   -- Do more initialization here, that really enables the use of your addon. Register Events, Hook functions, Create Frames, Get information from the game that wasn't available in OnInitialize
   print("moduleLoader", "OnDisable", SDL3)
end

---------------------------------------------------------------------------------------------------------------------------------------
--moduleLoader functions
---------------------------------------------------------------------------------------------------------------------------------------
function Sku2.modules:CreateModulesFromPrototypes()
   -- set up modules code and settings & UI struct for current flavor 
   for moduleName, moduleObject in pairs(Sku2.modules) do
      if type(moduleObject) == "table" and moduleObject.isSkuModule == true then
         print("setting up", moduleName, SDL3)
         --set up flavor specific code
         --thanks to 'overloading' the prototypes we have tables with default and any flavor specific values
         --we just need to build the final modules code from these tables
         for funcName, funcObject in pairs(moduleObject._prototypes.code) do
            if funcObject[Sku2.utility:GetClientFlavorString()] then
               moduleObject[funcName] = funcObject[Sku2.utility:GetClientFlavorString()]
            else
               moduleObject[funcName] = funcObject.default
            end
            if type(moduleObject[funcName]) == "table" then
               --remove the prototypes metatable
               setmetatable(moduleObject[funcName], nil)
            end
         end
         
         --set up flavor specific settings Struct
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
                  if settingObject.menuBuilder ~= nil then
                     if settingObject.menuBuilder == false then
                        tChildrenFound[settingName].menuBuilder = false
                     else
                        tChildrenFound[settingName].menuBuilder = settingObject.menuBuilder[Sku2.utility:GetClientFlavorString()] or settingObject.menuBuilder["default"]
                     end
                  else
                     tChildrenFound[settingName].menuBuilder = nil
                  end
                  tChildrenFound[settingName].flavors = nil
               end
            end
            return tChildrenFound
         end
         moduleObject.settingsStruct = {}
         for settingTypeName, settingTypeObject in pairs(moduleObject._prototypes.settings) do
            moduleObject.settingsStruct[settingTypeName] = settingsIteratorHelper(settingTypeObject, "")
         end

         --set up flavor specific UI Struct
         moduleObject.uiStruct = {}
         for uiName, uiObject in pairs(moduleObject._prototypes.UI) do
            local tValid = false
            if uiObject.flavors ~= nil then
               for _, clientFlavorName in pairs(uiObject.flavors) do
                  if clientFlavorName == Sku2.utility:GetClientFlavorString() then   
                     tValid = true
                  end
               end
            else
               tValid = true
            end
            if tValid == true then
               moduleObject.uiStruct[uiName] = uiObject
               if uiObject.menuBuilder[Sku2.utility:GetClientFlavorString()] ~= nil then
                  moduleObject.uiStruct[uiName].menuBuilder = uiObject.menuBuilder[Sku2.utility:GetClientFlavorString()]
               else
                  moduleObject.uiStruct[uiName].menuBuilder = uiObject.menuBuilder["default"]
               end
               moduleObject.uiStruct[uiName].flavors = nil
            end
         end

      end
   end
end

---------------------------------------------------------------------------------------------------------------------------------------
function Sku2.modules:FindModulesDependingOnModule(aModuleName)
   local allDependingModules = {}
   
   local function checkDependendModules(aModuleName, atab)
      if Sku2.modules[aModuleName].dependencies then
         for _, dependencyName in pairs(Sku2.modules[aModuleName].dependencies) do
            if not allDependingModules[dependencyName] then
               allDependingModules[#allDependingModules + 1] = dependencyName
               allDependingModules[dependencyName] = #allDependingModules
            end
            checkDependendModules(dependencyName, atab.."  ")
         end
      end
   end

   checkDependendModules(aModuleName, "")

   for x = 1, #allDependingModules do
      print("found", x, "of", #allDependingModules, allDependingModules[x], SDL3)
   end

   return allDependingModules
end

---------------------------------------------------------------------------------------------------------------------------------------
function Sku2.modules:DisableModule(aModuleName, aIncludingDependingModules)
	if InCombatLockdown() == true then
		Sku2.debug:Error("modules can't be disabled in combat!")
		return
	end

   if Sku2.modules[aModuleName]:IsEnabled() ~= true then
      print(aModuleName.." already is disabled", SDL2)
      return
   end

   local allDependendModules = Sku2.modules:FindAllModulesThatDependOnModule(aModuleName)
   if #allDependendModules > 0 then
      if aIncludingDependingModules then
         for moduleName, _ in pairs(allDependendModules) do
            print("disableing "..moduleName, SDL2)
            if Sku2.modules[moduleName]:IsEnabled() == true then
               Sku2.modules[moduleName]:Disable()
            end
         end
         Sku2.modules[aModuleName]:Disable()
      else
         print("there are "..#allDependendModules.." depending on "..aModuleName.." that must be disabled too. call with aIncludingDependingModules = true to disable them all.", SDL1)
      end
   else
      print("disableing "..aModuleName, SDL2)
      if Sku2.modules[aModuleName]:IsEnabled() == true then
         Sku2.modules[aModuleName]:Disable()
      end
   end
end

---------------------------------------------------------------------------------------------------------------------------------------
function Sku2.modules:EnableModule(aModuleName, aIncludingDependencyModules)
	if InCombatLockdown() == true then
		Sku2.debug:Error("modules can't be enabled in combat!")
		return
	end











end