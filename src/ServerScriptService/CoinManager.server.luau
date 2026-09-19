local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local CurrencyService = require(ServerScriptService.Services.CurrencyService)

local CoinsFolder = game:GetService("Workspace").CoinsFolder

local collectedCoins = {}

local function coinPickedUp(coin)
    collectedCoins[coin] = true

    coin.CanTouch = false
    coin.Transparency = 1

    task.delay(5, function()        
        coin.CanTouch = true
        coin.Transparency = 0

        collectedCoins[coin] = nil
    end)
end

local function getPlayerAndCharacterFromPart(part)
    local currentAncestor = part.Parent
    
        while currentAncestor do
            if currentAncestor:IsA("Model") then
                local player = Players:GetPlayerFromCharacter(currentAncestor)
    
                if player then 
                    return player, currentAncestor
                end
            end
    
            currentAncestor = currentAncestor.Parent        
        end

        return nil, nil
end

local function onCoinTouched(part, coin)
    if collectedCoins[coin] then
        return
    end

    local player, character = getPlayerAndCharacterFromPart(part)
    if not player then 
        return
    end

    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then 
        return
    end

    coinPickedUp(coin)
    CurrencyService.AddCoins(player)
end

local function setupCoin(coin)
    if coin:IsA("BasePart") then
        coin.Touched:Connect(function(part)
            onCoinTouched(part, coin)
        end)
    end
end

for _, coin in ipairs(CoinsFolder:GetChildren()) do
    setupCoin(coin)
end

CoinsFolder.ChildAdded:Connect(setupCoin)
