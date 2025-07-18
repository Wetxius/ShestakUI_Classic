local T, C, L = unpack(ShestakUI)
if C.actionbar.enable ~= true then return end

----------------------------------------------------------------------------------------
--	Hide Blizzard ActionBars stuff(by Tukz)
----------------------------------------------------------------------------------------
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function()
	MainMenuBar:SetScale(0.00001)
	MainMenuBar:EnableMouse(false)

	if T.Classic then
		PetActionBarFrame:EnableMouse(false)
		StanceBarFrame:EnableMouse(false)
	else
		PetActionBar:EnableMouse(false)
		PetActionBar:UnregisterAllEvents()
		StanceBar:EnableMouse(false)
		StanceBar:UnregisterAllEvents()
	end

	if T.Wrath or T.Cata or T.Mists or T.Mainline then
		OverrideActionBar:SetScale(0.00001)
		OverrideActionBar:EnableMouse(false)
	end

	if T.Mainline then
		MicroButtonAndBagsBar:SetScale(0.00001)
		MicroButtonAndBagsBar:EnableMouse(false)
		MicroButtonAndBagsBar:ClearAllPoints()
		MicroButtonAndBagsBar:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, -99) -- Prevent scaling for right panels
		BagsBar:Hide()
		BagsBar:UnregisterAllEvents()
	end

	if T.Mainline then
		if not C.actionbar.micromenu then
			MicroMenu:Hide()
			TalentMicroButton:ClearAllPoints()
			TalentMicroButton:SetPoint("TOP", UIParent, "TOP", 0, 100) -- hide missing talent alert
		end
	end

	MainMenuBar:SetMovable(true)
	MainMenuBar:SetUserPlaced(true)
	MainMenuBar.ignoreFramePositionManager = true
	MainMenuBar:SetAttribute("ignoreFramePositionManager", true)

	local elements = {
		MainMenuBar, MainMenuBarArtFrame, OverrideActionBar, PossessBarFrame, PetActionBarFrame, StanceBarFrame,
		MultiBarBottomLeft.QuickKeybindGlow, MultiBarLeft.QuickKeybindGlow, MultiBarBottomRight.QuickKeybindGlow, MultiBarRight.QuickKeybindGlow,
		StatusTrackingBarManager
	}

	if T.Mainline then
		if not C_ClassTrial.IsClassTrialCharacter() then
			tinsert(elements, IconIntroTracker)
		end
	end

	for _, element in pairs(elements) do
		if element.UnregisterAllEvents then
			element:UnregisterAllEvents()
		end

		if element ~= MainMenuBar then
			element:Hide()
		end
		element:SetAlpha(0)
	end

	if T.Wrath or T.Cata or T.Mists or T.Mainline then
		for i = 1, 6 do
			local b = _G["OverrideActionBarButton"..i]
			b:UnregisterAllEvents()
			b:SetAttribute("statehidden", true)
			b:SetAttribute("showgrid", 1)
		end
	end

	if T.Vanilla then
		hooksecurefunc("PlayerTalentFrame_LoadUI", function()
			PlayerTalentFrame:UnregisterEvent("CHARACTER_POINTS_CHANGED")
		end)
	else
		hooksecurefunc("TalentFrame_LoadUI", function()
			if T.Classic then
				PlayerTalentFrame:UnregisterEvent("CHARACTER_POINTS_CHANGED")
				if T.Wrath or T.Cata or T.Mists then
					PlayerTalentFrame:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
				end
			else
				PlayerTalentFrame:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
			end
		end)
	end

	-- Fixed SetPointBase and ShowBase taints after finish Pet Battle, entering new combat and summon Hunter pet.
	ActionBarController:UnregisterEvent("UPDATE_VEHICLE_ACTIONBAR")
	ActionBarController:UnregisterEvent("UPDATE_OVERRIDE_ACTIONBAR")
end)

----------------------------------------------------------------------------------------
--	Set mouseover for bars
----------------------------------------------------------------------------------------
function RightBarMouseOver(alpha)
	RightActionBarAnchor:SetAlpha(alpha)
	PetActionBarAnchor:SetAlpha(alpha)
	StanceBarAnchor:SetAlpha(alpha)

	if MultiBarLeft:IsShown() then
		for i = 1, 12 do
			local b = _G["MultiBarLeftButton"..i]
			b:SetAlpha(alpha)
			local c = _G["MultiBarLeftButton"..i.."Cooldown"]
			T.HideSpiral(c, alpha)
		end
		MultiBarLeft:SetAlpha(alpha)
	end

	if MultiBarRight:IsShown() then
		for i = 1, 12 do
			local b = _G["MultiBarRightButton"..i]
			b:SetAlpha(alpha)
			local c = _G["MultiBarRightButton"..i.."Cooldown"]
			T.HideSpiral(c, alpha)
		end
		MultiBarRight:SetAlpha(alpha)
	end

	if C.actionbar.rightbars > 2 then
		if T.Classic then
			if MultiBarBottomRight:IsShown() then
				for i = 1, 12 do
					local b = _G["MultiBarBottomRightButton"..i]
					b:SetAlpha(alpha)
					local c = _G["MultiBarBottomRightButton"..i.."Cooldown"]
					T.HideSpiral(c, alpha)
				end
				MultiBarBottomRight:SetAlpha(alpha)
			end
		else
			if MultiBar5:IsShown() then
				for i = 1, 12 do
					local b = _G["MultiBar5Button"..i]
					b:SetAlpha(alpha)
					local c = _G["MultiBar5Button"..i.."Cooldown"]
					T.HideSpiral(c, alpha)
				end
				MultiBar5:SetAlpha(alpha)
			end
		end
	end

	if C.actionbar.petbar_horizontal == false and C.actionbar.petbar_hide == false then
		if PetHolder:IsShown() then
			for i = 1, NUM_PET_ACTION_SLOTS do
				local b = _G["PetActionButton"..i]
				b:SetAlpha(alpha)
				local c = _G["PetActionButton"..i.."Cooldown"]
				T.HideSpiral(c, alpha)
			end
			PetHolder:SetAlpha(alpha)
		end
	end

	if C.actionbar.stancebar_horizontal == false and C.actionbar.stancebar_hide == false then
		if StanceHolder:IsShown() then
			for i = 1, 10 do
				local b = _G["StanceButton"..i]
				b:SetAlpha(alpha)
				local c = _G["StanceButton"..i.."Cooldown"]
				T.HideSpiral(c, alpha)
			end
			StanceHolder:SetAlpha(alpha)
		end
	end
end

function StanceBarMouseOver(alpha)
	for i = 1, 10 do
		local b = _G["StanceButton"..i]
		b:SetAlpha(alpha)
		local c = _G["StanceButton"..i.."Cooldown"]
		T.HideSpiral(c, alpha)
	end
	StanceHolder:SetAlpha(alpha)
end

function PetBarMouseOver(alpha)
	for i = 1, NUM_PET_ACTION_SLOTS do
		local b = _G["PetActionButton"..i]
		b:SetAlpha(alpha)
		local c = _G["PetActionButton"..i.."Cooldown"]
		T.HideSpiral(c, alpha)
	end
	PetHolder:SetAlpha(alpha)
end

if C.actionbar.rightbars_mouseover == true then
	RightActionBarAnchor:SetAlpha(0)
	RightActionBarAnchor:SetScript("OnEnter", function() RightBarMouseOver(1) end)
	RightActionBarAnchor:SetScript("OnLeave", function() if not HoverBind.enabled then RightBarMouseOver(0) end end)
end

function BottomBarMouseOver(alpha)
	for i = 1, 12 do
		local b = _G["ActionButton"..i]
		b:SetAlpha(alpha)
		local c = _G["ActionButton"..i.."Cooldown"]
		T.HideSpiral(c, alpha)
	end

	if C.actionbar.bottombars > 1 and MultiBarBottomLeft:IsShown() then
		for i = 1, 12 do
			local b = _G["MultiBarBottomLeftButton"..i]
			b:SetAlpha(alpha)
			local c = _G["MultiBarBottomLeftButton"..i.."Cooldown"]
			T.HideSpiral(c, alpha)
		end
	end

	if C.actionbar.bottombars > 2 and MultiBarBottomRight:IsShown() then
		if C.actionbar.toggle_mode == true and ShestakUISettingsPerChar.BottomBars == 1 then
			for i = 4, 6 do
				local b = _G["MultiBarBottomRightButton"..i]
				b:SetAlpha(alpha)
				local c = _G["MultiBarBottomRightButton"..i.."Cooldown"]
				T.HideSpiral(c, alpha)
			end

			for i = 10, 12 do
				local b = _G["MultiBarBottomRightButton"..i]
				b:SetAlpha(alpha)
				local c = _G["MultiBarBottomRightButton"..i.."Cooldown"]
				T.HideSpiral(c, alpha)
			end
		else
			for i = 1, 12 do
				local b = _G["MultiBarBottomRightButton"..i]
				b:SetAlpha(alpha)
				local c = _G["MultiBarBottomRightButton"..i.."Cooldown"]
				T.HideSpiral(c, alpha)
			end
		end
	end
end

if C.actionbar.bottombars_mouseover then
	ActionBarAnchor:SetScript("OnEnter", function() BottomBarMouseOver(1) end)
	ActionBarAnchor:SetScript("OnLeave", function() if not HoverBind.enabled then BottomBarMouseOver(0) end end)

	if C.actionbar.split_bars == true then
		SplitBarLeft:SetScript("OnEnter", function() BottomBarMouseOver(1) end)
		SplitBarLeft:SetScript("OnLeave", function() if not HoverBind.enabled then BottomBarMouseOver(0) end end)

		SplitBarRight:SetScript("OnEnter", function() BottomBarMouseOver(1) end)
		SplitBarRight:SetScript("OnLeave", function() if not HoverBind.enabled then BottomBarMouseOver(0) end end)
	end
end

function Bar1MouseOver(alpha)
	for i = 1, 12 do
		local b = _G["ActionButton"..i]
		b:SetAlpha(alpha)
		local c = _G["ActionButton"..i.."Cooldown"]
		T.HideSpiral(c, alpha)
	end
end

function Bar2MouseOver(alpha)
	if MultiBarBottomLeft:IsShown() then
		for i = 1, 12 do
			local b = _G["MultiBarBottomLeftButton"..i]
			b:SetAlpha(alpha)
			local c = _G["MultiBarBottomLeftButton"..i.."Cooldown"]
			T.HideSpiral(c, alpha)
		end
	end
end

function Bar3MouseOver(alpha)
	if MultiBarLeft:IsShown() then
		for i = 1, 12 do
			local b = _G["MultiBarLeftButton"..i]
			b:SetAlpha(alpha)
			local c = _G["MultiBarLeftButton"..i.."Cooldown"]
			T.HideSpiral(c, alpha)
		end
	end
end

function Bar4MouseOver(alpha)
	if MultiBarRight:IsShown() then
		for i = 1, 12 do
			local b = _G["MultiBarRightButton"..i]
			b:SetAlpha(alpha)
			local c = _G["MultiBarRightButton"..i.."Cooldown"]
			T.HideSpiral(c, alpha)
		end
	end
end

function Bar5MouseOver(alpha)
	if MultiBarBottomRight:IsShown() then
		for i = 1, 12 do
			local b = _G["MultiBarBottomRightButton"..i]
			b:SetAlpha(alpha)
			local c = _G["MultiBarBottomRightButton"..i.."Cooldown"]
			T.HideSpiral(c, alpha)
		end
	end
end

function Bar6MouseOver(alpha)
	if MultiBar5:IsShown() then
		for i = 1, 12 do
			local b = _G["MultiBar6Button"..i]
			b:SetAlpha(alpha)
			local c = _G["MultiBar6Button"..i.."Cooldown"]
			T.HideSpiral(c, alpha)
		end
	end
end

function Bar7MouseOver(alpha)
	if MultiBar6:IsShown() then
		for i = 1, 12 do
			local b = _G["MultiBar6Button"..i]
			b:SetAlpha(alpha)
			local c = _G["MultiBar6Button"..i.."Cooldown"]
			T.HideSpiral(c, alpha)
		end
	end
end

function Bar8MouseOver(alpha)
	if MultiBar7:IsShown() then
		for i = 1, 12 do
			local b = _G["MultiBar7Button"..i]
			b:SetAlpha(alpha)
			local c = _G["MultiBar7Button"..i.."Cooldown"]
			T.HideSpiral(c, alpha)
		end
	end
end

----------------------------------------------------------------------------------------
--	Fix cooldown spiral alpha (WoD bug)
----------------------------------------------------------------------------------------
function T.HideSpiral(f, alpha)
	f:SetSwipeColor(0, 0, 0, alpha * 0.8)
	f:SetDrawBling(alpha == 1)
end

local EventSpiral = CreateFrame("Frame")
EventSpiral:RegisterEvent("PLAYER_ENTERING_WORLD")
EventSpiral:SetScript("OnEvent", function()
	if C.actionbar.rightbars_mouseover == true then
		RightBarMouseOver(0)
	end

	if C.actionbar.petbar_mouseover == true and C.actionbar.petbar_horizontal == true and C.actionbar.petbar_hide ~= true then
		PetBarMouseOver(0)
	end

	if C.actionbar.stancebar_mouseover == true and C.actionbar.stancebar_horizontal == true and C.actionbar.stancebar_hide ~= true then
		StanceBarMouseOver(C.actionbar.stancebar_mouseover_alpha)
	end

	if C.actionbar.bottombars_mouseover then
		BottomBarMouseOver(0)
	end

	if C.actionbar.editor then
		if C.actionbar.bar1_mouseover then
			Bar1MouseOver(0)
		end

		if C.actionbar.bar2_mouseover then
			Bar2MouseOver(0)
		end

		if C.actionbar.bar3_mouseover then
			Bar3MouseOver(0)
		end

		if C.actionbar.bar4_mouseover then
			Bar4MouseOver(0)
		end

		if C.actionbar.bar5_mouseover then
			Bar5MouseOver(0)
		end

		if T.Mainline and C.actionbar.bar6_mouseover then
			Bar6MouseOver(0)
		end
	end

	if T.Mainline and C.actionbar.bar7_mouseover then
		Bar7MouseOver(0)
	end

	if T.Mainline and C.actionbar.bar8_mouseover then
		Bar8MouseOver(0)
	end

	EventSpiral:UnregisterEvent("PLAYER_ENTERING_WORLD")
end)

if (C.actionbar.rightbars_mouseover == true and C.actionbar.petbar_horizontal == false and C.actionbar.petbar_hide == false) or (C.actionbar.petbar_mouseover == true and C.actionbar.petbar_horizontal == true and C.actionbar.petbar_hide == false) then
	local EventPetSpiral = CreateFrame("Frame")
	EventPetSpiral:RegisterEvent("PET_BAR_UPDATE_COOLDOWN")
	EventPetSpiral:SetScript("OnEvent", function()
		for i = 1, NUM_PET_ACTION_SLOTS do
			local c = _G["PetActionButton"..i.."Cooldown"]
			T.HideSpiral(c, 0)
		end
		EventPetSpiral:UnregisterEvent("PET_BAR_UPDATE_COOLDOWN")
	end)
end

----------------------------------------------------------------------------------------
--	Show grid function
----------------------------------------------------------------------------------------
if T.Classic then
	local frame = CreateFrame("Frame")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:SetScript("OnEvent", function(self)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		SetActionBarToggles(1, 1, 1, 1, 0)
		if C.actionbar.show_grid == true then
			SetCVar("alwaysShowActionBars", 1)
			for i = 1, 12 do
				local reason = ACTION_BUTTON_SHOW_GRID_REASON_EVENT or 2
				local button = _G[format("ActionButton%d", i)]
				button.noGrid = nil
				button:SetAttribute("showgrid", 1)
				ActionButton_ShowGrid(button, reason)
				button:SetAttribute("statehidden", true)

				button = _G[format("MultiBarRightButton%d", i)]
				button.noGrid = nil
				button:SetAttribute("showgrid", 1)
				ActionButton_ShowGrid(button, reason)
				button:SetAttribute("statehidden", true)

				button = _G[format("MultiBarBottomRightButton%d", i)]
				button.noGrid = nil
				button:SetAttribute("showgrid", 1)
				ActionButton_ShowGrid(button, reason)
				button:SetAttribute("statehidden", true)

				button = _G[format("MultiBarLeftButton%d", i)]
				button.noGrid = nil
				button:SetAttribute("showgrid", 1)
				ActionButton_ShowGrid(button, reason)
				button:SetAttribute("statehidden", true)

				button = _G[format("MultiBarBottomLeftButton%d", i)]
				button.noGrid = nil
				button:SetAttribute("showgrid", 1)
				ActionButton_ShowGrid(button, reason)
				button:SetAttribute("statehidden", true)

				if T.Wrath or T.Cata or T.Mists then
					if _G["VehicleMenuBarActionButton"..i] then
						_G["VehicleMenuBarActionButton"..i]:SetAttribute("statehidden", true)
					end
				end
			end
		else
			SetCVar("alwaysShowActionBars", 0)
			
		end
	end)
else
	if not C.actionbar.show_grid then
		local allButtons = {}
		for i = 1, 12 do
			local button = _G[format("ActionButton%d", i)]
			tinsert(allButtons, button)

			local button = _G[format("MultiBarRightButton%d", i)]
			tinsert(allButtons, button)

			button = _G[format("MultiBarBottomRightButton%d", i)]
			tinsert(allButtons, button)

			button = _G[format("MultiBarLeftButton%d", i)]
			tinsert(allButtons, button)

			button = _G[format("MultiBarBottomLeftButton%d", i)]
			tinsert(allButtons, button)

			button = _G[format("MultiBar5Button%d", i)]
			tinsert(allButtons, button)

			button = _G[format("MultiBar6Button%d", i)]
			tinsert(allButtons, button)

			button = _G[format("MultiBar7Button%d", i)]
			tinsert(allButtons, button)
		end

		local frame = CreateFrame("Frame")
		frame:RegisterEvent("ACTIONBAR_SHOWGRID")
		frame:RegisterEvent("ACTIONBAR_HIDEGRID")
		frame:RegisterEvent("PLAYER_ENTERING_WORLD")
		frame:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
		frame:RegisterEvent("ACTIONBAR_UPDATE_STATE")
		frame:RegisterEvent("UPDATE_VEHICLE_ACTIONBAR")
		frame:SetScript("OnEvent", function(self, event)
			if event == "ACTIONBAR_SHOWGRID" then
				for i = 1, #allButtons do
					allButtons[i]:SetAlpha(1)
				end
			elseif event == "ACTIONBAR_PAGE_CHANGED" or event == "ACTIONBAR_UPDATE_STATE" or event == "UPDATE_VEHICLE_ACTIONBAR" then
				C_Timer.After(0.02, function()
					for i = 1, #allButtons do
						local button = allButtons[i]
						button:SetAlpha(1)
						if not button:HasAction() then
							button:SetAlpha(0)
						end
					end
				end)
			else
				C_Timer.After(0.05, function()
					for i = 1, #allButtons do
						local button = allButtons[i]
						if not button:HasAction() then
							button:SetAlpha(0)
						end
					end
				end)
			end
		end)
	end
end

----------------------------------------------------------------------------------------
--	Pet/StanceBar style functions
----------------------------------------------------------------------------------------
T.ShiftBarUpdate = function()
	local numForms = GetNumShapeshiftForms()
	local texture, isActive, isCastable
	local button, icon, cooldown
	local start, duration, enable
	for i = 1, 10 do
		button = _G["StanceButton"..i]
		icon = _G["StanceButton"..i.."Icon"]
		if i <= numForms then
			texture, isActive, isCastable = GetShapeshiftFormInfo(i)
			icon:SetTexture(texture)

			cooldown = _G["StanceButton"..i.."Cooldown"]
			if texture then
				cooldown:SetAlpha(1)
			else
				cooldown:SetAlpha(0)
			end

			start, duration, enable = GetShapeshiftFormCooldown(i)
			CooldownFrame_Set(cooldown, start, duration, enable)

			if isActive then
				if T.Classic then
					StanceBarFrame.lastSelected = button:GetID()
				end
				button:SetChecked(true)
			else
				button:SetChecked(false)
			end

			if isCastable then
				icon:SetVertexColor(1.0, 1.0, 1.0)
			else
				icon:SetVertexColor(0.4, 0.4, 0.4)
			end
		end
	end
end

T.PetBarUpdate = function()
	local petActionButton, petActionIcon, petAutoCastableTexture, petAutoCastShine
	for i = 1, NUM_PET_ACTION_SLOTS, 1 do
		local buttonName = "PetActionButton"..i
		petActionButton = _G[buttonName]
		petActionIcon = _G[buttonName.."Icon"]
		petAutoCastableTexture = _G["PetActionButton"..i].AutoCastable or _G[buttonName.."AutoCastable"]
		petAutoCastShine = _G[buttonName.."Shine"]
		local name, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i)

		if not isToken then
			petActionIcon:SetTexture(texture)
			petActionButton.tooltipName = name
		else
			petActionIcon:SetTexture(_G[texture])
			petActionButton.tooltipName = _G[name]
		end

		petActionButton.isToken = isToken

		if isActive and name ~= "PET_ACTION_FOLLOW" then
			petActionButton:SetChecked(true)
			if IsPetAttackAction(i) then
				if T.Classic then
					PetActionButton_StartFlash(petActionButton)
				else
					petActionButton:StartFlash()
					petActionButton:GetCheckedTexture():SetAlpha(0.5)
				end
			end
		else
			petActionButton:SetChecked(false)
			if IsPetAttackAction(i) then
				if T.Classic then
					PetActionButton_StopFlash(petActionButton)
				else
					petActionButton:StopFlash()
					petActionButton:GetCheckedTexture():SetAlpha(1.0)
				end
			end
		end

		if autoCastAllowed then
			petAutoCastableTexture:Show()
		else
			petAutoCastableTexture:Hide()
		end

		if autoCastEnabled then
			AutoCastShine_AutoCastStart(petAutoCastShine)
		else
			AutoCastShine_AutoCastStop(petAutoCastShine)
		end

		if name then
			if not C.actionbar.show_grid then
				petActionButton:SetAlpha(1)
			end
		else
			if not C.actionbar.show_grid then
				petActionButton:SetAlpha(0)
			end
		end

		if texture then
			if GetPetActionSlotUsable(i) then
				SetDesaturation(petActionIcon, nil)
			else
				SetDesaturation(petActionIcon, 1)
			end
			petActionIcon:Show()
		else
			petActionIcon:Hide()
		end

		if not PetHasActionBar() and texture and name ~= "PET_ACTION_FOLLOW" then
			if T.Classic then
				PetActionButton_StopFlash(petActionButton)
			else
				petActionButton:StopFlash()
			end
			SetDesaturation(petActionIcon, 1)
			petActionButton:SetChecked(false)
		end
	end
end