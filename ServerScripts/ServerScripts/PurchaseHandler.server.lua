-- PurchaseHandler.server.lua
-- Handles all tycoon purchases server-side
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PurchaseEvent = ReplicatedStorage.Remotes:WaitForChild("Purchase")

local function validatePurchase(player, tycoon, item)
	if tycoon:GetAttribute("OwnerUserId") ~= player.UserId then
		return false, "Ownership mismatch"
	end

	if item:GetAttribute("Purchased") then
		return false, "Already purchased"
	end

	return true
end

PurchaseEvent.OnServerEvent:Connect(function(player, tycoon, itemId)
	if not tycoon or not itemId then return end

	local itemsFolder = tycoon:FindFirstChild("Items")
	if not itemsFolder then return end

	local item = itemsFolder:FindFirstChild(itemId)
	if not item then return end

	local price = item:GetAttribute("Price")
	if not price then return end

	local stats = player:FindFirstChild("leaderstats")
	local cash = stats and stats:FindFirstChild("Cash")
	if not cash or cash.Value < price then
		return
	end

	local isValid, reason = validatePurchase(player, tycoon, item)
	if not isValid then
		warn("Purchase denied:", reason)
		return
	end

	cash.Value -= price
	item:SetAttribute("Purchased", true)
	item.Parent = tycoon.BuiltItems
end)
