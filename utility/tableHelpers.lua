print("ultility\\tableHelpers.lua loading", SDL3)

local L = Sku2.L
Sku2.utility.tableHelpers = {}

---------------------------------------------------------------------------------------------------------------------------------------
function Sku2.utility.tableHelpers:AddTableToSecureHandlerBody(aNewTableName, aNewTableValues, aExistingBody)
	local tChars = {"a", "b", "c"}
	local tBody = "local "..aNewTableName.." = table.new() "
	for i, v in pairs(aNewTableValues) do
		tBody = tBody.."table.insert("..aNewTableName..", '"..v.."')"
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