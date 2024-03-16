--[[
to do:
   - add Sku2.debug.OutputErrorsToCopy
   - add slash commands
   - register events via dispatcher
   - implment audio output in Sku2.debug.AudioError
   - use Sku2.debug.SetErrorNotifications(aSkuChatNotification, aSkuAudioNotification, aBugsackAudioNotification) on settings loaded/changed
   - use Sku2.debug.ClearErrors
   - handle ACTION_BLOCKED, ACTION_FORBIDDEN events


]]

--print("debug\\core1.lua loading", SDL3)
local L = Sku2.L

local originalPrint = getprinthandler()
local BugGrabber = BugGrabber

Sku2.debug = {
   debugLevel = 3, -- 0 to 3 (0 is nothing)
   maxRepeatingErrors = -1, -- -1 for all
   bugChatNotification = true,
   bugAaudioNotification = true,
   bugAaudioNotificationOnePerSeconds = 5,
   bugAaudioNotificationLastOutputTime = GetTimePreciseSec() - 100,
}

--[[
   global debug level constants for easier use with print() (we can't use just numbers for debug level, because print takes
   an unknown number of arguments and in our hook we do need to check if there is a debug level value)
]]
for x = 0, 3 do
   _G["SDL"..x] = "SkuDebugLevel"..x
   _G["sdl"..x] = "SkuDebugLevel"..x
end

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
function Sku2.debug.SetErrorNotifications(aSkuChatNotification, aSkuAudioNotification, aBugsackAudioNotification)
   if aBugsackAudioNotification then
      if aBugsackAudioNotification == false and _G["BugSack"] then
         _G["BugSack"].db.mute = nil
      elseif aBugsackAudioNotification == false and _G["BugSack"] then
         _G["BugSack"].db.mute = true
      end
   end
   if aSkuChatNotification then
      Sku2.debug.bugChatNotification = aSkuChatNotification
   end
   if aSkuChatNotification then
      Sku2.debug.bugChatNotification = aSkuAudioNotification
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
function Sku2.debug.AudioError(aError, aDetailed, aForce)
   if Sku2.debug.bugAaudioNotification ~= true then
      return
   end
   if GetTimePreciseSec() - Sku2.debug.bugAaudioNotificationLastOutputTime > Sku2.debug.bugAaudioNotificationOnePerSeconds then
      Sku2.debug.bugAaudioNotificationLastOutputTime = GetTimePreciseSec()
      if aError.counter < 2 then
         print("<insert bug audio notification here>")



      end
   end
end

---------------------------------------------------------------------------------------------------------
function Sku2.debug.PrintError(aError, aDetailed, aForce)
   --[[error = {number, session, counter, message, time, locals, stack}]]
   if Sku2.debug.bugChatNotification ~= true then
      return
   end

   local tMessage
   if (aError.counter < Sku2.debug.maxRepeatingErrors or Sku2.debug.maxRepeatingErrors == -1) or aForce == true then
      tMessage = aError.number..": "..aError.time.." "..aError.counter.." x "..aError.message
   elseif aError.counter == Sku2.debug.maxRepeatingErrors then
      tMessage = aError.number..": "..aError.time.." "..aError.counter.." x "..aError.message.." (repeating)"
   end
   if tMessage then
      if aDetailed and aError.stack then
         print(tMessage.."\n"..aError.stack)
      else
         print(tMessage)
      end
   end
end

---------------------------------------------------------------------------------------------------------
function Sku2.debug.OutputErrors(aNumberOfErrors, aDetailed, aFromStart)
   if not BugGrabber then
      return
   end

   local errors = Sku2.debug:GetErrors(BugGrabber:GetSessionId())
   if not errors or #errors == 0 then
      return
   end

   local tend = #errors
   local tstart = #errors - aNumberOfErrors + 1
   if tstart < 1 then
      tstart = 1
   end

   if aFromStart then
      tstart = 1
      tend = aNumberOfErrors
   end

   for x = tstart, tend do
      errors[x].number = x
      Sku2.debug.PrintError(errors[x], aDetailed, true)
   end
end

---------------------------------------------------------------------------------------------------------
function Sku2.debug.OutputLastError(aDetailed, aForce)
   if not BugGrabber then
      return
   end

   local errors = Sku2.debug:GetErrors(BugGrabber:GetSessionId())
   if not errors or #errors == 0 then
      return
   end
   errors[#errors].number = #errors
   Sku2.debug.PrintError(errors[#errors], aDetailed, aForce)
   Sku2.debug.AudioError(errors[#errors], aDetailed, aForce)
end

---------------------------------------------------------------------------------------------------------
function Sku2.debug.OnError()
   Sku2.debug.OutputLastError()
end

---------------------------------------------------------------------------------------------------------
function Sku2.debug:GetErrors(sessionId)
   if not BugGrabber then
      return
   end

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
            local sessionDataClean = {}
            if sessionData ~= nil and #sessionData > 0 then 
               print("--> Errors on loading:", #sessionDataClean, (#sessionData - 1))
               Sku2.debug.OutputErrors(#sessionData - 1, nil, true)
               Sku2.debug.OnError()
            end
            BugGrabber.RegisterCallback(Sku2, "BugGrabber_BugGrabbed", Sku2.debug.OnError)
         end
      end
   end
end

---------------------------------------------------------------------------------------------------------
function events:MACRO_ACTION_BLOCKED(event, msg)   
   --Sku2.debug.Error(event..": "..msg)
end

---------------------------------------------------------------------------------------------------------
function events:ADDON_ACTION_BLOCKED(event, msg)
   --Sku2.debug.Error(event..": "..msg)
end

---------------------------------------------------------------------------------------------------------
function events:MACRO_ACTION_FORBIDDEN(event, msg)
   --Sku2.debug.Error(event..": "..msg)
end

---------------------------------------------------------------------------------------------------------
function events:ADDON_ACTION_FORBIDDEN(event, msg)
   --Sku2.debug.Error(event..": "..msg)
end