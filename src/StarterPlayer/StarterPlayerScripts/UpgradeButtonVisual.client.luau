local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SpeedUpgradeButtonCdRemoteEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SpeedUpgradeButtonCd")

local speedUpgradeButtonModel = Workspace:WaitForChild("SpeedUpgradeButton")
local speedUpgradeButtonColor = speedUpgradeButtonModel:WaitForChild("ButtonPart").Color

local function speedUpgradeButtonVisual(cooldownTime)
    speedUpgradeButtonModel.ButtonPart.Color = Color3.fromRGB(255, 0, 0)    
    
    task.delay(cooldownTime, function()        
        speedUpgradeButtonModel.ButtonPart.Color = speedUpgradeButtonColor
    end)
end

SpeedUpgradeButtonCdRemoteEvent.OnClientEvent:Connect(speedUpgradeButtonVisual)
    