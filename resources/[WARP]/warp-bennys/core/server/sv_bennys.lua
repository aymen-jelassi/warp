local chicken = vehicleBaseRepairCost

RegisterServerEvent('warp-bennys:attemptPurchase')
AddEventHandler('warp-bennys:attemptPurchase', function(type, upgradeLevel)
	local src = source
    local user = exports["warp-base"]:getModule("Player"):GetUser(src)
    if type == "repair" then
        if user:getCash() >= chicken then
            user:removeMoney(chicken)
            TriggerClientEvent('warp-bennys:purchaseSuccessful', src, chicken)
        else
            TriggerClientEvent('warp-bennys:purchaseFailed', src)
        end
    elseif type == "performance" then
        if user:getCash() >= vehicleCustomisationPrices[type].prices[upgradeLevel] then
            TriggerClientEvent('warp-bennys:purchaseSuccessful', src, vehicleCustomisationPrices[type].prices[upgradeLevel])
            user:removeMoney(vehicleCustomisationPrices[type].prices[upgradeLevel])
        else
            TriggerClientEvent('warp-bennys:purchaseFailed', src)
        end
    else
        if user:getCash() >= vehicleCustomisationPrices[type].price then
            TriggerClientEvent('warp-bennys:purchaseSuccessful', src, vehicleCustomisationPrices[type].price)
            user:removeMoney(vehicleCustomisationPrices[type].price)
        else
            TriggerClientEvent('warp-bennys:purchaseFailed', src)
        end
    end
end)

RegisterServerEvent('warp-bennys:updateRepairCost')
AddEventHandler('warp-bennys:updateRepairCost', function(cost)
    chicken = cost
end)


RegisterServerEvent('dreams:bennys:pay1')
AddEventHandler('dreams:bennys:pay1', function()
    local src = source
    local user = exports["warp-base"]:getModule("Player"):GetUser(src)

    if user:getCash() >= 1350 then
        user:removeMoney(1350)
        TriggerClientEvent('bennys:civ:repair:cl', src)
        TriggerEvent('DoLongHudText', "You Have Been Charged For: $1350!", 2)
    else
        TriggerClientEvent('DoLongHudText', src, 'You need $1350', 2)
    end
end)
