local T, C, L = unpack(ShestakUI)

----------------------------------------------------------------------------------------
--	ShestakUI variables
----------------------------------------------------------------------------------------
T.dummy = function() return end
T.name = UnitName("player")
T.race = select(2, UnitRace("player"))
T.class = select(2, UnitClass("player"))
T.level = UnitLevel("player")
T.client = GetLocale()
T.realm = GetRealmName()
T.color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[T.class]
T.version = C_AddOns.GetAddOnMetadata("ShestakUI", "Version")
T.screenWidth, T.screenHeight = GetPhysicalScreenSize()
T.HiDPI = GetScreenHeight() / T.screenHeight < 0.75

T.toc = select(4, GetBuildInfo())
T.newPatch = T.toc >= 100105

do -- Expansions
	T.TBC = WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC
	T.Cata = WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC
	T.Mists = WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC
	T.Wrath = WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC
	T.Mainline = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
	T.Vanilla = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
	T.Classic = WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE

	local season = C_Seasons and C_Seasons.GetActiveSeason()
	T.HardCore = season == 3		-- Hardcore
	T.SoD = season == 2				-- Season of Discovery
	T.ClassicAnniv = season == 11	-- Anniversary
	T.ClassicAnnivHC = season == 12	-- Anniversary Hardcore

	T.SoM = C_Seasons and C_Seasons.HasActiveSeason() and C_Seasons.GetActiveSeason() == Enum.SeasonID.SeasonOfMastery

	local IsHardcoreActive = C_GameRules and C_GameRules.IsHardcoreActive
	T.Hardcore = IsHardcoreActive and IsHardcoreActive()

	local IsEngravingEnabled = C_Engraving and C_Engraving.IsEngravingEnabled
	T.IsEngravingEnabled = IsEngravingEnabled and IsEngravingEnabled()
end

-- BETA
GetContainerItemInfo = GetContainerItemInfo or function(bagIndex, slotIndex)
	local info = C_Container.GetContainerItemInfo(bagIndex, slotIndex)
	if info then
		return info.iconFileID, info.stackCount, info.isLocked, info.quality, info.isReadable, info.hasLoot, info.hyperlink, info.isFiltered, info.hasNoValue, info.itemID, info.isBound
	end
end

local function EasyMenu_Initialize(frame, level, menuList)
	for index = 1, #menuList do
		local value = menuList[index]
		if value.text then
			value.index = index
			UIDropDownMenu_AddButton(value, level)
		end
	end
end

function EasyMenu(menuList, menuFrame, anchor, x, y, displayMode, autoHideDelay)
	if displayMode == "MENU"  then
		menuFrame.displayMode = displayMode
	end
	UIDropDownMenu_Initialize(menuFrame, EasyMenu_Initialize, displayMode, nil, menuList)
	ToggleDropDownMenu(1, nil, menuFrame, anchor, x, y, menuList, nil, autoHideDelay)
end