local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	AddonList skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	if not T.TBC then
		local buttons = {
			"AddonListEnableAllButton",
			"AddonListDisableAllButton",
			"AddonListCancelButton",
			"AddonListOkayButton"
		}

		for _, button in pairs(buttons) do
			_G[button]:SkinButton()
		end
	else
		local buttons = {
			AddonList.EnableAllButton,
			AddonList.DisableAllButton,
			AddonList.CancelButton,
			AddonList.OkayButton
		}

		for i = 1, #buttons do
			local frame = buttons[i]
			if frame then
				frame:SkinButton()
			end
		end
	end

	AddonList:StripTextures()
	AddonList:SetTemplate("Transparent")
	AddonList:SetHeight(AddonList:GetHeight() + 3)

	AddonListInset:StripTextures()
	AddonListInset:SetTemplate("Overlay")
	AddonListInset:SetPoint("BOTTOMRIGHT", -6, 29)

	if T.Classic and not T.TBC then
		for i = 1, MAX_ADDONS_DISPLAYED do
			T.SkinCheckBox(_G["AddonListEntry"..i.."Enabled"], nil, true)
			_G["AddonListEntry"..i.."Load"]:SkinButton()
		end
	else
		local function forceSaturation(self, _, force)
			if force then return end
			self:SetVertexColor(0.6, 0.6, 0.6)
			self:SetDesaturated(true, true)
		end

		hooksecurefunc("AddonList_InitAddon", function(child)
			if not child.styled then
				T.SkinCheckBox(child.Enabled)
				child.LoadAddonButton:SkinButton()
				hooksecurefunc(child.Enabled:GetCheckedTexture(), "SetDesaturated", forceSaturation)

				T.ReplaceIconString(child.Title)
				hooksecurefunc(child.Title, "SetText", T.ReplaceIconString)

				child.styled = true
			end
		end)
	end

	if T.Classic and not T.TBC then
		AddonListScrollFrame:StripTextures()
		T.SkinScrollBar(AddonListScrollFrameScrollBar)
	else
		T.SkinScrollBar(AddonList.ScrollBar)
	end
	T.SkinCloseButton(AddonListCloseButton)
	T.SkinDropDownBox(AddonList.Dropdown)
	if AddonListForceLoad then
		T.SkinCheckBox(AddonListForceLoad)
		AddonListForceLoad:SetSize(25, 25)
	end
	if AddonList.ForceLoad then
		T.SkinCheckBox(AddonList.ForceLoad)
		AddonList.ForceLoad:SetSize(25, 25)
		T.SkinEditBox(AddonList.SearchBox)
	end
end

tinsert(T.SkinFuncs["ShestakUI"], LoadSkin)
