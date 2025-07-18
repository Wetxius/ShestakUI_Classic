local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	Friends skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	local StripAllTextures = {
		"FriendsFrame",
		"FriendsListFrame",
		"FriendsTabHeader",
		"FriendsFrameFriendsScrollFrame",
		"WhoFrameColumnHeader1",
		"WhoFrameColumnHeader2",
		"WhoFrameColumnHeader3",
		"WhoFrameColumnHeader4",
		"AddFriendFrame",
		"AddFriendNoteFrame",
		"FriendsFriendsFrame",
		"FriendsFriendsList",
		"IgnoreListFrame",
		"FriendsFrameInset",
		"WhoFrameListInset",
		"WhoFrameEditBoxInset",
		"GuildFrame",
		"GuildFrameLFGFrame",
		"GuildFrameColumnHeader1",
		"GuildFrameColumnHeader2",
		"GuildFrameColumnHeader3",
		"GuildFrameColumnHeader4",
		"GuildFrameGuildStatusColumnHeader1",
		"GuildFrameGuildStatusColumnHeader2",
		"GuildFrameGuildStatusColumnHeader3",
		"GuildFrameGuildStatusColumnHeader4",
		"GuildMemberDetailFrame",
		"GuildMemberNoteBackground",
		"GuildMemberOfficerNoteBackground",
		-- "LFRQueueFrameListInset",
		-- "LFRQueueFrameRoleInset",
		-- "LFRQueueFrameCommentInset",
		-- "ScrollOfResurrectionSelectionFrame",
		-- "ScrollOfResurrectionSelectionFrameList",
		-- "ScrollOfResurrectionFrame",
		-- "ScrollOfResurrectionFrameNoteFrame",
		"FriendsFrameBattlenetFrame",
		"BattleTagInviteFrame",
		-- "RecruitAFriendNoteFrame",
		-- "QuickJoinScrollFrame",
		-- "QuickJoinRoleSelectionFrame",
	}

	for _, object in pairs(StripAllTextures) do
		_G[object]:StripTextures()
	end

	local KillTextures = {
		"FriendsFrameIcon",
		"FriendsFrameBroadcastInputLeft",
		"FriendsFrameBroadcastInputRight",
		"FriendsFrameBroadcastInputMiddle"
	}

	for _, texture in pairs(KillTextures) do
		_G[texture]:Kill()
	end

	local buttons = {
		"FriendsFrameAddFriendButton",
		"FriendsFrameSendMessageButton",
		"WhoFrameWhoButton",
		"WhoFrameAddFriendButton",
		"WhoFrameGroupInviteButton",
		"FriendsFrameIgnorePlayerButton",
		"FriendsFrameUnsquelchButton",
		"AddFriendEntryFrameAcceptButton",
		"AddFriendEntryFrameCancelButton",
		"AddFriendInfoFrameContinueButton",
		"FriendsFriendsCloseButton",
		"FriendsFriendsSendRequestButton",
		"GuildFrameGuildInformationButton",
		"GuildFrameAddMemberButton",
		"GuildFrameControlButton",
		"GuildMemberRemoveButton",
		"GuildMemberGroupInviteButton",
		-- "ScrollOfResurrectionSelectionFrameAcceptButton",
		-- "ScrollOfResurrectionSelectionFrameCancelButton",
		-- "ScrollOfResurrectionFrameAcceptButton",
		-- "ScrollOfResurrectionFrameCancelButton",
		-- "RecruitAFriendFrameSendButton",
	}

	for _, button in pairs(buttons) do
		_G[button]:SkinButton()
	end

	local scrollbars = {
		"FriendsFrameFriendsScrollFrameScrollBar",
		"FriendsFrameIgnoreScrollFrameScrollBar",
		"FriendsFriendsScrollFrameScrollBar",
		"WhoListScrollFrameScrollBar",
		"GuildListScrollFrameScrollBar",
		-- "QuickJoinScrollFrameScrollBar",
	}

	for _, scrollbar in pairs(scrollbars) do
		T.SkinScrollBar(_G[scrollbar])
	end

	T.SkinCheckBox(GuildFrameLFGButton)
	T.SkinCheckBox(RaidFrameAllAssistCheckButton)

	-- Reposition buttons
	WhoFrameWhoButton:SetPoint("RIGHT", WhoFrameAddFriendButton, "LEFT", -3, 0)
	WhoFrameAddFriendButton:SetPoint("RIGHT", WhoFrameGroupInviteButton, "LEFT", -3, 0)
	WhoFrameGroupInviteButton:SetPoint("BOTTOMRIGHT", WhoFrame, "BOTTOMRIGHT", -4, 4)
	FriendsFrameAddFriendButton:SetPoint("BOTTOMLEFT", FriendsFrame, "BOTTOMLEFT", 4, 4)
	FriendsFrameSendMessageButton:SetPoint("BOTTOMRIGHT", FriendsFrame, "BOTTOMRIGHT", -4, 4)
	FriendsFrameIgnorePlayerButton:SetPoint("BOTTOMLEFT", FriendsFrame, "BOTTOMLEFT", 4, 4)
	FriendsFrameUnsquelchButton:SetPoint("BOTTOMRIGHT", FriendsFrame, "BOTTOMRIGHT", -4, 4)
	GuildFrameLFGButton:SetPoint("TOPRIGHT", GuildFrame, "TOPRIGHT", -8, -36)

	-- Resize Buttons
	WhoFrameWhoButton:SetSize(WhoFrameWhoButton:GetWidth() + 7, WhoFrameWhoButton:GetHeight())
	WhoFrameAddFriendButton:SetSize(WhoFrameAddFriendButton:GetWidth() - 4, WhoFrameAddFriendButton:GetHeight())
	WhoFrameGroupInviteButton:SetSize(WhoFrameGroupInviteButton:GetWidth() - 4, WhoFrameGroupInviteButton:GetHeight())
	if T.Wrath or T.Cata or T.Mists then
		T.SkinEditBox(WhoFrameEditBox, WhoFrameEditBox:GetWidth() + 15, WhoFrameEditBox:GetHeight() - 7)
	else
		T.SkinEditBox(WhoFrameEditBox, WhoFrameEditBox:GetWidth() + 30, WhoFrameEditBox:GetHeight() - 15)
	end
	WhoFrameEditBox:SetPoint("BOTTOM", WhoFrame, "BOTTOM", 0, 31)

	T.SkinEditBox(AddFriendNameEditBox)
	AddFriendNameEditBox:SetHeight(AddFriendNameEditBox:GetHeight() - 5)
	AddFriendFrame:SetTemplate("Transparent")
	FriendsFriendsFrame:SetTemplate("Transparent")
	FriendsFriendsList:SetTemplate("Overlay")

	-- Pending invites
	FriendsFrameFriendsScrollFrame.PendingInvitesHeaderButton:SkinButton()
	local function SkinFriendRequest(frame)
		if not frame.isSkinned then
			frame.DeclineButton:SetPoint("RIGHT", frame, "RIGHT", -2, 1)
			frame.DeclineButton:SkinButton()
			frame.AcceptButton:SkinButton()
			frame.isSkinned = true
		end
	end
	hooksecurefunc(FriendsFrameFriendsScrollFrame.invitePool, "Acquire", function()
		if FriendsFrameFriendsScrollFrame.invitePool.activeObjects then
			for object in pairs(FriendsFrameFriendsScrollFrame.invitePool.activeObjects) do
				SkinFriendRequest(object)
			end
		end
	end)

	-- Who Frame
	local function UpdateWhoSkins()
		WhoListScrollFrame:StripTextures()
	end

	WhoFrame:HookScript("OnShow", UpdateWhoSkins)
	hooksecurefunc("FriendsFrame_OnEvent", UpdateWhoSkins)

	WhoListScrollFrame:ClearAllPoints()
	WhoListScrollFrame:SetPoint("TOPRIGHT", WhoFrameListInset, -25, 0)

	-- Guild Frame
	GuildListScrollFrame:StripTextures()
	GuildListScrollFrame:CreateBackdrop("Overlay")
	GuildListScrollFrame.backdrop:SetPoint("TOPLEFT", -2, 4)
	GuildListScrollFrame.backdrop:SetPoint("BOTTOMRIGHT", 25, -4)

	GuildListScrollFrameScrollBar:SetPoint("TOPRIGHT", GuildListScrollFrame.backdrop, -6, 0)

	-- GuildFrameGuildListToggleButton:SkinButton()

	GuildMemberDetailFrame:CreateBackdrop("Transparent")

	T.SkinCloseButton(GuildMemberDetailCloseButton, GuildMemberDetailCloseButton.backdrop)

	GuildMemberNoteBackground:CreateBackdrop("Overlay")
	GuildMemberNoteBackground.backdrop:SetPoint("TOPLEFT", -5, -2)
	GuildMemberNoteBackground.backdrop:SetPoint("BOTTOMRIGHT", 7, 3)

	GuildMemberOfficerNoteBackground:CreateBackdrop("Overlay")
	GuildMemberOfficerNoteBackground.backdrop:SetPoint("TOPLEFT", -5, -2)
	GuildMemberOfficerNoteBackground.backdrop:SetPoint("BOTTOMRIGHT", 7, 3)

	-- BNet Frame
	FriendsFrameBroadcastInput:CreateBackdrop("Overlay")
	FriendsFrameBroadcastInput.backdrop:SetPoint("TOPLEFT", -2, 2)
	FriendsFrameBroadcastInput.backdrop:SetPoint("BOTTOMRIGHT", 0, 1)

	FriendsFrameBattlenetFrame.BroadcastButton:SetAlpha(0)
	FriendsFrameBattlenetFrame.BroadcastButton:ClearAllPoints()
	FriendsFrameBattlenetFrame.BroadcastButton:SetAllPoints(FriendsFrameBattlenetFrame)

	FriendsFrameBattlenetFrame.BroadcastFrame:StripTextures()
	FriendsFrameBattlenetFrame.BroadcastFrame:CreateBackdrop("Transparent")
	FriendsFrameBattlenetFrame.BroadcastFrame.backdrop:SetPoint("TOPLEFT", 1, 1)
	FriendsFrameBattlenetFrame.BroadcastFrame.backdrop:SetPoint("BOTTOMRIGHT", 1, 1)

	FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame:StripTextures()
	FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame:CreateBackdrop("Overlay")
	FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame.backdrop:SetPoint("TOPLEFT", -2, 4)
	FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame.backdrop:SetPoint("BOTTOMRIGHT", 2, 0)
	FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame.CancelButton:SkinButton()
	FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame.UpdateButton:SkinButton()

	FriendsFrameBattlenetFrame.UnavailableInfoFrame:StripTextures()
	FriendsFrameBattlenetFrame.UnavailableInfoFrame:CreateBackdrop("Transparent")
	FriendsFrameBattlenetFrame.UnavailableInfoFrame.backdrop:SetPoint("TOPLEFT", 4, -4)
	FriendsFrameBattlenetFrame.UnavailableInfoFrame.backdrop:SetPoint("BOTTOMRIGHT", -4, 4)

	BattleTagInviteFrame:SetTemplate("Transparent")
	for i = 1, BattleTagInviteFrame:GetNumChildren() do
		local child = select(i, BattleTagInviteFrame:GetChildren())
		if child:GetObjectType() == "Button" then
			child:SkinButton()
		end
	end

	FriendsFrame:SetTemplate("Transparent")

	--[[
	ScrollOfResurrectionSelectionFrame:SetTemplate("Transparent")
	ScrollOfResurrectionSelectionFrameList:SetTemplate("Overlay")
	T.SkinEditBox(ScrollOfResurrectionSelectionFrameTargetEditBox, nil, ScrollOfResurrectionSelectionFrameTargetEditBox:GetHeight() - 5)

	ScrollOfResurrectionFrame:SetTemplate("Transparent")
	ScrollOfResurrectionFrameNoteFrame:SetTemplate("Overlay")
	T.SkinEditBox(ScrollOfResurrectionFrameTargetEditBox, nil, ScrollOfResurrectionFrameTargetEditBox:GetHeight() - 5)

	RecruitAFriendFrame:SetTemplate("Transparent")
	T.SkinCloseButton(RecruitAFriendFrameCloseButton)
	T.SkinEditBox(RecruitAFriendNameEditBox)
	T.SkinEditBox(RecruitAFriendNoteFrame)

	RecruitAFriendSentFrame:SetTemplate("Transparent")
	RecruitAFriendSentFrame.OKButton:SkinButton()
	T.SkinCloseButton(RecruitAFriendSentFrameCloseButton)

	FriendsTabHeaderSoRButton:SetTemplate("Default")
	FriendsTabHeaderSoRButton:StyleButton()
	FriendsTabHeaderSoRButton.icon:SetDrawLayer("OVERLAY")
	FriendsTabHeaderSoRButton.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	FriendsTabHeaderSoRButton.icon:ClearAllPoints()
	FriendsTabHeaderSoRButton.icon:SetPoint("TOPLEFT", 2, -2)
	FriendsTabHeaderSoRButton.icon:SetPoint("BOTTOMRIGHT", -2, 2)

	FriendsTabHeaderRecruitAFriendButton:SetTemplate("Default")
	FriendsTabHeaderRecruitAFriendButton:StyleButton()
	FriendsTabHeaderRecruitAFriendButton:SetSize(23, 23)
	FriendsTabHeaderRecruitAFriendButton:ClearAllPoints()
	FriendsTabHeaderRecruitAFriendButton:SetPoint("TOPRIGHT", FriendsFrame, -9, -58)
	FriendsTabHeaderRecruitAFriendButtonIcon:SetDrawLayer("OVERLAY")
	FriendsTabHeaderRecruitAFriendButtonIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	FriendsTabHeaderRecruitAFriendButtonIcon:ClearAllPoints()
	FriendsTabHeaderRecruitAFriendButtonIcon:SetPoint("TOPLEFT", 2, -2)
	FriendsTabHeaderRecruitAFriendButtonIcon:SetPoint("BOTTOMRIGHT", -2, 2)
	--]]

	T.SkinCloseButton(FriendsFrameCloseButton)
	T.SkinDropDownBox(WhoFrameDropdown, 150)
	T.SkinDropDownBox(FriendsFrameStatusDropdown, 70)
	T.SkinDropDownBox(FriendsFriendsFrameDropdown)

	-- Bottom Tabs
	FriendsFrameTab1:ClearAllPoints()
	FriendsFrameTab1:SetPoint("TOPLEFT", FriendsFrame, "BOTTOMLEFT", 2, -2)
	for i = 1, 5 do
		T.SkinTab(_G["FriendsFrameTab"..i])
	end

	for i = 1, 2 do
		T.SkinTab(_G["FriendsTabHeaderTab"..i], true)
	end
end

tinsert(T.SkinFuncs["ShestakUI"], LoadSkin)
