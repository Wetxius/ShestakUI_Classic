local T, C, L = unpack(ShestakUI)
if C.unitframe.enable ~= true or T.class ~= "WARLOCK" then return end

local _, ns = ...
local oUF = ns.oUF

if(oUF:IsClassic() and not oUF:IsCata() and not oUF:IsMists()) then return end

local ClassPowerType
local ClassPowerID
if GetActiveTalentGroup(isInspect, isPet, specGroup) == 3 then 
	ClassPowerType = Enum.PowerType.SoulShards or 7
	ClassPowerID = 'SOUL_SHARDS'
elseif GetActiveTalentGroup(isInspect, isPet, specGroup) == 2 then
	ClassPowerType = Enum.PowerType.DemonicFury or 15
	ClassPowerID = 'DEMONIC_FURY'
elseif GetActiveTalentGroup(isInspect, isPet, specGroup) == 1 then
	ClassPowerType = Enum.PowerType.BurningEmbers or 14
	ClassPowerID = 'BURNING_EMBERS'
end



local function Update(self, _, unit, powerType)
	if(self.unit ~= unit or (powerType and powerType ~= ClassPowerID)) then return end

	local element = self.SoulShards

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

	local cur
	if ClassPowerID == 'DEMONIC_FURY' then
		cur = UnitPower("player", ClassPowerType)
		else
		cur = UnitPower("player", ClassPowerType)
	end
	local max = (oUF:IsClassic() and 4) -- Cause we don't use :Factory to spawn frames it return sometimes "3"

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
	return (self.SoulShards.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, "ForceUpdate", element.__owner.unit)
end

local function Visibility(self)
	local element = self.SoulShards

	if not UnitHasVehicleUI("player") then
		element:Show()
		if self.Debuffs then self.Debuffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 2, 19) end
	end
	self:RegisterEvent("UNIT_POWER_UPDATE", Path)
end

local function Enable(self)
	local element = self.SoulShards
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		element.handler = CreateFrame("Frame", nil, element)
		element.handler:RegisterEvent("PLAYER_TALENT_UPDATE")
		element.handler:RegisterEvent("PLAYER_ENTERING_WORLD")
		element.handler:SetScript("OnEvent", function() Visibility(self) end)

		return true
	end
end

local function Disable(self)
	local element = self.SoulShards
	if(element) then
		element.handler:UnregisterEvent("PLAYER_TALENT_UPDATE")
		element.handler:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end

oUF:AddElement("SoulShards", Path, Enable, Disable)