local T, C, L = unpack(ShestakUI)

local Mult = T.mult
if T.screenHeight > 1200 then
	Mult = T.Scale(1)
end

local colorTable = setmetatable(
	{},
	{__index = function(self, val)
		local r, g, b = C_Item.GetItemQualityColor(val)
		rawset(self, val, {r, g, b})

		return self[val]
	end}
)

local createBorder = function(self, point)
	local bc = self.oGlowBorder
	if not bc then
		if C.skins.blizzard_frames == true or C_AddOns.IsAddOnLoaded("Aurora") then
			if not self:IsObjectType("Frame") then
				bc = CreateFrame("Frame", nil, self:GetParent(), BackdropTemplateMixin and "BackdropTemplate")
			else
				bc = CreateFrame("Frame", nil, self, BackdropTemplateMixin and "BackdropTemplate")
			end

			bc:SetBackdrop({
				edgeFile = C.media.blank,
				edgeSize = Mult,
			})

			if self.backdrop then
				bc:SetPoint("TOPLEFT", 0, 0)
				bc:SetPoint("BOTTOMRIGHT", 0, 0)
			else
				bc:SetPoint("TOPLEFT", point or self, 0, 0)
				bc:SetPoint("BOTTOMRIGHT", point or self, 0, 0)
			end
		else
			if not self:IsObjectType("Frame") then
				bc = self:GetParent():CreateTexture(nil, "OVERLAY")
			else
				bc = self:CreateTexture(nil, "OVERLAY")
			end

			bc:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
			bc:SetBlendMode("ADD")
			bc:SetAlpha(0.8)

			bc:SetSize(70, 70)

			bc:SetPoint("CENTER", point or self)
		end
		self.oGlowBorder = bc
	end

	return bc
end

local borderDisplay = function(frame, color)
	if color then
		local bc = createBorder(frame)
		local rgb = colorTable[color]

		if rgb then
			if C.skins.blizzard_frames == true or C_AddOns.IsAddOnLoaded("Aurora") then
				bc:SetBackdropBorderColor(rgb[1], rgb[2], rgb[3])
				if bc.backdrop then
					bc.backdrop:SetBackdropBorderColor(rgb[1], rgb[2], rgb[3])
				end
			else
				bc:SetVertexColor(rgb[1], rgb[2], rgb[3])
			end
			bc:Show()
		end

		return true
	elseif frame.oGlowBorder then
		frame.oGlowBorder:Hide()
	end
end

function oGlow:RegisterColor(name, r, g, b)
	if rawget(colorTable, name) then
		return nil, string.format("Color [%s] is already registered.", name)
	else
		rawset(colorTable, name, {r, g, b})
	end

	return true
end

oGlow:RegisterDisplay("Border", borderDisplay)
