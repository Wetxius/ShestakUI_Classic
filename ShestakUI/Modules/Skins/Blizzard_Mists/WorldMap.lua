local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	WorldMap skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	if C_AddOns.IsAddOnLoaded("Mapster") then return end

	WorldMapFrame:StripTextures()
	WorldMapFrame:CreateBackdrop("Transparent")

	WorldMapFrame.BorderFrame:SetFrameStrata(WorldMapFrame:GetFrameStrata())


	WorldMapFrame.MiniBorderFrame:StripTextures()
	WorldMapFrame.MiniBorderFrame:CreateBackdrop("Transparent")

	T.SkinDropDownBox(WorldMapContinentDropdown)
	T.SkinDropDownBox(WorldMapZoneDropdown)
	T.SkinDropDownBox(WorldMapZoneMinimapDropdown)
	T.SkinCheckBox(WorldMapTrackQuest)


	T.SkinScrollBar(QuestScrollFrame.ScrollBar)
	T.SkinScrollBar(QuestMapDetailsScrollFrame.ScrollBar)

	WorldMapZoneDropdown:SetPoint("LEFT", WorldMapContinentDropdown, "RIGHT", 5, 0)
	WorldMapZoomOutButton:SetPoint("LEFT", WorldMapZoneDropdown, "RIGHT", 5, 0)

	WorldMapZoomOutButton:SkinButton()
	
	T.SkinMaxMinFrame(WorldMapFrame.MaximizeMinimizeFrame)

	if WorldMapMixin:IsMaximized() then 
		T.SkinCloseButton(WorldMapFrameCloseButton, WorldMapMixin.BorderFrame)
	else 
		T.SkinCloseButton(WorldMapFrameCloseButton, MiniBorderRight)
	end
	-- WorldMapFrameCloseButton:SetPoint("TOPRIGHT", WorldMapFrame.BorderFrame, "TOPRIGHT", 5, 4);

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
