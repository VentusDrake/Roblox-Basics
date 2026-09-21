local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerStatsService = require(ServerScriptService.Services.PlayerStatsService)

local SpeedUpgradeButtonCdRemoteEvent = ReplicatedStorage.Remotes.SpeedUpgradeButtonCd

local speedUpgradeButtonModel = Workspace.SpeedUpgradeButton
local speedUpgradeButtonCd = 5 -- seconds

local speedUpgradeButtonCooldown = {}

local function onSpeedUpgradeButtonTouched(part)
    local character = part.Parent
    if not character or not character:IsA("Model") then
        return
    end

    local player = Players:GetPlayerFromCharacter(character)
    if not player then 
        return
    end

    if speedUpgradeButtonCooldown[player] then
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        return
    end
    
    speedUpgradeButtonCooldown[player] = true
    
    local success = PlayerStatsService.UpgradePlayerSpeed(player)
    if not success then
        speedUpgradeButtonCooldown[player] = nil
        return
    end

    SpeedUpgradeButtonCdRemoteEvent:FireClient(player, speedUpgradeButtonCd)

    task.delay(speedUpgradeButtonCd, function()
        speedUpgradeButtonCooldown[player] = nil
    end)

end

speedUpgradeButtonModel.ButtonPart.Touched:Connect(onSpeedUpgradeButtonTouched)
