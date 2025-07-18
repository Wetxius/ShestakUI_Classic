local T, C, L = unpack(ShestakUI)
if C.loot.auto_greed ~= true or T.level ~= MAX_PLAYER_LEVEL then return end

----------------------------------------------------------------------------------------
--	Auto greed/disenchant on green items(by Tekkub)
----------------------------------------------------------------------------------------
local frame = CreateFrame("Frame")
frame:RegisterEvent("START_LOOT_ROLL")
frame:SetScript("OnEvent", function(_, _, id)
	local _, _, _, quality, BoP, _, _, canDisenchant = GetLootRollItemInfo(id)
	if id and quality == 2 and not BoP then
		local link = GetLootRollItemLink(id)
		local _, _, _, ilevel = C_Item.GetItemInfo(link)
		if canDisenchant and (T.Classic or (T.Mainline and ilevel > 270)) then
			RollOnLoot(id, 3)
		else
			RollOnLoot(id, 2)
		end
	end
end)
