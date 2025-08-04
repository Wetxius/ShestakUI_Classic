local T, C, L = unpack(ShestakUI)
if C.unitframe.enable ~= true or T.class ~= "WARLOCK" then return end

local _, ns = ...
local oUF = ns.oUF

if(oUF:IsClassic() and not (oUF:IsCata() or oUF:IsMists())) then return end

local SpecPowerType
if C_SpecializationInfo.GetSpecialization() == 1 then
	SpecPowerType = Enum.PowerType.SoulShards or 7
elseif C_SpecializationInfo.GetSpecialization() == 2 then
	SpecPowerType = Enum.PowerType.DemonicFury or 15
elseif C_SpecializationInfo.GetSpecialization() == 3 then
	SpecPowerType = Enum.PowerType.BurningEmbers or 14
end


local function UpdateColor(self, event, unit, powerType)
	if(self.unit ~= unit or powerType ~= SpecPowerType) then return end
	local element = self.SoulShards

	local r, g, b, color
	if(element.colorThreat and not UnitPlayerControlled(unit) and UnitThreatSituation('player', unit)) then
		color =  self.colors.threat[UnitThreatSituation('player', unit)]
	elseif(element.colorPower) then
		color = self.colors.power[ALTERNATE_POWER_INDEX]
	elseif(element.colorClass and (UnitIsPlayer(unit) or UnitInPartyIsAI(unit)))
		or (element.colorClassNPC and not (UnitIsPlayer(unit) or UnitInPartyIsAI(unit))) then
		local _, class = UnitClass(unit)
		color = self.colors.class[class]
	elseif(element.colorSelection and unitSelectionType(unit, element.considerSelectionInCombatHostile)) then
		color = self.colors.selection[unitSelectionType(unit, element.considerSelectionInCombatHostile)]
	elseif(element.colorReaction and UnitReaction(unit, 'player')) then
		color = self.colors.reaction[UnitReaction(unit, 'player')]
	elseif(element.colorSmooth) then
		local adjust = 0 - (element.min or 0)
		r, g, b = self:ColorGradient((element.cur or 1) + adjust, (element.max or 1) + adjust, unpack(element.smoothGradient or self.colors.smooth))
	end

	if(color) then
		r, g, b = color[1], color[2], color[3]
	end

	if(b) then
		element:SetStatusBarColor(r, g, b)

		local bg = element.bg
		if(bg) then
			local mu = bg.multiplier or 1
			bg:SetVertexColor(r * mu, g * mu, b * mu)
		end
	end


	if(element.PostUpdateColor) then
		element:PostUpdateColor(unit, r, g, b)
	end
end

local function Update(self, _, unit, powerType)
	if(self.unit ~= unit or powerType ~= SpecPowerType) then return end

	local element = self.SoulShards

	if(element.PreUpdate) then
		element:PreUpdate(unit)
	end

	if C_SpecializationInfo.GetSpecialization() == (1 or 3) then
		local cur = UnitPower("player", SpecPowerType) or 0
		local max = 4

		for i = 1, max do
			if i <= cur then
				element[i]:SetAlpha(1)
			else
				element[i]:SetAlpha(0.2)
			end
		end
	elseif C_SpecializationInfo.GetSpecialization() == 2 then
			local cur = (UnitPower("player", SpecPowerType) * 0.001)
			local max = 1

			element:SetMinMaxValues(0, max)
			element:SetValue(cur)

			--element:UpdateColor(unit, cur, min, max, displayType)
	end


	if(element.PostUpdate) then
		return element:PostUpdate(cur)
	end
end

local function Path(self, ...)
	return (self.SoulShards.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, "ForceUpdate", element.__owner.unit, "SOUL_SHARDS")
end

local function Enable(self, unit)
	local element = self.SoulShards
	if(element) and unit == "player" then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent("UNIT_POWER_UPDATE", Path)
		self:RegisterEvent("UNIT_DISPLAYPOWER", Path)
		self:RegisterEvent('PLAYER_TALENT_UPDATE', Path, true)


		return true
	end
end

local function Disable(self)
	local element = self.SoulShards
	if(element) then
		self:UnregisterEvent("UNIT_POWER_UPDATE", Path)
		self:UnregisterEvent("UNIT_DISPLAYPOWER", Path)
		self:UnregisterEvent('PLAYER_TALENT_UPDATE', Path)

	end
end

oUF:AddElement("SoulShards", Path, Enable, Disable)