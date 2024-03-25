print("ultility\\tooltipHelpers.lua loading", SDL3)

local L = Sku2.L
Sku2.utility.tooltipHelpers = {}

---------------------------------------------------------------------------------------------------------------------------------------
function Sku2.utility.tooltipHelpers:GetTooltipDataFromItemButton(aButton)
	if not aButton then
		Sku2.debug:Error("GetTooltipDataFromItemButton: aButton is nil")
		return
	end

	local firstLine, body
	local itemData = {
		name = nil,
		id = nil,
		effectiveLevel = nil,
		rarity = nil,
		--[[
		type = "",
		itemSubType = "",
		itemEquipLoc = "",
		itemSellPrice = 0,
		itemClassID = 0,
		itemSubClassID = 0,
		bindType = 0,
		]]
	}

	--first try if there is some UpdateTooltip function
	if not firstLine then
		if aButton.UpdateTooltip then
			GameTooltip:ClearLines()
			GameTooltip:Hide()
			aButton:UpdateTooltip()
		end
	end

	--then let's try OnEnter
	if GameTooltip:IsShown() ~= true then
		GameTooltip:ClearLines()
		if aButton.GetScript and aButton:GetScript("OnEnter") then
			aButton:GetScript("OnEnter")(aButton)
		end
	end

	--got something? nice, build return values
	if GameTooltip:IsShown() == true then
		local itemName, ItemLink = GameTooltip:GetItem()
		if itemName then
			itemData.name = itemName
			itemData.link = ItemLink

			local tEffectiveILvl = GetDetailedItemLevelInfo(ItemLink)
			if tEffectiveILvl then
				itemData.effectiveLevel = tEffectiveILvl
			end

			for x = 0, #ITEM_QUALITY_COLORS do
				local tItemCol = ITEM_QUALITY_COLORS[x].color:GenerateHexColor()
				if tItemCol == "ffa334ee" then 
					tItemCol = "ffa335ee"
				end
				if string.find(ItemLink, tItemCol) then
					if _G["ITEM_QUALITY"..x.."_DESC"] then
						itemData.rarity = _G["ITEM_QUALITY"..x.."_DESC"]
					end
				end
			end			
		end

		local tLineCounter = 1
		firstLine = ""
		body = ""
		for i = 1, select("#", GameTooltip:GetRegions()) do
			local region = select(i, GameTooltip:GetRegions())
			if region and region:GetObjectType() == "FontString" then
				local text = region:GetText()
				if text then
					if text ~= "" and text ~= " " then
						text = Sku2.utility:Unescape(text)
						if tLineCounter == 1 then
							firstLine = text
							body = text
						else
							body = body.."\n"..text
						end
					end
					tLineCounter = tLineCounter + 1
				end
			end
		end

		GameTooltip:Hide() 
	end

	return firstLine, body, itemData
end
