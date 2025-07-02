local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true or C_AddOns.IsAddOnLoaded("QuestLogEx") then return end -- incomplete

----------------------------------------------------------------------------------------
--	QuestLog skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	if T.Wrath  then
		-- Let's try it out
	else
		-- QuestLogTimerText:SetTextColor(1, 1, 1)

		QuestLogFrame:SetAttribute("UIPanelLayout-width", T.Scale(685))
		QuestLogFrame:SetAttribute("UIPanelLayout-height", T.Scale(490))
		QuestLogFrame:SetSize(700, 500)
		QuestLogFrame:CreateBackdrop("Transparent")
		QuestLogFrame.backdrop:SetPoint("TOPLEFT", 10, -12)
		QuestLogFrame.backdrop:SetPoint("BOTTOMRIGHT", -1, 8)

		QuestLogTitleText:ClearAllPoints()
		QuestLogTitleText:SetPoint("TOP", QuestLogFrame.backdrop, "TOP", 0, -6)

		T.SkinCloseButton(QuestLogFrameCloseButton)
		QuestLogFrameCloseButton:ClearAllPoints()
		QuestLogFrameCloseButton:SetPoint("TOPRIGHT", -5, -16)

		QuestLogListScrollFrame:StripTextures()
		QuestLogListScrollFrame:CreateBackdrop("Default", true)
		QuestLogListScrollFrame.backdrop:SetPoint("TOPLEFT", -4, 2)
		QuestLogListScrollFrame:SetSize(300, 375)
		QuestLogListScrollFrame:ClearAllPoints()
		QuestLogListScrollFrame:SetPoint("TOPLEFT", QuestLogFrame, 32, -65)

		QuestLogDetailScrollFrame:StripTextures()
		QuestLogDetailScrollFrame:CreateBackdrop("Default", true)
		QuestLogDetailScrollFrame.backdrop:SetPoint("TOPLEFT", -4, 2)
		QuestLogDetailScrollFrame:SetSize(300, 375)
		QuestLogDetailScrollFrame:ClearAllPoints()
		QuestLogDetailScrollFrame:SetPoint("TOPRIGHT", QuestLogFrame, -32, -73)

		QuestLogNoQuestsText:ClearAllPoints()
		QuestLogNoQuestsText:SetPoint("CENTER", EmptyQuestLogFrame, "CENTER", -45, 65)
		
		QuestLogFrameAbandonButton:SetPoint("LEFT", 24, 10)
		QuestLogFrameAbandonButton:SetWidth(100)
		QuestLogFrameAbandonButton:SetText(ABANDON_QUEST)

		QuestFramePushQuestButton:ClearAllPoints()
		QuestFramePushQuestButton:SetPoint("LEFT", QuestLogFrameAbandonButton, "RIGHT", 2, 0)
		QuestFramePushQuestButton:SetWidth(100)
		QuestFramePushQuestButton:SetText(SHARE_QUEST)

		--	QuestLogFrameShowMapButton:SetPoint("CENTER", 4, 0)

		QuestLogFrameCancelButton:SkinButton()
		QuestLogFrameCancelButton:SetPoint("BOTTOMRIGHT", -30, 15)
		QuestLogFrameCancelButton:SetWidth(100)
		
		QuestLogFrameTrackButton:SkinButton()
		QuestLogFrameTrackButton:SetPoint("LEFT", QuestFramePushQuestButton, "RIGHT", 2, 0)
		QuestLogFrameTrackButton:SetWidth(100)

		T.SkinScrollBar(QuestLogDetailScrollFrameScrollBar)
		T.SkinScrollBar(QuestLogListScrollFrameScrollBar)
		QuestLogListScrollFrameScrollBar:SetPoint("TOPLEFT", QuestLogListScrollFrame, "TOPRIGHT", 5, -16)

		local QuestStrip = {
			"QuestLogFrame",
			"QuestLogCount",
			"QuestLogQuestCount",
			"EmptyQuestLogFrame"
		}

		for i = 1, getn(QuestStrip) do
			local object = _G[QuestStrip[i]]
			if object then
				object:StripTextures(true)
			end
		end

		QuestLogQuestCount:ClearAllPoints()
		QuestLogQuestCount:SetPoint("TOPRIGHT", QuestLogFrame.backdrop, "TOPRIGHT", -32, -30)

		local QuestButtons = {
			"QuestLogFrameAbandonButton",
			"QuestFrameCancelButton",
			"QuestFramePushQuestButton",
		}

		for i = 1, getn(QuestButtons) do
			local object = _G[QuestButtons[i]]
			if object then
				object:StripTextures()
				object:SkinButton()
			end
		end

		local function QuestQualityColors(frame, text, quality, link)
			if link and not quality then
				quality = select(3, C_Item.GetItemInfo(link))
			end

			if frame then
				Mixin(frame, BackdropTemplateMixin) -- 9.0 to set backdrop
			end

			if quality then
				if frame then
					local R, G, B = GetItemQualityColor(quality)
					frame:SetBackdropBorderColor(R, G, B)
				end
				text:SetTextColor(GetItemQualityColor(quality) or 1, 1, 1)
			else
				if frame then
					frame:SetBackdropBorderColor(unpack(C.media.backdrop_color))
				end
				text:SetTextColor(1, 1, 1)
			end
		end

		hooksecurefunc("QuestRewardItem_OnClick", function()
			QuestRewardItemHighlight:ClearAllPoints()
			QuestRewardItemHighlight:SetOutside(this:GetName().."IconTexture")
			_G[this:GetName().."Name"]:SetTextColor(1, 1, 0)

			for i = 1, MAX_NUM_ITEMS do
				local questItem = _G["QuestRewardItem"..i]
				local questName = _G["QuestRewardItem"..i.."Name"]
				local link = questItem.type and GetQuestItemLink(questItem.type, questItem:GetID())

				if questItem ~= this then
					QuestQualityColors(nil, questName, nil, link)
				end
			end
		end)

		local function QuestObjectiveTextColor()
			local numObjectives = GetNumQuestLeaderBoards()
			local objective
			local _, type, finished
			local numVisibleObjectives = 0
			for i = 1, numObjectives do
				_, type, finished = GetQuestLogLeaderBoard(i)
				if type ~= "spell" then
					numVisibleObjectives = numVisibleObjectives + 1
					objective = _G["QuestLogObjective"..numVisibleObjectives]
					if finished then
						objective:SetTextColor(1, 0.80, 0.10)
					else
						objective:SetTextColor(0.6, 0.6, 0.6)
					end
				end
			end
		end

		hooksecurefunc("QuestLog_UpdateQuestDetails", function()
			local requiredMoney = GetQuestLogRequiredMoney()
			if requiredMoney > 0 then
				if requiredMoney > GetMoney() then
					QuestLogRequiredMoneyText:SetTextColor(0.6, 0.6, 0.6)
				else
					QuestLogRequiredMoneyText:SetTextColor(1, 0.80, 0.10)
				end
			end
		end)

		hooksecurefunc("QuestFrameItems_Update", function(questState)
			local titleTextColor = {1, 0.80, 0.10}
			local textColor = {1, 1, 1}

			QuestLogDescriptionTitle:SetTextColor(unpack(titleTextColor))
			QuestLogQuestTitle:SetTextColor(unpack(titleTextColor))
			QuestLogRewardTitleText:SetTextColor(unpack(titleTextColor))
			QuestLogObjectivesText:SetTextColor(unpack(textColor))
			QuestLogQuestDescription:SetTextColor(unpack(textColor))
			QuestLogItemChooseText:SetTextColor(unpack(textColor))
			QuestLogItemReceiveText:SetTextColor(unpack(textColor))
			QuestLogSpellLearnText:SetTextColor(unpack(textColor))

			if GetQuestLogRequiredMoney() > 0 then
				if GetQuestLogRequiredMoney() > GetMoney() then
					QuestLogRequiredMoneyText:SetTextColor(0.6, 0.6, 0.6)
				else
					QuestLogRequiredMoneyText:SetTextColor(unpack(textColor))
				end
			end

			QuestObjectiveTextColor()

			local numQuestRewards, numQuestChoices
			if questState == "QuestLog" then
				numQuestRewards, numQuestChoices = GetNumQuestLogRewards(), GetNumQuestLogChoices()
			else
				numQuestRewards, numQuestChoices = GetNumQuestRewards(), GetNumQuestChoices()
			end

			local rewardsCount = numQuestChoices + numQuestRewards
			if rewardsCount > 0 then
				local questItem, itemName, link
				local questItemName = questState.."Item"

				for i = 1, rewardsCount do
					questItem = _G[questItemName..i]
					itemName = _G[questItemName..i.."Name"]
					link = questItem.type and (questState == "QuestLog" and GetQuestLogItemLink or GetQuestItemLink)(questItem.type, questItem:GetID())

					QuestQualityColors(questItem, itemName, nil, link)
				end
			end
		end)
		


		--[[
        local function UpdateQuests() -- causing issues
            local numEntries, numQuests = GetNumQuestLogEntries()
            local offset = FauxScrollFrame_GetOffset(QuestLogListScrollFrame)
            local index, questLogTitle, highlight, text

            for i = 1, QUESTS_DISPLAYED do
                questLogTitle = _G["QuestLogTitle"..i]
                highlight = _G["QuestLogTitle"..i.."Highlight"]
                text = _G["QuestLogTitle"..i.."NormalText"]
                index = offset + i

                if index <= numEntries then
                    questLogTitleText, level, questTag, isHeader, isCollapsed, isComplete, frequency, questID, startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isBounty, isStory, isHidden, isScaling = GetQuestLogTitle(index)
                    if isHeader then
                        questLogTitle:SetSize(14, 14)
                        questLogTitle:SetPoint("CENTER")
                        questLogTitle:SetHitRectInsets(1, 1, 1, 1)

                        highlight:SetTexture(0)
                        highlight.SetTexture = T.dummy

                        text:ClearAllPoints()
                        text:SetPoint("LEFT", questLogTitle, "RIGHT", 6, 0)

                        hooksecurefunc(questLogTitle, "SetNormalTexture", function(self, texture)
                            self:StripTextures()
                            self:SetTemplate("Overlay")

                            self.minus = self:CreateTexture(nil, "OVERLAY")
                            self.minus:SetSize(7, 1)
                            self.minus:SetPoint("CENTER")
                            self.minus:SetTexture(C.media.blank)

                            if not string.find(texture, "MinusButton") then
                                self.plus = self:CreateTexture(nil, "OVERLAY")
                                self.plus:SetSize(1, 7)
                                self.plus:SetPoint("CENTER")
                                self.plus:SetTexture(C.media.blank)
                            end
                        end)
                    end
                end
            end
        end
        hooksecurefunc("QuestLog_Update", UpdateQuests)
        --]]
	end
end

table.insert(T.SkinFuncs["ShestakUI"], LoadSkin)