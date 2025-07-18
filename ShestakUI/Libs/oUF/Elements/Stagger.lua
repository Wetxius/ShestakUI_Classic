local T, C, L = unpack(ShestakUI)

if(select(2, UnitClass('player')) ~= 'MONK') then return end

local _, ns = ...
local oUF = ns.oUF

if(oUF:IsClassic() and not oUF:IsMists()) then return end

-- sourced from FrameXML/Constants.lua
local SPEC_MONK_BREWMASTER = (SPEC_MONK_BREWMASTER or 1)

-- sourced from FrameXML/MonkStaggerBar.lua
local BREWMASTER_POWER_BAR_NAME = BREWMASTER_POWER_BAR_NAME or 'STAGGER'

-- percentages at which bar should change color
local STAGGER_YELLOW_TRANSITION =  STAGGER_YELLOW_TRANSITION or 0.3
local STAGGER_RED_TRANSITION = STAGGER_RED_TRANSITION or 0.6

-- table indices of bar colors
local STAGGER_GREEN_INDEX = STAGGER_GREEN_INDEX or 1
local STAGGER_YELLOW_INDEX = STAGGER_YELLOW_INDEX or 2
local STAGGER_RED_INDEX = STAGGER_RED_INDEX or 3

local function UpdateColor(element, cur, max)
	local colors = element.__owner.colors.power[BREWMASTER_POWER_BAR_NAME]
	local perc = cur / max

	local t
	if(perc >= STAGGER_RED_TRANSITION) then
		t = colors and colors[STAGGER_RED_INDEX]
	elseif(perc > STAGGER_YELLOW_TRANSITION) then
		t = colors and colors[STAGGER_YELLOW_INDEX]
	else
		t = colors and colors[STAGGER_GREEN_INDEX]
	end

	local r, g, b
	if(t) then
		r, g, b = t[1], t[2], t[3]
		if(b) then
			element:SetStatusBarColor(r, g, b)

			local bg = element.bg
			if(bg and b) then
				local mu = bg.multiplier or 1
				bg:SetVertexColor(r * mu, g * mu, b * mu)
			end
		end
	end
end

local function Update(self, event, unit)
	if(unit and unit ~= self.unit) then return end

	local element = self.Stagger

	--[[ Callback: Stagger:PreUpdate()
	Called before the element has been updated.

	* self - the Stagger element
	--]]
	if(element.PreUpdate) then
		element:PreUpdate()
	end

	-- Blizzard code has nil checks for UnitStagger return
	local cur = UnitStagger('player') or 0
	local max = UnitHealthMax('player')

	element:SetMinMaxValues(0, max)
	element:SetValue(cur)

	--[[ Override: Stagger:UpdateColor(cur, max)
	Used to completely override the internal function for updating the widget's colors.

	* self - the Stagger element
	* cur  - the amount of staggered damage (number)
	* max  - the player's maximum possible health value (number)
	--]]
	element:UpdateColor(cur, max)

	--[[ Callback: Stagger:PostUpdate(cur, max)
	Called after the element has been updated.

	* self - the Stagger element
	* cur  - the amount of staggered damage (number)
	* max  - the player's maximum possible health value (number)
	--]]
	if(element.PostUpdate) then
		element:PostUpdate(cur, max)
	end
end

local function Path(self, ...)
	--[[ Override: Stagger.Override(self, event, unit)
	Used to completely override the internal update function.

	* self  - the parent object
	* event - the event triggering the update (string)
	* unit  - the unit accompanying the event (string)
	--]]
	return (self.Stagger.Override or Update)(self, ...)
end

local function Visibility(self, event, unit)
	if(SPEC_MONK_BREWMASTER ~= T.GetSpecialization() or UnitHasVehiclePlayerFrameUI('player') or (T.level < 10)) then
		if(self.Stagger:IsShown()) then
			self.Stagger:Hide()
			self:UnregisterEvent('UNIT_AURA', Path)
		end
		if SPEC_MONK_WINDWALKER ~= T.GetSpecialization() then
			if self.Debuffs then self.Debuffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 2, 5) end	-- ShestakUI
		end
	else
		if(not self.Stagger:IsShown()) then
			self.Stagger:Show()
			self:RegisterEvent('UNIT_AURA', Path)
		end
		if self.Debuffs then self.Debuffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 2, 19) end	-- ShestakUI

		return Path(self, event, unit)
	end
end

local function VisibilityPath(self, ...)
	--[[ Override: Stagger.OverrideVisibility(self, event, unit)
	Used to completely override the internal visibility toggling function.

	* self  - the parent object
	* event - the event triggering the update (string)
	* unit  - the unit accompanying the event (string)
	--]]
	return (self.Stagger.OverrideVisibility or Visibility)(self, ...)
end

local function ForceUpdate(element)
	return VisibilityPath(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self)
	local element = self.Stagger
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_DISPLAYPOWER', VisibilityPath)
		self:RegisterEvent('PLAYER_TALENT_UPDATE', VisibilityPath, true)

		element.handler = CreateFrame("Frame", nil, element)	-- ShestakUI
		element.handler:RegisterEvent("PLAYER_TALENT_UPDATE")
		element.handler:RegisterEvent("PLAYER_ENTERING_WORLD")
		element.handler:SetScript("OnEvent", function() Visibility(self) end)

		if(element:IsObjectType('StatusBar') and not element:GetStatusBarTexture()) then
			element:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
		end

		if(not element.UpdateColor) then
			element.UpdateColor = UpdateColor
		end

		MonkStaggerBar:UnregisterEvent('PLAYER_ENTERING_WORLD')
		MonkStaggerBar:UnregisterEvent('PLAYER_SPECIALIZATION_CHANGED')
		MonkStaggerBar:UnregisterEvent('UNIT_DISPLAYPOWER')
		MonkStaggerBar:UnregisterEvent('UNIT_EXITED_VEHICLE')
		MonkStaggerBar:UnregisterEvent('UPDATE_VEHICLE_ACTIONBAR')

		-- do not change this without taking Visibility into account
		element:Hide()

		return true
	end
end

local function Disable(self)
	local element = self.Stagger
	if(element) then
		element:Hide()

		self:UnregisterEvent('UNIT_AURA', Path)
		self:UnregisterEvent('UNIT_DISPLAYPOWER', VisibilityPath)
		self:UnregisterEvent('PLAYER_TALENT_UPDATE', VisibilityPath)

		MonkStaggerBar:RegisterEvent('PLAYER_ENTERING_WORLD')
		MonkStaggerBar:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED')
		MonkStaggerBar:RegisterEvent('UNIT_DISPLAYPOWER')
		MonkStaggerBar:RegisterEvent('UNIT_EXITED_VEHICLE')
		MonkStaggerBar:RegisterEvent('UPDATE_VEHICLE_ACTIONBAR')
	end
end

oUF:AddElement('Stagger', VisibilityPath, Enable, Disable)