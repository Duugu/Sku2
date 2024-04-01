print("ultility\\tableHelpers.lua loading", SDL3)

local L = Sku2.L
Sku2.utility.tableHelpers = {}

---------------------------------------------------------------------------------------------------------------------------------------
function Sku2.utility.tableHelpers:AddStringIndexTableToSecureHandlerBody(aNewTableName, aNewTableValues, aExistingBody)
	local tBody = "local "..aNewTableName.." = table.new() "
	for i, v in pairs(aNewTableValues) do
		tBody = tBody..aNewTableName.."['"..tostring(i).."'] = '"..tostring(v).."' "
	end
	return tBody.." "..aExistingBody
end

---------------------------------------------------------------------------------------------------------------------------------------
function Sku2.utility.tableHelpers:AddNumberIndexTableToSecureHandlerBody(aNewTableName, aNewTableValues, aExistingBody)
	local tBody = "local "..aNewTableName.." = table.new() "
	for i, v in pairs(aNewTableValues) do
		tBody = tBody.."table.insert("..tostring(aNewTableName)..", '"..tostring(v).."')"
	end
	return tBody.." "..aExistingBody
end

---------------------------------------------------------------------------------------------------------------------------------------
function Sku2.utility.tableHelpers:TableCopy(t, deep, seen)
	seen = seen or {}
	if t == nil then return nil end
	if seen[t] then return seen[t] end
	local nt = {}
	for k, v in pairs(t) do
		if type(v) ~= "userdata" and k ~= "frame" and k ~= 0  then
			if deep and type(v) == 'table' then
				nt[k] = SkuOptions:TableCopy(v, deep, seen)
			else
				nt[k] = v
			end
		end
	end
	--setmetatable(nt, getmetatable(t), deep, seen))
	seen[t] = nt
	return nt
end

---------------------------------------------------------------------------------------------------------------------------------------
function Sku2.utility.tableHelpers:SkuSpairs(t, order)
	local keys = {}
	for k in pairs(t) do keys[#keys+1] = k end
	if order then
		table.sort(keys, function(a,b) return order(t, a, b) end)
	else
		table.sort(keys)
	end
	local i = 0
	return function()
		i = i + 1
		if keys[i] then
			return keys[i], t[keys[i]]
		end
	end
end