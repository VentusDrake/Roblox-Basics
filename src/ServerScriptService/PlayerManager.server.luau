local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local PlayerStatsService = require(ServerScriptService.Services.PlayerStatsService)

local initializedPlayers = {}

local function onPlayerAdded(player)
    if initializedPlayers[player] then
        return
    end

    initializedPlayers[player] = true

    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local coins = Instance.new("IntValue")
    coins.Name = "Coins"
    coins.Value = 0
    coins.Parent = leaderstats

    PlayerStatsService.InitializePlayerStats(player)

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
