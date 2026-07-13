local T, C, L = unpack(ShestakUI)
if C.unitframe.enable ~= true or T.class ~= "PRIEST" then return end

local _, ns = ...
local oUF = ns.oUF

if(oUF:IsClassic() and not oUF:IsCata() and not oUF:IsMists()) then return end

local SPELL_POWER_SHADOW_ORBS = Enum.PowerType.ShadowOrbs or 28

local function Update(self, _, unit, powerType)
	if(self.unit ~= unit or (powerType and powerType ~= "SHADOW_ORBS")) then return end

	local element = self.ShadowOrbs

	if(element.PreUpdate) then
		element:PreUpdate(unit)
	end

	if UnitHasVehicleUI("player") then
		element:Hide()
		if self.Debuffs then self.Debuffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 2, 5) end
	else
		element:Show()
		if self.Debuffs then self.Debuffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 2, 19) end
	end

	local cur = UnitPower("player", SPELL_POWER_SHADOW_ORBS)
	local max = UnitPowerMax("player", SPELL_POWER_SHADOW_ORBS)
	local spacing = select(4, element[3]:GetPoint())
	local barWidth = element:GetWidth()
	local lastBar = 0

	if element.max ~= max then
		if max == 3 then
			element[4]:Hide()
			element[5]:Hide()
		elseif max == 5 then
			element[4]:Show()
			element[5]:Show()
		end

		for i = 1, max do
			if i ~= max then
				element[i]:SetWidth(barWidth / max - spacing)
				lastBar = lastBar + (barWidth / max)
			else
				element[i]:SetWidth(barWidth - lastBar)
			end
		end

		element.max = max
	end

	for i = 1, max do
		if(i <= cur) then
			element[i]:SetAlpha(1)
		else
			element[i]:SetAlpha(0.2)
		end
	end

	if(element.PostUpdate) then
		return element:PostUpdate(cur)
	end
end

local function Path(self, ...)
	--[[ Override: ShadowOrbs.Override(self, event, unit)
	Used to completely override the internal update function.

	* self  - the parent object
	* event - the event triggering the update (string)
	* unit  - the unit accompanying the event (string)
	--]]
	return (self.ShadowOrbs.Override or Update)(self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Visibility(self)
	local element = self.ShadowOrbs
	local spec = T.GetSpecialization()

	if spec == 1 or UnitHasVehicleUI("player") then
		element:Hide()
		if self.Debuffs then self.Debuffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 2, 5) end
	else
		element:Show()
		if self.Debuffs then self.Debuffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 2, 19) end
	end
end

local function Enable(self)
	local element = self.ShadowOrbs
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent("UNIT_DISPLAYPOWER", Path)
		self:RegisterEvent("UNIT_POWER_UPDATE", Path)
		self:RegisterEvent("UNIT_MAXPOWER", Path)

		element.handler = CreateFrame("Frame", nil, element)	-- ShestakUI
		element.handler:RegisterEvent("PLAYER_TALENT_UPDATE")
		element.handler:RegisterEvent("PLAYER_ENTERING_WORLD")
		element.handler:SetScript("OnEvent", function() Visibility(self) end)

		if(not element.UpdateColor) then
			element.UpdateColor = UpdateColor
		end

		-- do not change this without taking Visibility into account
		element:Hide()

		return true
	end
end

local function Disable(self)
	local element = self.ShadowOrbs
	if(element) then
		element:Hide()

		self:UnregisterEvent('UNIT_DISPLAYPOWER', Path)
		self:UnregisterEvent('UNIT_POWER_UPDATE', Path)
		self:UnregisterEvent('UNIT_MAXPOWER', Path)
		element.handler:UnregisterEvent('PLAYER_TALENT_UPDATE')
		element.handler:UnregisterEvent('PLAYER_ENTERING_WORLD')
	end
end

oUF:AddElement('ShadowOrbs', Path, Enable, Disable)