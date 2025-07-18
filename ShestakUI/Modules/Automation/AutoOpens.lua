local T, C, L = unpack(ShestakUI)
if C.automation.open_items ~= true then return end

----------------------------------------------------------------------------------------
--	Auto opening of items in bag (kAutoOpen by Kellett)
----------------------------------------------------------------------------------------
local frame, atBank, atMail, atMerchant = CreateFrame("Frame")
frame:SetScript("OnEvent", function(self, event, ...) self[event](...) end)

function frame:Register(event, func)
	self:RegisterEvent(event)
	self[event] = function(...)
		func(...)
	end
end

frame:Register("BANKFRAME_OPENED", function()
	atBank = true
end)

frame:Register("BANKFRAME_CLOSED", function()
	atBank = false
end)

if T.TBC or T.Wrath or T.Cata or T.Mists then
	frame:Register("GUILDBANKFRAME_OPENED", function()
		atBank = true
	end)

	frame:Register("GUILDBANKFRAME_CLOSED", function()
		atBank = false
	end)
elseif T.Mainline then
	frame:Register("PLAYER_INTERACTION_MANAGER_FRAME_SHOW", function(...)
		local type = ...
		if type == 10 then	-- Guild bank
			atBank = true
		end
	end)

	frame:Register("PLAYER_INTERACTION_MANAGER_FRAME_HIDE", function(...)
		local type = ...
		if type == 10 then	-- Guild bank
			atBank = false
		end
	end)
end

frame:Register("MAIL_SHOW", function()
	atMail = true
end)

frame:Register("MAIL_CLOSED", function()
	atMail = false
end)

frame:Register("MERCHANT_SHOW", function()
	atMerchant = true
end)

frame:Register("MERCHANT_CLOSED", function()
	atMerchant = false
end)

frame:Register("BAG_UPDATE_DELAYED", function()
	if atBank or atMail or atMerchant then return end
	for bag = 0, 4 do
		for slot = 0, C_Container.GetContainerNumSlots(bag) do
			local _, _, locked, _, _, lootable, _, _, _, id = GetContainerItemInfo(bag, slot)
			if lootable and not locked and id and T.OpenItems[id] then
				print("|cffff0000"..OPENING..": "..C_Container.GetContainerItemLink(bag, slot)..".|r")
				C_Container.UseContainerItem(bag, slot)
				return
			end
		end
	end
end)
