local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local PlayerStatsService = require(ServerScriptService.Services.PlayerStatsService)

local initializedPlayers = {}

local function initializeLeaderstats(player)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player
    
    local coins = Instance.new("IntValue")
    coins.Name = "Coins"
    coins.Value = 0
    coins.Parent = leaderstats

    local speed = Instance.new("IntValue")
    speed.Name = "Speed"
    speed.Value = PlayerStatsService.GetPlayerSpeed(player)
    speed.Parent = leaderstats
end

local function onPlayerAdded(player)
    if initializedPlayers[player] then
        return
    end

    initializedPlayers[player] = true
    PlayerStatsService.InitializePlayerStats(player)
    initializeLeaderstats(player)

    player.CharacterAdded:Connect(function(character)
        PlayerStatsService.ApplyStatsToCharacter(player, character)
    end)

    if player.Character then
        PlayerStatsService.ApplyStatsToCharacter(player, player.Character)
    end
end

local function onPlayerRemoving(player)
    initializedPlayers[player] = nil
    PlayerStatsService.RemovePlayerStats(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

for _, player in Players:GetPlayers() do
    onPlayerAdded(player)
end
