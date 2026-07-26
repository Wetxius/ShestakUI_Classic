local T, C, L = unpack(ShestakUI)
if C.aura.player_auras ~= true then return end

----------------------------------------------------------------------------------------
--	Style player buff(by Tukz)
----------------------------------------------------------------------------------------
local rowbuffs = 16
local alpha = 0

local GetFormattedTime = function(s)
	if s >= 86400 then
		return format("%dd", floor(s / 86400 + 0.5))
	elseif s >= 3600 then
		return format("%dh", floor(s / 3600 + 0.5))
	elseif s >= 60 then
		return format("%dm", floor(s / 60 + 0.5))
	end
	return floor(s + 0.5)
end

local BuffsAnchor = CreateFrame("Frame", "BuffsAnchor", UIParent)
BuffsAnchor:SetPoint(unpack(C.position.player_buffs))
BuffsAnchor:SetSize((15 * C.aura.player_buff_size) + 42, (C.aura.player_buff_size * 2) + 3)

----------------------------------------------------------------------------------------
--	Modern buff frame
----------------------------------------------------------------------------------------
if BuffFrame.AuraContainer then
	SetCVar("collapseExpandBuffs", 0)
	if BuffFrame.CollapseAndExpandButton then
		BuffFrame.CollapseAndExpandButton:Kill()
	end

	DebuffFrame.AuraContainer:Hide()

	local function UpdateDuration(aura, timeLeft)
		local duration = aura.Duration
		if timeLeft and C.aura.show_timer == true then
			duration:SetVertexColor(1, 1, 1)
			duration:SetFormattedText(GetFormattedTime(timeLeft))
		else
			duration:Hide()
		end
	end

	local styling
	hooksecurefunc(BuffFrame.AuraContainer, "UpdateGridLayout", function(self, auras)
		if styling then return end
		styling = true

		local previousBuff, aboveBuff
		for index, aura in ipairs(auras) do
			aura:SetSize(C.aura.player_buff_size, C.aura.player_buff_size)

			if not aura.isSkinned then
				aura:SetTemplate("Default")
				if C.aura.classcolor_border == true then
					aura:SetBackdropBorderColor(unpack(C.media.classborder_color))
				end

				if aura.TempEnchantBorder then
					aura.TempEnchantBorder:SetAlpha(0)
				end

				local duration = aura.Duration
				duration:ClearAllPoints()
				duration:SetPoint("CENTER", 2, 1)
				duration:SetDrawLayer("ARTWORK")
				duration:SetFont(C.font.auras_font, C.font.auras_font_size, C.font.auras_font_style)
				duration:SetShadowOffset(C.font.auras_font_shadow and 1 or 0, C.font.auras_font_shadow and -1 or 0)

				hooksecurefunc(aura, "UpdateDuration", UpdateDuration)

				if C.aura.player_buff_mouseover then
					aura:SetParent(BuffsAnchor)
					aura:HookScript("OnEnter", function()
						BuffsAnchor:SetAlpha(1)
					end)
					aura:HookScript("OnLeave", function()
						BuffsAnchor:SetAlpha(alpha)
					end)
				end

				aura.isSkinned = true
			end

			aura.Icon:CropIcon()
			aura.Icon:SetDrawLayer("BORDER")
			aura.Icon:ClearAllPoints()
			aura.Icon:SetPoint("TOPLEFT", aura, "TOPLEFT", 2, -2)
			aura.Icon:SetPoint("BOTTOMRIGHT", aura, "BOTTOMRIGHT", -2, 2)

			aura.Count:ClearAllPoints()
			aura.Count:SetPoint("BOTTOMRIGHT", 2, 0)
			aura.Count:SetDrawLayer("ARTWORK")
			aura.Count:SetFont(C.font.auras_font, C.font.auras_font_size, C.font.auras_font_style)
			aura.Count:SetShadowOffset(C.font.auras_font_shadow and 1 or 0, C.font.auras_font_shadow and -1 or 0)

			aura:ClearAllPoints()
			if (index > 1) and (mod(index, rowbuffs) == 1) then
				aura:SetPoint("TOP", aboveBuff, "BOTTOM", 0, -3)
				aboveBuff = aura
			elseif index == 1 then
				aura:SetPoint("TOPRIGHT", BuffsAnchor, "TOPRIGHT", 0, 0)
				aboveBuff = aura
			else
				aura:SetPoint("RIGHT", previousBuff, "LEFT", -3, 0)
			end
			previousBuff = aura
		end

		styling = false
	end)

	-- Mouseover
	if C.aura.player_buff_mouseover then
		BuffsAnchor:SetAlpha(alpha)
		BuffsAnchor:HookScript("OnEnter", function()
			BuffsAnchor:SetAlpha(1)
		end)
		BuffsAnchor:HookScript("OnLeave", function()
			BuffsAnchor:SetAlpha(alpha)
		end)
	end

	return
end

if TemporaryEnchantFrame then
	TemporaryEnchantFrame:SetPoint("TOPRIGHT", BuffsAnchor, "TOPRIGHT", 0, 0)
end

if _G["TempEnchant2"] then
	_G["TempEnchant2"]:ClearAllPoints()
	_G["TempEnchant2"]:SetPoint("RIGHT", _G["TempEnchant1"], "LEFT", -3, 0)

	for i = 1, NUM_TEMP_ENCHANT_FRAMES do
		local buff = _G["TempEnchant"..i]
		local icon = _G["TempEnchant"..i.."Icon"]
		local border = _G["TempEnchant"..i.."Border"]
		local duration = _G["TempEnchant"..i.."Duration"]
		local charges = buff:CreateFontString(buff:GetName() .. "Charges", "ARTWORK", "NumberFontNormal")

		if border then border:Hide() end

		if i ~= 3 then
			buff:SetTemplate("Default")
			if C.aura.classcolor_border == true then
				buff:SetBackdropBorderColor(unpack(C.media.classborder_color))
			end
		end

		buff:SetSize(C.aura.player_buff_size, C.aura.player_buff_size)

		icon:CropIcon()
		icon:SetDrawLayer("BORDER")

		duration:ClearAllPoints()
		duration:SetPoint("CENTER", 1, 1)
		duration:SetDrawLayer("ARTWORK")
		duration:SetFont(C.font.auras_font, C.font.auras_font_size, C.font.auras_font_style)
		duration:SetShadowOffset(C.font.auras_font_shadow and 1 or 0, C.font.auras_font_shadow and -1 or 0)

		if C.aura.player_buff_mouseover then
			buff:SetParent(BuffsAnchor)
			buff:HookScript("OnEnter", function()
				BuffsAnchor:SetAlpha(1)
			end)
			buff:HookScript("OnLeave", function()
				BuffsAnchor:SetAlpha(alpha)
			end)
		end

		charges:ClearAllPoints()
		charges:SetPoint("BOTTOMLEFT", 1, 0)
		charges:SetFont(C.font.auras_font, C.font.auras_font_size, C.font.auras_font_style)
		charges:SetShadowOffset(C.font.auras_font_shadow and 1 or 0, C.font.auras_font_shadow and -1 or 0)
		charges:Hide()
	end
end

local function StyleBuffs(buttonName, index)
	local buff = _G[buttonName..index]
	local icon = _G[buttonName..index.."Icon"]
	local border = _G[buttonName..index.."Border"]
	local duration = _G[buttonName..index.."Duration"]
	local count = _G[buttonName..index.."Count"]

	if border then border:Hide() end

	if icon and not buff.isSkinned then
		buff:SetTemplate("Default")
		if C.aura.classcolor_border == true then
			buff:SetBackdropBorderColor(unpack(C.media.classborder_color))
		end

		buff:SetSize(C.aura.player_buff_size, C.aura.player_buff_size)

		icon:CropIcon()
		icon:SetDrawLayer("BORDER")

		duration:ClearAllPoints()
		duration:SetPoint("CENTER", 1, 1)
		duration:SetDrawLayer("ARTWORK")
		duration:SetFont(C.font.auras_font, C.font.auras_font_size, C.font.auras_font_style)
		duration:SetShadowOffset(C.font.auras_font_shadow and 1 or 0, C.font.auras_font_shadow and -1 or 0)

		count:ClearAllPoints()
		count:SetPoint("BOTTOMRIGHT", 1, 0)
		count:SetDrawLayer("ARTWORK")
		count:SetFont(C.font.auras_font, C.font.auras_font_size, C.font.auras_font_style)
		count:SetShadowOffset(C.font.auras_font_shadow and 1 or 0, C.font.auras_font_shadow and -1 or 0)

		buff.isSkinned = true
	end
end

local function UpdateBuffAnchors()
	local buttonName = "BuffButton"
	local previousBuff, aboveBuff
	local numBuffs = 0
	local slack = BuffFrame.numEnchants
	local mainhand, _, _, _, offhand = GetWeaponEnchantInfo()

	for index = 1, BUFF_ACTUAL_DISPLAY do
		StyleBuffs(buttonName, index)
		local buff = _G[buttonName..index]
		numBuffs = numBuffs + 1
		index = numBuffs + slack
		buff:ClearAllPoints()
		if (index > 1) and (mod(index, rowbuffs) == 1) then
			buff:SetPoint("TOP", aboveBuff, "BOTTOM", 0, -3)
			aboveBuff = buff
		elseif index == 1 then
			buff:SetPoint("TOPRIGHT", BuffsAnchor, "TOPRIGHT", 0, 0)
			aboveBuff = buff
		else
			if numBuffs == 1 then
				if mainhand and offhand and not UnitHasVehicleUI("player") then
					buff:SetPoint("RIGHT", TempEnchant2, "LEFT", -3, 0)
					aboveBuff = TempEnchant1
				elseif ((mainhand and not offhand) or (offhand and not mainhand)) and not UnitHasVehicleUI("player") then
					buff:SetPoint("RIGHT", TempEnchant1, "LEFT", -3, 0)
					aboveBuff = TempEnchant1
				else
					buff:SetPoint("TOPRIGHT", BuffsAnchor, "TOPRIGHT", 0, 0)
				end
			else
				buff:SetPoint("RIGHT", previousBuff, "LEFT", -3, 0)
			end
		end
		previousBuff = buff
	end
end

local function UpdateDebuffAnchors(buttonName, index)
	_G[buttonName..index]:Hide()
end

hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", UpdateBuffAnchors)
hooksecurefunc("DebuffButton_UpdateAnchors", UpdateDebuffAnchors)

local function UpdateDuration(buff, timeLeft)
	local duration = buff.duration
	if timeLeft and C.aura.show_timer == true then
		duration:SetFormattedText(GetFormattedTime(timeLeft))
		duration:SetVertexColor(1, 1, 1)
		duration:Show()
	else
		duration:Hide()
	end

	-- Temporary Weapon Enchants
	local name = buff:GetName()
	if not strmatch(name, "TempEnchant") or name == "TempEnchant3" then return end

	local index = strmatch(name, "%d+")
	local hasMainHandEnchant, _, mainHandCharges, _, hasOffHandEnchant, _, offHandCharges = GetWeaponEnchantInfo()
	local slotIndex = 16
	local chargeCount = mainHandCharges

	if index == "1" and (hasMainHandEnchant and hasOffHandEnchant) or (not hasMainHandEnchant and hasOffHandEnchant) then
		slotIndex = 17
		chargeCount = offHandCharges
	end

	local charges = _G["TempEnchant" .. index .. "Charges"]
	charges:SetText(chargeCount)

	if chargeCount > 0 then
		charges:Show()
	else
		charges:Hide()
	end

	local quality = GetInventoryItemQuality("player", slotIndex)

	if quality then
		local R, G, B = GetItemQualityColor(quality)
		buff:SetBackdropBorderColor(R, G, B)
	end
end

hooksecurefunc("AuraButton_UpdateDuration", UpdateDuration)

-- Mouseover
if C.aura.player_buff_mouseover then
	BuffsAnchor:SetAlpha(alpha)
	BuffsAnchor:HookScript("OnEnter", function()
		BuffsAnchor:SetAlpha(1)
	end)
	BuffsAnchor:HookScript("OnLeave", function()
		BuffsAnchor:SetAlpha(alpha)
	end)
end

-- Disable BuffFrame_OnUpdate that changes alpha
BuffFrame:SetScript("OnUpdate", nil)