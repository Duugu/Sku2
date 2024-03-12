print("locales\\core.lua loading", SDL3)
Sku2.L = LibStub("AceLocale-3.0"):GetLocale("Sku2", false)
--[[

Sku2.locales = {}

local gameLocale = GetLocale()
if gameLocale == "enGB" or gameLocale == "enAU" then
	gameLocale = "enUS"
end
Sku2.locales.defaultLocale = gameLocale

local localesData = {}

---------------------------------------------------------------------------------------------------------
--- Creates a new localization table for the provided locale code
-- @param aCode: locale code
-- @param aIsDefault: bool (default: false)
-- @return localization table for aCode
function Sku2.locales:NewLocale(aCode, aIsDefault)
   if not aCode then
      Sku2:Error("No locale code provided")
      return
   end

   if asIsDefault == true then
      Sku2.locales.defaultLocale = aCode
   end

   localesData[aCode] = {}
   setmetatable(localesData[aCode], {
      __index = function(self, key) -- requesting totally unknown entries: fire off a nonbreaking error and return key
         print(key)
         rawset(self, key, key)      -- only need to see the warning once, really
         Sku2:Error("Missing entry for '"..tostring(key).."'")
         return key
      end
   })

   return localesData[aCode]
end

---------------------------------------------------------------------------------------------------------
--- Returns the localization table for the provided locale code
-- @param aCode: locale code (default: gameLocale code)
-- @return localization table for aCode
function Sku2.locales:GetLocale(aCode)
   if not aCode then
      aCode = Sku2.locales.defaultLocale
   end

   if not localesData[aCode] then
      Sku2:Error(string.format("There is no data for %s", aCode))
      return
   end

   return localesData[aCode]
end
]]