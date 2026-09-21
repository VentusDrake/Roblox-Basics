local PlayerStatsService = {}

local DEFAULT_SPEED = 16
local SPEED_UPGRADE = 2
local playerSpeeds = {}

local function updatePlayerSpeedOnLeaderstats(player, newSpeed)
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then
        warn("No leaderstats found for player: " .. player.Name)
        return
    end

    local speedStat = leaderstats:FindFirstChild("Speed")
    if not speedStat then
        warn("No Speed stat found in leaderstats for player: " .. player.Name)
        return
    end

    speedStat.Value = newSpeed
end

function PlayerStatsService.InitializePlayerStats(player)
    playerSpeeds[player] = {
        Speed = DEFAULT_SPEED
    }
end

function PlayerStatsService.GetPlayerSpeed(player)
    local playerSpeed = playerSpeeds[player]
    if not playerSpeed then 
        return nil
    end

    return playerSpeed.Speed
end

function PlayerStatsService.ApplyStatsToCharacter(player, character)
    local playerSpeed = playerSpeeds[player]
    if not playerSpeed then 
        warn("No speed data found for player: " .. player.Name)
        return
    end

    local humanoid = character:WaitForChild("Humanoid")

    humanoid.WalkSpeed = playerSpeed.Speed
end

function PlayerStatsService.UpgradePlayerSpeed(player)
    local playerSpeed = playerSpeeds[player]
    if not playerSpeed then 
        return false
    end

    
    local character = player.Character
    if not character then 
        warn("No character found for player: " .. player.Name)
        return false
    end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        warn("No Humanoid found for player: " .. player.Name)
        return false
    end
     
    playerSpeed.Speed = playerSpeed.Speed + SPEED_UPGRADE
    humanoid.WalkSpeed = playerSpeed.Speed
    updatePlayerSpeedOnLeaderstats(player, playerSpeed.Speed)

    return true
end

function PlayerStatsService.RemovePlayerStats(player)
    playerSpeeds[player] = nil
end

return PlayerStatsService