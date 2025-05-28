local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end -- incomplete

----------------------------------------------------------------------------------------
--	Quest skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	QuestFrame:StripTextures(true)
	QuestFrameInset:StripTextures(true)
	QuestFrameDetailPanel:StripTextures(true)
	QuestDetailScrollFrame:StripTextures(true)
	QuestDetailScrollChildFrame:StripTextures(true)
	QuestRewardScrollFrame:StripTextures(true)
	QuestRewardScrollChildFrame:StripTextures(true)
	QuestProgressScrollFrame:StripTextures(true)
	QuestGreetingScrollFrame:StripTextures(true)
	QuestFrameProgressPanel:StripTextures(true)
	QuestFrameRewardPanel:StripTextures(true)
	QuestFramePortrait:SetAlpha(0)

	QuestFrameProgressPanelMaterialTopLeft:SetAlpha(0)
	QuestFrameProgressPanelMaterialTopRight:SetAlpha(0)
	QuestFrameProgressPanelMaterialBotLeft:SetAlpha(0)
	QuestFrameProgressPanelMaterialBotRight:SetAlpha(0)

	QuestFrame:CreateBackdrop("Transparent")
	QuestFrame.backdrop:SetPoint("TOPLEFT", 0, 0)
	QuestFrame.backdrop:SetPoint("BOTTOMRIGHT", 0, 0)

	QuestFrameAcceptButton:SkinButton(true)
	QuestFrameDeclineButton:SkinButton(true)
	QuestFrameCompleteButton:SkinButton(true)
	QuestFrameGoodbyeButton:SkinButton(true)
	QuestFrameCompleteQuestButton:SkinButton(true)

	T.SkinCloseButton(QuestFrameCloseButton, QuestFrame.backdrop)
	T.SkinScrollBar(QuestDetailScrollFrame.ScrollBar)
	T.SkinScrollBar(QuestProgressScrollFrame.ScrollBar)
	T.SkinScrollBar(QuestRewardScrollFrame.ScrollBar)
	T.SkinScrollBar(QuestGreetingScrollFrame.ScrollBar)
	T.SkinScrollBar(QuestNPCModelTextScrollFrame.ScrollBar)

	for i = 1, 6 do
		local button = _G["QuestProgressItem"..i]
		local texture = _G["QuestProgressItem"..i.."IconTexture"]

		if button.NameFrame then button.NameFrame:Hide() end
		button.Name:SetFont(C.media.normal_font, 12, "")

		button:CreateBackdrop("Default")
		button.backdrop:ClearAllPoints()
		button.backdrop:SetPoint("TOPLEFT", texture, -2, 2)
		button.backdrop:SetPoint("BOTTOMRIGHT", texture, 2, -2)

		texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	end

	hooksecurefunc("QuestFrameProgressItems_Update", function()
		QuestProgressTitleText:SetTextColor(1, 0.8, 0)
		QuestProgressTitleText:SetShadowColor(0, 0, 0)
		QuestProgressText:SetTextColor(1, 1, 1)
		QuestProgressRequiredItemsText:SetTextColor(1, 0.8, 0)
		QuestProgressRequiredItemsText:SetShadowColor(0, 0, 0)
		QuestProgressRequiredMoneyText:SetTextColor(1, 0.8, 0)
	end)

		-- QuestInfo
	hooksecurefunc("QuestInfo_Display", function(template, parentFrame)
		-- Headers
		QuestInfoTitleHeader:SetTextColor(1, 0.8, 0)
		QuestInfoTitleHeader:SetShadowColor(0, 0, 0)
		QuestInfoDescriptionHeader:SetTextColor(1, 0.8, 0)
		QuestInfoDescriptionHeader:SetShadowColor(0, 0, 0)
		QuestInfoObjectivesHeader:SetTextColor(1, 0.8, 0)
		QuestInfoObjectivesHeader:SetShadowColor(0, 0, 0)
		QuestInfoRewardsFrame.Header:SetTextColor(1, 0.8, 0)
		QuestInfoRewardsFrame.Header:SetShadowColor(0, 0, 0)

		-- Other text
		QuestInfoDescriptionText:SetTextColor(1, 1, 1)
		QuestInfoDescriptionText:SetShadowOffset(1, -1)
		QuestInfoObjectivesText:SetTextColor(1, 1, 1)
		QuestInfoObjectivesText:SetShadowOffset(1, -1)
		QuestInfoGroupSize:SetTextColor(1, 1, 1)
		QuestInfoGroupSize:SetShadowOffset(1, -1)
		QuestInfoRewardText:SetTextColor(1, 1, 1)
		QuestInfoRewardText:SetShadowOffset(1, -1)
		QuestInfoSpellObjectiveLearnLabel:SetTextColor(1, 1, 1)
		QuestInfoSpellObjectiveLearnLabel:SetShadowOffset(1, -1)
		QuestInfoQuestType:SetTextColor(1, 1, 1)
		QuestInfoQuestType:SetShadowOffset(1, -1)

		-- Reward frame text
		QuestInfoRewardsFrame.ItemChooseText:SetTextColor(1, 1, 1)
		QuestInfoRewardsFrame.ItemChooseText:SetShadowOffset(1, -1)
		QuestInfoRewardsFrame.ItemReceiveText:SetTextColor(1, 1, 1)
		QuestInfoRewardsFrame.ItemReceiveText:SetShadowOffset(1, -1)
		QuestInfoRewardsFrame.XPFrame.ReceiveText:SetTextColor(1, 1, 1)
		QuestInfoRewardsFrame.XPFrame.ReceiveText:SetShadowOffset(1, -1)

		local rewardsFrame = QuestInfoFrame.rewardsFrame
		local isQuestLog = QuestInfoFrame.questLog ~= nil
		local isMapQuest = rewardsFrame == MapQuestInfoRewardsFrame

		local questID = isQuestLog and C_QuestLog.GetSelectedQuest() or GetQuestID()
		local spellRewards = C_QuestInfoSystem.GetQuestRewardSpells(questID) or {}
		local numSpellRewards = #spellRewards
		if numSpellRewards and numSpellRewards > 0 then
			-- Spell Headers
			for spellHeader in rewardsFrame.spellHeaderPool:EnumerateActive() do
				spellHeader:SetVertexColor(1, 1, 1)
			end
			-- Follower Rewards
			for followerReward in rewardsFrame.followerRewardPool:EnumerateActive() do
				if not followerReward.isSkinned then
					followerReward:CreateBackdrop("Overlay")
					followerReward.backdrop:SetAllPoints(followerReward.BG)
					followerReward.backdrop:SetPoint("TOPLEFT", 45, -5)
					followerReward.backdrop:SetPoint("BOTTOMRIGHT", 2, 5)
					followerReward.BG:Hide()
					followerReward.isSkinned = true

					followerReward.PortraitFrame:SetWidth(followerReward.PortraitFrame:GetHeight())
					followerReward.PortraitFrame:ClearAllPoints()
					followerReward.PortraitFrame:SetPoint("RIGHT", followerReward.backdrop, "LEFT", -2, 0)

					followerReward.PortraitFrame.PortraitRing:Hide()
					followerReward.PortraitFrame.PortraitRingQuality:SetTexture()
					followerReward.PortraitFrame.LevelBorder:SetAlpha(0)
					followerReward.PortraitFrame.Portrait:SetTexCoord(0.2, 0.85, 0.2, 0.85)

					local level = followerReward.PortraitFrame.Level
					level:ClearAllPoints()
					level:SetPoint("BOTTOM", followerReward.PortraitFrame, 0, 5)
					level:SetFontObject("SystemFont_Outline_Small")
					level:SetShadowOffset(0, 0)

					local squareBG = CreateFrame("Frame", nil, followerReward.PortraitFrame)
					squareBG:SetFrameLevel(followerReward.PortraitFrame:GetFrameLevel()-1)
					squareBG:SetPoint("TOPLEFT", 2, -2)
					squareBG:SetPoint("BOTTOMRIGHT", -2, 2)
					squareBG:SetTemplate("Default")
					followerReward.PortraitFrame.squareBG = squareBG

					followerReward.PortraitFrame.Portrait:SetPoint("TOPLEFT", squareBG, 2, -2)
					followerReward.PortraitFrame.Portrait:SetPoint("BOTTOMRIGHT", squareBG, -2, 2)

					-- AdventuresFollowerPortraitFrame
					local portrait = followerReward.AdventuresFollowerPortraitFrame
					portrait:SetWidth(portrait:GetHeight() - 2)
					portrait:ClearAllPoints()
					portrait:SetPoint("RIGHT", followerReward.backdrop, "LEFT", -2, 0)

					portrait.CircleMask:Hide()
					portrait.PuckBorder:Hide()
					portrait.LevelDisplayFrame.LevelCircle:SetAlpha(0)

					local level = portrait.LevelDisplayFrame.LevelText
					level:ClearAllPoints()
					level:SetPoint("BOTTOM", portrait, 0, 5)
					level:SetFontObject("SystemFont_Outline_Small")
					level:SetShadowOffset(0, 0)

					if not portrait.backdrop then
						portrait:CreateBackdrop("Default")
						portrait.backdrop:SetPoint("TOPLEFT", portrait, "TOPLEFT", -1, 1)
						portrait.backdrop:SetPoint("BOTTOMRIGHT", portrait, "BOTTOMRIGHT", 1, -1)
						portrait.backdrop:SetFrameLevel(portrait:GetFrameLevel())
					end

					portrait.Portrait:SetTexCoord(0.2, 0.85, 0.2, 0.85)
					portrait.Portrait:ClearAllPoints()
					portrait.Portrait:SetInside(portrait.backdrop, 3, 3)

					local point, relativeTo, relativePoint, _, yOfs = followerReward:GetPoint()
					followerReward:SetPoint(point, relativeTo, relativePoint, 8, yOfs)
				end
				local r, g, b = followerReward.PortraitFrame.PortraitRingQuality:GetVertexColor()
				if r > 0.99 and r < 1 then
					r, g, b = unpack(C.media.border_color)
				end
				followerReward.PortraitFrame.squareBG:SetBackdropBorderColor(r, g, b)
			end
			-- Spell Rewards
			for spellReward in rewardsFrame.spellRewardPool:EnumerateActive() do
				if not spellReward.isSkinned then
					SkinReward(spellReward)
					if not isMapQuest then
						local border = select(3, spellReward:GetRegions())
						border:Hide()

						spellReward.Icon:SetPoint("TOPLEFT", 0, 0)
						spellReward:SetHitRectInsets(0, 0, 0, 0)
						spellReward:SetSize(147, 41)
					end
					spellReward.isSkinned = true
				end
			end
		end
	end)

	-- QuestGreeting
	local function UpdateGreetingPanel()
		QuestFrameGreetingPanel:StripTextures()
		QuestFrameGreetingGoodbyeButton:SkinButton()
		GreetingText:SetTextColor(1, 1, 1)
		CurrentQuestsText:SetTextColor(1, 0.8, 0)
		AvailableQuestsText:SetTextColor(1, 0.8, 0)
		QuestGreetingFrameHorizontalBreak:Kill()

		for button in QuestFrameGreetingPanel.titleButtonPool:EnumerateActive() do
			local text = button:GetFontString():GetText()
			if text and strfind(text, "|cff000000") then
				button:GetFontString():SetText(gsub(text, "|cff000000", "|cffFFFF00"))
			end
		end
	end

	QuestFrameGreetingPanel:HookScript("OnShow", UpdateGreetingPanel)
	hooksecurefunc("QuestFrameGreetingPanel_OnShow", UpdateGreetingPanel)
end

tinsert(T.SkinFuncs["ShestakUI"], LoadSkin)
