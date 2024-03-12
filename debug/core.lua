--print("debug\\core1.lua loading", SDL3)
local L = Sku2.L

local originalPrint = getprinthandler()
local BugGrabber = BugGrabber

Sku2.debug = {}
Sku2.debug.debugLevel = 3 -- 0 to 3 (0 is nothing)
Sku2.debug.maxRepeatingErrors = -1 -- -1 for all

for x = 0, 3 do
   _G["SDL"..x] = "SkuDebugLevel"..x
   _G["sdl"..x] = "SkuDebugLevel"..x
end

local startTime = GetTimePreciseSec()
local addonLoaded
local dbLoading = {}
local db = {}

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
      if db[aErrorText] then
         aErrorText = aErrorText.." (repeating)"
      end
      if not db[aErrorText] then
         db[aErrorText] = 1
         db[#db + 1] = {debugLevel = debugLevel, errorText = aErrorText, time = aTime}
         print(string.format("%.3f", db[#db].time), "Sku Error ("..db[#db].debugLevel.."):", db[#db].errorText)
      else
         db[aErrorText] = db[aErrorText] + 1
      end
   end
end

---------------------------------------------------------------------------------------------------------
function Sku2.debug.ClearErrors()
   db = {}
   if _G["BugSack"] then
      _G["BugSack"]:Reset()
   end
end

---------------------------------------------------------------------------------------------------------
function Sku2.debug.PrintError(aError, aDetailed, aForce)
   --[[error = {number, session, counter, message, time, locals, stack}]]
   local tMessage
   if (aError.counter < Sku2.debug.maxRepeatingErrors or Sku2.debug.maxRepeatingErrors == -1) or aForce == true then
      tMessage = aError.number..": "..aError.time.." "..aError.counter.." x "..aError.message
   elseif aError.counter == Sku2.debug.maxRepeatingErrors then
      tMessage = aError.number..": "..aError.time.." "..aError.counter.." x "..aError.message.." (repeating)"
   end
   if tMessage then
      if aDetailed then
         print(tMessage.."\n"..aError.stack)
      else
         print(tMessage)
      end
   end
end
---------------------------------------------------------------------------------------------------------
function Sku2.debug.PrintErrors(aNumberOfErrors, aDetailed)
   local errors = Sku2.debug:GetErrors(BugGrabber:GetSessionId())
   if not errors or #errors == 0 then
      return
   end

   local tstart = #errors - aNumberOfErrors
   if tstart < 1 then
      tstart = 1
   end

   for x = tstart, #errors do
      errors[x].number = x
      Sku2.debug.PrintError(errors[x], aDetailed, true)
   end
end
---------------------------------------------------------------------------------------------------------
function Sku2.debug.PrintLastError(aDetailed, aForce)
   local errors = Sku2.debug:GetErrors(BugGrabber:GetSessionId())
   if not errors or #errors == 0 then
      return
   end
   errors[#errors].number = #errors
   Sku2.debug.PrintError(errors[#errors], aDetailed, aForce)
end

---------------------------------------------------------------------------------------------------------
function Sku2.debug.OnError()
   Sku2.debug.PrintLastError()
end

---------------------------------------------------------------------------------------------------------
function Sku2.debug:GetErrors(sessionId, a, b)
   if sessionId then
      local errors = {}
      local db = BugGrabber:GetDB()
      for i, e in next, db do
         if sessionId == e.session then
            errors[#errors + 1] = e
         end
      end
      return errors
   end
end

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
function events:ADDON_LOADED(event, msg)
   if msg == "Sku2" then
      if BugGrabber then
         local tSessionId = BugGrabber:GetSessionId()
         if tSessionId then
            local sessionData = Sku2.debug:GetErrors(tSessionId)
            if sessionData ~= nil and #sessionData > 0 then 
               for x = 1, #sessionData do
                  sessionData[x].number = x
               end
               print("--> Errors on loading:", #sessionData)
               Sku2.debug.PrintErrors(#sessionData)
            end
            BugGrabber.RegisterCallback(Sku2, "BugGrabber_BugGrabbed", Sku2.debug.OnError)
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