local T, C, L = unpack(ShestakUI)

----------------------------------------------------------------------------------------
--	Number value function
----------------------------------------------------------------------------------------
T.Round = function(number, decimals)
	if not decimals then decimals = 0 end
	if decimals and decimals > 0 then
		local mult = 10 ^ decimals
		return floor(number * mult + 0.5) / mult
	end
	return floor(number + 0.5)
end

T.ShortValue = function(value)
	if value >= 1e11 then
		return ("%.0fb"):format(value / 1e9)
	elseif value >= 1e10 then
		return ("%.1fb"):format(value / 1e9):gsub("%.?0+([km])$", "%1")
	elseif value >= 1e9 then
		return ("%.2fb"):format(value / 1e9):gsub("%.?0+([km])$", "%1")
	elseif value >= 1e8 then
		return ("%.0fm"):format(value / 1e6)
	elseif value >= 1e7 then
		return ("%.1fm"):format(value / 1e6):gsub("%.?0+([km])$", "%1")
	elseif value >= 1e6 then
		return ("%.2fm"):format(value / 1e6):gsub("%.?0+([km])$", "%1")
	elseif value >= 1e5 then
		return ("%.0fk"):format(value / 1e3)
	elseif value >= 1e3 then
		return ("%.1fk"):format(value / 1e3):gsub("%.?0+([km])$", "%1")
	else
		return value
	end
end

T.RGBToHex = function(r, g, b)
	r = tonumber(r) <= 1 and tonumber(r) >= 0 and tonumber(r) or 0
	g = tonumber(g) <= tonumber(g) and tonumber(g) >= 0 and tonumber(g) or 0
	b = tonumber(b) <= 1 and tonumber(b) >= 0 and tonumber(b) or 0
	return string.format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
end

----------------------------------------------------------------------------------------
--	Chat channel check
----------------------------------------------------------------------------------------
T.CheckChat = function(warning)
	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		return "INSTANCE_CHAT"
	elseif IsInRaid(LE_PARTY_CATEGORY_HOME) then
		if warning and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or IsEveryoneAssistant()) then
			return "RAID_WARNING"
		else
			return "RAID"
		end
	elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
		return "PARTY"
	end
	return "SAY"
end

----------------------------------------------------------------------------------------
--	Player's role check
----------------------------------------------------------------------------------------
local isCaster = {
	DEATHKNIGHT = {nil, nil, nil},
	DEMONHUNTER = {nil, nil},
	DRUID = {true},					-- Balance
	HUNTER = {nil, nil, nil},
	MAGE = {true, true, true},
	MONK = {nil, nil, nil},
	PALADIN = {nil, nil, nil},
	PRIEST = {nil, nil, true},		-- Shadow
	ROGUE = {nil, nil, nil},
	SHAMAN = {true},				-- Elemental
	WARLOCK = {true, true, true},
	WARRIOR = {nil, nil, nil},
	EVOKER = {true}
}

local function CheckRole()
	local spec, role
	if T.Classic then
		spec = T.GetSpecialization()
		role = spec and T.GetSpecializationRole(spec)
	else
		spec = GetSpecialization()
		role = spec and GetSpecializationRole(spec)
	end

	T.Spec = spec
	if role == "TANK" then
		T.Role = "Tank"
	elseif role == "HEALER" then
		T.Role = "Healer"
	elseif role == "DAMAGER" then
		if isCaster[T.class][spec] then
			T.Role = "Caster"
		else
			T.Role = "Melee"
		end
	elseif role == "MELEE" then
		T.Role = "Melee"
	elseif role == "CASTER" then
		T.Role = "Caster"
	end
end
local RoleUpdater = CreateFrame("Frame")
RoleUpdater:RegisterEvent("PLAYER_ENTERING_WORLD")
if T.Vanilla or T.TBC then
	RoleUpdater:RegisterEvent("CHARACTER_POINTS_CHANGED")
	RoleUpdater:RegisterUnitEvent("UNIT_INVENTORY_CHANGED", "player", "")
	RoleUpdater:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
	if T.SoD then
		RoleUpdater:RegisterEvent("RUNE_UPDATED")
	end
elseif T.Wrath or T.Cata or T.Mists then
	RoleUpdater:RegisterEvent("PLAYER_TALENT_UPDATE")
	RoleUpdater:RegisterUnitEvent("UNIT_INVENTORY_CHANGED", "player", "")
	RoleUpdater:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
	if T.class == "DEATHKNIGHT" then
		RoleUpdater:RegisterEvent("UPDATE_SHAPESHIFT_COOLDOWN")
	end
else
	RoleUpdater:RegisterEvent("PLAYER_TALENT_UPDATE")
end
RoleUpdater:SetScript("OnEvent", CheckRole)

T.IsHealerSpec = function()
	local healer = false
	local spec = GetSpecialization()

	if (T.class == "EVOKER" and spec == 2) or (T.class == "DRUID" and spec == 4) or (T.class == "MONK" and spec == 2) or
	(T.class == "PALADIN" and spec == 1) or (T.class == "PRIEST" and spec ~= 3) or (T.class == "SHAMAN" and spec == 3) then
		healer = true
	end

	return healer
end

----------------------------------------------------------------------------------------
--	Player's buff check
----------------------------------------------------------------------------------------
T.CheckPlayerBuff = function(spell)
	for i = 1, 40 do
		local name, _, _, _, _, _, unitCaster = UnitBuff("player", i)
		if not name then break end
		if name == spell then
			return i, unitCaster
		end
	end
	return nil
end

----------------------------------------------------------------------------------------
--	Player's level check
----------------------------------------------------------------------------------------
local function CheckLevel(_, _, level)
	T.level = level
end
local LevelUpdater = CreateFrame("Frame")
LevelUpdater:RegisterEvent("PLAYER_LEVEL_UP")
LevelUpdater:SetScript("OnEvent", CheckLevel)

----------------------------------------------------------------------------------------
--	Pet Battle Hider
----------------------------------------------------------------------------------------
if T.Mainline then
	T_PetBattleFrameHider = CreateFrame("Frame", "ShestakUI_PetBattleFrameHider", UIParent, "SecureHandlerStateTemplate")
	T_PetBattleFrameHider:SetAllPoints()
	T_PetBattleFrameHider:SetFrameStrata("LOW")
	RegisterStateDriver(T_PetBattleFrameHider, "visibility", "[petbattle] hide; show")
end

----------------------------------------------------------------------------------------
--	UTF functions
----------------------------------------------------------------------------------------
T.UTF = function(string, i, dots)
	if not string then return end
	local bytes = string:len()
	if bytes <= i then
		return string
	else
		local len, pos = 0, 1
		while (pos <= bytes) do
			len = len + 1
			local c = string:byte(pos)
			if c > 0 and c <= 127 then
				pos = pos + 1
			elseif c >= 192 and c <= 223 then
				pos = pos + 2
			elseif c >= 224 and c <= 239 then
				pos = pos + 3
			elseif c >= 240 and c <= 247 then
				pos = pos + 4
			end
			if len == i then break end
		end
		if len == i and pos <= bytes then
			return string:sub(1, pos - 1)..(dots and "..." or "")
		else
			return string
		end
	end
end

----------------------------------------------------------------------------------------
--	Move functions
----------------------------------------------------------------------------------------
T.CalculateMoverPoints = function(mover)
	local centerX, centerY = UIParent:GetCenter()
	local width = UIParent:GetRight()
	local x, y = mover:GetCenter()

	local point = "BOTTOM"
	if y >= centerY then
		point = "TOP"
		y = -(UIParent:GetTop() - mover:GetTop())
	else
		y = mover:GetBottom()
	end

	if x >= (width * 2 / 3) then
		point = point.."RIGHT"
		x = mover:GetRight() - width
	elseif x <= (width / 3) then
		point = point.."LEFT"
		x = mover:GetLeft()
	else
		x = x - centerX
	end

	return x, y, point
end

T.IsFramePositionedLeft = function(frame)
	local x = frame:GetCenter()
	local screenWidth = GetScreenWidth()
	local positionedLeft = false

	if x and x < (screenWidth / 2) then
		positionedLeft = true
	end

	return positionedLeft
end

T.CurrentProfile = function(reset)
	if ShestakUIOptionsGlobal[T.realm][T.name] then
		if ShestakUIPositionsPerChar == nil then
			ShestakUIPositionsPerChar = ShestakUIPositions
		end
		if not ShestakUIPositionsPerChar then return {} end
		local i = tostring(ShestakUIOptionsGlobal[T.realm]["Current_Profile"][T.name])
		ShestakUIPositionsPerChar[i] = ShestakUIPositionsPerChar[i] or {}
		if reset then
			ShestakUIPositionsPerChar[i] = {}
		else
			return ShestakUIPositionsPerChar[i]
		end
	else
		if not ShestakUIPositions then return {} end
		local i = tostring(ShestakUIOptionsGlobal["Current_Profile"])
		ShestakUIPositions[i] = ShestakUIPositions[i] or {}
		if reset then
			ShestakUIPositions[i] = {}
		else
			return ShestakUIPositions[i]
		end
	end
end