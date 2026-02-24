local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	TrainerUI skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	ClassTrainerFrame:StripTextures(true)
	ClassTrainerFrame:CreateBackdrop("Transparent")
	ClassTrainerFrame.backdrop:SetPoint("TOPLEFT", 10, -12)
	ClassTrainerFrame.backdrop:SetPoint("BOTTOMRIGHT", -32, 76)

	T.SkinCloseButton(ClassTrainerFrameCloseButton, ClassTrainerFrame.backdrop)

	ClassTrainerNameText:ClearAllPoints()
	ClassTrainerNameText:SetPoint("TOP", ClassTrainerFrame.backdrop, "TOP", 0, -6)
	ClassTrainerGreetingText:ClearAllPoints()
	ClassTrainerGreetingText:SetPoint("TOP", ClassTrainerNameText, "BOTTOM", 0, -4)

	ClassTrainerCancelButton:SkinButton()
	ClassTrainerTrainButton:SkinButton()
	ClassTrainerTrainButton:ClearAllPoints()
	ClassTrainerTrainButton:SetPoint("RIGHT", ClassTrainerCancelButton, "LEFT", -2, 0)

	if T.TBC then
		T.SkinDropDownBox(ClassTrainerFrame.FilterDropdown)
	else
		T.SkinFilter(ClassTrainerFrame.FilterDropdown)
	end

	ClassTrainerListScrollFrame:StripTextures()
	T.SkinScrollBar(ClassTrainerListScrollFrameScrollBar)

	ClassTrainerDetailScrollFrame:StripTextures()
	T.SkinScrollBar(ClassTrainerDetailScrollFrameScrollBar)

	if ClassTrainerSkillIcon then
		ClassTrainerSkillIcon:StripTextures()
		ClassTrainerSkillIcon:SetTemplate("Default")
	end

	hooksecurefunc("ClassTrainer_SetSelection", function()
		if ClassTrainerSkillIcon:GetNormalTexture() and not ClassTrainerSkillIcon.styled then
			ClassTrainerSkillIcon:GetNormalTexture():ClearAllPoints()
			ClassTrainerSkillIcon:GetNormalTexture():SetPoint("TOPLEFT", 2, -2)
			ClassTrainerSkillIcon:GetNormalTexture():SetPoint("BOTTOMRIGHT", -2, 2)
			ClassTrainerSkillIcon:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
			ClassTrainerSkillIcon.styled = true
		end
	end)

	ClassTrainerExpandButtonFrame:StripTextures()
	ClassTrainerCollapseAllButton:StripTextures()
	T.SkinExpandOrCollapse(ClassTrainerCollapseAllButton)

	-- local function UpdateFrame()
		-- local numSkills = GetNumTrainerServices()
		-- local offset = FauxScrollFrame_GetOffset(ClassTrainerListScrollFrame)
		-- local index, button

		-- for i = 1, CLASS_TRAINER_SKILLS_DISPLAYED do
			-- button = _G["ClassTrainerSkill"..i]
			-- index = offset + i

			-- if index <= numSkills then
				-- local _, _, serviceType = GetTrainerServiceInfo(index)

				-- if serviceType == "header" then
					-- if not button.hooked then
						-- T.SkinExpandOrCollapse(button)
						-- button.hooked = true
					-- end
				-- end
			-- end
		-- end
	-- end
	-- hooksecurefunc("ClassTrainerFrame_Update", UpdateFrame)
end

T.SkinFuncs["Blizzard_TrainerUI"] = LoadSkin
