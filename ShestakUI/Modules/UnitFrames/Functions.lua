local T, C, L = unpack(ShestakUI)
if C.unitframe.enable ~= true then return end

----------------------------------------------------------------------------------------
--	Unit frames functions
----------------------------------------------------------------------------------------
local _, ns = ...
local oUF = ns.oUF
T.oUF = oUF

T.EclipseDirection = function(self)
	if GetEclipseDirection() == "sun" then
		self.Text:SetText("|cff4478BC>>|r")
	elseif GetEclipseDirection() == "moon" then
		self.Text:SetText("|cffE5994C<<|r")
	else
		self.Text:SetText("")
	end
end

T.UpdateEclipse = function(self, login)
	local eb = self.EclipseBar
	local txt = self.EclipseBar.Text

	if login then
		eb:SetScript("OnUpdate", nil)
	end

	if eb:IsShown() then
		txt:Show()
		if self.Debuffs then self.Debuffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 2, 19) end
	else
		txt:Hide()
		if (C.unitframe_class_bar.combo_always == true or GetShapeshiftFormID() == CAT_FORM) and C.unitframe_class_bar.combo_old ~= true then return end
		if self.Debuffs then self.Debuffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 2, 5) end
	end
end

T.UpdateAllElements = function(frame)
	for _, v in ipairs(frame.__elements) do
		v(frame, "UpdateElement", frame.unit)
	end
end

T.SetFontString = function(parent, fontName, fontHeight, fontStyle)
	local fs = parent:CreateFontString(nil, "ARTWORK")
	fs:SetFont(fontName, fontHeight, fontStyle)
	fs:SetShadowOffset(C.font.unit_frames_font_shadow and 1 or 0, C.font.unit_frames_font_shadow and -1 or 0)
	return fs
end

T.PostUpdateHealthColor = function(health, unit, r, g, b)
	if unit and unit:find("arena%dtarget") then return end
	if not UnitIsConnected(unit) or (UnitIsDeadOrGhost(unit) and not UnitIsFeignDeath(unit)) then
		health:SetValue(0)
		if not UnitIsConnected(unit) then
			health.value:SetText("|cffD7BEA5"..L_UF_OFFLINE.."|r")
		elseif UnitIsDead(unit) then
			health.value:SetText("|cffD7BEA5"..L_UF_DEAD.."|r")
		elseif UnitIsGhost(unit) then
			health.value:SetText("|cffD7BEA5"..L_UF_GHOST.."|r")
		end
	else
		local min, max = UnitHealth(unit), UnitHealthMax(unit)

		health:SetMinMaxValues(0, max)
		health:SetValue(min)
		health.cur = min
		health.max = max

		T.PostUpdateHealth(health, unit, min, max)
	end
end

T.PostUpdateHealth = function(health, unit, min, max)
	if unit and unit:find("arena%dtarget") then return end
	local r, g, b
	if (C.unitframe.own_color ~= true and C.unitframe.enemy_health_color and unit == "target" and UnitIsEnemy(unit, "player") and UnitIsPlayer(unit)) or (C.unitframe.own_color ~= true and unit == "target" and not UnitIsPlayer(unit) and UnitIsFriend(unit, "player")) then
		local c = T.oUF_colors.reaction[UnitReaction(unit, "player")]
		if c then
			r, g, b = c[1], c[2], c[3]
			health:SetStatusBarColor(r, g, b)
		else
			r, g, b = 0.3, 0.7, 0.3
			health:SetStatusBarColor(r, g, b)
		end
	end
	if unit == "pet" then
		local _, class = UnitClass("player")
		local r, g, b = unpack(T.oUF_colors.class[class])
		if T.Classic and not T.Cata and T.class == "HUNTER" and C.unitframe.bar_color_happiness then
			local mood = GetPetHappiness()
			if mood then
				if mood ~= 3 then
					r, g, b = unpack(T.oUF_colors.happiness[mood])
				end
				if b then
					health:SetStatusBarColor(r, g, b)
					if health.bg and health.bg.multiplier then
						local mu = health.bg.multiplier
						health.bg:SetVertexColor(r * mu, g * mu, b * mu)
					end
				end
			end
		elseif C.unitframe.own_color == true then
			health:SetStatusBarColor(unpack(C.unitframe.uf_color))
			health.bg:SetVertexColor(0.1, 0.1, 0.1)
		elseif b then
			health:SetStatusBarColor(r, g, b)
			if health.bg and health.bg.multiplier then
				local mu = health.bg.multiplier
				health.bg:SetVertexColor(r * mu, g * mu, b * mu)
			end
		end
	end
	if C.unitframe.bar_color_value == true and not UnitIsTapDenied(unit) then
		if C.unitframe.own_color == true then
			r, g, b = C.unitframe.uf_color[1], C.unitframe.uf_color[2], C.unitframe.uf_color[3]
		else
			r, g, b = health:GetStatusBarColor()
		end
		local newr, newg, newb = oUF:ColorGradient(min, max, 1, 0, 0, 1, 1, 0, r, g, b)

		health:SetStatusBarColor(newr, newg, newb)
		if health.bg and health.bg.multiplier then
			local mu = health.bg.multiplier
			health.bg:SetVertexColor(newr * mu, newg * mu, newb * mu)
		end
	end
	if min ~= max then
		r, g, b = oUF:ColorGradient(min, max, 0.69, 0.31, 0.31, 0.65, 0.63, 0.35, 0.33, 0.59, 0.33)
		if (unit == "player" and not UnitHasVehicleUI("player") or unit == "vehicle") and health:GetAttribute("normalUnit") ~= "pet" then
			if C.unitframe.show_total_value == true then
				if C.unitframe.color_value == true then
					health.value:SetFormattedText("|cff559655%s|r |cffD7BEA5-|r |cff559655%s|r", T.ShortValue(min), T.ShortValue(max))
				else
					health.value:SetFormattedText("|cffffffff%s - %s|r", T.ShortValue(min), T.ShortValue(max))
				end
			else
				if C.unitframe.color_value == true then
					health.value:SetFormattedText("|cffAF5050%d|r |cffD7BEA5-|r |cff%02x%02x%02x%d%%|r", min, r * 255, g * 255, b * 255, floor(min / max * 100))
				else
					health.value:SetFormattedText("|cffffffff%d - %d%%|r", min, floor(min / max * 100))
				end
			end
		elseif unit == "target" then
			if C.unitframe.show_total_value == true then
				if C.unitframe.color_value == true then
					health.value:SetFormattedText("|cff559655%s|r |cffD7BEA5-|r |cff559655%s|r", T.ShortValue(min), T.ShortValue(max))
				else
					health.value:SetFormattedText("|cffffffff%s - %s|r", T.ShortValue(min), T.ShortValue(max))
				end
			else
				if C.unitframe.color_value == true then
					health.value:SetFormattedText("|cff%02x%02x%02x%d%%|r |cffD7BEA5-|r |cffAF5050%s|r", r * 255, g * 255, b * 255, floor(min / max * 100), T.ShortValue(min))
				else
					health.value:SetFormattedText("|cffffffff%d%% - %s|r", floor(min / max * 100), T.ShortValue(min))
				end
			end
		elseif unit and unit:find("boss%d") then
			if C.unitframe.color_value == true then
				health.value:SetFormattedText("|cff%02x%02x%02x%d%%|r |cffD7BEA5-|r |cffAF5050%s|r", r * 255, g * 255, b * 255, floor(min / max * 100), T.ShortValue(min))
			else
				health.value:SetFormattedText("|cffffffff%d%% - %s|r", floor(min / max * 100), T.ShortValue(min))
			end
		else
			if C.unitframe.color_value == true then
				health.value:SetFormattedText("|cff%02x%02x%02x%d%%|r", r * 255, g * 255, b * 255, floor(min / max * 100))
			else
				health.value:SetFormattedText("|cffffffff%d%%|r", floor(min / max * 100))
			end
		end
	else
		if unit == "player" and not UnitHasVehicleUI("player") or unit == "vehicle" then
			if C.unitframe.color_value == true then
				health.value:SetText("|cff559655"..max.."|r")
			else
				health.value:SetText("|cffffffff"..max.."|r")
			end
		else
			if C.unitframe.color_value == true then
				health.value:SetText("|cff559655"..T.ShortValue(max).."|r")
			else
				health.value:SetText("|cffffffff"..T.ShortValue(max).."|r")
			end
		end
	end
end

T.PostUpdateRaidHealthColor = function(health, unit, r, g, b)
	if not UnitIsConnected(unit) or (UnitIsDeadOrGhost(unit) and not UnitIsFeignDeath(unit)) then
		health:SetValue(0)
		if not UnitIsConnected(unit) then
			health.value:SetText("|cffD7BEA5"..L_UF_OFFLINE.."|r")
		elseif UnitIsDead(unit) then
			health.value:SetText("|cffD7BEA5"..L_UF_DEAD.."|r")
		elseif UnitIsGhost(unit) then
			health.value:SetText("|cffD7BEA5"..L_UF_GHOST.."|r")
		end
	else
		local min, max = UnitHealth(unit), UnitHealthMax(unit)

		health:SetMinMaxValues(0, max)
		health:SetValue(min)
		health.cur = min
		health.max = max

		T.PostUpdateRaidHealth(health, unit, min, max)
	end
end

T.PostUpdateRaidHealth = function(health, unit, min, max)
	local self = health:GetParent()
	local power = self.Power
	local border = self.backdrop
	local r, g, b
	if not UnitIsPlayer(unit) and UnitIsFriend(unit, "player") and C.unitframe.own_color ~= true then
		local c = T.oUF_colors.reaction[5]
		local r, g, b = c[1], c[2], c[3]
		health:SetStatusBarColor(r, g, b)
		if health.bg and health.bg.multiplier then
			local mu = health.bg.multiplier
			health.bg:SetVertexColor(r * mu, g * mu, b * mu)
		end
	end
	if C.unitframe.bar_color_value == true and not UnitIsTapDenied(unit) then
		if C.unitframe.own_color == true then
			r, g, b = C.unitframe.uf_color[1], C.unitframe.uf_color[2], C.unitframe.uf_color[3]
		else
			r, g, b = health:GetStatusBarColor()
		end
		local newr, newg, newb = oUF:ColorGradient(min, max, 1, 0, 0, 1, 1, 0, r, g, b)

		health:SetStatusBarColor(newr, newg, newb)
		if health.bg and health.bg.multiplier then
			local mu = health.bg.multiplier
			health.bg:SetVertexColor(newr * mu, newg * mu, newb * mu)
		end
	end
	if min ~= max then
		r, g, b = oUF:ColorGradient(min, max, 0.69, 0.31, 0.31, 0.65, 0.63, 0.35, 0.33, 0.59, 0.33)
		if self:GetParent():GetName():match("oUF_PartyDPS") then
			if C.unitframe.color_value == true then
				health.value:SetFormattedText("|cffAF5050%s|r |cffD7BEA5-|r |cff%02x%02x%02x%d%%|r", T.ShortValue(min), r * 255, g * 255, b * 255, floor(min / max * 100))
			else
				health.value:SetFormattedText("|cffffffff%s - %d%%|r", T.ShortValue(min), floor(min / max * 100))
			end
		else
			if C.unitframe.color_value == true then
				if C.raidframe.deficit_health == true then
					health.value:SetText("|cffffffff".."-"..T.ShortValue(max - min))
				else
					health.value:SetFormattedText("|cff%02x%02x%02x%d%%|r", r * 255, g * 255, b * 255, floor(min / max * 100))
				end
			else
				if C.raidframe.deficit_health == true then
					health.value:SetText("|cffffffff".."-"..T.ShortValue(max - min))
				else
					health.value:SetFormattedText("|cffffffff%d%%|r", floor(min / max * 100))
				end
			end
		end
	else
		if C.unitframe.color_value == true then
			health.value:SetText("|cff559655"..T.ShortValue(max).."|r")
		else
			health.value:SetText("|cffffffff"..T.ShortValue(max).."|r")
		end
	end
	if C.raidframe.alpha_health == true then
		if min / max > 0.95 then
			health:SetAlpha(0.6)
			power:SetAlpha(0.6)
			border:SetAlpha(0.6)
		else
			health:SetAlpha(1)
			power:SetAlpha(1)
			border:SetAlpha(1)
		end
	end
end

T.PreUpdatePower = function(power, unit)
	local _, pToken = UnitPowerType(unit)

	local color = T.oUF_colors.power[pToken]
	if color then
		power:SetStatusBarColor(color[1], color[2], color[3])
	end
end

T.PostUpdatePowerColor = function(power, unit, r, g, b)
	if unit and unit:find("arena%dtarget") then return end

	if not UnitIsConnected(unit) or (UnitIsDeadOrGhost(unit) and not UnitIsFeignDeath(unit)) then
		power:SetValue(0)
	else
		local displayType, min
		if power.displayAltPower then
			displayType, min = power:GetDisplayPower()
		end

		local cur, max = UnitPower(unit, displayType), UnitPowerMax(unit, displayType)
		power:SetMinMaxValues(min or 0, max)
		power:SetValue(cur)
		power.cur = cur
		power.min = min
		power.max = max
		power.displayType = displayType
	end
end

T.PostUpdatePower = function(power, unit, cur, _, max)
	if unit and unit:find("arena%dtarget") then return end
	local self = power:GetParent()
	local pType, pToken = UnitPowerType(unit)
	local color = T.oUF_colors.power[pToken]

	if color then
		power.value:SetTextColor(color[1], color[2], color[3])
	end

	if unit == "focus" or unit == "focustarget" or unit == "targettarget" or (self:GetParent():GetName():match("oUF_RaidDPS")) then return end

	if not UnitIsConnected(unit) then
		power.value:SetText()
	elseif (UnitIsDeadOrGhost(unit) and not UnitIsFeignDeath(unit)) or max == 0 then
		power.value:SetText()
	else
		if cur ~= max then
			if pType == 0 and pToken ~= "POWER_TYPE_DINO_SONIC" then
				if unit == "target" then
					if C.unitframe.show_total_value == true then
						if C.unitframe.color_value == true then
							power.value:SetFormattedText("%s |cffD7BEA5-|r %s", T.ShortValue(max - (max - cur)), T.ShortValue(max))
						else
							power.value:SetFormattedText("|cffffffff%s - %s|r", T.ShortValue(max - (max - cur)), T.ShortValue(max))
						end
					else
						if C.unitframe.color_value == true then
							power.value:SetFormattedText("%d%% |cffD7BEA5-|r %s", floor(cur / max * 100), T.ShortValue(max - (max - cur)))
						else
							power.value:SetFormattedText("|cffffffff%d%% - %s|r", floor(cur / max * 100), T.ShortValue(max - (max - cur)))
						end
					end
				elseif (unit == "player" and power:GetAttribute("normalUnit") == "pet") or unit == "pet" then
					if C.unitframe.show_total_value == true then
						if C.unitframe.color_value == true then
							power.value:SetFormattedText("%s |cffD7BEA5-|r %s", T.ShortValue(max - (max - cur)), T.ShortValue(max))
						else
							power.value:SetFormattedText("%s |cffffffff-|r %s", T.ShortValue(max - (max - cur)), T.ShortValue(max))
						end
					else
						if C.unitframe.color_value == true then
							power.value:SetFormattedText("%d%%", floor(cur / max * 100))
						else
							power.value:SetFormattedText("|cffffffff%d%%|r", floor(cur / max * 100))
						end
					end
				elseif unit and (unit:find("arena%d") or unit:find("boss%d")) then
					if C.unitframe.color_value == true then
						power.value:SetFormattedText("|cffD7BEA5%d%% - %s|r", floor(cur / max * 100), T.ShortValue(max - (max - cur)))
					else
						power.value:SetFormattedText("|cffffffff%d%% - %s|r", floor(cur / max * 100), T.ShortValue(max - (max - cur)))
					end
				elseif self:GetParent():GetName():match("oUF_PartyDPS") then
					if C.unitframe.color_value == true then
						power.value:SetFormattedText("%s |cffD7BEA5-|r %d%%", T.ShortValue(max - (max - cur)), floor(cur / max * 100))
					else
						power.value:SetFormattedText("|cffffffff%s - %d%%|r", T.ShortValue(max - (max - cur)), floor(cur / max * 100))
					end
				else
					if C.unitframe.show_total_value == true then
						if C.unitframe.color_value == true then
							power.value:SetFormattedText("%s |cffD7BEA5-|r %s", T.ShortValue(max - (max - cur)), T.ShortValue(max))
						else
							power.value:SetFormattedText("|cffffffff%s - %s|r", T.ShortValue(max - (max - cur)), T.ShortValue(max))
						end
					else
						if C.unitframe.color_value == true then
							power.value:SetFormattedText("%d |cffD7BEA5-|r %d%%", max - (max - cur), floor(cur / max * 100))
						else
							power.value:SetFormattedText("|cffffffff%d - %d%%|r", max - (max - cur), floor(cur / max * 100))
						end
					end
				end
			else
				if C.unitframe.color_value == true then
					power.value:SetText(max - (max - cur))
				else
					power.value:SetText("|cffffffff"..max - (max - cur).."|r")
				end
			end
		else
			if unit == "pet" or unit == "target" or (unit and unit:find("arena%d")) or (self:GetParent():GetName():match("oUF_PartyDPS")) then
				if C.unitframe.color_value == true then
					power.value:SetText(T.ShortValue(cur))
				else
					power.value:SetText("|cffffffff"..T.ShortValue(cur).."|r")
				end
			else
				if C.unitframe.color_value == true then
					power.value:SetText(cur)
				else
					power.value:SetText("|cffffffff"..cur.."|r")
				end
			end
		end
	end
end

local SetUpAnimGroup = function(self)
	self.anim = self:CreateAnimationGroup()
	self.anim:SetLooping("BOUNCE")
	self.anim.fade = self.anim:CreateAnimation("Alpha")
	self.anim.fade:SetFromAlpha(1)
	self.anim.fade:SetToAlpha(0)
	self.anim.fade:SetDuration(0.6)
	self.anim.fade:SetSmoothing("IN_OUT")
end

local Flash = function(self)
	if not self.anim then
		SetUpAnimGroup(self)
	end

	if not self.anim:IsPlaying() then
		self.anim:Play()
	end
end

local StopFlash = function(self)
	if self.anim then
		self.anim:Finish()
	end
end

T.UpdateManaLevel = function(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed < 0.2 then return end
	self.elapsed = 0

	if UnitPowerType("player") == 0 then
		local cur = UnitPower("player", 0)
		local max = UnitPowerMax("player", 0)
		local percMana = max > 0 and (cur / max * 100) or 100
		if percMana <= 20 and not UnitIsDeadOrGhost("player") then
			self.ManaLevel:SetText("|cffaf5050"..MANA_LOW.."|r")
			Flash(self)
		else
			self.ManaLevel:SetText()
			StopFlash(self)
		end
	elseif T.class ~= "DRUID" and T.class ~= "PRIEST" and T.class ~= "SHAMAN" then
		self.ManaLevel:SetText()
		StopFlash(self)
	end
end

T.UpdateClassMana = function(self)
	if self.unit ~= "player" then return end

	if UnitPowerType("player") ~= 0 then
		local min = UnitPower("player", 0)
		local max = UnitPowerMax("player", 0)
		local percMana = max > 0 and (min / max * 100) or 100
		if percMana <= 20 and not UnitIsDeadOrGhost("player") then
			self.FlashInfo.ManaLevel:SetText("|cffaf5050"..MANA_LOW.."|r")
			Flash(self.FlashInfo)
		else
			self.FlashInfo.ManaLevel:SetText()
			StopFlash(self.FlashInfo)
		end

		if min ~= max then
			if self.Power.value:GetText() then
				self.ClassMana:SetPoint("RIGHT", self.Power.value, "LEFT", -1, 0)
				self.ClassMana:SetFormattedText("%d%%|r |cffD7BEA5-|r", floor(min / max * 100))
				self.ClassMana:SetJustifyH("RIGHT")
			else
				self.ClassMana:SetPoint("LEFT", self.Power, "LEFT", 4, 0)
				self.ClassMana:SetFormattedText("%d%%", floor(min / max * 100))
			end
		else
			self.ClassMana:SetText()
		end

		self.ClassMana:SetAlpha(1)
	else
		self.ClassMana:SetAlpha(0)
	end
end

T.UpdatePvPStatus = function(self)
	local unit = self.unit

	if self.Status then
		local factionGroup = UnitFactionGroup(unit)
		if UnitIsPVPFreeForAll(unit) then
			self.Status:SetText(PVP)
		elseif factionGroup and UnitIsPVP(unit) then
			self.Status:SetText(PVP)
		else
			self.Status:SetText("")
		end
	end
end

local ticks = {}
local setBarTicks = function(Castbar, numTicks)
	for _, v in pairs(ticks) do
		v:Hide()
	end
	if numTicks and numTicks > 0 then
		local delta = Castbar:GetWidth() / numTicks
		for i = 1, numTicks do
			if not ticks[i] then
				ticks[i] = Castbar:CreateTexture(nil, "OVERLAY")
				ticks[i]:SetTexture(C.media.texture)
				ticks[i]:SetVertexColor(unpack(C.media.border_color))
				ticks[i]:SetWidth(1)
				ticks[i]:SetHeight(Castbar:GetHeight())
				ticks[i]:SetDrawLayer("OVERLAY", 7)
			end
			ticks[i]:ClearAllPoints()
			ticks[i]:SetPoint("CENTER", Castbar, "RIGHT", -delta * i, 0)
			ticks[i]:Show()
		end
	end
end

local function castColor(unit)
	local r, g, b
	if UnitIsPlayer(unit) then
		local _, class = UnitClass(unit)
		local color = T.oUF_colors.class[class]
		if color then
			r, g, b = color[1], color[2], color[3]
		end
	else
		local reaction = UnitReaction(unit, "player")
		local color = T.oUF_colors.reaction[reaction]
		if color and reaction >= 5 then
			r, g, b = color[1], color[2], color[3]
		else
			r, g, b = 0.85, 0.77, 0.36
		end
	end

	return r, g, b
end

T.PostCastStart = function(Castbar, unit)
	if unit == "vehicle" then unit = "player" end

	if unit == "player" and C.unitframe.castbar_latency == true and Castbar.Latency then
		local _, _, _, ms = GetNetStats()
		Castbar.Latency:SetText(("%dms"):format(ms))
		if Castbar.casting then
			Castbar.SafeZone:SetDrawLayer("BORDER")
			Castbar.SafeZone:SetVertexColor(0.85, 0.27, 0.27)
		else
			Castbar.SafeZone:SetDrawLayer("ARTWORK")
			Castbar.SafeZone:SetVertexColor(0.85, 0.27, 0.27, 0.75)
		end
	end

	if unit == "player" and C.unitframe.castbar_ticks == true then
		if Castbar.casting then
			setBarTicks(Castbar, 0)
		else
			local spell = UnitChannelInfo(unit)
			Castbar.channelingTicks = T.CastBarTicks[spell] or 0
			setBarTicks(Castbar, Castbar.channelingTicks)
		end
	end

	if Castbar.notInterruptible and UnitCanAttack("player", unit) then
		Castbar:SetStatusBarColor(0.8, 0, 0)
		Castbar.bg:SetVertexColor(0.8, 0, 0, 0.2)
		Castbar.Overlay:SetBackdropBorderColor(0.8, 0, 0)
		if (C.unitframe.castbar_icon == true and unit == "target") or (unit == "focus" and C.unitframe.castbar_focus_type ~= "NONE") then
			Castbar.Button:SetBackdropBorderColor(0.8, 0, 0)
		end
	else
		if unit == "pet" or unit == "vehicle" then
			local _, class = UnitClass("player")
			local r, g, b = unpack(T.oUF_colors.class[class])
			if C.unitframe.own_color == true then
				Castbar:SetStatusBarColor(unpack(C.unitframe.uf_color))
				Castbar.bg:SetVertexColor(C.unitframe.uf_color_bg[1], C.unitframe.uf_color_bg[2], C.unitframe.uf_color_bg[3], 1)
			else
				if b then
					Castbar:SetStatusBarColor(r, g, b)
					Castbar.bg:SetVertexColor(r, g, b, 0.2)
				end
			end
		else
			if C.unitframe.own_color == true then
				Castbar:SetStatusBarColor(unpack(C.unitframe.uf_color))
				Castbar.bg:SetVertexColor(C.unitframe.uf_color_bg[1], C.unitframe.uf_color_bg[2], C.unitframe.uf_color_bg[3], 1)
			else
				local r, g, b = castColor(unit)
				Castbar:SetStatusBarColor(r, g, b)
				Castbar.bg:SetVertexColor(r, g, b, 0.2)
			end
		end
		Castbar.Overlay:SetBackdropBorderColor(unpack(C.media.border_color))
		if (C.unitframe.castbar_icon == true and unit == "target") or (unit == "focus" and C.unitframe.castbar_focus_type ~= "NONE") then
			Castbar.Button:SetBackdropBorderColor(unpack(C.media.border_color))
		end
		Castbar.Overlay:SetBackdropBorderColor(unpack(C.media.border_color))
		if C.unitframe.castbar_icon == true and (unit == "target" or unit == "focus") then
			Castbar.Button:SetBackdropBorderColor(unpack(C.media.border_color))
		end
	end

	if Castbar.Time and Castbar.Text then
		local timeWidth = Castbar.Time:GetStringWidth()
		local textWidth = Castbar:GetWidth() - timeWidth - 5

		if timeWidth == 0 then
			C_Timer.After(0.05, function()
				textWidth = Castbar:GetWidth() - Castbar.Time:GetStringWidth() - 5
				if textWidth > 0 then
					Castbar.Text:SetWidth(textWidth)
				end
			end)
		else
			Castbar.Text:SetWidth(textWidth)
		end
	end
end

T.CustomCastTimeText = function(self, duration)
	self.Time:SetText(("%.1f / %.1f"):format(self.channeling and duration or self.max - duration, self.max))
end

T.CustomCastDelayText = function(self, duration)
	self.Time:SetText(("%.1f |cffaf5050%s %.1f|r"):format(self.channeling and duration or self.max - duration, self.channeling and "-" or "+", abs(self.delay)))
end

T.AuraTrackerTime = function(self, elapsed)
	if self.active then
		self.timeleft = self.timeleft - elapsed
		if self.timeleft <= 5 then
			self.text:SetTextColor(1, 0, 0)
		else
			self.text:SetTextColor(1, 1, 1)
		end
		if self.timeleft <= 0 then
			self.icon:SetTexture(0)
			self.text:SetText("")
		end
		self.text:SetFormattedText("%.1f", self.timeleft)
	end
end

T.HideAuraFrame = function(self)
	if self.unit == "player" then
		if not C.aura.player_auras then
			if T.Classic then
				BuffFrame:UnregisterEvent("UNIT_AURA")
				BuffFrame:Hide()
				TemporaryEnchantFrame:Hide()
			else
				BuffFrame:Hide()
			end
			self.Debuffs:Hide()
		end
	elseif self.unit == "pet" and not C.aura.pet_debuffs or self.unit == "focus" and not C.aura.focus_debuffs
	or self.unit == "focustarget" and not C.aura.fot_debuffs or self.unit == "targettarget" and not C.aura.tot_debuffs then
		self.Debuffs:Hide()
	elseif self.unit == "target" and not C.aura.target_auras then
		self.Auras:Hide()
	end
end

T.PostCreateButton = function(element, button)
	button:SetTemplate("Default")

	button.remaining = T.SetFontString(button, C.font.auras_font, C.font.auras_font_size, C.font.auras_font_style)
	button.remaining:SetShadowOffset(C.font.auras_font_shadow and 1 or 0, C.font.auras_font_shadow and -1 or 0)
	button.remaining:SetPoint("CENTER", button, "CENTER", 1, 1)
	button.remaining:SetJustifyH("CENTER")

	button.Cooldown.noCooldownCount = true

	button.Icon:SetPoint("TOPLEFT", 2, -2)
	button.Icon:SetPoint("BOTTOMRIGHT", -2, 2)
	button.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	button.Count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 1, 0)
	button.Count:SetJustifyH("RIGHT")
	button.Count:SetFont(C.font.auras_font, C.font.auras_font_size, C.font.auras_font_style)
	button.Count:SetShadowOffset(C.font.auras_font_shadow and 1 or 0, C.font.auras_font_shadow and -1 or 0)

	if C.aura.show_spiral == true then
		element.disableCooldown = false
		button.Cooldown:SetReverse(true)
		button.Cooldown:SetHideCountdownNumbers(true)
		button.Cooldown:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
		button.Cooldown:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
		button.parent = CreateFrame("Frame", nil, button)
		button.parent:SetFrameLevel(button.Cooldown:GetFrameLevel() + 1)
		button.Count:SetParent(button.parent)
		button.remaining:SetParent(button.parent)
	else
		element.disableCooldown = true
	end
end

local day, hour, minute = 86400, 3600, 60
local FormatTime = function(s)
	if s >= day then
		return format("%dd", floor(s / day + 0.5))
	elseif s >= hour then
		return format("%dh", floor(s / hour + 0.5))
	elseif s >= minute then
		return format("%dm", floor(s / minute + 0.5))
	elseif s >= 5 then
		return floor(s + 0.5)
	end
	return format("%.1f", s)
end

T.CreateAuraTimer = function(self, elapsed)
	if self.timeLeft then
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed >= 0.1 then
			if not self.first then
				self.timeLeft = self.timeLeft - self.elapsed
			else
				self.timeLeft = self.timeLeft - GetTime()
				self.first = false
			end
			if self.timeLeft > 0 then
				local time = FormatTime(self.timeLeft)
				self.remaining:SetText(time)
			else
				self.remaining:Hide()
				self:SetScript("OnUpdate", nil)
			end
			self.elapsed = 0
		end
	end
end


local playerUnits = {
	player = true,
	pet = true,
	vehicle = true,
}

-- TODO: Revisit this when we eventually consolidate oUF's Auras element between Classic and Mainline
if T.Classic then
	T.PostUpdateButton = function(_, unit, button, _, _, duration, expirationTime, dispelName, isStealable)
		if button.isHarmful then
			if not UnitIsFriend("player", unit) and not playerUnits[button.caster] then
				if not C.aura.player_aura_only then
					button:SetBackdropBorderColor(unpack(C.media.border_color))
					button.Icon:SetDesaturated(true)
				end
			else
				if C.aura.debuff_color_type == true then
					local color = DebuffTypeColor[dispelName] or DebuffTypeColor.none
					button:SetBackdropBorderColor(color.r, color.g, color.b)
					button.Icon:SetDesaturated(false)
				else
					button:SetBackdropBorderColor(1, 0, 0)
				end
			end
		else
			if (isStealable or ((T.class == "MAGE" or T.class == "PRIEST" or T.class == "SHAMAN" or T.class == "HUNTER") and dispelName == "Magic")) and not UnitIsFriend("player", unit) then
				button:SetBackdropBorderColor(1, 0.85, 0)
			else
				button:SetBackdropBorderColor(unpack(C.media.border_color))
			end
			button.Icon:SetDesaturated(false)
		end

		if duration and duration > 0 and C.aura.show_timer == true then
			button.remaining:Show()
			button.timeLeft = expirationTime
			button:SetScript("OnUpdate", T.CreateAuraTimer)
		else
			button.remaining:Hide()
			button.timeLeft = math.huge
			button:SetScript("OnUpdate", nil)
		end

		button.first = true
	end

	T.CustomFilter = function(_, unit, button, _, _, _, _, _, _, caster)
		if C.aura.player_aura_only then
			if button.isHarmful then
				if not UnitIsFriend("player", unit) and not playerUnits[caster] then
					return false
				end
			end
		end
		return true
	end

	T.CustomFilterBoss = function(_, unit, button, name, _, _, _, _, _, caster)
		if button.isHarmful then
			if (playerUnits[caster] or caster == unit) then
				if (T.DebuffBlackList and not T.DebuffBlackList[name]) or not T.DebuffBlackList then
					return true
				end
			end
			return false
		end
		return true
	end
else
	T.PostUpdateButton = function(_, button, unit, data)
		if data.isHarmful then
			if not UnitIsFriend("player", unit) and not playerUnits[data.sourceUnit] then
				if not C.aura.player_aura_only then
					button:SetBackdropBorderColor(unpack(C.media.border_color))
					button.Icon:SetDesaturated(true)
				end
			else
				if C.aura.debuff_color_type == true then
					local color = DebuffTypeColor[data.dispelName] or DebuffTypeColor.none
					button:SetBackdropBorderColor(color.r, color.g, color.b)
					button.Icon:SetDesaturated(false)
				else
					button:SetBackdropBorderColor(1, 0, 0)
				end
			end
		else
			if (data.isStealable or ((T.class == "MAGE" or T.class == "PRIEST" or T.class == "SHAMAN" or T.class == "HUNTER") and data.dispelName == "Magic")) and not UnitIsFriend("player", unit) then
				button:SetBackdropBorderColor(1, 0.85, 0)
			else
				button:SetBackdropBorderColor(unpack(C.media.border_color))
			end
			button.Icon:SetDesaturated(false)
		end

		if data.duration and data.duration > 0 and C.aura.show_timer == true then
			button.remaining:Show()
			button.timeLeft = data.expirationTime
			button:SetScript("OnUpdate", T.CreateAuraTimer)
		else
			button.remaining:Hide()
			button.timeLeft = math.huge
			button:SetScript("OnUpdate", nil)
		end

		button.first = true
	end

	T.CustomFilter = function(element, unit, data)
		if C.aura.player_aura_only then
			if data.isHarmful then
				if not UnitIsFriend("player", unit) and not playerUnits[data.sourceUnit] then
					return false
				end
			end
		end
		return true
	end

	T.CustomFilterBoss = function(element, unit, data)
		if data.isHarmful then
			if (playerUnits[data.sourceUnit] or data.sourceUnit == unit) then
				if (T.DebuffBlackList and not T.DebuffBlackList[data.name]) or not T.DebuffBlackList then
					return true
				end
			end
			return false
		end
		return true
	end
end

T.UpdateThreat = function(self, unit, status, r, g, b)
	local parent = self:GetParent()
	local badunit = not unit or parent.unit ~= unit

	if not badunit and status and status > 1 then
		parent.backdrop:SetBackdropBorderColor(r, g, b)
	else
		parent.backdrop:SetBackdropBorderColor(unpack(C.media.border_color))
	end
end

local CountOffSets = {
	TOPLEFT = {"LEFT", "RIGHT", 1, 0},
	TOPRIGHT = {"RIGHT", "LEFT", 2, 0},
	BOTTOMLEFT = {"LEFT", "RIGHT", 1, 0},
	BOTTOMRIGHT = {"RIGHT", "LEFT", 2, 0},
	LEFT = {"LEFT", "RIGHT", 1, 0},
	RIGHT = {"RIGHT", "LEFT", 2, 0},
	TOP = {"RIGHT", "LEFT", 2, 0},
	BOTTOM = {"RIGHT", "LEFT", 2, 0},
}

T.CreateAuraWatchIcon = function(_, icon)
	icon:CreateBorder(nil, true)
	if T.Classic and not T.Mists then
		icon.icon:SetPoint("TOPLEFT", icon, 0, 0)
		icon.icon:SetPoint("BOTTOMRIGHT", icon, 0, 0)
	end
	icon.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	icon.icon:SetDrawLayer("ARTWORK")
	if icon.cd then
		icon.cd:SetReverse(true)
		icon.cd:SetHideCountdownNumbers(true)
		if C.raidframe.plugins_buffs_timer then
			icon.parent = CreateFrame("Frame", nil, icon)
			icon.parent:SetFrameLevel(icon.cd:GetFrameLevel() + 1)
			icon.remaining = T.SetFontString(icon.parent, C.font.auras_font, C.font.auras_font_size, C.font.auras_font_style)
			icon.remaining:SetShadowOffset(C.font.auras_font_shadow and 1 or 0, C.font.auras_font_shadow and -1 or 0)
			icon.remaining:SetPoint("CENTER", icon, "CENTER", 1, 0)
			icon.remaining:SetJustifyH("CENTER")
		end
	end
end

T.CreateAuraWatch = function(self)
	local auras = CreateFrame("Frame", nil, self)
	auras:SetPoint("TOPLEFT", self.Health, 0, 0)
	auras:SetPoint("BOTTOMRIGHT", self.Health, 0, 0)
	auras.icons = {}
	auras.PostCreateButton = T.CreateAuraWatchIcon
	
	if not C.aura.show_timer then
		auras.hideCooldown = true
	end

	local buffs = {}

	if T.RaidBuffs["ALL"] then
		for _, value in pairs(T.RaidBuffs["ALL"]) do
			tinsert(buffs, value)
		end
	end

	if T.RaidBuffs[T.class] then
		for _, value in pairs(T.RaidBuffs[T.class]) do
			tinsert(buffs, value)
		end
	end

	if buffs then
		for _, spell in pairs(buffs) do
			local icon = CreateFrame("Frame", nil, auras)
			icon.spellID = spell[1]
			icon.anyUnit = spell[4]
			icon.strictMatching = spell[5]
			icon:SetSize(7 * C.raidframe.icon_multiplier, 7 * C.raidframe.icon_multiplier)
			icon:SetPoint(spell[2], 0, 0)

			local tex = icon:CreateTexture(nil, "OVERLAY")
			tex:SetAllPoints(icon)
			tex:SetTexture(C.media.blank)
			if spell[3] then
				tex:SetVertexColor(unpack(spell[3]))
			else
				tex:SetVertexColor(0.8, 0.8, 0.8)
			end
			icon.icon = tex

			local count = T.SetFontString(icon, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
			local point, anchorPoint, x, y = unpack(CountOffSets[spell[2]])
			count:SetPoint(point, icon, anchorPoint, x, y)
			icon.count = count

			auras.icons[spell[1]] = icon
		end
	end

	self.AuraWatch = auras
end

T.CreateHealthPrediction = function(self)
	local mhpb = self.Health:CreateTexture(nil, "ARTWORK")
	mhpb:SetTexture(C.media.texture)
	mhpb:SetVertexColor(0, 1, 0.5, 0.2)

	local ohpb = self.Health:CreateTexture(nil, "ARTWORK")
	ohpb:SetTexture(C.media.texture)
	ohpb:SetVertexColor(0, 1, 0, 0.2)

	local ahpb = self.Health:CreateTexture(nil, "ARTWORK")
	ahpb:SetTexture(C.media.texture)
	ahpb:SetVertexColor(1, 1, 0, 0.2)

	local hab = self.Health:CreateTexture(nil, "ARTWORK")
	hab:SetTexture(C.media.texture)
	hab:SetVertexColor(1, 0, 0, 0.4)

	local oa = self.Health:CreateTexture(nil, "ARTWORK")
	oa:SetTexture([[Interface\AddOns\ShestakUI\Media\Textures\Cross.tga]], "REPEAT", "REPEAT")
	oa:SetVertexColor(0.5, 0.5, 1)
	oa:SetHorizTile(true)
	oa:SetVertTile(true)
	oa:SetAlpha(0.4)
	oa:SetBlendMode("ADD")

	local oha = self.Health:CreateTexture(nil, "ARTWORK")
	oha:SetTexture([[Interface\AddOns\ShestakUI\Media\Textures\Cross.tga]], "REPEAT", "REPEAT")
	oha:SetVertexColor(1, 0, 0)
	oha:SetHorizTile(true)
	oha:SetVertTile(true)
	oha:SetAlpha(0.4)
	oha:SetBlendMode("ADD")

	self.HealthPrediction = {
		myBar = mhpb,
		otherBar = ohpb,
		absorbBar = ahpb,
		healAbsorbBar = hab,
		overAbsorb = C.raidframe.plugins_over_absorb and oa,
		overHealAbsorb = C.raidframe.plugins_over_heal_absorb and oha
	}
end