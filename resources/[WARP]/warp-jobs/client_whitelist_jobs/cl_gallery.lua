RegisterNetEvent("gallery-menu")
AddEventHandler("gallery-menu", function()
    local rank = exports["isPed"]:GroupRank("art_gallery")
    if rank >= 1 then
        TriggerEvent('warp-context:sendMenu', {
            {
                id = "1",
                header = "Mined Items",
                txt = ""
            },
            {
                id = "2",
                header = "Sell Diamond Gem",
                txt = "D",
                params = {
                    event = "warp-jobs:gellery_sell_diamonds",
                }
            },
            {
                id = "3",
                header = "Sell Aquamarine Gem",
                txt = "A",
                params = {
                    event = "warp-jobs:gellery_sell_aquamarine",
                }
            },
            {
                id = "4",
                header = "Sell Jade Gem",
                txt = "J",
                params = {
                    event = "warp-jobs:gellery_sell_jade",
                }
            },
            {
                id = "5",
                header = "Sell Citrine Gem",
                txt = "C",
                params = {
                    event = "warp-jobs:gellery_sell_citrine",
                }
            },
            {
                id = "6",
                header = "Sell Garnet Gem",
                txt = "G",
                params = {
                    event = "warp-jobs:gellery_sell_garnet",
                }
            },
            {
                id = "7",
                header = "Sell Opal Gem",
                txt = "O",
                params = {
                    event = "warp-jobs:gellery_sell_opal",
                }
            },
            {
                id = "8",
                header = "Other Items",
                txt = ""
            },
            {
                id = "9",
                header = "Sell Art Piece",
                txt = "Art Piece",
                params = {
                    event = "warp-jobs:gellery_sell_stolen_art",
                }
            },
            {
                id = "10",
                header = "Sell Golden Coin",
                txt = "Gold Coin",
                params = {
                    event = "warp-jobs:gallery_sell_gold_coins",
                }
            },
            {
                id = "11",
                header = "Sell Valuable Goods",
                txt = "Valuable Goods",
                params = {
                    event = "warp-jobs:gallery_sell_val_goods",
                }
            },
            {
                id = "12",
                header = "Sell Gold Bars",
                txt = "Gold Bars",
                params = {
                    event = "warp-jobs:gallery_sell_gold_bars",
                }
            },
            {
                id = "13",
                header = "Sell Rolex Watches",
                txt = "Rolex Watche\'s",
                params = {
                    event = "warp-jobs:gallery_sell_rolex_watch",
                }
            },
            {
                id = "14",
                header = "Sell 8ct Chains",
                txt = "8ct Chains",
                params = {
                    event = "warp-jobs:gallery_sell_8ct_chains",
                }
            },
            {
                id = "15",
                header = "Close Menu",
                txt = "Close menu",
                params = {
                    event = "",
                }
            },
        })
    end
end)

-- Stash

RegisterNetEvent('warp-gallery:open_stash')
AddEventHandler('warp-gallery:open_stash', function()
    local rank = exports['isPed']:GroupRank('art_gallery')
    if rank >= 1 then
        TriggerEvent('server-inventory-open', '1', 'art-gallery-stash')
    else
        TriggerEvent('DoLongHudText', 'You cant access this', 2)
    end
end)

RegisterNetEvent('warp-lost:open_stash')
AddEventHandler('warp-lost:open_stash', function()
    local rank = exports['isPed']:GroupRank('lostmc')
    if rank >= 1 then
        TriggerEvent('server-inventory-open', '1', 'lost-mc-stash')
    else
        TriggerEvent('DoLongHudText', 'You cant access this', 2)
    end
end)

-- Sales

-- Mining Gem

RegisterNetEvent('warp-jobs:gellery_sell_diamonds')
AddEventHandler('warp-jobs:gellery_sell_diamonds', function()
    local pGemAmount = exports["warp-applications"]:KeyboardInput({
        header = "How Much Diamond Gems?",
        rows = {
        {
            id = 0,
            txt = "Input How Many Diamond Gems You Want To Sell"
        }
        }
    })
    if pGemAmount[1] ~= nil then
        if exports['warp-inventory']:hasEnoughOfItem('mineddiamond', pGemAmount[1].input) then
            FreezeEntityPosition(PlayerPedId(), true)
            local finished = exports['warp-taskbar']:taskBar(2000*pGemAmount[1].input, 'Selling Diamond Gems')
            if finished == 100 then
                if exports['warp-inventory']:hasEnoughOfItem('mineddiamond', pGemAmount[1].input) then
                    TriggerEvent('inventory:removeItem', 'mineddiamond', pGemAmount[1].input)
                    TriggerServerEvent('zyloz:payout', 3000*pGemAmount[1].input)
                    FreezeEntityPosition(PlayerPedId(), false)
                else
                    FreezeEntityPosition(PlayerPedId(), false)
                    TriggerEvent('DoLongHudText', 'Might wanna try again', 2)
                end
            end
        end
    end
end)

-- Mining Stone

RegisterNetEvent('warp-jobs:gellery_sell_aquamarine')
AddEventHandler('warp-jobs:gellery_sell_aquamarine', function()
    local pStoneAmount = exports["warp-applications"]:KeyboardInput({
        header = "How Many Aquamarine?",
        rows = {
        {
            id = 0,
            txt = "Input How Much Stones You Want To Sell"
        }
        }
    })
    if pStoneAmount[1] ~= nil then
        if exports['warp-inventory']:hasEnoughOfItem('minedaquamarine', pStoneAmount[1].input) then
            FreezeEntityPosition(PlayerPedId(), true)
            local finished = exports['warp-taskbar']:taskBar(2000*pStoneAmount[1].input, 'Selling Aquamarine')
            if finished == 100 then
                if exports['warp-inventory']:hasEnoughOfItem('minedaquamarine', pStoneAmount[1].input) then
                    TriggerEvent('inventory:removeItem', 'minedaquamarine', pStoneAmount[1].input)
                    TriggerServerEvent('zyloz:payout', 6000*pStoneAmount[1].input)
                    FreezeEntityPosition(PlayerPedId(), false)
                else
                    FreezeEntityPosition(PlayerPedId(), false)
                    TriggerEvent('DoLongHudText', 'Might wanna try again', 2)
                end
            end
        end
    end
end)

-- Mining Coal

RegisterNetEvent('warp-jobs:gellery_sell_jade')
AddEventHandler('warp-jobs:gellery_sell_jade', function()
    local pCoalAmount = exports["warp-applications"]:KeyboardInput({
        header = "How Many Jade\'s?",
        rows = {
        {
            id = 0,
            txt = "Input How Many Jade\'s You Want To Sell"
        }
        }
    })
    if pCoalAmount[1] ~= nil then
        if exports['warp-inventory']:hasEnoughOfItem('minedjade', pCoalAmount[1].input) then
            FreezeEntityPosition(PlayerPedId(), true)
            local finished = exports['warp-taskbar']:taskBar(2000*pCoalAmount[1].input, 'Selling Mined Jade')
            if finished == 100 then
                if exports['warp-inventory']:hasEnoughOfItem('minedjade', pCoalAmount[1].input) then
                    TriggerEvent('inventory:removeItem', 'minedjade', pCoalAmount[1].input)
                    TriggerServerEvent('zyloz:payout', 5000*pCoalAmount[1].input)
                    FreezeEntityPosition(PlayerPedId(), false)
                else
                    FreezeEntityPosition(PlayerPedId(), false)
                    TriggerEvent('DoLongHudText', 'Might wanna try again', 2)
                end
            end
        end
    end
end)

-- Mining Diamond

RegisterNetEvent('warp-jobs:gellery_sell_citrine')
AddEventHandler('warp-jobs:gellery_sell_citrine', function()
    local pDiamondAmount = exports["warp-applications"]:KeyboardInput({
        header = "How Many Citrine?",
        rows = {
        {
            id = 0,
            txt = "Input How Many Citrine\'s You Want To Sell"
        }
        }
    })
    if pDiamondAmount[1] ~= nil then
        if exports['warp-inventory']:hasEnoughOfItem('minedcitrine', pDiamondAmount[1].input) then
            FreezeEntityPosition(PlayerPedId(), true)
            local finished = exports['warp-taskbar']:taskBar(2000*pDiamondAmount[1].input, 'Selling Citrine')
            if finished == 100 then
                if exports['warp-inventory']:hasEnoughOfItem('minedcitrine', pDiamondAmount[1].input) then
                    TriggerEvent('inventory:removeItem', 'minedcitrine', pDiamondAmount[1].input)
                    TriggerServerEvent('zyloz:payout', 4000*pDiamondAmount[1].input)
                    FreezeEntityPosition(PlayerPedId(), false)
                else
                    FreezeEntityPosition(PlayerPedId(), false)
                    TriggerEvent('DoLongHudText', 'Might wanna try again', 2)
                end
            end
        end
    end
end)

-- Mining Sapphire

RegisterNetEvent('warp-jobs:gellery_sell_garnet')
AddEventHandler('warp-jobs:gellery_sell_garnet', function()
    local pSapphireAmount = exports["warp-applications"]:KeyboardInput({
        header = "How Many Garnet\'s?",
        rows = {
        {
            id = 0,
            txt = "Input How Much Sapphires You Want To Sell"
        }
        }
    })
    if pSapphireAmount[1] ~= nil then
        if exports['warp-inventory']:hasEnoughOfItem('minedgarnet', pSapphireAmount[1].input) then
            FreezeEntityPosition(PlayerPedId(), true)
            local finished = exports['warp-taskbar']:taskBar(2000*pSapphireAmount[1].input, 'Selling Garnet')
            if finished == 100 then
                if exports['warp-inventory']:hasEnoughOfItem('minedgarnet', pSapphireAmount[1].input) then
                    TriggerEvent('inventory:removeItem', 'minedgarnet', pSapphireAmount[1].input)
                    TriggerServerEvent('zyloz:payout', 7000*pSapphireAmount[1].input)
                    FreezeEntityPosition(PlayerPedId(), false)
                else
                    FreezeEntityPosition(PlayerPedId(), false)
                    TriggerEvent('DoLongHudText', 'Might wanna try again', 2)
                end
            end
        end
    end
end)

-- Mining Ruby

RegisterNetEvent('warp-jobs:gellery_sell_opal')
AddEventHandler('warp-jobs:gellery_sell_opal', function()
    local pRubyAmount = exports["warp-applications"]:KeyboardInput({
        header = "How Many Opal?",
        rows = {
        {
            id = 0,
            txt = "Input How Many Opal You Want To Sell"
        }
        }
    })
    if pRubyAmount[1] ~= nil then
        if exports['warp-inventory']:hasEnoughOfItem('minedopal', pRubyAmount[1].input) then
            FreezeEntityPosition(PlayerPedId(), true)
            local finished = exports['warp-taskbar']:taskBar(2000*pRubyAmount[1].input, 'Selling Opal')
            if finished == 100 then
                if exports['warp-inventory']:hasEnoughOfItem('minedopal', pRubyAmount[1].input) then
                    TriggerEvent('inventory:removeItem', 'minedopal', pRubyAmount[1].input)
                    TriggerServerEvent('zyloz:payout', 10000*pRubyAmount[1].input)
                    FreezeEntityPosition(PlayerPedId(), false)
                else
                    FreezeEntityPosition(PlayerPedId(), false)
                    TriggerEvent('DoLongHudText', 'Might wanna try again', 2)
                end
            end
        end
    end
end)

-- Stolen Art

RegisterNetEvent('warp-jobs:gellery_sell_stolen_art')
AddEventHandler('warp-jobs:gellery_sell_stolen_art', function()
    local pArtAmt = exports["warp-applications"]:KeyboardInput({
        header = "How Many Art Pieces?",
        rows = {
        {
            id = 0,
            txt = "Input How Many Art Piece\'s You Want To Sell"
        }
        }
    })
    if pArtAmt[1] ~= nil then
        if exports['warp-inventory']:hasEnoughOfItem('stolenart', pArtAmt[1].input) then
            FreezeEntityPosition(PlayerPedId(), true)
            local finished = exports['warp-taskbar']:taskBar(2000*pArtAmt[1].input, 'Selling Art Pieces')
            if finished == 100 then
                if exports['warp-inventory']:hasEnoughOfItem('stolenart', pArtAmt[1].input) then
                    TriggerEvent('inventory:removeItem', 'stolenart', pArtAmt[1].input)
                    TriggerServerEvent('zyloz:payout', 5000*pArtAmt[1].input)
                    FreezeEntityPosition(PlayerPedId(), false)
                else
                    FreezeEntityPosition(PlayerPedId(), false)
                    TriggerEvent('DoLongHudText', 'Might wanna try again', 2)
                end
            end
        end
    end
end)

-- Golden Coins

RegisterNetEvent('warp-jobs:gallery_sell_gold_coins')
AddEventHandler('warp-jobs:gallery_sell_gold_coins', function()
    local pGCAmt = exports["warp-applications"]:KeyboardInput({
        header = "How Many Golden Coin\'s?",
        rows = {
        {
            id = 0,
            txt = "Input How Many Golden Coin\'s You Want To Sell"
        }
        }
    })
    if pGCAmt[1] ~= nil then
        if exports['warp-inventory']:hasEnoughOfItem('goldcoin', pGCAmt[1].input) then
            FreezeEntityPosition(PlayerPedId(), true)
            local finished = exports['warp-taskbar']:taskBar(2000*pGCAmt[1].input, 'Selling Golden Coins')
            if finished == 100 then
                if exports['warp-inventory']:hasEnoughOfItem('goldcoin', pGCAmt[1].input) then
                    TriggerEvent('inventory:removeItem', 'goldcoin', pGCAmt[1].input)
                    TriggerServerEvent('zyloz:payout', 500*pGCAmt[1].input)
                    FreezeEntityPosition(PlayerPedId(), false)
                else
                    FreezeEntityPosition(PlayerPedId(), false)
                    TriggerEvent('DoLongHudText', 'Might wanna try again', 2)
                end
            end
        end
    end
end)

-- Valuable Goods

RegisterNetEvent('warp-jobs:gallery_sell_val_goods')
AddEventHandler('warp-jobs:gallery_sell_val_goods', function()
    local pVGAmt = exports["warp-applications"]:KeyboardInput({
        header = "How Many Valuable Good\'s?",
        rows = {
        {
            id = 0,
            txt = "Input How Many Valuable Good\'s You Want To Sell"
        }
        }
    })
    if pVGAmt[1] ~= nil then
        if exports['warp-inventory']:hasEnoughOfItem('valuablegoods', pVGAmt[1].input) then
            FreezeEntityPosition(PlayerPedId(), true)
            local finished = exports['warp-taskbar']:taskBar(2000*pVGAmt[1].input, 'Selling Valuable Goods')
            if finished == 100 then
                if exports['warp-inventory']:hasEnoughOfItem('valuablegoods', pVGAmt[1].input) then
                    TriggerEvent('inventory:removeItem', 'valuablegoods', pVGAmt[1].input)
                    TriggerServerEvent('zyloz:payout', 750*pVGAmt[1].input)
                    FreezeEntityPosition(PlayerPedId(), false)
                else
                    FreezeEntityPosition(PlayerPedId(), false)
                    TriggerEvent('DoLongHudText', 'Might wanna try again', 2)
                end
            end
        end
    end
end)

-- Golden Bars

RegisterNetEvent('warp-jobs:gallery_sell_gold_bars')
AddEventHandler('warp-jobs:gallery_sell_gold_bars', function()
    local pGBAmt = exports["warp-applications"]:KeyboardInput({
        header = "How Many Gold Bar\'s?",
        rows = {
        {
            id = 0,
            txt = "Input How Many Gold Bar\'s You Want To Sell"
        }
        }
    })
    if pGBAmt[1] ~= nil then
        if exports['warp-inventory']:hasEnoughOfItem('goldbar', pGBAmt[1].input) then
            FreezeEntityPosition(PlayerPedId(), true)
            local finished = exports['warp-taskbar']:taskBar(2000*pGBAmt[1].input, 'Selling Valuable Goods')
            if finished == 100 then
                if exports['warp-inventory']:hasEnoughOfItem('goldbar', pGBAmt[1].input) then
                    TriggerEvent('inventory:removeItem', 'goldbar', pGBAmt[1].input)
                    TriggerServerEvent('zyloz:payout', 1000*pGBAmt[1].input)
                    FreezeEntityPosition(PlayerPedId(), false)
                else
                    FreezeEntityPosition(PlayerPedId(), false)
                    TriggerEvent('DoLongHudText', 'Might wanna try again', 2)
                end
            end
        end
    end
end)

-- Rolex Watch

RegisterNetEvent('warp-jobs:gallery_sell_rolex_watch')
AddEventHandler('warp-jobs:gallery_sell_rolex_watch', function()
    local pRWAmt = exports["warp-applications"]:KeyboardInput({
        header = "How Many Rolex Watche\'s?",
        rows = {
        {
            id = 0,
            txt = "Input How Many Rolex Watche\'s You Want To Sell"
        }
        }
    })
    if pRWAmt[1] ~= nil then
        if exports['warp-inventory']:hasEnoughOfItem('rolexwatch', pRWAmt[1].input) then
            FreezeEntityPosition(PlayerPedId(), true)
            local finished = exports['warp-taskbar']:taskBar(2000*pRWAmt[1].input, 'Selling Rolex Watche\'s')
            if finished == 100 then
                if exports['warp-inventory']:hasEnoughOfItem('rolexwatch', pRWAmt[1].input) then
                    TriggerEvent('inventory:removeItem', 'rolexwatch', pRWAmt[1].input)
                    TriggerServerEvent('zyloz:payout', 500*pRWAmt[1].input)
                    FreezeEntityPosition(PlayerPedId(), false)
                else
                    FreezeEntityPosition(PlayerPedId(), false)
                    TriggerEvent('DoLongHudText', 'Might wanna try again', 2)
                end
            end
        end
    end
end)

-- 8CT Chains

RegisterNetEvent('warp-jobs:gallery_sell_8ct_chains')
AddEventHandler('warp-jobs:gallery_sell_8ct_chains', function()
    local p8ctAmt = exports["warp-applications"]:KeyboardInput({
        header = "How Many 8ct Chain\'s?",
        rows = {
        {
            id = 0,
            txt = "Input How Many 8ct Chain\'s You Want To Sell"
        }
        }
    })
    if p8ctAmt[1] ~= nil then
        if exports['warp-inventory']:hasEnoughOfItem('stolen8ctchain', p8ctAmt[1].input) then
            FreezeEntityPosition(PlayerPedId(), true)
            local finished = exports['warp-taskbar']:taskBar(2000*p8ctAmt[1].input, 'Selling 8ct Chain\'s')
            if finished == 100 then
                if exports['warp-inventory']:hasEnoughOfItem('stolen8ctchain', p8ctAmt[1].input) then
                    TriggerEvent('inventory:removeItem', 'stolen8ctchain', p8ctAmt[1].input)
                    TriggerServerEvent('zyloz:payout', 75*p8ctAmt[1].input)
                    FreezeEntityPosition(PlayerPedId(), false)
                else
                    FreezeEntityPosition(PlayerPedId(), false)
                    TriggerEvent('DoLongHudText', 'Might wanna try again', 2)
                end
            end
        end
    end
end)