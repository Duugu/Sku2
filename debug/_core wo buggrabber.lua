print("debug\\core.lua loading")
local L = Sku2.L

local originalPrint = getprinthandler()
local orginalErrorHandler = geterrorhandler()

Sku2.debug = {}
Sku2.debug.debugLevel = 1 -- 0 to 3 (0 is nothing)

for x = 0, 3 do
   _G["SDL"..x] = "SkuDebugLevel"..x
   _G["sdl"..x] = "SkuDebugLevel"..x
end

local startTime = GetTimePreciseSec()
local addonLoaded
local dbLoading = {}
local db = {}

---------------------------------------------------------------------------------------------------------
function Sku2.debug.Error(aErrorText, aDebugLevel, aTime)
   if not aErrorText then
      return
   end

   if not aTime then
      aTime = GetTimePreciseSec() - startTime
   end

   aErrorText = tostring(aErrorText)

   if aDebugLevel == SDL0 then
      debugLevel = 0
   elseif aDebugLevel == SDL1 then
      debugLevel = 1
   elseif aDebugLevel == SDL2 then
      debugLevel = 2
   elseif aDebugLevel == SDL3 then
      debugLevel = 3
   else
      debugLevel = 1
   end

   if debugLevel <= Sku2.debug.debugLevel then
      if addonLoaded == true then
         if db[aErrorText] then
            aErrorText = aErrorText.." ..."
         end
         if not db[aErrorText] then
            db[aErrorText] = 1
            db[#db + 1] = {debugLevel = debugLevel, errorText = aErrorText, time = aTime}
            print(string.format("%.3f", db[#db].time), "Sku Error ("..db[#db].debugLevel.."):", db[#db].errorText)
         else
            db[aErrorText] = db[aErrorText] + 1
         end
      else
         dbLoading[#dbLoading + 1] = {debugLevel = debugLevel, errorText = aErrorText, time = aTime}
      end

      orginalErrorHandler(aErrorText)
   end
end
seterrorhandler(Sku2.debug.Error)

---------------------------------------------------------------------------------------------------------
function Sku2.debug.Print(...)
   local debugLevel
   local tResultString = ""
   local tStringsTable = {...}
   for x = 1, #tStringsTable - 1 do
      tResultString = tResultString..tostring(tStringsTable[x]).." "
   end

   if tStringsTable[#tStringsTable] == SDL0 then
      debugLevel = 0
   elseif tStringsTable[#tStringsTable] == SDL1 then
      debugLevel = 1
   elseif tStringsTable[#tStringsTable] == SDL2 then
      debugLevel = 2
   elseif tStringsTable[#tStringsTable] == SDL3 then
      debugLevel = 3
   else
      tResultString = tResultString..tostring(tStringsTable[#tStringsTable]).." "
   end

   if not debugLevel then
      originalPrint(...)
   else
      if debugLevel <= Sku2.debug.debugLevel then
         if tResultString:find("Sku Error") then
            originalPrint(tResultString)
         else
            originalPrint("Sku debug ("..debugLevel..")", tResultString)
         end
      end
   end
end
setprinthandler(Sku2.debug.Print)

---------------------------------------------------------------------------------------------------------
local events = {}
do
   local frame = CreateFrame("Frame")
   frame:SetScript("OnEvent", function(_, event, ...)
      events[event](events, event, ...)
   end)
   frame:RegisterEvent("ADDON_LOADED")
   frame:RegisterEvent("ADDON_ACTION_BLOCKED")
   frame:RegisterEvent("MACRO_ACTION_FORBIDDEN")
   frame:RegisterEvent("ADDON_ACTION_BLOCKED")
   frame:RegisterEvent("MACRO_ACTION_FORBIDDEN")
   frame:RegisterEvent("LUA_WARNING")
end

---------------------------------------------------------------------------------------------------------
function events:ADDON_LOADED(_, msg)
   if msg == "Sku2" then
      addonLoaded = true
      if #dbLoading > 0 then
         print("--> Errors on loading:", #dbLoading)
         for x = 1, #dbLoading do
            Sku2.debug.Error(dbLoading[x].errorText, dbLoading[x].debugLevel, dbLoading[x].time)
         end
      end
   end
end

---------------------------------------------------------------------------------------------------------
function events:MACRO_ACTION_BLOCKED(event, msg)
   Sku2.debug.Error(event..": "..msg)
end

---------------------------------------------------------------------------------------------------------
function events:ADDON_ACTION_BLOCKED(event, msg)
   Sku2.debug.Error(event..": "..msg)
end

---------------------------------------------------------------------------------------------------------
function events:MACRO_ACTION_FORBIDDEN(event, msg)
   Sku2.debug.Error(event..": "..msg)end

---------------------------------------------------------------------------------------------------------
function events:ADDON_ACTION_FORBIDDEN(event, msg)
   Sku2.debug.Error(event..": "..msg)
end

---------------------------------------------------------------------------------------------------------
function events:LUA_WARNING(event, warnType, warningText)
   --print(event, warnType, warningText)
   --Sku2.debug.Error(event..": "..msg)
end