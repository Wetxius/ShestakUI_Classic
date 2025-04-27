local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	TalentUI skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	_G["PlayerTalentFrame"]:StripTextures()
	_G["PlayerTalentFrame"]:CreateBackdrop("Transparent")
	_G["PlayerTalentFrame"].backdrop:SetPoint("TOPLEFT", 0, 0)
	_G["PlayerTalentFrame"].backdrop:SetPoint("BOTTOMRIGHT", -1, 2)

	_G["PlayerTalentFramePortrait"]:Hide()

	T.SkinCloseButton(_G["PlayerTalentFrameCloseButton"], _G["PlayerTalentFrame"].backdrop)

	_G["PlayerTalentFrameTitleText"]:ClearAllPoints()
	_G["PlayerTalentFrameTitleText"]:SetPoint("TOP", _G["PlayerTalentFrame"].backdrop, "TOP", 0, -6)

	local function HandleTabs()
		local lastTab
		for index, tab in next, TalentTabs do
			if index ~= 2 or HasPetUI() then
				tab:ClearAllPoints()
	
				if index == 1 then
					tab:Point('TOPLEFT', _G.PlayerTalentFrame, 'BOTTOMLEFT', -10, 0)
				else
					tab:Point('TOPLEFT', lastTab, 'TOPRIGHT', -19, 0)
				end
	
				lastTab = tab
			end
		end
	end

	for i = 1, MAX_TALENT_TABS do
		local panelName = 'PlayerTalentFramePanel'..i
		local panel = _G[panelName]
		panel:StripTextures()
		panel:CreateBackdrop("Transparent")
		panel.backdrop:SetPoint("TOPLEFT", 0, 0)
		panel.backdrop:SetPoint("BOTTOMRIGHT", 0, 0)
		panel.SelectTreeButton:SkinButton()
		-- Skin Talent Summary Panel
		panel.Summary:StripTextures()
		panel.Summary:CreateBackdrop()

		-- Skin Talent Tree Headers
		panel.HeaderIcon:StripTextures()
		panel.HeaderIcon.Icon:SkinIcon()
		panel.HeaderIcon.PointsSpent:SetPoint("LEFT", panel.RoleIcon2, "LEFT", -15, 0)
		panel.HeaderIcon.PointsSpent:SetFont(C.media.pixel_font, C.media.pixel_font_size, C.media.pixel_font_style)
		
		-- Skin Talent Icons
		for j = 1, MAX_NUM_TALENTS do
			local talentNum = panelName.."Talent"..j
			local talent = _G[talentNum]
	
			if talent then
			talent:StripTextures()
			talent:SetTemplate("Default")
			talent:StyleButton()

			talent.icon:SetInside()
			talent.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			talent.icon:SetDrawLayer("ARTWORK")

			talent.Rank:SetFont(C.media.pixel_font, C.media.pixel_font_size, C.media.pixel_font_style)
			end
		end
	end

	-- Skin some buttons
	_G["PlayerTalentFrameToggleSummariesButton"]:SkinButton()
	_G["PlayerTalentFrameActivateButton"]:SkinButton()
	_G["PlayerTalentFrameResetButton"]:SkinButton()
	_G["PlayerTalentFrameLearnButton"]:SkinButton()

	for i = 1, 5 do
		T.SkinTab(_G["PlayerTalentFrameTab"..i])
	end

	for i = 1, 3 do
		local tab = _G["PlayerSpecTab"..i]
		if tab then
			tab:GetRegions():SetSize(0.1, 0.1)
			tab:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
			tab:GetNormalTexture():ClearAllPoints()
			tab:GetNormalTexture():SetPoint("TOPLEFT", 2, -2)
			tab:GetNormalTexture():SetPoint("BOTTOMRIGHT", -2, 2)
			tab:CreateBackdrop("Default")
			tab.backdrop:SetAllPoints()
			tab:StyleButton(true)
		end
	end

	local f = CreateFrame("Frame")
	f:RegisterEvent("CHARACTER_POINTS_CHANGED")
	f:SetScript("OnEvent", function()
		PlayerTalentFrame_Update()
	end)
end

T.SkinFuncs["Blizzard_TalentUI"] = LoadSkin
