RegisterNetEvent("rollcash:menu")
AddEventHandler("rollcash:menu", function()
	TriggerEvent('warp-context:sendMenu', {
		{
			id = "1",
			header = "Clean Small Bags",
			txt = "Clean your Small Bags",
			params = {
				event = "warp-jobs:fishing_sell:rollcash",
			}
		},
		{
			id = "2",
			header = "Close Menu",
			txt = "Close menu",
			params = {
				event = "",
			}
		},
	})
end)

-- clean band of notes

RegisterNetEvent("bandnotes:menu")
AddEventHandler("bandnotes:menu", function()
	TriggerEvent('warp-context:sendMenu', {
		{
			id = "1",
			header = "Clean Big Bag",
			txt = "Clean Big Bag",
			params = {
				event = "warp-jobs:fishing_sell:band",
			}
		},
		{
			id = "2",
			header = "Close Menu",
			txt = "Close menu",
			params = {
				event = "",
			}
		},
	})
end)

-- Sales

-- Bands

RegisterNetEvent('warp-jobs:fishing_sell:band')
AddEventHandler('warp-jobs:fishing_sell:band', function()
    local pBandAmount = exports["warp-applications"]:KeyboardInput({
        header = "How Much Bands?",
        rows = {
        {
            id = 0,
            txt = "Input How Much Bands You Want To Sell"
        }
        }
    })
    if pBandAmount[1] ~= nil then
        if exports['warp-inventory']:hasEnoughOfItem('inkedmoneybag', pBandAmount[1].input) then
            FreezeEntityPosition(PlayerPedId(), true)
            local finished = exports['warp-taskbar']:taskBar(2500*pBandAmount[1].input, 'Washing Large Money Bag')
            if finished == 100 then
                if exports['warp-inventory']:hasEnoughOfItem('inkedmoneybag', pBandAmount[1].input) then
                    TriggerEvent('inventory:removeItem', 'inkedmoneybag', pBandAmount[1].input)
					TriggerServerEvent( 'zyloz:payout', math.random(32500,35000)*pBandAmount[1].input)
                    FreezeEntityPosition(PlayerPedId(), false)
                else
                    FreezeEntityPosition(PlayerPedId(), false)
                    TriggerEvent('DoLongHudText', 'Might wanna try again', 2)
                end
            end
        end
    end
end)

-- Rollcash

RegisterNetEvent('warp-jobs:fishing_sell:rollcash')
AddEventHandler('warp-jobs:fishing_sell:rollcash', function()
    local pRollCashAmount = exports["warp-applications"]:KeyboardInput({
        header = "How Much Cash Rolls?",
        rows = {
        {
            id = 0,
            txt = "Input How Much Cash Rolls You Want To Sell"
        }
        }
    })
    if pRollCashAmount[1] ~= nil then
        if exports['warp-inventory']:hasEnoughOfItem('inkset', pRollCashAmount[1].input) then
            FreezeEntityPosition(PlayerPedId(), true)
            local finished = exports['warp-taskbar']:taskBar(1500*pRollCashAmount[1].input, 'Washing Small Money Bag')
            if finished == 100 then
                if exports['warp-inventory']:hasEnoughOfItem('inkset', pRollCashAmount[1].input) then
                    TriggerEvent('inventory:removeItem', 'inkset', pRollCashAmount[1].input)
					TriggerServerEvent( 'zyloz:payout', math.random(300,500)*pRollCashAmount[1].input)
                    FreezeEntityPosition(PlayerPedId(), false)
                else
                    FreezeEntityPosition(PlayerPedId(), false)
                    TriggerEvent('DoLongHudText', 'Might wanna try again', 2)
                end
            end
        end
    end
end)