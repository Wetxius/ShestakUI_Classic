local T, C, L = unpack(ShestakUI)

----------------------------------------------------------------------------------------
--	Reskin Blizzard windows(by Tukz and Co)
----------------------------------------------------------------------------------------
local SkinBlizzUI = CreateFrame("Frame")
SkinBlizzUI:RegisterEvent("ADDON_LOADED")
SkinBlizzUI:SetScript("OnEvent", function(_, _, addon)
	if C_AddOns.IsAddOnLoaded("Skinner") or C_AddOns.IsAddOnLoaded("Aurora") then return end

	-- Stuff not in Blizzard load-on-demand
	if addon == "ShestakUI" then
		-- Skin checkButtons
		local checkButtons = {
			"LFDRoleCheckPopupRoleButtonTank",
			"LFDRoleCheckPopupRoleButtonDPS",
			"LFDRoleCheckPopupRoleButtonHealer"
		}

		for _, object in pairs(checkButtons) do
			local checkButton = _G[object] and _G[object].checkButton
			if checkButton then
				T.SkinCheckBox(_G[object].checkButton)
			end
		end

		-- Blizzard Frame reskin
		local bgskins = {
			"GameMenuFrame",
			"BNToastFrame",
			"ReadyCheckFrame",
			"ColorPickerFrame",
			"LFDRoleCheckPopup",
			"LFDReadyCheckPopup",
			"GuildInviteFrame",
			"RolePollPopup",
			"BaudErrorFrame",
			"OpacityFrame",
			"GeneralDockManagerOverflowButtonList",
			"QueueStatusFrame",
			"BasicScriptErrors"
		}

		GameMenuFrame:StripTextures()
		OpacityFrame:StripTextures()

		if T.Wrath or T.Cata or T.Mists then
			RolePollPopup:StripTextures()
		end

		if T.Wrath or T.Cata or T.Mists or T.Mainline then
			QueueStatusFrame:StripTextures()
			LFDRoleCheckPopup:StripTextures()
		end

		if T.Mainline then
			ColorPickerFrame.Border:Hide()
		end

		AutoCompleteBox.NineSlice:SetTemplate("Transparent")
		TicketStatusFrameButton.NineSlice:SetTemplate("Transparent")

		for i = 1, getn(bgskins) do
			local frame = _G[bgskins[i]]
			if frame then
				frame:SetTemplate("Transparent")
			end
		end

		if T.TBC then
			local function SetModifiedBackdrop(self)
				if self:IsEnabled() then
					self.backdrop:SetBackdropBorderColor(unpack(C.media.classborder_color))
					if self.backdrop.overlay then
						self.backdrop.overlay:SetVertexColor(C.media.classborder_color[1] * 0.3, C.media.classborder_color[2] * 0.3, C.media.classborder_color[3] * 0.3, 1)
					end
				end
			end

			local function SetOriginalBackdrop(self)
				self.backdrop:SetBackdropBorderColor(unpack(C.media.border_color))
				if self.backdrop.overlay then
					self.backdrop.overlay:SetVertexColor(0.1, 0.1, 0.1, 1)
				end
			end

			local function SkinButton(f)
				if f.SetNormalTexture then f:SetNormalTexture(0) end
				if f.SetHighlightTexture then f:SetHighlightTexture(0) end
				if f.SetPushedTexture then f:SetPushedTexture(0) end
				if f.SetDisabledTexture then f:SetDisabledTexture(0) end

				if f.Left then f.Left:SetAlpha(0) end
				if f.Right then f.Right:SetAlpha(0) end
				if f.Middle then f.Middle:SetAlpha(0) end
				if f.Center then f.Center:SetAlpha(0) end
				if f.LeftSeparator then f.LeftSeparator:SetAlpha(0) end
				if f.RightSeparator then f.RightSeparator:SetAlpha(0) end
				if f.Flash then f.Flash:SetAlpha(0) end

				if f.TopLeft then f.TopLeft:Hide() end
				if f.TopRight then f.TopRight:Hide() end
				if f.BottomLeft then f.BottomLeft:Hide() end
				if f.BottomRight then f.BottomRight:Hide() end
				if f.TopMiddle then f.TopMiddle:Hide() end
				if f.MiddleLeft then f.MiddleLeft:Hide() end
				if f.MiddleRight then f.MiddleRight:Hide() end
				if f.BottomMiddle then f.BottomMiddle:Hide() end
				if f.MiddleMiddle then f.MiddleMiddle:Hide() end
				if f.Background then f.Background:Hide() end

				f:CreateBackdrop("Overlay")
				f:HookScript("OnEnter", SetModifiedBackdrop)
				f:HookScript("OnLeave", SetOriginalBackdrop)
			end

			hooksecurefunc(GameMenuFrame, "InitButtons", function(self)
				if not self.buttonPool then return end

				for button in self.buttonPool:EnumerateActive() do
					if not button.styled then
						button:SetSize(150, 28)
						SkinButton(button)
						button.backdrop:SetInside(button, 2, 2)
						button.styled = true
					end
					button:HookScript("OnEnter", SetModifiedBackdrop)
					button:HookScript("OnLeave", SetOriginalBackdrop)
				end
			end)
			if GameMenuFrame.ShestakUI then
				SkinButton(GameMenuFrame.ShestakUI)
				GameMenuFrame.ShestakUI.backdrop:SetInside(GameMenuFrame.ShestakUI, 2, 2)
				local fstring = GameMenuFrame.ShestakUI:GetFontString()
				fstring:SetFont(C.media.normal_font, 14)
			end
		end

		local insetskins = {
			"BaudErrorFrameListScrollBox",
			"BaudErrorFrameDetailScrollBox"
		}

		for i = 1, getn(insetskins) do
			local frame = _G[insetskins[i]]
			if frame then
				frame:SetTemplate("Overlay")
			end
		end

		-- Reskin popups
		for i = 1, 4 do
			for j = 1, 4 do
				_G["StaticPopup"..i.."Button"..j]:SkinButton()
			end
			local frame = _G["StaticPopup"..i]
			frame:StripTextures()
			frame:CreateBackdrop("Transparent")
			frame.backdrop:SetPoint("TOPLEFT", 2, -2)
			frame.backdrop:SetPoint("BOTTOMRIGHT", -2, 2)

			local editBox = _G["StaticPopup"..i.."EditBox"]
			editBox.NineSlice:StripTextures()
			editBox:CreateBackdrop("Overlay")
			editBox.backdrop:SetPoint("TOPLEFT", 3, -1)
			editBox.backdrop:SetPoint("BOTTOMRIGHT", -3, 2)

			local gold = _G["StaticPopup"..i.."MoneyInputFrameGold"]
			local silver = _G["StaticPopup"..i.."MoneyInputFrameSilver"]
			local copper = _G["StaticPopup"..i.."MoneyInputFrameCopper"]
			T.SkinEditBox(gold)
			T.SkinEditBox(silver)
			T.SkinEditBox(copper)
			gold.backdrop:SetPoint("TOPLEFT", -3, 0)
			silver.backdrop:SetPoint("TOPLEFT", -3, 0)
			copper.backdrop:SetPoint("TOPLEFT", -3, 0)

			local itemFrame = frame.ItemFrame
			if itemFrame.NameFrame then
				itemFrame.NameFrame:Kill()
			end

			itemFrame.Item:GetNormalTexture():Kill()
			itemFrame.Item:SetTemplate("Default")
			itemFrame.Item:StyleButton()
			itemFrame.Item.IconBorder:SetAlpha(0)

			local icon = _G["StaticPopup"..i.."IconTexture"]
			icon:CropIcon()

			local close = _G["StaticPopup"..i.."CloseButton"]
			close:SetNormalTexture(0)
			close.SetNormalTexture = T.dummy
			close:SetPushedTexture(0)
			close.SetPushedTexture = T.dummy
			T.SkinCloseButton(close)
		end
		_G["StaticPopup1ExtraButton"]:SkinButton()

		if T.Mainline then
			T.SkinCloseButton(_G["RolePollPopupCloseButton"])
		end

		-- Cinematic popup
		_G["CinematicFrameCloseDialog"]:SetScale(C.general.uiscale)
		_G["CinematicFrameCloseDialog"]:StripTextures()
		_G["CinematicFrameCloseDialog"]:SetTemplate("Transparent")
		_G["CinematicFrameCloseDialogConfirmButton"]:SkinButton()
		_G["CinematicFrameCloseDialogResumeButton"]:SkinButton()
		_G["CinematicFrameCloseDialogResumeButton"]:SetPoint("LEFT", _G["CinematicFrameCloseDialogConfirmButton"], "RIGHT", 15, 0)

		-- Movie popup /run MovieFrame_PlayMovie(MovieFrame, 18)
		MovieFrame.CloseDialog:SetScale(C.general.uiscale)
		MovieFrame.CloseDialog:StripTextures()
		MovieFrame.CloseDialog:SetTemplate("Transparent")
		MovieFrame.CloseDialog.ConfirmButton:SkinButton()
		MovieFrame.CloseDialog.ResumeButton:SkinButton()
		MovieFrame.CloseDialog.ResumeButton:SetPoint("LEFT", MovieFrame.CloseDialog.ConfirmButton, "RIGHT", 15, 0)

		-- PetBattle popup
		_G["PetBattleQueueReadyFrame"]:SetTemplate("Transparent")
		_G["PetBattleQueueReadyFrame"].AcceptButton:SkinButton()
		_G["PetBattleQueueReadyFrame"].DeclineButton:SkinButton()

		-- Reskin Dropdown menu
		local dropdowns = {"DropDownList", "L_DropDownList", "Lib_DropDownList"}
		hooksecurefunc("UIDropDownMenu_InitializeHelper", function()
			for _, name in next, dropdowns do
				for i = 1, UIDROPDOWNMENU_MAXLEVELS do
					local backdrop = _G[name..i.."Backdrop"]
					if backdrop then
						backdrop:SetTemplate("Transparent")
						local menu = _G[name..i.."MenuBackdrop"].NineSlice or _G[name..i.."MenuBackdrop"]
						if menu then
							menu:SetTemplate("Transparent")
						end
						if backdrop.Bg then
							backdrop.Bg:SetAlpha(0)
						end
					end
				end
			end
		end)

		hooksecurefunc("ToggleDropDownMenu", function(level)
			if not level then
				level = 1
			end

			for i = 1, _G.UIDROPDOWNMENU_MAXBUTTONS do
				local button = _G["DropDownList"..level.."Button"..i]
				local check = _G["DropDownList"..level.."Button"..i.."Check"]
				local uncheck = _G["DropDownList"..level.."Button"..i.."UnCheck"]

				if not button.backdrop then
					button:CreateBackdrop("Transparent")
					button.backdrop:SetBackdropColor(C.media.backdrop_color[1], C.media.backdrop_color[2], C.media.backdrop_color[3], 0.3)
				end

				button.backdrop:Hide()

				local texture = check:GetTexture()
				if not button.notCheckable and (T.Classic or texture == 375502) then
					uncheck:SetTexture()
					local _, co = check:GetTexCoord()
					if co == 0 then
						check:SetTexture([[Interface\Buttons\UI-CheckBox-Check]])
						check:SetVertexColor(1, 0.9, 0, 1)
						check:SetSize(18, 18)
						check:SetDesaturated(true)
						button.backdrop:SetInside(check, 4, 4)
					else
						check:SetTexture(C.media.blank)
						check:SetVertexColor(1, 0.82, 0, 0.8)
						check:SetSize(6, 6)
						check:SetDesaturated(false)
						button.backdrop:SetOutside(check)
					end

					button.backdrop:Show()
					check:SetTexCoord(0, 1, 0, 1)
				else
					check:SetSize(16, 16)
				end
			end
		end)

		if RaiderIO_CustomDropDownListMenuBackdrop then
			RaiderIO_CustomDropDownListMenuBackdrop:StripTextures()
		end

		if MyFrameDropDownBackdrop then
			MyFrameDropDownBackdrop:SetTemplate("Transparent")
		end

		--	Blizzard_Menu skin
		do
			local backdrops = {}
			local function SkinFrame(frame)
				frame:StripTextures()

				if backdrops[frame] then
					frame.backdrop = backdrops[frame] -- relink it back
				else
					frame:CreateBackdrop("Transparent") -- :SetTemplate errors out
					frame.backdrop:SetInside(frame, 0, 0)
					backdrops[frame] = frame.backdrop

					if frame.ScrollBar then
						T.SkinScrollBar(frame.ScrollBar)
					end
				end
			end

			local function OpenMenu(manager, _, menuDescription)
				local menu = manager:GetOpenMenu()
				if menu then
					SkinFrame(menu)
					menuDescription:AddMenuAcquiredCallback(SkinFrame)
				end
			end

			local manager = _G.Menu.GetManager()
			hooksecurefunc(manager, "OpenMenu", OpenMenu)
			hooksecurefunc(manager, "OpenContextMenu", OpenMenu)
		end

		-- Reskin menu
		-- local ChatMenus = {
			-- "ChatMenu",
			-- "EmoteMenu",
			-- "LanguageMenu",
			-- "VoiceMacroMenu"
		-- }

		-- for i = 1, getn(ChatMenus) do
			-- if _G[ChatMenus[i]] == _G["ChatMenu"] then
				-- _G[ChatMenus[i]]:HookScript("OnShow", function(self)
					-- if self.NineSlice then
						-- self.NineSlice:SetTemplate("Transparent")
					-- else
						-- self:SetTemplate("Transparent")
					-- end
					-- self:ClearAllPoints()
					-- self:SetPoint("BOTTOMRIGHT", ChatFrame1, "BOTTOMRIGHT", 0, 30)
				-- end)
			-- else
				-- _G[ChatMenus[i]]:HookScript("OnShow", function(self)
					-- if self.NineSlice then
						-- self.NineSlice:SetTemplate("Transparent")
					-- else
						-- self:SetTemplate("Transparent")
					-- end
				-- end)
			-- end
		-- end

		-- Hide header textures and move text/buttons
		local BlizzardHeader = {
			"GameMenuFrame",
			"ColorPickerFrame"
		}

		for _, frame in pairs(BlizzardHeader) do
			local title = T.Classic and _G[frame.."Header"] or _G[frame] and _G[frame].Header
			if title then
				title:StripTextures()
				title:ClearAllPoints()
				title:SetPoint("TOP", frame, 0, 0)
			end
		end

		-- Reskin buttons
		local BlizzardButtons = {
			"GameMenuButtonOptions",
			"GameMenuButtonHelp",
			"GameMenuButtonStore",
			"GameMenuButtonUIOptions",
			"GameMenuButtonSettings",
			"GameMenuButtonEditMode",
			"GameMenuButtonKeybindings",
			"GameMenuButtonMacros",
			"GameMenuButtonRatings",
			"GameMenuButtonAddOns",
			"GameMenuButtonAddons",
			"GameMenuButtonLogout",
			"GameMenuButtonQuit",
			"GameMenuButtonContinue",
			"GameMenuButtonMacOptions",
			"GameMenuButtonOptionHouse",
			"GameMenuButtonSettingsUI",
			"GameMenuButtonWhatsNew",
			"ReadyCheckFrameYesButton",
			"ReadyCheckFrameNoButton",
			"ColorPickerOkayButton",
			"ColorPickerCancelButton",
			"GuildInviteFrameJoinButton",
			"GuildInviteFrameDeclineButton",
			"RolePollPopupAcceptButton",
			"LFDRoleCheckPopupDeclineButton",
			"LFDRoleCheckPopupAcceptButton",
			"LFDReadyCheckPopupAcceptButton",
			"RaidUtilityConvertButton",
			"RaidUtilityMainTankButton",
			"RaidUtilityMainAssistButton",
			"RaidUtilityRoleButton",
			"RaidUtilityReadyCheckButton",
			"RaidUtilityShowButton",
			"RaidUtilityCloseButton",
			"RaidUtilityDisbandButton",
			"RaidUtilityRaidControlButton",
			"BasicScriptErrorsButton"
		}

		if C.misc.raid_tools == true then
			tinsert(BlizzardButtons, "CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton")
		end

		for i = 1, getn(BlizzardButtons) do
			local buttons = _G[BlizzardButtons[i]]
			if buttons then
				buttons:SkinButton()
			end
		end
		if T.Mainline then
			LFDReadyCheckPopup.YesButton:SkinButton(true)
			LFDReadyCheckPopup.NoButton:SkinButton(true)
		end

		-- Button position or text
		_G["ColorPickerOkayButton"]:ClearAllPoints()
		_G["ColorPickerOkayButton"]:SetPoint("BOTTOMLEFT", _G["ColorPickerFrame"], "BOTTOMLEFT", 6, 6)
		_G["ColorPickerCancelButton"]:ClearAllPoints()
		_G["ColorPickerCancelButton"]:SetPoint("BOTTOMRIGHT", _G["ColorPickerFrame"], "BOTTOMRIGHT", -6, 6)
		_G["ReadyCheckFrameYesButton"]:SetParent(_G["ReadyCheckFrame"])
		_G["ReadyCheckFrameYesButton"]:ClearAllPoints()
		_G["ReadyCheckFrameNoButton"]:SetParent(_G["ReadyCheckFrame"])
		_G["ReadyCheckFrameNoButton"]:ClearAllPoints()
		_G["ReadyCheckFrameYesButton"]:SetPoint("RIGHT", _G["ReadyCheckFrame"], "CENTER", 0, -22)
		_G["ReadyCheckFrameNoButton"]:SetPoint("LEFT", _G["ReadyCheckFrameYesButton"], "RIGHT", 6, 0)
		_G["ReadyCheckFrameText"]:SetParent(_G["ReadyCheckFrame"])
		_G["ReadyCheckFrameText"]:ClearAllPoints()
		_G["ReadyCheckFrameText"]:SetPoint("TOP", 0, -12)

		-- Others
		if T.Mainline then
			for i = 1, 10 do
				select(i, GuildInviteFrame:GetRegions()):Hide()
			end
		end
		_G["GeneralDockManagerOverflowButtonList"]:SetFrameStrata("HIGH")
		_G["ReadyCheckListenerFrame"]:SetAlpha(0)
		_G["ReadyCheckFrame"]:HookScript("OnShow", function(self) if UnitIsUnit("player", self.initiator) then self:Hide() end end)

		-- StackSplit
		StackSplitFrame:SetFrameStrata("TOOLTIP")
		StackSplitFrame:StripTextures()
		StackSplitFrame:CreateBackdrop("Transparent")
		StackSplitFrame.backdrop:SetPoint("TOPLEFT", 5, -5)
		StackSplitFrame.backdrop:SetPoint("BOTTOMRIGHT", -5, 10)
		if T.Classic then
			StackSplitOkayButton:SkinButton()
			StackSplitCancelButton:SkinButton()
		else
			StackSplitFrame.OkayButton:SkinButton()
			StackSplitFrame.CancelButton:SkinButton()
		end

		if T.Classic then
			_G["StaticPopup1CloseButton"]:HookScript("OnShow", function(self)
				self:StripTextures(true)
				T.SkinCloseButton(self, nil, "-")
			end)
			T.SkinCloseButton(_G["ItemRefCloseButton"])
		end

		if C.skins.blizzard_frames == true then
			-- What's new frame
			if T.Mainline then
				SplashFrame:CreateBackdrop("Transparent")
				SplashFrame.BottomCloseButton:SkinButton()
				T.SkinCloseButton(SplashFrame.TopCloseButton)
			end

			-- NavBar Buttons (Used in EncounterJournal and HelpFrame)
			local function NavButtonXOffset(button, point, anchor, point2, _, yoffset, skip)
				if not skip then
					button:SetPoint(point, anchor, point2, 1, yoffset, true)
				end
			end

			local function SkinNavBarButtons(self)
				if self:GetParent():GetName() == "WorldMapFrame" then return end
				local total = #self.navList
				local navButton = self.navList[total]
				if navButton then
					if total == 2 then
						-- EJ.navBar.home.xoffset = 1 (this causes a taint, use the hook below instead)
						NavButtonXOffset(navButton, navButton:GetPoint())
						hooksecurefunc(navButton, "SetPoint", NavButtonXOffset)
					end

					if not navButton.isSkinned then
						navButton:SkinButton(true)
						if navButton.MenuArrowButton then
							navButton.MenuArrowButton:SetNormalTexture(0)
							navButton.MenuArrowButton:SetPushedTexture(0)
							navButton.MenuArrowButton:SetHighlightTexture(0)
						end

						navButton.xoffset = 1
						navButton.isSkinned = true
					end
				end
			end
			hooksecurefunc("NavBar_AddButton", SkinNavBarButtons)

			if T.client == "ruRU" then
				_G["DeclensionFrame"]:SetTemplate("Transparent")
				_G["DeclensionFrameCancelButton"]:SkinButton()
				_G["DeclensionFrameOkayButton"]:SkinButton()
				T.SkinNextPrevButton(_G["DeclensionFrameSetNext"])
				T.SkinNextPrevButton(_G["DeclensionFrameSetPrev"])
				for i = 1, 5 do
					_G["DeclensionFrameDeclension"..i.."Edit"]:StripTextures(true)
					_G["DeclensionFrameDeclension"..i.."Edit"]:SetTemplate("Overlay")
					_G["DeclensionFrameDeclension"..i.."Edit"]:SetTextInsets(3, 0, 0, 0)
				end
			end

			local function SkinIconArray(baseName, numIcons)
				for i = 1, numIcons do
					local button = _G[baseName..i]
					local texture = _G[baseName..i.."Icon"]

					button:StripTextures()
					button:StyleButton(true)
					button:SetTemplate("Default")

					texture:ClearAllPoints()
					texture:SetPoint("TOPLEFT", 2, -2)
					texture:SetPoint("BOTTOMRIGHT", -2, 2)
					texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				end
			end

			-- This is used to create icons for the GuildBankPopupFrame, MacroPopupFrame, and GearManagerDialogPopup
			hooksecurefunc("BuildIconArray", function(_, baseName, _, rowSize, numRows)
				local numIcons = rowSize * numRows
				SkinIconArray(baseName, numIcons)
			end)

			if T.Mainline then
				hooksecurefunc(HelpTipTemplateMixin, "ApplyText", function(self)
					T.SkinHelpBox(self)
				end)
			end
		end
	end
end)
