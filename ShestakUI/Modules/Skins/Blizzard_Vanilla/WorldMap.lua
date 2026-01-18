local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	WorldMap skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	if C_AddOns.IsAddOnLoaded("Mapster") then return end

	WorldMapFrame:StripTextures()
	WorldMapFrame:CreateBackdrop("Transparent")
	WorldMapFrame.backdrop:SetPoint("TOPLEFT", 9, -4)
	WorldMapFrame.backdrop:SetPoint("BOTTOMRIGHT", -8, 26)

	WorldMapFrame.BorderFrame:SetFrameStrata(WorldMapFrame:GetFrameStrata())

	T.SkinDropDownBox(WorldMapContinentDropdown)
	T.SkinDropDownBox(WorldMapZoneDropdown)

	if WorldMapZoneMinimapDropdown then
		T.SkinDropDownBox(WorldMapZoneMinimapDropdown)
	end

	if WorldMapFrame.MiniBorderFrame then
		WorldMapFrame.MiniBorderFrame:StripTextures()
	end

	WorldMapZoneDropdown:SetPoint("LEFT", WorldMapContinentDropdown, "RIGHT", 3, 0)
	WorldMapZoomOutButton:SetPoint("LEFT", WorldMapZoneDropdown, "RIGHT", 6, 0)

	WorldMapZoomOutButton:SkinButton()

	T.SkinCloseButton(WorldMapFrameCloseButton, WorldMapFrame.backdrop)
	WorldMapFrameCloseButton.SetPoint = T.dummy

	if WorldMapFrame.MaximizeMinimizeFrame then
		T.SkinMaxMinFrame(WorldMapFrame.MaximizeMinimizeFrame, WorldMapFrameCloseButton)
		WorldMapFrame.MaximizeMinimizeFrame.SetPoint = T.dummy
	end

	if Questie_Toggle then
		Questie_Toggle:SkinButton()
		Questie_Toggle:ClearAllPoints()
		Questie_Toggle:SetHeight(22)
		Questie_Toggle:SetPoint("LEFT", WorldMapZoomOutButton, "RIGHT", 6, 0)
		Questie_Toggle.SetPoint = T.dummy
	end

	WorldMapFrame:RegisterEvent("PLAYER_LOGIN")
	WorldMapFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
	WorldMapFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
	WorldMapFrame:HookScript("OnEvent", function(self, event)
		if event == "PLAYER_LOGIN" then
			WorldMapFrame:Show()
			WorldMapFrame:Hide()
		elseif event == "PLAYER_REGEN_DISABLED" then
			if WorldMapFrame:IsShown() then
				HideUIPanel(WorldMapFrame)
			end
		end
	end)
end

tinsert(T.SkinFuncs["ShestakUI"], LoadSkin)
