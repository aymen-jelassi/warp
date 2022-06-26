
local currentTwats = {}

RegisterNetEvent('Client:UpdateTweets')
AddEventHandler('Client:UpdateTweets', function(data)
    local handle = exports["isPed"]:isPed("twitterhandle")
    SendNUIMessage({openSection = "twatter", twats = data, myhandle = handle})
    -- SendNUIMessage({openSection = "tweetnotify", twats2 = data, myhandle2 = handle})
end)

local currentTwats = {}

RegisterNetEvent('Client:UpdateTweet')
AddEventHandler('Client:UpdateTweet', function(tweet)

    local handle = exports["isPed"]:isPed("twitterhandle")
    currentTwats[#currentTwats+1] = tweet 
    
    if not hasPhone() then
      return
    end


    if currentTwats[#currentTwats]["handle"] == handle then
      SendNUIMessage({openSection = "twatter", twats = currentTwats, myhandle = handle})
    end

    if string.find(currentTwats[#currentTwats]["message"],handle) then
      if currentTwats[#currentTwats]["handle"] ~= handle then
        SendNUIMessage({openSection = "newtweet"})
      end


      if phoneNotifications then
        PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
        TriggerEvent("DoLongHudText","You were just mentioned in a tweet on your phone.",15)
      end
    end

    if allowpopups and not guiEnabled then
      
      SendNUIMessage({
    
        openSection = "phonemedio", timeout = "3000" }) 
    end

end)

RegisterNUICallback('btnTwatter', function()
    local handle = exports["isPed"]:isPed("twitterhandle")
    SendNUIMessage({openSection = "twatter", twats = currentTwats, myhandle = handle})
end)
  
RegisterNUICallback('newTwatSubmit', function(data, cb)
    local handle = exports["isPed"]:isPed("twitterhandle")
    TriggerServerEvent('Tweet', handle, data.twat, data.time)
    TriggerServerEvent('warp-phone:twatSendNotification', handle, data.twat, data.time)   
end)


RegisterNetEvent('warp-phone:TwatNotify')
AddEventHandler('warp-phone:TwatNotify', function(tHandle, pTwat, pTime)
    SendNUIMessage({openSection = "tweetnotify", ptwat = pTwat, phandle = tHandle, ptime =pTime})
    if exports['warp-phone']:pOpen() == false then 
        SendNUIMessage({openSection = "phonemedio", timeout = "5200"}) 
    end
end)