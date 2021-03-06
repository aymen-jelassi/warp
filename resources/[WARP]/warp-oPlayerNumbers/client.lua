local hidden = {}
local showPlayerBlips = false
local ignorePlayerNameDistance = false
local disPlayerNames = 50
local playerSource = 0


function DrawText3D(x,y,z, text, textColor) -- some useful function, use it if you want!
    local color = { r = 255, g = 255, b = 255, alpha = 255 } -- Color of the text 
    if textColor ~= nil then 
        color = {r = textColor[1] or 255, g = textColor[2] or 255, b = textColor[3] or 255, alpha = textColor[4] or 255}
    end
    
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px,py,pz) - vector3(x,y,z))

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    
    if onScreen then
        SetTextScale(0.3,0.3)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(color.r, color.g, color.b, color.alpha)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function DrawText3DTalking(x,y,z, text, textColor) -- some useful function, use it if you want!
    local color = { r = 220, g = 220, b = 220, alpha = 255 } -- Color of the text 
    if textColor ~= nil then 
        color = {r = textColor[1] or 22, g = textColor[2] or 55, b = textColor[3] or 155, alpha = textColor[4] or 255}
    end

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px,py,pz) - vector3(x,y,z))

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    
    if onScreen then
        SetTextScale(0.0*scale, 0.75*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(color.r, color.g, color.b, color.alpha)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

RegisterNetEvent("hud:HidePlayer")
AddEventHandler("hud:HidePlayer", function(player, toggle)
    if type(player) == "table" then
        for k,v in pairs(player) do
            local id = GetPlayerFromServerId(k)
            hidden[id] = k
        end
        return
    end
    local id = GetPlayerFromServerId(player)
    if toggle == true then hidden[id] = player
    else
        for k,v in pairs(hidden) do
            if v == player then hidden[k] = nil end
        end
    end
end)

Controlkey = {["generalScoreboard"] = {303,"U"}} 
RegisterNetEvent('event:control:update')
AddEventHandler('event:control:update', function(table)
    Controlkey["generalScoreboard"] = table["generalScoreboard"]
end)

Citizen.CreateThread(function()
    while true do
        if IsControlPressed(0, Controlkey["generalScoreboard"][1]) then

            for i=0,255 do
                N_0x31698aa80e0223f8(i)
            end
            for id = 0, 255 do
                if NetworkIsPlayerActive( id ) then
                    local playerped = PlayerPedId()
                    local HeadBone = 0x796e
                    local ped = GetPlayerPed(id)
                    local playerCoords = GetPedBoneCoords(playerped, HeadBone)
                    if ped == playerped then
                        DrawText3DTalking(playerCoords.x, playerCoords.y, playerCoords.z+0.5, " ".. GetPlayerServerId(id) .. " ", {152, 251, 152, 255})
                    else
                        local pedCoords = GetPedBoneCoords(ped, HeadBone)
                        local distance = math.floor(#(playerCoords - pedCoords))

                        local isDucking = IsPedDucking(GetPlayerPed( id ))
                        local cansee = HasEntityClearLosToEntity( GetPlayerPed( -1 ), GetPlayerPed( id ), 17 )
                        local isReadyToShoot = IsPedWeaponReadyToShoot(GetPlayerPed( id ))
                        local isStealth = GetPedStealthMovement(GetPlayerPed( id ))
                        local isDriveBy = IsPedDoingDriveby(GetPlayerPed( id ))
                        local isInCover = IsPedInCover(GetPlayerPed( id ),true)
                        if isStealth == nil then
                            isStealth = 0
                        end

                        if isDucking or isStealth == 1 or isDriveBy or isInCover then
                            cansee = false
                        end

                        if hidden[id] then cansee = false end
                        
                        if (distance < disPlayerNames) then
                            if(NetworkIsPlayerTalking(id)) then
                                if cansee then
                                    DrawText3DTalking(pedCoords.x, pedCoords.y, pedCoords.z+0.5, " ".. GetPlayerServerId(id) .. " ", {140, 204, 239, 255})
                                end
                            else
                                if cansee then
                                    DrawText3DTalking(pedCoords.x, pedCoords.y, pedCoords.z+0.5, " ".. GetPlayerServerId(id) .. " ", {255, 255, 255, 255})
                                end
                            end
                        end
                            
                    end
                end
            end
            Citizen.Wait(0)
        else
            Citizen.Wait(2000)
        end
    end
end)