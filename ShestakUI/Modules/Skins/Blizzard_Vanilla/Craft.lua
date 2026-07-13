local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	Craft skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	local frame = CraftFrame
	frame:StripTextures(true)
	frame:CreateBackdrop("Transparent")
	frame.backdrop:SetPoint("TOPLEFT", 10, -12)
	frame.backdrop:SetPoint("BOTTOMRIGHT", -32, 76)

	T.SkinCloseButton(CraftFrameCloseButton, frame.backdrop)

	T.SkinCheckBox(CraftFrameAvailableFilterCheckButton)

	CraftRankFrame:StripTextures()
	CraftRankFrame:CreateBackdrop("Overlay")
	CraftRankFrame:SetStatusBarTexture(C.media.blank)

	CraftCancelButton:SkinButton()
	CraftCreateButton:SkinButton()
	CraftCreateButton:ClearAllPoints()
	CraftCreateButton:SetPoint("RIGHT", CraftCancelButton, "LEFT", -2, 0)

	if frame.Dropdown then
		T.SkinDropDownBox(frame.Dropdown)
	end

	T.SkinScrollBar(CraftListScrollFrameScrollBar)
	T.SkinScrollBar(CraftDetailScrollFrameScrollBar)

	_G.CraftDetailScrollFrameTop:SetAlpha(0)
	_G.CraftDetailScrollFrameBottom:SetAlpha(0)

	CraftDetailHeaderLeft:SetAlpha(0)

	CraftIcon:SetTemplate("Default")

	for i = 1, _G.MAX_CRAFT_REAGENTS do
		local icon = _G["CraftReagent"..i.."IconTexture"]
		local count = _G["CraftReagent"..i.."Count"]
		local nameFrame = _G["CraftReagent"..i.."NameFrame"]

		icon:SkinIcon()

		nameFrame:SetAlpha(0)
	end

	hooksecurefunc("CraftFrame_SetSelection", function()
		if CraftIcon:GetNormalTexture() and not CraftIcon.styled then
			CraftIcon:GetNormalTexture():ClearAllPoints()
			CraftIcon:GetNormalTexture():SetPoint("TOPLEFT", 2, -2)
			CraftIcon:GetNormalTexture():SetPoint("BOTTOMRIGHT", -2, 2)
			CraftIcon:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
			CraftIcon.styled = true
		end
	end)
end

T.SkinFuncs["Blizzard_CraftUI"] = LoadSkin