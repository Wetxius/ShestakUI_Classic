local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	EventTrace skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	local frame = EventTrace
	T.SkinCloseButton(frame.CloseButton)

	frame:StripTextures()
	frame:SetTemplate("Transparent")

	if EventTrace.SubtitleBar.OptionsDropDown then
		EventTrace.SubtitleBar.OptionsDropDown:SkinButton()
	end

	if EventTrace.SubtitleBar.OptionsDropdown then
		EventTrace.SubtitleBar.OptionsDropdown:SkinButton()
	end
	T.SkinEditBox(EventTrace.Log.Bar.SearchBox, nil, 16)

	if EventTrace.Log.Events.ScrollBar.Background then
		EventTrace.Log.Events.ScrollBar.Background:Hide()
	end

	EventTraceTooltip:HookScript("OnShow", function(self)
		self.NineSlice:SetTemplate("Transparent")
	end)
end

T.SkinFuncs["Blizzard_EventTrace"] = LoadSkin