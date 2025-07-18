local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	Character skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	T.SkinCloseButton(CharacterFrameCloseButton)

	-- Azerite Items
	local function UpdateAzeriteItem(self)
		if not self.styled then
			self.AzeriteTexture:SetAlpha(0)
			self.RankFrame.Texture:SetTexture(0)
			self.RankFrame.Label:SetFontObject("SystemFont_Outline_Small")
			self.RankFrame.Label:SetShadowOffset(0, 0)
			self.RankFrame.Label:SetPoint("CENTER", self.RankFrame.Texture, 0, 2)

			self.styled = true
		end
		self:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.3)
		self:GetHighlightTexture():SetPoint("TOPLEFT", 2, -2)
		self:GetHighlightTexture():SetPoint("BOTTOMRIGHT", -2, 2)
	end

	local function UpdateAzeriteEmpoweredItem(self)
		self.AzeriteTexture:SetAtlas("AzeriteIconFrame")
		self.AzeriteTexture:SetTexCoord(0.05, 0.95, 0.05, 0.95)
		self.AzeriteTexture:SetPoint("TOPLEFT", 2, -2)
		self.AzeriteTexture:SetPoint("BOTTOMRIGHT", -2, 2)
		self.AzeriteTexture:SetDrawLayer("BORDER", 1)
	end

	local slots = {
		"HeadSlot",
		"NeckSlot",
		"ShoulderSlot",
		"BackSlot",
		"ChestSlot",
		"ShirtSlot",
		"TabardSlot",
		"WristSlot",
		"HandsSlot",
		"WaistSlot",
		"LegsSlot",
		"FeetSlot",
		"Finger0Slot",
		"Finger1Slot",
		"Trinket0Slot",
		"Trinket1Slot",
		"MainHandSlot",
		"SecondaryHandSlot",
		"RangedSlot"
	}

	if T.Mainline then
		select(16, CharacterMainHandSlot:GetRegions()):Hide()
		select(16, CharacterSecondaryHandSlot:GetRegions()):Hide()
	end

	for _, i in pairs(slots) do
		local slot = _G["Character"..i]

		if slot then
			_G["Character"..i.."Frame"]:Hide()
			local icon = _G["Character"..i.."IconTexture"]
			local border = _G["Character"..i].IconBorder

			border:SetAlpha(0)
			slot:StyleButton()
			slot:SetNormalTexture(0)
			slot.SetHighlightTexture = T.dummy
			slot:GetHighlightTexture().SetAllPoints = T.dummy
			slot:SetFrameLevel(slot:GetFrameLevel() + 2)
			slot:SetTemplate("Default")

			icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			icon:ClearAllPoints()
			icon:SetPoint("TOPLEFT", 2, -2)
			icon:SetPoint("BOTTOMRIGHT", -2, 2)

			if slot.popoutButton:GetPoint() == "TOP" then
				slot.popoutButton:SetPoint("TOP", slot, "BOTTOM", 0, 2)
			else
				slot.popoutButton:SetPoint("LEFT", slot, "RIGHT", -2, 0)
			end

			if T.Mainline then
				hooksecurefunc(slot, "DisplayAsAzeriteItem", UpdateAzeriteItem)
				hooksecurefunc(slot, "DisplayAsAzeriteEmpoweredItem", UpdateAzeriteEmpoweredItem)
			end
		end
	end

	-- Strip Textures
	local charframe = {
		CharacterFrame,
		CharacterModelScene,
		CharacterFrameInset,
		CharacterStatsPane,
		CharacterFrameInsetRight,
		PaperDollSidebarTabs,
		-- PaperDollEquipmentManagerPane
	}

	for i = 1, #charframe do
		local button = charframe[i]
		button:StripTextures()
	end

	EquipmentFlyoutFrameHighlight:Kill()
	EquipmentFlyoutFrame.NavigationFrame:StripTextures()
	EquipmentFlyoutFrame.NavigationFrame.BottomBackground:Hide()
	EquipmentFlyoutFrame.NavigationFrame:SetTemplate("Transparent")
	EquipmentFlyoutFrame.NavigationFrame:SetPoint("TOPLEFT", EquipmentFlyoutFrameButtons, "BOTTOMLEFT", 3, -1)
	EquipmentFlyoutFrame.NavigationFrame:SetPoint("TOPRIGHT", EquipmentFlyoutFrameButtons, "BOTTOMRIGHT", 0, -1)
	T.SkinNextPrevButton(EquipmentFlyoutFrame.NavigationFrame.PrevButton)
	T.SkinNextPrevButton(EquipmentFlyoutFrame.NavigationFrame.NextButton)

	local function SkinItemFlyouts()
		EquipmentFlyoutFrameButtons:StripTextures()

		for i = 1, 23 do
			local button = _G["EquipmentFlyoutFrameButton"..i]
			local icon = _G["EquipmentFlyoutFrameButton"..i.."IconTexture"]
			if button then
				button:StyleButton()
				button.IconBorder:Hide()

				icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				button:GetNormalTexture():SetTexture(0)

				icon:ClearAllPoints()
				icon:SetPoint("TOPLEFT", 2, -2)
				icon:SetPoint("BOTTOMRIGHT", -2, 2)
				button:SetFrameStrata("DIALOG")
				if not button.backdrop then
					button:CreateBackdrop("Default")
					button.backdrop:SetAllPoints()
				end
			end
		end
	end

	-- Swap item flyout frame (shown when holding alt over a slot)
	EquipmentFlyoutFrame:HookScript("OnShow", SkinItemFlyouts)
	hooksecurefunc("EquipmentFlyout_Show", SkinItemFlyouts)

	-- Icon in upper right corner of character frame
	CharacterFrame:SetTemplate("Transparent")
	CharacterFramePortrait:Kill()
	CharacterModelFrameBackgroundOverlay:SetColorTexture(0, 0, 0)
	CharacterModelScene:CreateBackdrop("Default")
	CharacterModelScene.backdrop:SetPoint("TOPLEFT", -3, 4)
	CharacterModelScene.backdrop:SetPoint("BOTTOMRIGHT", 4, 0)

	-- Unit Background Texture
	CharacterModelFrameBackgroundTopLeft:SetPoint("TOPLEFT", CharacterModelScene.backdrop, "TOPLEFT", 2, -2)
	CharacterModelFrameBackgroundTopRight:SetPoint("TOPRIGHT", CharacterModelScene.backdrop, "TOPRIGHT", -2, -2)
	CharacterModelFrameBackgroundBotLeft:SetPoint("BOTTOMLEFT", CharacterModelScene.backdrop, "BOTTOMLEFT", 2, -50)
	CharacterModelFrameBackgroundBotRight:SetPoint("BOTTOMRIGHT", CharacterModelScene.backdrop, "BOTTOMRIGHT", -2, -50)

	local scrollbars = {
		PaperDollFrame.TitleManagerPane.ScrollBar,
		PaperDollFrame.EquipmentManagerPane.ScrollBar,
		ReputationListScrollFrame,
		ReputationListScrollFrame.ScrollBar,	
		TokenFrameContainer.scrollBar,
		CharacterStatsPane.ScrollBar
	}

	for i = 1, #scrollbars do
		T.SkinScrollBar(scrollbars[i])
	end

	local function SkinStatsPane(frame)
		frame:StripTextures()

		local bg = frame.Background
		bg:SetTexture(C.media.blank)
		bg:ClearAllPoints()
		bg:SetPoint("CENTER", 0, -15)
		bg:SetSize(165, 1)
		bg:SetVertexColor(unpack(C.media.border_color))

		local border = CreateFrame("Frame", "$parentOuterBorder", frame, BackdropTemplateMixin and "BackdropTemplate")
		border:SetPoint("TOPLEFT", bg, "TOPLEFT", -T.mult, T.mult)
		border:SetPoint("BOTTOMRIGHT", bg, "BOTTOMRIGHT", T.mult, -T.mult)
		border:SetFrameLevel(frame:GetFrameLevel() + 1)
		border:SetBackdrop({
			edgeFile = C.media.blank, edgeSize = T.mult,
			insets = {left = T.mult, right = T.mult, top = T.mult, bottom = T.mult}
		})
		border:SetBackdropBorderColor(unpack(C.media.backdrop_color))
	end

	if T.Mainline then
		CharacterStatsPane.ItemLevelFrame.Value:SetFont(C.media.normal_font, 18, "")
		CharacterStatsPane.ItemLevelFrame.Value:SetShadowOffset(1, -1)
		CharacterStatsPane.ItemLevelFrame.Background:Hide()

		SkinStatsPane(CharacterStatsPane.ItemLevelCategory)
		SkinStatsPane(CharacterStatsPane.AttributesCategory)
		SkinStatsPane(CharacterStatsPane.EnhancementsCategory)
	end

	--Skin Stats Pane for Cata Classic
	if T.Classic then
		for i = 1, 7 do
			local paneNumber = _G["CharacterStatsPaneCategory"..i]
			if paneNumber then
				paneNumber:StripTextures()
			end
		end
	end

	-- Titles
	hooksecurefunc(_G.PaperDollFrame.TitleManagerPane.ScrollBox, "Update", function(frame)
		for _, child in next, {frame.ScrollTarget:GetChildren()} do
			if not child.isSkinned then
				child:DisableDrawLayer("BACKGROUND")
				child.isSkinned = true
			end
		end
	end)

	-- Equipment Manager
	PaperDollFrameEquipSet:SkinButton()
	PaperDollFrameSaveSet:SkinButton()
	PaperDollFrameEquipSet:SetWidth(PaperDollFrameEquipSet:GetWidth() - 8)
	PaperDollFrameSaveSet:SetWidth(PaperDollFrameSaveSet:GetWidth() - 8)
	PaperDollFrameEquipSet:SetPoint("TOPLEFT", PaperDollFrame.EquipmentManagerPane, "TOPLEFT", 8, 0)
	PaperDollFrameSaveSet:SetPoint("LEFT", PaperDollFrameEquipSet, "RIGHT", 4, 0)
	hooksecurefunc(_G.PaperDollFrame.EquipmentManagerPane.ScrollBox, "Update", function(frame)
		for _, child in next, {frame.ScrollTarget:GetChildren()} do
			if child.icon and not child.isSkinned then

				child.BgTop:SetTexture(0)
				child.BgBottom:SetTexture(0)
				child.BgMiddle:SetTexture(0)

				child.Check:SetTexture(0)
				child.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

				if not child.backdrop then
					child:CreateBackdrop("Default")
				end

				child.backdrop:SetPoint("TOPLEFT", child.icon, "TOPLEFT", -2, 2)
				child.backdrop:SetPoint("BOTTOMRIGHT", child.icon, "BOTTOMRIGHT", 2, -2)
				child.icon:SetParent(child.backdrop)

				-- Making all icons the same size and position because otherwise BlizzardUI tries to attach itself to itself when it refreshes
				child.icon:SetPoint("LEFT", child, "LEFT", 4, 0)
				child.icon.SetPoint = T.dummy
				child.icon:SetSize(36, 36)
				child.icon.SetSize = T.dummy

				child.isSkinned = true
			end
		end
	end)

	GearManagerPopupFrame:HookScript("OnShow", function(frame)
		if not frame.isSkinned then
			T.SkinIconSelectionFrame(frame)
		end
	end)

	-- Handle Tabs at bottom of character frame
	for i = 1, 4 do
		T.SkinTab(_G["CharacterFrameTab"..i])
	end

	-- Buttons used to toggle between equipment manager, titles, and character stats
	local function FixSidebarTabCoords()
		for i = 1, #PAPERDOLL_SIDEBARS do
			local tab = _G["PaperDollSidebarTab"..i]
			if tab then
				tab.Highlight:SetColorTexture(1, 1, 1, 0.3)
				tab.Highlight:SetPoint("TOPLEFT", 3, -4)
				tab.Highlight:SetPoint("BOTTOMRIGHT", -1, 0)
				tab.Hider:SetColorTexture(0.4, 0.4, 0.4, 0.4)
				tab.Hider:SetPoint("TOPLEFT", 3, -4)
				tab.Hider:SetPoint("BOTTOMRIGHT", -1, 0)
				tab.TabBg:Kill()

				if i == 1 then
					for i = 1, tab:GetNumRegions() do
						local region = select(i, tab:GetRegions())
						region:SetTexCoord(0.16, 0.86, 0.16, 0.86)
						region.SetTexCoord = T.dummy
					end
				end
				tab:CreateBackdrop("Default")
				tab.backdrop:SetPoint("TOPLEFT", 1, -2)
				tab.backdrop:SetPoint("BOTTOMRIGHT", 1, -2)
			end
		end
	end
	hooksecurefunc("PaperDollFrame_UpdateSidebarTabs", FixSidebarTabCoords)

	-- Reputation
	if T.Classic then
		local function UpdateFactionSkins()
			-- ReputationListScrollFrame:StripTextures()
			ReputationFrame:StripTextures(true)
			local factionOffset = FauxScrollFrame_GetOffset(ReputationListScrollFrame)
			for i = 1, GetNumFactions() do
				local statusbar = _G["ReputationBar"..i.."ReputationBar"]
				local button = _G["ReputationBar"..i.."ExpandOrCollapseButton"]
				local factionIndex = factionOffset + i
				local _, _, _, _, _, _, _, _, _, isCollapsed = GetFactionInfo(factionIndex)

				if statusbar then
					statusbar:SetStatusBarTexture(C.media.texture)

					if not statusbar.backdrop then
						statusbar:CreateBackdrop("Overlay")
					end

					_G["ReputationBar"..i.."Background"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarHighlight1"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarHighlight2"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarAtWarHighlight1"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarAtWarHighlight2"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarLeftTexture"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarRightTexture"]:SetTexture(nil)
				end

				if button then
					if not button.isSkinned then
						T.SkinExpandOrCollapse(button)
						if isCollapsed then
							button.bg.plus:Show()
						else
							button.bg.plus:Hide()
						end
						button.isSkinned = true
					end
				end
			end
			ReputationDetailFrame:StripTextures()
			ReputationDetailFrame:SetTemplate("Transparent")
			ReputationDetailFrame:SetPoint("TOPLEFT", ReputationFrame, "TOPRIGHT", 3, 0)
			T.SkinCloseButton(ReputationDetailCloseButton)
			T.SkinCheckBox(ReputationDetailMainScreenCheckbox)
			T.SkinCheckBox(ReputationDetailInactiveCheckbox)
			T.SkinCheckBox(ReputationDetailAtWarCheckbox)
		end
		ReputationFrame:HookScript("OnShow", UpdateFactionSkins)
		hooksecurefunc("ExpandFactionHeader", UpdateFactionSkins)
		hooksecurefunc("CollapseFactionHeader", UpdateFactionSkins)
	else
		hooksecurefunc(_G.ReputationFrame.ScrollBox, "Update", function(frame)
			for _, child in next, { frame.ScrollTarget:GetChildren() } do
				local container = child.Container
				if container and not container.IsSkinned then
					container:StripTextures()

					if container.ExpandOrCollapseButton then
						T.SkinExpandOrCollapse(container.ExpandOrCollapseButton)
					end

					if container.ReputationBar then
						container.ReputationBar:StripTextures()
						container.ReputationBar:SetStatusBarTexture(C.media.texture)
						if not container.ReputationBar.backdrop then
							container.ReputationBar:CreateBackdrop("Overlay")
						end
					end

					container.IsSkinned = true
				end
			end
		end)

		ReputationDetailFrame:StripTextures()
		ReputationDetailFrame:SetTemplate("Transparent")
		ReputationDetailFrame:SetPoint("TOPLEFT", ReputationFrame, "TOPRIGHT", 3, 0)
		T.SkinCloseButton(ReputationDetailCloseButton)
		T.SkinCheckBox(ReputationDetailMainScreenCheckbox)
		T.SkinCheckBox(ReputationDetailInactiveCheckbox)
		T.SkinCheckBox(ReputationDetailAtWarCheckbox)
		ReputationDetailViewRenownButton:SkinButton()
	end

	-- Currency
	if T.Classic then
		TokenFrame:HookScript("OnShow", function()
			local buttons = TokenFrameContainer.buttons
			local numButtons = #buttons

			for i = 1, numButtons do
				local button = buttons[i]
				if button then
					button.highlight:Kill()
					button.categoryMiddle:Kill()
					button.categoryLeft:Kill()
					button.categoryRight:Kill()

					if button.icon then
						button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
					end
				end
			end
			TokenFramePopup:StripTextures()
			TokenFramePopup:SetTemplate("Transparent")
			TokenFramePopup:SetPoint("TOPLEFT", TokenFrame, "TOPRIGHT", 3, 0)
			T.SkinCloseButton(TokenFramePopupCloseButton)
			T.SkinCheckBox(TokenFramePopupBackpackCheckbox)
			T.SkinCheckBox(TokenFramePopupInactiveCheckbox)
		end)
	else
		TokenFramePopup:StripTextures()
		TokenFramePopup:SetTemplate("Transparent")
		TokenFramePopup:SetPoint("TOPLEFT", TokenFrame, "TOPRIGHT", 3, 0)
		if TokenFramePopup.CloseButton then
			T.SkinCloseButton(TokenFramePopup.CloseButton)
		end
		T.SkinCheckBox(TokenFramePopup.InactiveCheckbox)
		T.SkinCheckBox(TokenFramePopup.BackpackCheckbox)

		hooksecurefunc(_G.TokenFrame.ScrollBox, "Update", function(frame)
			for _, child in next, {frame.ScrollTarget:GetChildren()} do
				if child.Highlight and not child.styled then
					child.CategoryLeft:SetAlpha(0)
					child.CategoryRight:SetAlpha(0)
					child.CategoryMiddle:SetAlpha(0)
					child.Highlight:Kill()

					child.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

					child.styled = true
				end
			end
		end)
	end
end

tinsert(T.SkinFuncs["ShestakUI"], LoadSkin)