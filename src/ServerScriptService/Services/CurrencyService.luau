local CurrencyService = {}

function CurrencyService.AddCoins(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then 
        local coins = leaderstats:FindFirstChild("Coins")
        if coins then
            coins.Value = coins.Value + 1
        end
    end
end

return CurrencyService