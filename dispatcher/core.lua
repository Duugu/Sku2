--[[
	SkuDispatcher:RegisterEventCallback("PLAYER_ENTERING_WORLD", function(self, aEventName)
		print("PLAYER_ENTERING_WORLD", self, aEventName)
		
		--SkuDispatcher:UnregisterEventCallback("PLAYER_REGEN_ENABLED", self)
	end, true)
]]
--print("dispatcher\\core.lua loading", SDL3)

local _G = _G

SkuDispatcher = LibStub("AceAddon-3.0"):NewAddon("SkuDispatcher", "AceConsole-3.0", "AceEvent-3.0")

---------------------------------------------------------------------------------------------------------------------------------------
SkuDispatcher.Registered = {}
SkuDispatcher.OneCallback = {}

---------------------------------------------------------------------------------------------------------------------------------------
function SkuDispatcher:TriggerSkuEvent(aEventName, ...)
	if SkuDispatcher[aEventName] then
		SkuDispatcher[aEventName](SkuDispatcher, aEventName, ...)
	end
end

---------------------------------------------------------------------------------------------------------------------------------------
function SkuDispatcher:OnDisable()
	
end

---------------------------------------------------------------------------------------------------------------------------------------
function SkuDispatcher:OnInitialize()

end

---------------------------------------------------------------------------------------------------------------------------------------
function SkuDispatcher:OnEnable()

end

---------------------------------------------------------------------------------------------------------------------------------------
function SkuDispatcher:UnregisterEventCallback(aEventName, aCallbackFunc)
	--print("SkuDispatcher:UnregisterEventCallback(aEventName, aCallbackFunc)", aEventName, aCallbackFunc)
	if not SkuDispatcher.Registered[aEventName] then
		print("Error: event not registered")
		return
	end
	if not SkuDispatcher.Registered[aEventName].callbacks[tostring(aCallbackFunc)] then
		print("Error: no registered callback function")
		return
	end

	SkuDispatcher.Registered[aEventName].callbacks[tostring(aCallbackFunc)] = nil

	for i, v in pairs(SkuDispatcher.Registered[aEventName].callbacks) do
		return
	end

	-- no callbacks left > unregister event
	if string.sub(aEventName, 1, 4) ~= "SKU_" then
		SkuDispatcher:UnregisterEvent(aEventName)
	end
	SkuDispatcher[aEventName] = nil
	SkuDispatcher.Registered[aEventName] = nil
end

---------------------------------------------------------------------------------------------------------------------------------------
function SkuDispatcher:RegisterEventCallback(aEventName, aCallbackFunc, aOnlyOneCallbackFlag)
	--print("RegisterEventCallback(aEventName, aCallbackFunc, aOnlyOneCallbackFlag)", aEventName, aCallbackFunc, aOnlyOneCallbackFlag)
	aOnlyOneCallbackFlag = aOnlyOneCallbackFlag or false

	if not SkuDispatcher.Registered[aEventName] then
		SkuDispatcher[aEventName] = function(...)
			local arg1, eventName, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12 = ... 
			for functionRef, callbackFuncTable in pairs(SkuDispatcher.Registered[aEventName].callbacks) do
				callbackFuncTable.callbackFunc(callbackFuncTable.callbackFunc, eventName, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12)
				if callbackFuncTable.onlyOneCallback == true then
					SkuDispatcher:UnregisterEventCallback(aEventName, functionRef)
				end
			end
		end

		SkuDispatcher.Registered[aEventName] = {
			handler = SkuDispatcher[aEventName],
			callbacks = {},
		}

		if string.sub(aEventName, 1, 4) ~= "SKU_" then
			SkuDispatcher:RegisterEvent(aEventName)
		end
	end

	if not SkuDispatcher.Registered[aEventName].callbacks[tostring(aCallbackFunc)] then
		SkuDispatcher.Registered[aEventName].callbacks[tostring(aCallbackFunc)] = {callbackFunc = aCallbackFunc, onlyOneCallback = aOnlyOneCallbackFlag}
	end
end