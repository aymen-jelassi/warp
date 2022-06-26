
RegisterNetEvent('warp-jobs:bahama_mamas_stash')
AddEventHandler('warp-jobs:bahama_mamas_stash', function()
    local BahamaMammaRank = exports['isPed']:GroupRank('bahama_mammas')
    if BahamaMammaRank >= 1 then
        TriggerEvent('server-inventory-open', '1', 'bahamamammas-stash')
    else
        TriggerEvent('DoLongHudText', 'You do not have access to this.', 2)
    end
end)