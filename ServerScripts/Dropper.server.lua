-- Dropper.server.lua
-- Handles money generation for tycoon droppers
local Players = game:GetService("Players")

local Dropper = {}
Dropper.__index = Dropper

local DEFAULT_COOLDOWN = 1.25

function Dropper.new(dropPart)
	assert(dropPart:IsA("BasePart"), "Dropper must be a BasePart")

	local self = setmetatable({}, Dropper)
	self.Part = dropPart
	self.Value = dropPart:GetAttribute("DropValue") or 25
	self.Cooldown = dropPart:GetAttribute("Cooldown") or DEFAULT_COOLDOWN
	self.LastTriggered = {}

	self:_bind()
	return self
end

function Dropper:_canTrigger(player)
	local last = self.LastTriggered[player.UserId]
	return not last or (os.clock() - last >= self.Cooldown)
end

function Dropper:_rewardPlayer(player)
	local stats = player:FindFirstChild("leaderstats")
	if not stats then return end

	local cash = stats:FindFirstChild("Cash")
	if not cash then return end

	cash.Value += self.Value
end

function Dropper:_bind()
	self.Part.Touched:Connect(function(hit)
		local character = hit.Parent
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if not humanoid then return end

		local player = Players:GetPlayerFromCharacter(character)
		if not player then return end

		if not self:_canTrigger(player) then
			return
		end

		self.LastTriggered[player.UserId] = os.clock()
		self:_rewardPlayer(player)

		self.Part:Destroy()
	end)
end

return Dropper
