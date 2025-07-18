local T, C, L = unpack(ShestakUI)
if C.unitframe.enable ~= true then return end

----------------------------------------------------------------------------------------
--	UnitFrames based on oUF_Caellian(by Caellian)
----------------------------------------------------------------------------------------
local _, ns = ...
local oUF = ns.oUF

-- Frame size
if C.unitframe.extra_height_auto then
	C.unitframe.extra_health_height = C.font.unit_frames_font_size - 8
	C.unitframe.extra_power_height = C.font.unit_frames_font_size - 8
end
T.extraHeight = C.unitframe.extra_health_height + C.unitframe.extra_power_height

local player_width = C.unitframe.player_width
local pet_width = (player_width - 7) / 2
local boss_width = C.unitframe.boss_width

-- Create layout
local function Shared(self, unit)
	-- Set our own colors
	self.colors = T.oUF_colors

	-- Register click
	self:RegisterForClicks("AnyUp")
	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)

	local unit = (unit and unit:find("arena%dtarget")) and "arenatarget"
			or (unit and unit:find("arena%d")) and "arena"
			or (unit and unit:find("boss%d")) and "boss" or unit

	-- Menu
	if (not T.Vanilla and (unit == "arena" and C.unitframe.show_arena == true and unit ~= "arenatarget")) or (unit == "boss" and C.unitframe.show_boss == true) then
		self:SetAttribute("type2", "focus")
		self:SetAttribute("type3", "macro")
		self:SetAttribute("macrotext3", "/clearfocus")
		self:SetAttribute("oUF-enableArenaPrep", false)
	else
		self:SetAttribute("*type2", "togglemenu")
	end

	-- Backdrop for every units
	self:CreateBackdrop("Default")
	self:SetFrameStrata("BACKGROUND")
	self.backdrop:SetFrameLevel(T.Classic and 2 or 3)

	-- Health bar
	self.Health = CreateFrame("StatusBar", self:GetName().."_Health", self)
	if unit == "player" or unit == "target" or unit == "arena" or unit == "boss" then
		self.Health:SetHeight(21 + C.unitframe.extra_health_height)
	elseif unit == "arenatarget" then
		self.Health:SetHeight(27 + T.extraHeight)
	else
		self.Health:SetHeight(13 + (C.unitframe.extra_health_height / 2))
	end
	self.Health:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
	self.Health:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0)
	self.Health:SetStatusBarTexture(C.media.texture)

	if T.Classic then
		self.Health.frequentUpdates = true
	end

	if C.unitframe.own_color == true then
		self.Health.colorTapping = false
		self.Health.colorDisconnected = false
		self.Health.colorClass = false
		self.Health.colorReaction = false
		self.Health:SetStatusBarColor(unpack(C.unitframe.uf_color))
	else
		self.Health.colorTapping = true
		self.Health.colorDisconnected = true
		self.Health.colorClass = true
		self.Health.colorReaction = true
	end

	if T.Classic and not T.Cata and not T.Mists and unit == "pet" and C.unitframe.bar_color_happiness == true then
		self.Health.colorHappiness = true
	else
		self.Health.colorHappiness = false
	end

	if C.unitframe.plugins_smooth_bar == true then
		self.Health.Smooth = true
	end

	self.Health.PostUpdate = T.PostUpdateHealth
	self.Health.PostUpdateColor = T.PostUpdateHealthColor

	-- Health bar background
	self.Health.bg = self.Health:CreateTexture(nil, "BORDER")
	self.Health.bg:SetAllPoints()
	self.Health.bg:SetTexture(C.media.texture)
	if C.unitframe.own_color == true then
		self.Health.bg:SetVertexColor(unpack(C.unitframe.uf_color_bg))
	else
		self.Health.bg.multiplier = 0.2
	end

	self.Health.value = T.SetFontString(self.Health, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
	if unit == "player" or unit == "pet" or unit == "focus" then
		self.Health.value:SetPoint("RIGHT", self.Health, "RIGHT", 0, 0)
		self.Health.value:SetJustifyH("RIGHT")
	elseif unit == "arena" then
		if C.unitframe.arena_on_right == true then
			self.Health.value:SetPoint("LEFT", self.Health, "LEFT", 2, 0)
			self.Health.value:SetJustifyH("LEFT")
		else
			self.Health.value:SetPoint("RIGHT", self.Health, "RIGHT", 0, 0)
			self.Health.value:SetJustifyH("RIGHT")
		end
	elseif unit == "boss" then
		if C.unitframe.boss_on_right == true then
			self.Health.value:SetPoint("LEFT", self.Health, "LEFT", 2, 0)
			self.Health.value:SetJustifyH("LEFT")
		else
			self.Health.value:SetPoint("RIGHT", self.Health, "RIGHT", 0, 0)
			self.Health.value:SetJustifyH("RIGHT")
		end
	elseif unit == "arenatarget" then
		self.Health.value:Hide()
	else
		self.Health.value:SetPoint("LEFT", self.Health, "LEFT", 2, 0)
		self.Health.value:SetJustifyH("LEFT")
	end

	-- Power bar
	self.Power = CreateFrame("StatusBar", self:GetName().."_Power", self)
	if unit == "player" or unit == "target" or unit == "arena" or unit == "boss" then
		self.Power:SetHeight(5 + C.unitframe.extra_power_height)
	elseif unit == "arenatarget" then
		self.Power:SetHeight(0)
	else
		self.Power:SetHeight(2)
	end
	self.Power:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, -1)
	self.Power:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", 0, -1)
	self.Power:SetStatusBarTexture(C.media.texture)

	self.Power.frequentUpdates = true
	self.Power.colorDisconnected = true
	self.Power.colorTapping = true
	if C.unitframe.own_color == true then
		self.Power.colorClass = true
	else
		self.Power.colorPower = true
	end
	if C.unitframe.plugins_smooth_bar == true then
		self.Power.Smooth = true
	end

	self.Power.PreUpdate = T.PreUpdatePower
	self.Power.PostUpdate = T.PostUpdatePower
	self.Power.PostUpdateColor = T.PostUpdatePowerColor

	self.Power.bg = self.Power:CreateTexture(nil, "BORDER")
	self.Power.bg:SetAllPoints()
	self.Power.bg:SetTexture(C.media.texture)
	if C.unitframe.own_color == true and unit == "pet" then
		self.Power.bg:SetVertexColor(C.unitframe.uf_color[1], C.unitframe.uf_color[2], C.unitframe.uf_color[3], 0.2)
	else
		self.Power.bg.multiplier = 0.2
	end

	self.Power.value = T.SetFontString(self.Power, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
	if unit == "player" then
		self.Power.value:SetPoint("RIGHT", self.Power, "RIGHT", 0, 0)
		self.Power.value:SetJustifyH("RIGHT")
	elseif unit == "arena" then
		if C.unitframe.arena_on_right == true then
			self.Power.value:SetPoint("LEFT", self.Power, "LEFT", 2, 0)
			self.Power.value:SetJustifyH("LEFT")
		else
			self.Power.value:SetPoint("RIGHT", self.Power, "RIGHT", 0, 0)
			self.Power.value:SetJustifyH("RIGHT")
		end
	elseif unit == "boss" then
		if C.unitframe.boss_on_right == true then
			self.Power.value:SetPoint("LEFT", self.Power, "LEFT", 2, 0)
			self.Power.value:SetJustifyH("LEFT")
		else
			self.Power.value:SetPoint("RIGHT", self.Power, "RIGHT", 0, 0)
			self.Power.value:SetJustifyH("RIGHT")
		end
	elseif unit == "pet" or unit == "focus" or unit == "focustarget" or unit == "targettarget" then
		self.Power.value:Hide()
	else
		self.Power.value:SetPoint("LEFT", self.Power, "LEFT", 2, 0)
		self.Power.value:SetJustifyH("LEFT")
	end

	-- Names
	if unit ~= "player" then
		self.Info = T.SetFontString(self.Health, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
		self.Info:SetWordWrap(false)
		if unit ~= "arenatarget" then
			self.Level = T.SetFontString(self.Power, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
		end
		if unit == "target" then
			self.Info:SetPoint("RIGHT", self.Health, "RIGHT", 0, 0)
			self.Info:SetPoint("LEFT", self.Health.value, "RIGHT", 0, 0)
			self.Info:SetJustifyH("RIGHT")
			self:Tag(self.Info, "[GetNameColor][NameLong]")
			self.Level:SetPoint("RIGHT", self.Power, "RIGHT", 0, 0)
			self:Tag(self.Level, "[cpoints] [Threat] [DiffColor][level][shortclassification]")
		elseif unit == "focus" or unit == "pet" then
			self.Info:SetPoint("LEFT", self.Health, "LEFT", 2, 0)
			self.Info:SetPoint("RIGHT", self.Health.value, "LEFT", 0, 0)
			self.Info:SetJustifyH("LEFT")
			if unit == "pet" then
				self:Tag(self.Info, "[PetNameColor][NameMedium]")
			else
				self:Tag(self.Info, "[GetNameColor][NameMedium]")
			end
		elseif unit == "arenatarget" then
			self.Info:SetPoint("CENTER", self.Health, "CENTER", 1, 0)
			self:Tag(self.Info, "[GetNameColor][NameArena]")
		elseif unit == "arena" then
			if C.unitframe.arena_on_right == true then
				self.Info:SetPoint("RIGHT", self.Health, "RIGHT", 0, 0)
				self.Info:SetPoint("LEFT", self.Health.value, "RIGHT", 0, 0)
				self.Info:SetJustifyH("RIGHT")
			else
				self.Info:SetPoint("LEFT", self.Health, "LEFT", 2, 0)
				self.Info:SetPoint("RIGHT", self.Health.value, "LEFT", 0, 0)
				self.Info:SetJustifyH("LEFT")
			end
			self:Tag(self.Info, "[GetNameColor][NameMedium]")
		elseif unit == "boss" then
			if C.unitframe.boss_on_right == true then
				self.Info:SetPoint("RIGHT", self.Health, "RIGHT", 0, 0)
				self.Info:SetPoint("LEFT", self.Health.value, "RIGHT", 0, 0)
				self.Info:SetJustifyH("RIGHT")
			else
				self.Info:SetPoint("LEFT", self.Health, "LEFT", 2, 0)
				self.Info:SetPoint("RIGHT", self.Health.value, "LEFT", 0, 0)
				self.Info:SetJustifyH("LEFT")
			end
			self:Tag(self.Info, "[GetNameColor][NameMedium]")
		else
			self.Info:SetPoint("RIGHT", self.Health, "RIGHT", 0, 0)
			self.Info:SetPoint("LEFT", self.Health.value, "RIGHT", 0, 0)
			self.Info:SetJustifyH("RIGHT")
			self:Tag(self.Info, "[GetNameColor][NameMedium]")
		end
	end

	if unit == "player" then
		if C.unitframe.player_name then
			self.Info = T.SetFontString(self.Health, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
			self.Info:SetPoint("LEFT", self.Health, "LEFT", 2, 0)
			self:Tag(self.Info, "[GetNameColor][NameLong]")

			self.Level = T.SetFontString(self.Power, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
			self.Level:SetPoint("LEFT", self.Power, "LEFT", 2, 0)
			self:Tag(self.Level, "[DiffColor][level][shortclassification]")
		end

		self.FlashInfo = CreateFrame("Frame", "FlashInfo", self)
		self.FlashInfo:SetScript("OnUpdate", T.UpdateManaLevel)
		self.FlashInfo:SetFrameLevel(self.Health:GetFrameLevel() + 1)
		self.FlashInfo:SetAllPoints(self.Health)

		self.FlashInfo.ManaLevel = T.SetFontString(self.FlashInfo, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
		self.FlashInfo.ManaLevel:SetPoint("CENTER", 0, 0)

		-- Combat icon
		if C.unitframe.icons_combat == true then
			self.CombatIndicator = self.Health:CreateTexture(nil, "OVERLAY")
			self.CombatIndicator:SetSize(18, 18)
			self.CombatIndicator:SetPoint("TOPRIGHT", 4, 8)
		end

		-- Resting icon
		if C.unitframe.icons_resting == true then
			self.RestingIndicator = self.Health:CreateTexture(nil, "OVERLAY")
			self.RestingIndicator:SetSize(18, 18)
			self.RestingIndicator:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", -8, -8)
		end

		-- Leader/Assistant icons
		if C.raidframe.icons_leader == true then
			-- Leader icon
			self.LeaderIndicator = self.Health:CreateTexture(nil, "OVERLAY")
			self.LeaderIndicator:SetSize(14, 14)
			self.LeaderIndicator:SetPoint("TOPLEFT", -3, 9)

			-- Assistant icon
			self.AssistantIndicator = self.Health:CreateTexture(nil, "OVERLAY")
			self.AssistantIndicator:SetSize(12, 12)
			self.AssistantIndicator:SetPoint("TOPLEFT", -3, 8)
		end

		-- LFD role icons
		if (T.Wrath or T.Cata or T.Mists or T.Mainline) and C.raidframe.icons_role == true then
			self.GroupRoleIndicator = self.Health:CreateTexture(nil, "OVERLAY")
			self.GroupRoleIndicator:SetSize(12, 12)
			self.GroupRoleIndicator:SetPoint("TOPLEFT", 10, 8)
		end

		-- Rune bar
		if C.unitframe_class_bar.rune == true and T.class == "DEATHKNIGHT" then
			self.Runes = CreateFrame("Frame", self:GetName().."_RuneBar", self)
			self.Runes:CreateBackdrop("Default")
			self.Runes:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
			self.Runes:SetSize(player_width, 7)
			if T.Mainline then
				self.Runes.colorSpec = true
				self.Runes.sortOrder = "asc"
			end

			for i = 1, 6 do
				self.Runes[i] = CreateFrame("StatusBar", self:GetName().."_Rune"..i, self.Runes)
				self.Runes[i]:SetSize((player_width - 5) / 6, 7)
				if i == 1 then
					self.Runes[i]:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
				else
					self.Runes[i]:SetPoint("TOPLEFT", self.Runes[i-1], "TOPRIGHT", 1, 0)
				end
				self.Runes[i]:SetStatusBarTexture(C.media.texture)

				self.Runes[i].bg = self.Runes[i]:CreateTexture(nil, "BORDER")
				self.Runes[i].bg:SetAllPoints()
				self.Runes[i].bg:SetTexture(C.media.texture)
				self.Runes[i].bg.multiplier = 0.2
			end
		end

		if T.Mainline and T.class == "MAGE" then
			-- Arcane Charge bar
			if C.unitframe_class_bar.arcane == true then
				self.ArcaneCharge = CreateFrame("Frame", self:GetName().."_ArcaneChargeBar", self)
				self.ArcaneCharge:CreateBackdrop("Default")
				self.ArcaneCharge:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
				self.ArcaneCharge:SetSize(player_width, 7)

				for i = 1, 4 do
					self.ArcaneCharge[i] = CreateFrame("StatusBar", self:GetName().."_ArcaneCharge"..i, self.ArcaneCharge)
					self.ArcaneCharge[i]:SetSize((player_width - 3) / 4, 7)
					if i == 1 then
						self.ArcaneCharge[i]:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
					else
						self.ArcaneCharge[i]:SetPoint("TOPLEFT", self.ArcaneCharge[i-1], "TOPRIGHT", 1, 0)
					end
					self.ArcaneCharge[i]:SetStatusBarTexture(C.media.texture)
					self.ArcaneCharge[i]:SetStatusBarColor(0.4, 0.8, 1)

					self.ArcaneCharge[i].bg = self.ArcaneCharge[i]:CreateTexture(nil, "BORDER")
					self.ArcaneCharge[i].bg:SetAllPoints()
					self.ArcaneCharge[i].bg:SetTexture(C.media.texture)
					self.ArcaneCharge[i].bg:SetVertexColor(0.4, 0.8, 1, 0.2)
				end
			end
		end

		if (T.Mainline or T.Mists) and T.class == "MONK" then
			-- Chi bar
			if C.unitframe_class_bar.chi == true then
				self.HarmonyBar = CreateFrame("Frame", self:GetName().."_HarmonyBar", self)
				self.HarmonyBar:CreateBackdrop("Default")
				self.HarmonyBar:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
				self.HarmonyBar:SetSize(player_width, 7)

				for i = 1, 6 do
					self.HarmonyBar[i] = CreateFrame("StatusBar", self:GetName().."_Harmony"..i, self.HarmonyBar)
					self.HarmonyBar[i]:SetSize((player_width - 5) / 6, 7)
					if i == 1 then
						self.HarmonyBar[i]:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
					else
						self.HarmonyBar[i]:SetPoint("TOPLEFT", self.HarmonyBar[i-1], "TOPRIGHT", 1, 0)
					end
					self.HarmonyBar[i]:SetStatusBarTexture(C.media.texture)
					self.HarmonyBar[i]:SetStatusBarColor(0.33, 0.63, 0.33)

					self.HarmonyBar[i].bg = self.HarmonyBar[i]:CreateTexture(nil, "BORDER")
					self.HarmonyBar[i].bg:SetAllPoints()
					self.HarmonyBar[i].bg:SetTexture(C.media.texture)
					self.HarmonyBar[i].bg:SetVertexColor(0.33, 0.63, 0.33, 0.2)
				end
			end

			-- Stagger bar
			if C.unitframe_class_bar.stagger == true then
				self.Stagger = CreateFrame("StatusBar", self:GetName().."_Stagger", self)
				self.Stagger:CreateBackdrop("Default")
				self.Stagger:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
				self.Stagger:SetSize(player_width, 7)
				self.Stagger:SetStatusBarTexture(C.media.texture)

				self.Stagger.bg = self.Stagger:CreateTexture(nil, "BORDER")
				self.Stagger.bg:SetAllPoints()
				self.Stagger.bg:SetTexture(C.media.texture)
				self.Stagger.bg.multiplier = 0.2

				self.Stagger.Text = T.SetFontString(self.Stagger, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
				self.Stagger.Text:SetPoint("CENTER", self.Stagger, "CENTER", 0, 0)
			end
		end

		-- Holy Power bar
		if (T.Cata or T.Mists or T.Mainline) and C.unitframe_class_bar.holy == true and T.class == "PALADIN" then
			self.HolyPower = CreateFrame("Frame", self:GetName().."_HolyPowerBar", self)
			self.HolyPower:CreateBackdrop("Default")
			self.HolyPower:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
			self.HolyPower:SetSize(player_width, 7)

			local maxHolyPower = T.Classic and 3 or 5
			for i = 1, maxHolyPower do
				self.HolyPower[i] = CreateFrame("StatusBar", self:GetName().."_HolyPower"..i, self.HolyPower)
				self.HolyPower[i]:SetSize((player_width - (T.Classic and 2 or 4)) / maxHolyPower, 7)
				if i == 1 then
					self.HolyPower[i]:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
				else
					self.HolyPower[i]:SetPoint("TOPLEFT", self.HolyPower[i-1], "TOPRIGHT", 1, 0)
				end
				self.HolyPower[i]:SetStatusBarTexture(C.media.texture)
				self.HolyPower[i]:SetStatusBarColor(0.89, 0.88, 0.1)

				self.HolyPower[i].bg = self.HolyPower[i]:CreateTexture(nil, "BORDER")
				self.HolyPower[i].bg:SetAllPoints()
				self.HolyPower[i].bg:SetTexture(C.media.texture)
				self.HolyPower[i].bg:SetVertexColor(0.89, 0.88, 0.1, 0.2)
			end
		end

		-- Soul Shards bar
		if (T.Cata or T.Mists or T.Mainline) and C.unitframe_class_bar.shard == true and T.class == "WARLOCK" then
			self.SoulShards = CreateFrame("Frame", self:GetName().."_SoulShardsBar", self)
			self.SoulShards:CreateBackdrop("Default")
			self.SoulShards:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
			self.SoulShards:SetSize(player_width, 7)

			local maxSoulShards = T.Classic and 3 or 5
			for i = 1, maxSoulShards do
				self.SoulShards[i] = CreateFrame("StatusBar", self:GetName().."_SoulShards"..i, self.SoulShards)
				self.SoulShards[i]:SetSize((player_width - (T.Classic and 2 or 4)) / maxSoulShards, 7)
				if i == 1 then
					self.SoulShards[i]:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
				else
					self.SoulShards[i]:SetPoint("TOPLEFT", self.SoulShards[i-1], "TOPRIGHT", 1, 0)
				end
				self.SoulShards[i]:SetStatusBarTexture(C.media.texture)
				self.SoulShards[i]:SetStatusBarColor(0.9, 0.37, 0.37)

				self.SoulShards[i].bg = self.SoulShards[i]:CreateTexture(nil, "BORDER")
				self.SoulShards[i].bg:SetAllPoints()
				self.SoulShards[i].bg:SetTexture(C.media.texture)
				self.SoulShards[i].bg:SetVertexColor(0.9, 0.37, 0.37, 0.2)
			end
		end

		-- Essence bar
		if T.Mainline and C.unitframe_class_bar.essence == true and T.class == "EVOKER" then
			self.Essence = CreateFrame("Frame", self:GetName().."_Essence", self, BackdropTemplateMixin and "BackdropTemplate", BackdropTemplateMixin and "BackdropTemplate")
			local maxEssence = UnitPowerMax(self.unit, Enum.PowerType.Essence)
			self.Essence:CreateBackdrop("Default")
			self.Essence:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
			self.Essence:SetSize(player_width, 7)

			for i = 1, 6 do
				self.Essence[i] = CreateFrame("StatusBar", self:GetName().."_Essence"..i, self.Essence, BackdropTemplateMixin and "BackdropTemplate")
				self.Essence[i]:SetSize((player_width - 5) / 6, 7)
				if i == 1 then
					self.Essence[i]:SetPoint("LEFT", self.Essence)
				else
					self.Essence[i]:SetPoint("TOPLEFT", self.Essence[i-1], "TOPRIGHT", 1, 0)
				end
				self.Essence[i]:SetStatusBarTexture(C.media.texture)
				self.Essence[i]:SetStatusBarColor(0.2, 0.58, 0.5)

				self.Essence[i].bg = self.Essence[i]:CreateTexture(nil, "BORDER")
				self.Essence[i].bg:SetAllPoints()
				self.Essence[i].bg:SetTexture(C.media.texture)
				self.Essence[i].bg:SetVertexColor(0.2, 0.58, 0.5, 0.2)
			end
		end

		-- Rogue/Druid Combo bar
		if C.unitframe_class_bar.combo == true and C.unitframe_class_bar.combo_old ~= true and (T.class == "ROGUE" or T.class == "DRUID") then
			self.ComboPoints = CreateFrame("Frame", self:GetName().."_ComboBar", self)
			self.ComboPoints:CreateBackdrop("Default")
			self.ComboPoints:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
			self.ComboPoints:SetSize(player_width, 7)

			local maxComboPoints = T.Classic and 5 or 7
			for i = 1, maxComboPoints do
				self.ComboPoints[i] = CreateFrame("StatusBar", self:GetName().."_Combo"..i, self.ComboPoints)
				self.ComboPoints[i]:SetSize((player_width - 5) / maxComboPoints, 7)
				if i == 1 then
					self.ComboPoints[i]:SetPoint("LEFT", self.ComboPoints)
				else
					self.ComboPoints[i]:SetPoint("LEFT", self.ComboPoints[i-1], "RIGHT", 1, 0)
				end
				self.ComboPoints[i]:SetStatusBarTexture(C.media.texture)
			end

			if T.Classic then
				self.ComboPoints[1]:SetStatusBarColor(0.9, 0.1, 0.1)
				self.ComboPoints[2]:SetStatusBarColor(0.9, 0.1, 0.1)
				self.ComboPoints[3]:SetStatusBarColor(0.9, 0.9, 0.1)
				self.ComboPoints[4]:SetStatusBarColor(0.9, 0.9, 0.1)
				self.ComboPoints[5]:SetStatusBarColor(0.1, 0.9, 0.1)
			end
		end

		-- Totem bar for Shaman
		if C.unitframe_class_bar.totem == true and T.class == "SHAMAN" then
			self.TotemBar = CreateFrame("Frame", self:GetName().."_TotemBar", self)
			self.TotemBar:CreateBackdrop("Default")
			self.TotemBar:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
			self.TotemBar:SetSize(player_width, 7)
			self.TotemBar.Destroy = not T.Vanilla and true

			for i = 1, 4 do
				self.TotemBar[i] = CreateFrame("StatusBar", self:GetName().."_Totem"..i, self.TotemBar)
				self.TotemBar[i]:SetSize((player_width - 3) / 4, 7)

				if i == 1 then
					self.TotemBar[i]:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
				else
					self.TotemBar[i]:SetPoint("TOPLEFT", self.TotemBar[i-1], "TOPRIGHT", 1, 0)
				end
				self.TotemBar[i]:SetStatusBarTexture(C.media.texture)
				self.TotemBar[i]:SetMinMaxValues(0, 1)

				self.TotemBar[i].bg = self.TotemBar[i]:CreateTexture(nil, "BORDER")
				self.TotemBar[i].bg:SetAllPoints()
				self.TotemBar[i].bg:SetTexture(C.media.texture)
				self.TotemBar[i].bg.multiplier = 0.2
			end
		end

		-- Totem bar for other classes
		if T.Mainline and C.unitframe_class_bar.totem == true and C.unitframe_class_bar.totem_other == true and T.class ~= "SHAMAN" then
			self.TotemBar = CreateFrame("Frame", self:GetName().."_TotemBar", self)
			self.TotemBar:SetFrameLevel(self.Health:GetFrameLevel() + 2)
			self.TotemBar:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
			self.TotemBar:SetSize(140, 7)
			self.TotemBar.Destroy = true

			for i = 1, 4 do
				self.TotemBar[i] = CreateFrame("StatusBar", self:GetName().."_Totem"..i, self.TotemBar)
				self.TotemBar[i]:SetSize(140 / 4, 7)
				if i == 1 then
					self.TotemBar[i]:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
				else
					self.TotemBar[i]:SetPoint("TOPLEFT", self.TotemBar[i-1], "TOPRIGHT", 0, 0)
				end
				self.TotemBar[i]:SetStatusBarTexture(C.media.texture)
				self.TotemBar[i]:SetMinMaxValues(0, 1)
				self.TotemBar[i]:CreateBorder(false, true)

				self.TotemBar[i].bg = self.TotemBar[i]:CreateTexture(nil, "BORDER")
				self.TotemBar[i].bg:SetAllPoints()
				self.TotemBar[i].bg:SetTexture(C.media.texture)
				self.TotemBar[i].bg.multiplier = 0.2
			end
		end

		-- Additional mana
		if T.class == "DRUID" or T.class == "PRIEST" or T.class == "SHAMAN" then
			CreateFrame("Frame"):SetScript("OnUpdate", function() T.UpdateClassMana(self) end)
			self.ClassMana = T.SetFontString(self.Power, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
			self.ClassMana:SetTextColor(1, 0.49, 0.04)
		end

		-- Eclipse bar
		if (T.Cata or T.Mists) and T.class == "DRUID" then
			if C.unitframe_class_bar.eclipse == true then
				self.EclipseBar = CreateFrame("Frame", self:GetName().."_EclipseBar", self)
				self.EclipseBar:CreateBackdrop("Default")
				self.EclipseBar:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
				self.EclipseBar:SetSize(217, 7)

				self.EclipseBar.LunarBar = CreateFrame("StatusBar", nil, self.EclipseBar)
				self.EclipseBar.LunarBar:SetPoint("LEFT", self.EclipseBar, "LEFT", 0, 0)
				self.EclipseBar.LunarBar:SetSize(self.EclipseBar:GetWidth(), self.EclipseBar:GetHeight())
				self.EclipseBar.LunarBar:SetStatusBarTexture(C.media.texture)
				self.EclipseBar.LunarBar:SetStatusBarColor(0.80, 0.80, 0.20)

				self.EclipseBar.SolarBar = CreateFrame("StatusBar", nil, self.EclipseBar)
				self.EclipseBar.SolarBar:SetPoint("LEFT", self.EclipseBar.LunarBar:GetStatusBarTexture(), "RIGHT", 0, 0)
				self.EclipseBar.SolarBar:SetSize(self.EclipseBar:GetWidth(), self.EclipseBar:GetHeight())
				self.EclipseBar.SolarBar:SetStatusBarTexture(C.media.texture)
				self.EclipseBar.SolarBar:SetStatusBarColor(0.30, 0.30, 0.80)

				self.EclipseBar.Text = T.SetFontString(self.EclipseBar.SolarBar, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
				self.EclipseBar.Text:SetPoint("CENTER", self.EclipseBar, "CENTER", -6, 0)

				self.EclipseBar.Pers = T.SetFontString(self.EclipseBar.SolarBar, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
				self.EclipseBar.Pers:SetPoint("LEFT", self.EclipseBar.Text, "RIGHT", 2, 0)
				self:Tag(self.EclipseBar.Pers, "[pereclipse]%")

				self.EclipseBar:SetScript("OnShow", function() T.UpdateEclipse(self, false) end)
				self.EclipseBar:SetScript("OnUpdate", function() T.UpdateEclipse(self, true) end)
				self.EclipseBar:SetScript("OnHide", function() T.UpdateEclipse(self, false) end)
				self.EclipseBar.PostUpdatePower = T.EclipseDirection
			end
		end

		-- Experience bar
		if C.unitframe.plugins_experience_bar == true then
			self.Experience = CreateFrame("StatusBar", self:GetName().."_Experience", self)
			self.Experience:CreateBackdrop("Default")
			self.Experience:EnableMouse(true)
			if C.unitframe.portrait_enable == true then
				self.Experience:SetPoint("TOPLEFT", self, "TOPLEFT", -25 - C.unitframe.portrait_width, 28)
			else
				self.Experience:SetPoint("TOPLEFT", self, "TOPLEFT", -18, 28)
			end
			self.Experience:SetSize(7, 94 + T.extraHeight + (C.unitframe.extra_health_height / 2))
			self.Experience:SetOrientation("Vertical")
			self.Experience:SetStatusBarTexture(C.media.texture)

			self.Experience.bg = self.Experience:CreateTexture(nil, "BORDER")
			self.Experience.bg:SetAllPoints()
			self.Experience.bg:SetTexture(C.media.texture)

			self.Experience.Rested = CreateFrame("StatusBar", nil, self.Experience)
			self.Experience.Rested:SetOrientation("Vertical")
			self.Experience.Rested:SetAllPoints()
			self.Experience.Rested:SetStatusBarTexture(C.media.texture)

			self.Experience.inAlpha = 1
			self.Experience.outAlpha = 0
		end

		-- Reputation bar
		if C.unitframe.plugins_reputation_bar == true then
			self.Reputation = CreateFrame("StatusBar", self:GetName().."_Reputation", self)
			self.Reputation:CreateBackdrop("Default")
			self.Reputation:EnableMouse(true)
			if C.unitframe.portrait_enable == true then
				if self.Experience and self.Experience:IsShown() then
					self.Reputation:SetPoint("TOPLEFT", self, "TOPLEFT", -39 - C.unitframe.portrait_width, 28)
				else
					self.Reputation:SetPoint("TOPLEFT", self, "TOPLEFT", -25 - C.unitframe.portrait_width, 28)
				end
			else
				if self.Experience and self.Experience:IsShown() then
					self.Reputation:SetPoint("TOPLEFT", self, "TOPLEFT", -32, 28)
				else
					self.Reputation:SetPoint("TOPLEFT", self, "TOPLEFT", -18, 28)
				end
			end
			self.Reputation:SetSize(7, 94 + T.extraHeight + (C.unitframe.extra_health_height / 2))
			self.Reputation:SetOrientation("Vertical")
			self.Reputation:SetStatusBarTexture(C.media.texture)

			self.Reputation.bg = self.Reputation:CreateTexture(nil, "BORDER")
			self.Reputation.bg:SetAllPoints()
			self.Reputation.bg:SetTexture(C.media.texture)

			self.Reputation.inAlpha = 1
			self.Reputation.outAlpha = 0
			self.Reputation.colorStanding = true
		end

		-- GCD spark
		if C.unitframe.plugins_gcd == true then
			self.GCD = CreateFrame("Frame", self:GetName().."_GCD", self)
			self.GCD:SetWidth(player_width + 3)
			self.GCD:SetHeight(3)
			self.GCD:SetFrameStrata("HIGH")
			self.GCD:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 0)

			self.GCD.Color = {1, 1, 1}
			self.GCD.Height = T.Scale(3)
			self.GCD.Width = T.Scale(4)
		end

		-- Power Spark
		if T.Classic and C.unitframe.plugins_power_spark == true then
			self.PowerSpark = CreateFrame("StatusBar", nil, self.Power)
			self.PowerSpark:SetFrameLevel(self.Power:GetFrameLevel() + 3)
			self.PowerSpark:SetAllPoints()
			self.PowerSpark.Spark = self.PowerSpark:CreateTexture(nil, "OVERLAY")
		end

		-- Absorbs value
		if T.Mainline and C.unitframe.plugins_absorbs == true then
			self.Absorbs = T.SetFontString(self.Health, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
			self.Absorbs:SetPoint("LEFT", self.Health, "LEFT", 4, 0)
			self:Tag(self.Absorbs, "[Absorbs]")
		end
	end

	-- Counter bar (Darkmoon Fair)
	if T.Mainline and (unit == "player" or unit == "pet") then
		self.CounterBar = CreateFrame("StatusBar", self:GetName().."_CounterBar", self)
		self.CounterBar:CreateBackdrop("Default")
		self.CounterBar:SetWidth(221)
		self.CounterBar:SetHeight(20)
		self.CounterBar:SetStatusBarTexture(C.media.texture)
		self.CounterBar:SetPoint("TOP", UIParent, "TOP", 0, -102)

		self.CounterBar.bg = self.CounterBar:CreateTexture(nil, "BORDER")
		self.CounterBar.bg:SetAllPoints()
		self.CounterBar.bg:SetTexture(C.media.texture)

		self.CounterBar.Text = T.SetFontString(self.CounterBar, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
		self.CounterBar.Text:SetPoint("CENTER")

		self.CounterBar:SetScript("OnValueChanged", function(_, value)
			local _, max = self.CounterBar:GetMinMaxValues()
			local r, g, b = oUF:ColorGradient(value, max, 0.8, 0, 0, 0.8, 0.8, 0, 0, 0.8, 0)
			self.CounterBar:SetStatusBarColor(r, g, b)
			self.CounterBar.bg:SetVertexColor(r, g, b, 0.2)
			self.CounterBar.Text:SetText(floor(value))
		end)
	end

	if unit == "pet" or unit == "targettarget" or unit == "focus" or unit == "focustarget" then
		self.Debuffs = CreateFrame("Frame", self:GetName().."_Debuffs", self)
		self.Debuffs:SetHeight(25)
		self.Debuffs:SetWidth(pet_width + 4)
		self.Debuffs.size = T.Scale(C.aura.debuff_size)
		self.Debuffs.spacing = T.Scale(3)
		self.Debuffs.num = 4
		self.Debuffs["growth-y"] = "DOWN"
		if unit == "pet" or unit == "focus" then
			self.Debuffs:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 2, -17)
			self.Debuffs.initialAnchor = "TOPRIGHT"
			self.Debuffs["growth-x"] = "LEFT"
		else
			self.Debuffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", -2, -17)
			self.Debuffs.initialAnchor = "TOPLEFT"
			self.Debuffs["growth-x"] = "RIGHT"
		end
		self.Debuffs.PostCreateButton = T.PostCreateButton
		self.Debuffs.PostUpdateButton = T.PostUpdateButton
		self.Debuffs.FilterAura = T.CustomFilter

		if unit == "pet" then
			self:RegisterEvent("UNIT_PET", T.UpdateAllElements)
		end
	end

	if unit == "player" or unit == "target" then
		if C.unitframe.portrait_enable == true then
			if C.unitframe.portrait_type == "3D" or C.unitframe.portrait_type == "OVERLAY" then
				self.Portrait = CreateFrame("PlayerModel", self:GetName().."_Portrait", self)
			else
				self.Portrait = CreateFrame("Frame", self:GetName().."_Portrait", self)
			end
			self.Portrait:SetHeight(C.unitframe.portrait_height)
			self.Portrait:SetWidth(C.unitframe.portrait_width)
			if unit == "player" then
				self.Portrait:SetPoint(unpack(C.position.unitframes.player_portrait))
			elseif unit == "target" then
				self.Portrait:SetPoint(unpack(C.position.unitframes.target_portrait))
			end

			self.Portrait.Icon = self.Portrait:CreateTexture(nil, "ARTWORK")
			self.Portrait.Icon:SetAllPoints()

			if C.unitframe.portrait_type == "ICONS" then
				self.Portrait.classIcons = true
			end

			self.Portrait:CreateBackdrop("Transparent")
			self.Portrait.backdrop:SetPoint("TOPLEFT", -2 - T.mult, 2 + T.mult)
			self.Portrait.backdrop:SetPoint("BOTTOMRIGHT", 2 + T.mult, -2 - T.mult)

			if C.unitframe.portrait_classcolor_border == true then
				if unit == "player" then
					self.Portrait.backdrop:SetBackdropBorderColor(T.color.r, T.color.g, T.color.b)
				elseif unit == "target" then
					self.Portrait.backdrop:RegisterEvent("PLAYER_TARGET_CHANGED")
					self.Portrait.backdrop:SetScript("OnEvent", function()
						local _, class = UnitClass("target")
						local color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
						if color then
							self.Portrait.backdrop:SetBackdropBorderColor(color.r, color.g, color.b)
						else
							self.Portrait.backdrop:SetBackdropBorderColor(unpack(C.media.border_color))
						end
					end)
				end
			end

			if C.unitframe.portrait_type == "OVERLAY" then
				local healthTex = self.Health:GetStatusBarTexture()
				self.Portrait:ClearAllPoints()
				self.Portrait:SetPoint("TOPLEFT", healthTex, "TOPLEFT", 0, 0)
				self.Portrait:SetPoint("BOTTOMRIGHT", healthTex, "BOTTOMRIGHT", 0, 1)
				self.Portrait:SetFrameLevel(self.Health:GetFrameLevel())
				self.Portrait.backdrop:Hide()
				self.Portrait:SetAlpha(0.5)

				if C.filger.enable then
					local frame = CreateFrame("Frame")
					frame:RegisterEvent("PLAYER_LOGIN")
					frame:SetScript("OnEvent", function()
						T_DE_BUFF_BAR_Anchor:ClearAllPoints()
						T_DE_BUFF_BAR_Anchor:SetPoint(C.position.filger.target_bar[1], C.position.filger.target_bar[2], C.position.filger.target_bar[3], C.position.filger.target_bar[4], C.position.filger.target_bar[5])
					end)
				end
			end
		end

		if unit == "player" then
			self.Debuffs = CreateFrame("Frame", self:GetName().."_Debuffs", self)
			self.Debuffs:SetHeight(165)
			self.Debuffs:SetWidth(player_width + 4)
			self.Debuffs.size = T.Scale(C.aura.debuff_size)
			self.Debuffs.spacing = T.Scale(3)
			self.Debuffs.initialAnchor = "BOTTOMRIGHT"
			self.Debuffs["growth-y"] = "UP"
			self.Debuffs["growth-x"] = "LEFT"
			if (T.class == "DEATHKNIGHT" and C.unitframe_class_bar.rune == true)
			or (T.Cata and T.class == "DRUID" and C.unitframe_class_bar.eclipse == true)
			or ((T.class == "DRUID" or T.class == "ROGUE") and C.unitframe_class_bar.combo == true and C.unitframe_class_bar.combo_old ~= true)
			or (T.Cata and T.class == "PALADIN" and C.unitframe_class_bar.holy == true)
			or (T.class == "SHAMAN" and C.unitframe_class_bar.totem == true)
			or ((T.Cata or T.Mainline) and T.class == "WARLOCK" and C.unitframe_class_bar.shard == true) then
				self.Debuffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 2, 19)
			else
				self.Debuffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 2, 5)
			end

			self.Debuffs.PostCreateButton = T.PostCreateButton
			self.Debuffs.PostUpdateButton = T.PostUpdateButton
		end

		if unit == "target" then
			self.Auras = CreateFrame("Frame", self:GetName().."_Auras", self)
			self.Auras:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -2, 5)
			self.Auras.initialAnchor = "BOTTOMLEFT"
			self.Auras["growth-x"] = "RIGHT"
			self.Auras["growth-y"] = "UP"
			self.Auras.numDebuffs = 16
			self.Auras.numBuffs = 32
			self.Auras:SetHeight(165)
			self.Auras:SetWidth(player_width + 4)
			self.Auras.spacing = T.Scale(3)
			self.Auras.size = T.Scale(C.aura.debuff_size)
			self.Auras.gap = true
			self.Auras.PostCreateButton = T.PostCreateButton
			self.Auras.PostUpdateButton = T.PostUpdateButton
			self.Auras.FilterAura = T.CustomFilter

			-- Rogue/Druid Combo bar
			if C.unitframe_class_bar.combo == true and (C.unitframe_class_bar.combo_old == true or (T.class ~= "DRUID" and T.class ~= "ROGUE")) then
				self.ComboPoints = CreateFrame("Frame", self:GetName().."_ComboBar", self)
				self.ComboPoints:CreateBackdrop("Default")
				self.ComboPoints:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
				self.ComboPoints:SetSize(player_width, 7)

				local maxComboPoints = T.Classic and 5 or 7
				for i = 1, maxComboPoints do
					self.ComboPoints[i] = CreateFrame("StatusBar", self:GetName().."_Combo"..i, self.ComboPoints)
					self.ComboPoints[i]:SetSize((player_width - 5) / maxComboPoints, 7)
					if i == 1 then
						self.ComboPoints[i]:SetPoint("LEFT", self.ComboPoints)
					else
						self.ComboPoints[i]:SetPoint("LEFT", self.ComboPoints[i-1], "RIGHT", 1, 0)
					end
					self.ComboPoints[i]:SetStatusBarTexture(C.media.texture)
				end

				if T.Classic then
					self.ComboPoints[1]:SetStatusBarColor(0.9, 0.1, 0.1)
					self.ComboPoints[2]:SetStatusBarColor(0.9, 0.1, 0.1)
					self.ComboPoints[3]:SetStatusBarColor(0.9, 0.9, 0.1)
					self.ComboPoints[4]:SetStatusBarColor(0.9, 0.9, 0.1)
					self.ComboPoints[5]:SetStatusBarColor(0.1, 0.9, 0.1)
				end
			end

			-- Enemy specialization
			if T.Mainline and C.unitframe.plugins_enemy_spec == true then
				self.EnemySpec = T.SetFontString(self.Power, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
				self.EnemySpec:SetTextColor(1, 0, 0)
				self.EnemySpec:SetPoint("BOTTOM", self.Power, "BOTTOM", 0, -1)
			end

			-- Quest icon
			if T.Mainline then
				self.QuestIndicator = self.Health:CreateTexture(nil, "OVERLAY")
				self.QuestIndicator:SetSize(20, 20)
				self.QuestIndicator:SetPoint("CENTER", self.Health, "CENTER", -20, 0)
			end
		end

		if C.unitframe.plugins_combat_feedback == true then
			self.CombatFeedbackText = T.SetFontString(self.Health, C.font.unit_frames_font, C.font.unit_frames_font_size * 2, C.font.unit_frames_font_style)
			if C.unitframe.portrait_enable == true then
				self.CombatFeedbackText:SetPoint("BOTTOM", self.Portrait, "BOTTOM", 0, 0)
				self.CombatFeedbackText:SetParent(self.Portrait)
			else
				self.CombatFeedbackText:SetPoint("CENTER", 0, 1)
			end
		end

		if C.unitframe.icons_pvp == true then
			self.Status = T.SetFontString(self.Health, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
			self.Status:SetPoint("CENTER", self.Health, "CENTER", 0, 0)
			self.Status:SetTextColor(0.69, 0.31, 0.31)
			self.Status:Hide()
			self.Status.Override = T.dummy

			self:SetScript("OnEnter", function(self) FlashInfo.ManaLevel:Hide() T.UpdatePvPStatus(self) self.Status:Show() UnitFrame_OnEnter(self) end)
			self:SetScript("OnLeave", function(self) FlashInfo.ManaLevel:Show() self.Status:Hide() UnitFrame_OnLeave(self) end)
		end
	end

	if C.unitframe.unit_castbar == true and not unit:match('%wtarget$') then
		self.Castbar = CreateFrame("StatusBar", self:GetName().."_Castbar", self)
		self.Castbar:SetStatusBarTexture(C.media.texture, "ARTWORK")

		self.Castbar.bg = self.Castbar:CreateTexture(nil, "BORDER")
		self.Castbar.bg:SetAllPoints()
		self.Castbar.bg:SetTexture(C.media.texture)

		self.Castbar.Overlay = CreateFrame("Frame", nil, self.Castbar)
		self.Castbar.Overlay:SetTemplate("Default")
		self.Castbar.Overlay:SetFrameStrata("BACKGROUND")
		self.Castbar.Overlay:SetFrameLevel(T.Classic and 2 or 3)
		self.Castbar.Overlay:SetPoint("TOPLEFT", -2, 2)
		self.Castbar.Overlay:SetPoint("BOTTOMRIGHT", 2, -2)

		self.Castbar.PostCastStart = T.PostCastStart

		if unit == "player" then
			if C.unitframe.castbar_icon == true then
				self.Castbar:SetPoint(C.position.unitframes.player_castbar[1], C.position.unitframes.player_castbar[2], C.position.unitframes.player_castbar[3], C.position.unitframes.player_castbar[4] + ((C.unitframe.castbar_height + 7) / 2) , C.position.unitframes.player_castbar[5])
				self.Castbar:SetWidth(C.unitframe.castbar_width)
			else
				self.Castbar:SetPoint(unpack(C.position.unitframes.player_castbar))
				self.Castbar:SetWidth(C.unitframe.castbar_width + C.unitframe.castbar_height + 7)
			end
			self.Castbar:SetHeight(C.unitframe.castbar_height)
		elseif unit == "target" then
			if C.unitframe.castbar_icon == true then
				if C.unitframe.plugins_swing == true then
					self.Castbar:SetPoint(C.position.unitframes.target_castbar[1], C.position.unitframes.target_castbar[2], C.position.unitframes.target_castbar[3], C.position.unitframes.target_castbar[4] - C.unitframe.castbar_height - 7, C.position.unitframes.target_castbar[5] + 12)
				else
					self.Castbar:SetPoint(C.position.unitframes.target_castbar[1], C.position.unitframes.target_castbar[2], C.position.unitframes.target_castbar[3], C.position.unitframes.target_castbar[4] - C.unitframe.castbar_height - 7, C.position.unitframes.target_castbar[5])
				end
				self.Castbar:SetWidth(C.unitframe.castbar_width)
			else
				if C.unitframe.plugins_swing == true then
					self.Castbar:SetPoint(C.position.unitframes.target_castbar[1], C.position.unitframes.target_castbar[2], C.position.unitframes.target_castbar[3], C.position.unitframes.target_castbar[4], C.position.unitframes.target_castbar[5] + 12)
				else
					self.Castbar:SetPoint(unpack(C.position.unitframes.target_castbar))
				end
				self.Castbar:SetWidth(C.unitframe.castbar_width + C.unitframe.castbar_height + 7)
			end
			self.Castbar:SetHeight(C.unitframe.castbar_height)
		elseif unit == "arena" or unit == "boss" then
			self.Castbar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -7)
			self.Castbar:SetWidth(boss_width)
			self.Castbar:SetHeight(16)
		else
			self.Castbar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -7)
			self.Castbar:SetWidth(pet_width)
			self.Castbar:SetHeight(5)
		end

		if unit == "player" or unit == "target" or unit == "arena" or unit == "boss" then
			self.Castbar.Time = T.SetFontString(self.Castbar, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
			self.Castbar.Time:SetPoint("RIGHT", self.Castbar, "RIGHT", 0, 0)
			self.Castbar.Time:SetTextColor(1, 1, 1)
			self.Castbar.Time:SetJustifyH("RIGHT")
			self.Castbar.CustomTimeText = T.CustomCastTimeText
			self.Castbar.CustomDelayText = T.CustomCastDelayText

			self.Castbar.Text = T.SetFontString(self.Castbar, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
			self.Castbar.Text:SetPoint("LEFT", self.Castbar, "LEFT", 2, 0)
			self.Castbar.Text:SetTextColor(1, 1, 1)
			self.Castbar.Text:SetJustifyH("LEFT")
			self.Castbar.Text:SetWordWrap(false)
			self.Castbar.Text:SetWidth(self.Castbar:GetWidth() - 50)

			if (C.unitframe.castbar_icon == true and (unit == "player" or unit == "target")) or unit == "arena" or unit == "boss" then
				self.Castbar.Button = CreateFrame("Frame", nil, self.Castbar)
				self.Castbar.Button:SetSize(self.Castbar:GetHeight() + 4, self.Castbar:GetHeight() + 4)
				self.Castbar.Button:SetTemplate("Default")

				self.Castbar.Icon = self.Castbar.Button:CreateTexture(nil, "ARTWORK")
				self.Castbar.Icon:SetPoint("TOPLEFT", self.Castbar.Button, 2, -2)
				self.Castbar.Icon:SetPoint("BOTTOMRIGHT", self.Castbar.Button, -2, 2)
				self.Castbar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

				if unit == "player" then
					self.Castbar.Button:SetPoint("RIGHT", self.Castbar, "LEFT", -5, 0)
				elseif unit == "target" then
					self.Castbar.Button:SetPoint("LEFT", self.Castbar, "RIGHT", 5, 0)
				elseif unit == "boss" then
					if C.unitframe.boss_on_right == true then
						self.Castbar.Button:SetPoint("TOPRIGHT", self.Castbar, "TOPLEFT", -5, 2)
					else
						self.Castbar.Button:SetPoint("TOPLEFT", self.Castbar, "TOPRIGHT", 5, 2)
					end
				elseif unit == "arena" then
					if C.unitframe.arena_on_right == true then
						self.Castbar.Button:SetPoint("TOPRIGHT", self.Castbar, "TOPLEFT", -5, 2)
					else
						self.Castbar.Button:SetPoint("TOPLEFT", self.Castbar, "TOPRIGHT", 5, 2)
					end
				end
			end

			if unit == "player" and C.unitframe.castbar_latency == true then
				self.Castbar.SafeZone = self.Castbar:CreateTexture(nil, "BORDER", nil, 1)
				self.Castbar.SafeZone:SetTexture(C.media.texture)
				self.Castbar.SafeZone:SetVertexColor(0.85, 0.27, 0.27)

				self.Castbar.Latency = T.SetFontString(self.Castbar, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
				self.Castbar.Latency:SetTextColor(1, 1, 1)
				self.Castbar.Latency:SetPoint("TOPRIGHT", self.Castbar.Time, "BOTTOMRIGHT", 0, 0)
				self.Castbar.Latency:SetJustifyH("RIGHT")
			end
		end

		if unit == "focus" then
			if C.unitframe.castbar_focus_type == "ICON" or C.unitframe.castbar_focus_type == "BAR" then
				self.Castbar.Button = CreateFrame("Frame", self:GetName().."_CastbarIcon", self.Castbar)
				self.Castbar.Button:SetPoint(unpack(C.position.unitframes.focus_castbar))
				self.Castbar.Button:SetTemplate("Default")

				self.Castbar.Icon = self.Castbar.Button:CreateTexture(nil, "ARTWORK")
				self.Castbar.Icon:SetPoint("TOPLEFT", self.Castbar.Button, 2, -2)
				self.Castbar.Icon:SetPoint("BOTTOMRIGHT", self.Castbar.Button, -2, 2)
				self.Castbar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			end
			if C.unitframe.castbar_focus_type == "ICON" then
				self.Castbar.Button:SetSize(65, 65)

				self.Castbar.Time = T.SetFontString(self.Castbar, C.font.unit_frames_font, C.font.unit_frames_font_size * 2, C.font.unit_frames_font_style)
				self.Castbar.Time:SetParent(self.Castbar.Button)
				self.Castbar.Time:SetTextColor(1, 1, 1)
				self.Castbar.Time:SetPoint("CENTER", self.Castbar.Icon, "CENTER", 0, 10)

				self.Castbar.Time2 = T.SetFontString(self.Castbar, C.font.unit_frames_font, C.font.unit_frames_font_size * 2, C.font.unit_frames_font_style)
				self.Castbar.Time2:SetParent(self.Castbar.Button)
				self.Castbar.Time2:SetTextColor(1, 1, 1)
				self.Castbar.Time2:SetPoint("CENTER", self.Castbar.Icon, "CENTER", 0, -10)

				self.Castbar.CustomTimeText = function(self, duration)
					self.Time:SetText(("%.1f"):format(self.max))
					self.Time2:SetText(("%.1f"):format(self.channeling and duration or self.max - duration))
				end
				self.Castbar.CustomDelayText = function(self)
					self.Time:SetText(("|cffaf5050%s %.1f|r"):format(self.channeling and "-" or "+", abs(self.delay)))
				end
			elseif C.unitframe.castbar_focus_type == "BAR" then
				self.Castbar:ClearAllPoints()
				self.Castbar:SetPoint("TOP", self.Castbar.Icon, "BOTTOM", 0, -7)
				self.Castbar:SetWidth(C.unitframe.castbar_width - 40)
				self.Castbar:SetHeight(C.unitframe.castbar_height)

				self.Castbar.Text = T.SetFontString(self.Castbar, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
				self.Castbar.Text:SetPoint("LEFT", self.Castbar, "LEFT", 2, 0)
				self.Castbar.Text:SetTextColor(1, 1, 1)
				self.Castbar.Text:SetJustifyH("LEFT")
				self.Castbar.Text:SetWordWrap(false)
				self.Castbar.Text:SetWidth(self.Castbar:GetWidth() - 50)

				self.Castbar.Button:SetSize(self.Castbar:GetHeight() + 30, self.Castbar:GetHeight() + 30)

				self.Castbar.Time = T.SetFontString(self.Castbar, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
				self.Castbar.Time:SetPoint("RIGHT", self.Castbar, "RIGHT", 0, 0)
				self.Castbar.Time:SetTextColor(1, 1, 1)
				self.Castbar.Time:SetJustifyH("RIGHT")
				self.Castbar.CustomTimeText = T.CustomCastTimeText
				self.Castbar.CustomDelayText = T.CustomCastDelayText
			end
		end
	end

	-- Swing bar
	if C.unitframe.plugins_swing == true and unit == "player" then
		self.Swing = CreateFrame("StatusBar", self:GetName().."_Swing", self)
		self.Swing:CreateBackdrop("Default")
		if C.unitframe.unit_castbar then
			self.Swing:SetPoint("BOTTOMRIGHT", "oUF_Player_Castbar", "TOPRIGHT", 0, 7)
		else
			self.Swing:SetPoint(C.position.unitframes.player_castbar[1], C.position.unitframes.player_castbar[2], C.position.unitframes.player_castbar[3], C.position.unitframes.player_castbar[4], C.position.unitframes.player_castbar[5] + 23)
		end
		self.Swing:SetSize(281, 5)
		self.Swing:SetStatusBarTexture(C.media.texture)
		if C.unitframe.own_color == true then
			self.Swing:SetStatusBarColor(unpack(C.unitframe.uf_color))
		else
			self.Swing:SetStatusBarColor(T.color.r, T.color.g, T.color.b)
		end

		self.Swing.bg = self.Swing:CreateTexture(nil, "BORDER")
		self.Swing.bg:SetAllPoints(self.Swing)
		self.Swing.bg:SetTexture(C.media.texture)
		if C.unitframe.own_color == true then
			self.Swing.bg:SetVertexColor(unpack(C.unitframe.uf_color_bg))
		else
			self.Swing.bg:SetVertexColor(T.color.r, T.color.g, T.color.b, 0.2)
		end

		self.Swing.Text = T.SetFontString(self.Swing, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
		self.Swing.Text:SetPoint("CENTER", 0, 0)
		self.Swing.Text:SetTextColor(1, 1, 1)

		self.SwingOH = CreateFrame("StatusBar", self:GetName().."_SwingOH", self)
		self.SwingOH:CreateBackdrop("Default")
		self.SwingOH:SetPoint("BOTTOMRIGHT", self.Swing, "BOTTOMRIGHT", 0, -10)
		self.SwingOH:SetSize(281, 5)
		self.SwingOH:SetStatusBarTexture(C.media.texture)
		if C.unitframe.own_color == true then
			self.SwingOH:SetStatusBarColor(unpack(C.unitframe.uf_color))
		else
			self.SwingOH:SetStatusBarColor(T.color.r, T.color.g, T.color.b)
		end

		self.SwingOH.bg = self.SwingOH:CreateTexture(nil, "BORDER")
		self.SwingOH.bg:SetAllPoints(self.SwingOH)
		self.SwingOH.bg:SetTexture(C.media.texture)
		if C.unitframe.own_color == true then
			self.SwingOH.bg:SetVertexColor(C.unitframe.uf_color[1], C.unitframe.uf_color[2], C.unitframe.uf_color[3], 0.2)
		else
			self.SwingOH.bg:SetVertexColor(T.color.r, T.color.g, T.color.b, 0.2)
		end

		self.SwingOH.Text = T.SetFontString(self.SwingOH, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
		self.SwingOH.Text:SetPoint("CENTER", 0, 0)
		self.SwingOH.Text:SetTextColor(1, 1, 1)
	end

	if C.unitframe.show_arena and unit == "arena" then
		self.Trinket = CreateFrame("Frame", self:GetName().."_Trinket", self)
		self.Trinket:SetSize(31 + T.extraHeight, 31 + T.extraHeight)

		self.FactionIcon = CreateFrame("Frame", nil, self)
		self.FactionIcon:SetSize(31 + T.extraHeight, 31 + T.extraHeight)

		if C.unitframe.arena_on_right == true then
			self.Trinket:SetPoint("TOPRIGHT", self, "TOPLEFT", -5, 2)
			self.FactionIcon:SetPoint("TOPRIGHT", self, "TOPLEFT", -5, 2)
		else
			self.Trinket:SetPoint("TOPLEFT", self, "TOPRIGHT", 5, 2)
			self.FactionIcon:SetPoint("TOPLEFT", self, "TOPRIGHT", 5, 2)
		end
		self.Trinket:SetTemplate("Default")
		self.FactionIcon:SetTemplate("Default")

		self.AuraTracker = CreateFrame("Frame", self:GetName().."_AuraTracker", self)
		self.AuraTracker:SetWidth(self.Trinket:GetWidth())
		self.AuraTracker:SetHeight(self.Trinket:GetHeight())
		self.AuraTracker:SetPoint("CENTER", self.Trinket, "CENTER")
		self.AuraTracker:SetFrameStrata("HIGH")

		self.AuraTracker.icon = self.AuraTracker:CreateTexture(nil, "ARTWORK")
		self.AuraTracker.icon:SetWidth(self.Trinket:GetWidth())
		self.AuraTracker.icon:SetHeight(self.Trinket:GetHeight())
		self.AuraTracker.icon:SetPoint("TOPLEFT", self.Trinket, 2, -2)
		self.AuraTracker.icon:SetPoint("BOTTOMRIGHT", self.Trinket, -2, 2)
		self.AuraTracker.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

		self.AuraTracker.text = T.SetFontString(self.AuraTracker, C.font.unit_frames_font, C.font.unit_frames_font_size * 2, C.font.unit_frames_font_style)
		self.AuraTracker.text:SetPoint("CENTER", self.AuraTracker, 0, 0)
		self.AuraTracker:SetScript("OnUpdate", T.AuraTrackerTime)

		if C.unitframe.plugins_enemy_spec == true then
			self.EnemySpec = T.SetFontString(self.Power, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
			self.EnemySpec:SetTextColor(1, 0, 0)
			if C.unitframe.arena_on_right == true then
				self.EnemySpec:SetPoint("RIGHT", self.Power, "RIGHT", 0, 0)
				self.EnemySpec:SetJustifyH("LEFT")
			else
				self.EnemySpec:SetPoint("LEFT", self.Power, "LEFT", 2, 0)
				self.EnemySpec:SetJustifyH("RIGHT")
			end
		end
	end

	if C.unitframe.show_boss and unit == "boss" then
		if T.Cata or T.Mists or T.Mainline then
			self.AlternativePower = CreateFrame("StatusBar", nil, self.Health, BackdropTemplateMixin and "BackdropTemplate")
			self.AlternativePower:SetFrameLevel(self.Health:GetFrameLevel() + 1)
			self.AlternativePower:SetHeight(5)
			self.AlternativePower:SetStatusBarTexture(C.media.texture)
			self.AlternativePower:SetStatusBarColor(0.9, 0, 0)
			self.AlternativePower:SetPoint("LEFT")
			self.AlternativePower:SetPoint("RIGHT")
			self.AlternativePower:SetPoint("TOP", self.Health, "TOP")
			self.AlternativePower:SetBackdrop({
				bgFile = C.media.blank,
				edgeFile = C.media.blank,
				tile = false, tileSize = 0, edgeSize = T.Scale(1),
				insets = {left = 0, right = 0, top = 0, bottom = T.Scale(-1)}
			})
			self.AlternativePower:SetBackdropColor(0, 0, 0)
			self.AlternativePower:SetBackdropBorderColor(0, 0, 0)

			self.AlternativePower.text = T.SetFontString(self.AlternativePower, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
			self.AlternativePower.text:SetPoint("CENTER", self.AlternativePower, "CENTER", 0, 0)
			self:Tag(self.AlternativePower.text, "[AltPower]")
		end

		if C.aura.boss_auras == true then
			self.Auras = CreateFrame("Frame", self:GetName().."_Auras", self)
			if C.unitframe.boss_on_right == true then
				self.Auras:SetPoint("RIGHT", self, "LEFT", -5, 0)
				self.Auras.initialAnchor = "RIGHT"
				self.Auras["growth-x"] = "LEFT"
			else
				self.Auras:SetPoint("LEFT", self, "RIGHT", 5, 0)
				self.Auras.initialAnchor = "LEFT"
				self.Auras["growth-x"] = "RIGHT"
			end
			self.Auras.numDebuffs = C.aura.boss_debuffs
			self.Auras.numBuffs = C.aura.boss_buffs
			self.Auras:SetHeight(31 + T.extraHeight)
			self.Auras:SetWidth((34 + T.extraHeight) * (C.aura.boss_debuffs + C.aura.boss_buffs + 1))
			self.Auras.spacing = T.Scale(3)
			self.Auras.size = T.Scale(31 + T.extraHeight)
			self.Auras.gap = true
			self.Auras.PostCreateButton = T.PostCreateButton
			self.Auras.PostUpdateButton = T.PostUpdateButton
			self.Auras.FilterAura = T.CustomFilterBoss
		end

		self:HookScript("OnShow", T.UpdateAllElements)
	end

	-- Aggro border
	if C.raidframe.aggro_border == true and unit ~= "arenatarget" then
		self.ThreatIndicator = CreateFrame("Frame", nil, self)
		self.ThreatIndicator.PostUpdate = T.UpdateThreat
	end

	-- Raid marks
	if C.raidframe.icons_raid_mark == true then
		self.RaidTargetIndicator = self:CreateTexture(nil, "OVERLAY")
		self.RaidTargetIndicator:SetParent(self.Health)
		self.RaidTargetIndicator:SetSize((unit == "player" or unit == "target") and 15 or 12, (unit == "player" or unit == "target") and 15 or 12)
		self.RaidTargetIndicator:SetPoint("TOP", self.Health, 0, 0)
	end

	-- Debuff highlight
	if unit ~= "arenatarget" then
		self.DebuffHighlight = self.Health:CreateTexture(nil, "OVERLAY")
		self.DebuffHighlight:SetAllPoints(self.Health)
		self.DebuffHighlight:SetTexture(C.media.highlight)
		self.DebuffHighlight:SetVertexColor(0, 0, 0, 0)
		self.DebuffHighlight:SetBlendMode("ADD")
		self.DebuffHighlightAlpha = 1
		self.DebuffHighlightFilter = true
	end

	-- Incoming heals and heal/damage absorbs
	if C.raidframe.plugins_healcomm == true then
		if T.Classic then
			local healBar = CreateFrame("StatusBar", nil, self)
			healBar:SetAllPoints(self.Health)
			healBar:SetStatusBarTexture(C.media.texture)
			healBar:SetStatusBarColor(0, 1, 0, 0.2)
			self.HealPrediction = healBar
		else
			T.CreateHealthPrediction(self)
		end
	end

	-- Power Prediction bar
	if C.unitframe.plugins_power_prediction == true and unit == "player" then
		local mainBar = CreateFrame("StatusBar", self:GetName().."_PowerPrediction", self.Power)
		mainBar:SetReverseFill(true)
		mainBar:SetPoint("TOP")
		mainBar:SetPoint("BOTTOM")
		mainBar:SetPoint("RIGHT", self.Power:GetStatusBarTexture(), "RIGHT")
		mainBar:SetStatusBarTexture(C.media.texture)
		mainBar:SetStatusBarColor(1, 1, 1, 0.5)
		mainBar:SetWidth(player_width)

		self.PowerPrediction = {
			mainBar = mainBar
		}
	end

	-- Fader
	if C.unitframe.plugins_fader == true then
		if unit ~= "arena" or unit ~= "arenatarget" or unit ~= "boss" then
			self.Fader = {
				[1] = {Combat = 1, Arena = 1, Instance = 1},
				[2] = {PlayerTarget = 1, PlayerNotMaxHealth = 1, PlayerNotMaxMana = 1, Casting = 1},
				[3] = {Stealth = 0.5},
				[4] = {notCombat = 0, PlayerTaxi = 0},
			}
		end
		self.NormalAlpha = 1
	end

	T.HideAuraFrame(self)

	if T.PostCreateUnitFrames then
		T.PostCreateUnitFrames(self, unit)
	end

	return self
end

----------------------------------------------------------------------------------------
--	Default position of ShestakUI unitframes
----------------------------------------------------------------------------------------
oUF:RegisterStyle("Shestak", Shared)

local player = oUF:Spawn("player", "oUF_Player")
player:SetPoint(unpack(C.position.unitframes.player))
player:SetSize(player_width, 27 + T.extraHeight)

local target = oUF:Spawn("target", "oUF_Target")
target:SetPoint(unpack(C.position.unitframes.target))
target:SetSize(player_width, 27 + T.extraHeight)

if C.unitframe.show_pet == true then
	local pet = oUF:Spawn("pet", "oUF_Pet")
	pet:SetPoint(unpack(C.position.unitframes.pet))
	pet:SetSize(pet_width, 16 + (C.unitframe.extra_health_height / 2))
end

if not T.Vanilla and C.unitframe.show_focus == true then
	local focus = oUF:Spawn("focus", "oUF_Focus")
	focus:SetPoint(unpack(C.position.unitframes.focus))
	focus:SetSize(pet_width, 16 + (C.unitframe.extra_health_height / 2))

	local focustarget = oUF:Spawn("focustarget", "oUF_FocusTarget")
	focustarget:SetPoint(unpack(C.position.unitframes.focus_target))
	focustarget:SetSize(pet_width, 16 + (C.unitframe.extra_health_height / 2))
end

if C.unitframe.show_target_target == true then
	local targettarget = oUF:Spawn("targettarget", "oUF_TargetTarget")
	targettarget:SetPoint(unpack(C.position.unitframes.target_target))
	targettarget:SetSize(pet_width, 16 + (C.unitframe.extra_health_height / 2))
end

if C.unitframe.show_boss == true then
	local boss = {}
	for i = 1, 8 do
		boss[i] = oUF:Spawn("boss"..i, "oUF_Boss"..i)
		if i == 1 then
			if C.unitframe.boss_on_right == true then
				boss[i]:SetPoint(unpack(C.position.unitframes.boss))
			else
				boss[i]:SetPoint("BOTTOMLEFT", C.position.unitframes.boss[2], "LEFT", C.position.unitframes.boss[4] + 46, C.position.unitframes.boss[5])
			end
		else
			boss[i]:SetPoint("BOTTOM", boss[i-1], "TOP", 0, 30)
		end
		boss[i]:SetSize(boss_width, 27 + T.extraHeight)
	end
end

if not T.Vanilla and C.unitframe.show_arena == true then
	local arena = {}
	for i = 1, 5 do
		arena[i] = oUF:Spawn("arena"..i, "oUF_Arena"..i)
		if i == 1 then
			if C.unitframe.arena_on_right == true then
				arena[i]:SetPoint(unpack(C.position.unitframes.arena))
			else
				arena[i]:SetPoint("BOTTOMLEFT", C.position.unitframes.arena[2], "LEFT", C.position.unitframes.arena[4] + 120, C.position.unitframes.arena[5])
			end
		else
			arena[i]:SetPoint("BOTTOM", arena[i-1], "TOP", 0, 30)
		end
		arena[i]:SetSize(boss_width, 27 + T.extraHeight)
	end

	local arenatarget = {}
	for i = 1, 5 do
		arenatarget[i] = oUF:Spawn("arena"..i.."target", "oUF_Arena"..i.."Target")
		if i == 1 then
			if C.unitframe.arena_on_right == true then
				arenatarget[i]:SetPoint("TOPLEFT", arena[i], "TOPRIGHT", 7, 0)
			else
				arenatarget[i]:SetPoint("TOPRIGHT", arena[i], "TOPLEFT", -7, 0)
			end
		else
			arenatarget[i]:SetPoint("BOTTOM", arenatarget[i-1], "TOP", 0, 30)
		end
		arenatarget[i]:SetSize(30 + T.extraHeight, 27 + T.extraHeight)
	end
end

----------------------------------------------------------------------------------------
--	Arena preparation(by Blizzard)(../Blizzard_ArenaUI/Blizzard_ArenaUI.lua)
----------------------------------------------------------------------------------------
if T.Mainline and C.unitframe.show_arena == true then
	local arenaprep = {}
	for i = 1, 5 do
		arenaprep[i] = CreateFrame("Frame", "oUF_ArenaPrep"..i, UIParent)
		arenaprep[i]:SetAllPoints(_G["oUF_Arena"..i])
		arenaprep[i]:CreateBackdrop("Default")
		arenaprep[i]:SetFrameStrata("BACKGROUND")

		arenaprep[i].Health = CreateFrame("StatusBar", nil, arenaprep[i])
		arenaprep[i].Health:SetAllPoints()
		arenaprep[i].Health:SetStatusBarTexture(C.media.texture)

		arenaprep[i].Spec = T.SetFontString(arenaprep[i].Health, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
		arenaprep[i].Spec:SetPoint("CENTER")

		arenaprep[i]:Hide()
	end

	local arenaprepupdate = CreateFrame("Frame")
	arenaprepupdate:RegisterEvent("PLAYER_LOGIN")
	arenaprepupdate:RegisterEvent("PLAYER_ENTERING_WORLD")
	arenaprepupdate:RegisterEvent("ARENA_OPPONENT_UPDATE")
	arenaprepupdate:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
	arenaprepupdate:SetScript("OnEvent", function(_, event)
		if event == "PLAYER_LOGIN" then
			for i = 1, 5 do
				arenaprep[i]:SetAllPoints(_G["oUF_Arena"..i])
			end
		elseif event == "ARENA_OPPONENT_UPDATE" then
			for i = 1, 5 do
				arenaprep[i]:Hide()
			end
		else
			local numOpps = GetNumArenaOpponentSpecs()

			if numOpps > 0 then
				for i = 1, 5 do
					local f = arenaprep[i]

					if i <= numOpps then
						local s = GetArenaOpponentSpec(i)
						local _, spec, class = nil, "UNKNOWN", "UNKNOWN"

						if s and s > 0 then
							_, spec, _, _, _, class = GetSpecializationInfoByID(s)
						end

						if class and spec then
							local color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
							if C.unitframe.own_color == true then
								f.Health:SetStatusBarColor(unpack(C.unitframe.uf_color))
								f.Spec:SetText(spec)
								f.Spec:SetTextColor(color.r, color.g, color.b)
							else
								if color then
									f.Health:SetStatusBarColor(color.r, color.g, color.b)
								else
									f.Health:SetStatusBarColor(unpack(C.unitframe.uf_color))
								end
								f.Spec:SetText(spec)
							end
							f:Show()
						end
					else
						f:Hide()
					end
				end
			else
				for i = 1, 5 do
					arenaprep[i]:Hide()
				end
			end
		end
	end)
end

----------------------------------------------------------------------------------------
--	Test UnitFrames(by community)
----------------------------------------------------------------------------------------
local moving = false
SlashCmdList.TEST_UF = function()
	if InCombatLockdown() then print("|cffffff00"..ERR_NOT_IN_COMBAT.."|r") return end
	if not moving then
		if T.Vanilla then
			for _, frames in pairs({"oUF_Target", "oUF_TargetTarget", "oUF_Pet"}) do
				if _G[frames] then
					_G[frames].oldunit = _G[frames].unit
					_G[frames]:SetAttribute("unit", "player")
				end
			end
		else
			for _, frames in pairs({"oUF_Target", "oUF_TargetTarget", "oUF_Pet", "oUF_Focus", "oUF_FocusTarget"}) do
				if _G[frames] then
					_G[frames].oldunit = _G[frames].unit
					_G[frames]:SetAttribute("unit", "player")
				end
			end
		end

		-- if T.Mainline and C.unitframe.show_arena == true then
		-- for i = 1, 5 do
		-- _G["oUF_Arena"..i].oldunit = _G["oUF_Arena"..i].unit
		-- _G["oUF_Arena"..i].Trinket.Hide = T.dummy
		-- _G["oUF_Arena"..i].Trinket.Icon:SetTexture("Interface\\Icons\\INV_Jewelry_Necklace_37")
		-- _G["oUF_Arena"..i]:SetAttribute("unit", "player")

		-- _G["oUF_Arena"..i.."Target"].oldunit = _G["oUF_Arena"..i.."Target"].unit
		-- _G["oUF_Arena"..i.."Target"]:SetAttribute("unit", "player")

		-- if C.unitframe.plugins_enemy_spec == true then
		-- _G["oUF_Arena"..i].EnemySpec:SetText(SPECIALIZATION)
		-- end

		-- if C.unitframe.plugins_diminishing == true then
		-- SlashCmdList.DIMINISHINGCD()
		-- end
		-- end
		-- end

		if C.unitframe.show_boss == true then
			for i = 1, 8 do
				_G["oUF_Boss"..i].oldunit = _G["oUF_Boss"..i].unit
				_G["oUF_Boss"..i]:SetAttribute("unit", "player")
			end
		end
		moving = true
	else
		if T.Vanilla then
			for _, frames in pairs({"oUF_Target", "oUF_TargetTarget", "oUF_Pet"}) do
				if _G[frames] then
					_G[frames].unit = _G[frames].oldunit
					_G[frames]:SetAttribute("unit", _G[frames].unit)
				end
			end
		else
			for _, frames in pairs({"oUF_Target", "oUF_TargetTarget", "oUF_Pet", "oUF_Focus", "oUF_FocusTarget"}) do
				if _G[frames] then
					_G[frames].unit = _G[frames].oldunit
					_G[frames]:SetAttribute("unit", _G[frames].unit)
				end
			end
		end

		-- if T.Mainline and C.unitframe.show_arena == true then
		-- for i = 1, 5 do
		-- _G["oUF_Arena"..i].Trinket.Hide = nil
		-- _G["oUF_Arena"..i]:SetAttribute("unit", _G["oUF_Arena"..i].oldunit)
		-- _G["oUF_Arena"..i.."Target"]:SetAttribute("unit", _G["oUF_Arena"..i.."Target"].oldunit)
		-- end
		-- end

		if C.unitframe.show_boss == true then
			for i = 1, 8 do
				_G["oUF_Boss"..i].unit = _G["oUF_Boss"..i].oldunit
				_G["oUF_Boss"..i]:SetAttribute("unit", _G["oUF_Boss"..i].unit)
			end
		end
		moving = false
	end
end
SLASH_TEST_UF1 = "/testui"
SLASH_TEST_UF2 = "/еуыегш"
SLASH_TEST_UF3 = "/testuf"
SLASH_TEST_UF4 = "/еуыега"

----------------------------------------------------------------------------------------
--	Player line
----------------------------------------------------------------------------------------
if C.unitframe.lines == true then
	local HorizontalPlayerLine = CreateFrame("Frame", "HorizontalPlayerLine", oUF_Player)
	HorizontalPlayerLine:CreatePanel("ClassColor", player_width + 11, 1, "TOPLEFT", "oUF_Player", "BOTTOMLEFT", -5, -5)
	HorizontalPlayerLine:SetBackdropBorderColor(T.color.r, T.color.g, T.color.b)

	local VerticalPlayerLine = CreateFrame("Frame", "VerticalPlayerLine", oUF_Player)
	VerticalPlayerLine:CreatePanel("ClassColor", 1, 98 + T.extraHeight + (C.unitframe.extra_health_height / 2), "TOPRIGHT", "oUF_Player", "TOPLEFT", -5, 30)
	VerticalPlayerLine:SetBackdropBorderColor(T.color.r, T.color.g, T.color.b)
end

----------------------------------------------------------------------------------------
--	Target line
----------------------------------------------------------------------------------------
if C.unitframe.lines == true then
	local HorizontalTargetLine = CreateFrame("Frame", "HorizontalTargetLine", oUF_Target)
	HorizontalTargetLine:CreatePanel("ClassColor", player_width + 11, 1, "TOPRIGHT", "oUF_Target", "BOTTOMRIGHT", 5, -5)
	HorizontalTargetLine:RegisterEvent("PLAYER_TARGET_CHANGED")
	HorizontalTargetLine:SetScript("OnEvent", function(self)
		local _, class = UnitClass("target")
		local color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
		if color then
			self:SetBackdropBorderColor(color.r, color.g, color.b)
		else
			self:SetBackdropBorderColor(unpack(C.media.border_color))
		end
	end)

	local VerticalTargetLine = CreateFrame("Frame", "VerticalTargetLine", oUF_Target)
	VerticalTargetLine:CreatePanel("ClassColor", 1, 98 + T.extraHeight + (C.unitframe.extra_health_height / 2), "TOPLEFT", "oUF_Target", "TOPRIGHT", 5, 30)
	VerticalTargetLine:RegisterEvent("PLAYER_TARGET_CHANGED")
	VerticalTargetLine:SetScript("OnEvent", function(self)
		local _, class = UnitClass("target")
		local color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
		if color then
			self:SetBackdropBorderColor(color.r, color.g, color.b)
		else
			self:SetBackdropBorderColor(unpack(C.media.border_color))
		end
	end)
end

----------------------------------------------------------------------------------------
--	Auto reposition heal raid frame
----------------------------------------------------------------------------------------
if C.raidframe.auto_position == "DYNAMIC" then
	local prevNum = 5
	local function Reposition(self, event)
		if (C.raidframe.layout == "HEAL" or C.raidframe.layout == "AUTO") and not C.raidframe.raid_groups_vertical and C.raidframe.raid_groups > 5 then
			if InCombatLockdown() then
				self:RegisterEvent("PLAYER_REGEN_ENABLED")
				return
			end
			local maxGroup = 5
			local num = GetNumGroupMembers()
			if num > 5 then
				local _, _, subgroup = GetRaidRosterInfo(num)
				if subgroup and subgroup > maxGroup then
					maxGroup = subgroup
				end
			end
			if maxGroup >= C.raidframe.raid_groups then
				maxGroup = C.raidframe.raid_groups
			end
			if C.raidframe.layout == "AUTO" and (((T.Wrath or T.Cata or T.Mists) and not T.Role == "Healer") or (T.Mainline and not T.IsHealerSpec())) then maxGroup = 5 end
			if prevNum ~= maxGroup then
				-- local offset = (maxGroup - 5) * (C.raidframe.heal_raid_height + 7) + ((maxGroup - ((maxGroup - 5))) * (C.raidframe.heal_raid_height - 26))
				local offset = (maxGroup - 5) * (C.raidframe.heal_raid_height + 7)
				if C.raidframe.layout == "AUTO" and (((T.Wrath or T.Cata or T.Mists) and not T.Role == "Healer") or (T.Mainline and not T.IsHealerSpec())) then offset = 0 end
				if C.unitframe.unit_castbar then
					if C.unitframe.castbar_icon == true then
						if oUF_Player_Castbar then
							oUF_Player_Castbar:SetPoint(C.position.unitframes.player_castbar[1], C.position.unitframes.player_castbar[2], C.position.unitframes.player_castbar[3], C.position.unitframes.player_castbar[4] + 11, C.position.unitframes.player_castbar[5] + offset)
						end
					else
						if oUF_Player_Castbar then
							oUF_Player_Castbar:SetPoint(C.position.unitframes.player_castbar[1], C.position.unitframes.player_castbar[2], C.position.unitframes.player_castbar[3], C.position.unitframes.player_castbar[4], C.position.unitframes.player_castbar[5] + offset)
						end
					end
				end

				player:SetPoint(C.position.unitframes.player[1], C.position.unitframes.player[2], C.position.unitframes.player[3], C.position.unitframes.player[4], C.position.unitframes.player[5] + offset)
				target:SetPoint(C.position.unitframes.target[1], C.position.unitframes.target[2], C.position.unitframes.target[3], C.position.unitframes.target[4], C.position.unitframes.target[5] + offset)
				prevNum = maxGroup
			end
			if event == "PLAYER_REGEN_ENABLED" then
				self:UnregisterEvent("PLAYER_REGEN_ENABLED")
			end
		else
			self:UnregisterAllEvents()
		end
	end

	local frame = CreateFrame("Frame")
	frame:RegisterEvent("PLAYER_LOGIN")
	frame:RegisterEvent("GROUP_ROSTER_UPDATE")
	if C.raidframe.layout == "AUTO" and (T.Wrath or T.Cata or T.Mists or T.Mainline) then
		frame:RegisterUnitEvent("PLAYER_SPECIALIZATION_CHANGED", "player", "")
	end
	frame:SetScript("OnEvent", Reposition)
elseif C.raidframe.auto_position == "STATIC" then
	local function Reposition(self)
		if (C.raidframe.layout == "HEAL" or C.raidframe.layout == "AUTO") and not C.raidframe.raid_groups_vertical and C.raidframe.raid_groups > 5 then
			-- local offset = (C.raidframe.raid_groups - 5) * (C.raidframe.heal_raid_height + 7) + ((C.raidframe.raid_groups - ((C.raidframe.raid_groups - 5))) * (C.raidframe.heal_raid_height - 26))
			local offset = (C.raidframe.raid_groups - 5) * (C.raidframe.heal_raid_height + 7)
			if C.raidframe.layout == "AUTO" and (((T.Wrath or T.Cata or T.Mists) and not T.Role == "Healer") or (T.Mainline and not T.IsHealerSpec())) then offset = 0 end
			if C.unitframe.unit_castbar then
				if C.unitframe.castbar_icon == true then
					if oUF_Player_Castbar then
						oUF_Player_Castbar:SetPoint(C.position.unitframes.player_castbar[1], C.position.unitframes.player_castbar[2], C.position.unitframes.player_castbar[3], C.position.unitframes.player_castbar[4] + 11, C.position.unitframes.player_castbar[5] + offset)
					end
				else
					if oUF_Player_Castbar then
						oUF_Player_Castbar:SetPoint(C.position.unitframes.player_castbar[1], C.position.unitframes.player_castbar[2], C.position.unitframes.player_castbar[3], C.position.unitframes.player_castbar[4], C.position.unitframes.player_castbar[5] + offset)
					end
				end
			end

			player:SetPoint(C.position.unitframes.player[1], C.position.unitframes.player[2], C.position.unitframes.player[3], C.position.unitframes.player[4], C.position.unitframes.player[5] + offset)
			target:SetPoint(C.position.unitframes.target[1], C.position.unitframes.target[2], C.position.unitframes.target[3], C.position.unitframes.target[4], C.position.unitframes.target[5] + offset)
		else
			self:UnregisterAllEvents()
		end
	end

	local frame = CreateFrame("Frame")
	frame:RegisterEvent("PLAYER_LOGIN")
	if C.raidframe.layout == "AUTO" and (T.Wrath or T.Cata or T.Mists or T.Mainline) then
		frame:RegisterUnitEvent("PLAYER_SPECIALIZATION_CHANGED", "player", "")
	end
	frame:SetScript("OnEvent", Reposition)
end