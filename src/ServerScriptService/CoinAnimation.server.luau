local RunService = game:GetService("RunService")

local coinsFolder = game:GetService("Workspace"):WaitForChild("CoinsFolder")

local coins = {}
local animationSpeed = 2
local amplitude = 1

local function setupCoinData(coin)
    if not coin:IsA("BasePart") then
        return
    end    

    coins[coin] = {
        startCFrame = coin.CFrame,
        startTime = time(),
        startAngle = math.random() * math.pi * 2
    }
end

local function animateCoins()
    local currentTime = time()

    for coin, data in pairs(coins) do 
        if not coin.Parent then 
            coins[coin] = nil
            continue
        end

        local elapsed = currentTime - data.startTime
        local height = math.sin(elapsed * animationSpeed) * amplitude
        local rotation = data.startAngle + elapsed * math.rad(90)

        coin.CFrame =
            data.startCFrame
            * CFrame.new(0, height, 0)
            * CFrame.Angles(0, rotation, 0)
    end
end

for _, coin in ipairs(coinsFolder:GetChildren()) do
    setupCoinData(coin)
end

RunService.Heartbeat:Connect(animateCoins)
