-- TycoonData.server.lua
-- Persistent data handling with versioned DataStore
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local STORE_VERSION = "v2"
local Store = DataStoreService:GetDataStore("TycoonData_" .. STORE_VERSION)

local DEFAULT_DATA = {
	Cash = 0,
	PurchasedItems = {}
}

local function deepCopy(tbl)
	local copy = {}
	for k, v in pairs(tbl) do
		copy[k] = typeof(v) == "table" and deepCopy(v) or v
	end
	return copy
end

local function load(player)
	local data
	local success = pcall(function()
		data = Store:GetAsync(player.UserId)
	end)

	if not success or typeof(data) ~= "table" then
		data = deepCopy(DEFAULT_DATA)
	end

	return data
end

local function save(player)
	local stats = player:FindFirstChild("leaderstats")
	if not stats then return end

	local data = {
		Cash = stats.Cash.Value,
		PurchasedItems = player:GetAttribute("PurchasedItems") or {}
	}

	pcall(function()
		Store:SetAsync(player.UserId, data)
	end)
end

Players.PlayerAdded:Connect(function(player)
	local data = load(player)

	local stats = Instance.new("Folder")
	stats.Name = "leaderstats"
	stats.Parent = player

	local cash = Instance.new("IntValue")
	cash.Name = "Cash"
	cash.Value = data.Cash
	cash.Parent = stats

	player:SetAttribute("PurchasedItems", data.PurchasedItems)
end)

Players.PlayerRemoving:Connect(save)
game:BindToClose(function()
	for _, player in ipairs(Players:GetPlayers()) do
		save(player)
	end
end)
