local isInstructorMode = false
local isHandcuffed = false
local isHandcuffedAndWalking = false
local hasOxygenTankOn = false
local gangNum = 0
local cuffStates = {}
local isAtGarage = false


-- Location's
local bennyLocation = vector3(-39.09, -1054.17, 27.79)
local bennyLocationHarmony = vector3(1174.78, 2639.96, 37.73)
local bennyLocationMRPD = vector3(450.01, -976.04, 25.03)
local bennyLocationTunershop = vector3(135.87, -3030.35, 7.04)
local bennyLocationHayes = vector3(-1424.20, -449.48, 35.29)
local bennyLocationHayes2 = vector3(-1417.7406005859, -445.55603027344, 35.295288085938)
local bennyLocationAutoExotic = vector3(547.25, -189.45, 53.88)
local bennysSandyShoresPD = vector3(1878.4317, 3696.0478, 32.934951)
local bennysRacingWarehouse = vector3(1032.5406494141,-2528.4790039062,27.679077148438)
local bennysHarmony2 = vector3(1182.4747314453, 2639.8022460938, 37.148681640625)

local RepairDriftSchool = vector3(-167.4725189209,-2460.7648925781,5.9091796875)

rootMenuConfig =  {
    {
        id = "police-actions",
        displayName = "Police Actions",
        icon = "#police-action",
        enableMenu = function()
            return (exports["isPed"]:isPed("myJob") == 'police' or exports["isPed"]:isPed("myJob") == 'sheriff' or exports["isPed"]:isPed("myJob") == 'state') and not exports['warp-death']:GetDeathStatus()
        end,
        subMenus = {'police:checkInventory', 'police:remmask', 'police:checkBank', 'police:checkLicenses', 'police:gsr', 'police:dnaSwab', 'police:riflerack'}
    },
    {
        id = "panic",
        displayName = "Panic",
        icon = "#police-action-panic",
        functionName = "police:policePanic",
        enableMenu = function()
            return (exports["isPed"]:isPed("myJob") == 'police' or exports["isPed"]:isPed("myJob") == 'sheriff' or exports["isPed"]:isPed("myJob") == 'state' and exports['warp-death']:GetDeathStatus())
        end,
        subMenus = {'police:tenThirteenA', 'police:tenThirteenB'}
    },
    {
        id = "emspanic",
        displayName = "Panic",
        icon = "#police-action-panic",
        functionName = "ems:panicbutton",
        enableMenu = function()
            return (exports["isPed"]:isPed("myJob") == 'ems' and exports['warp-death']:GetDeathStatus())
        end,
        subMenus = {'police:tenForteenA', 'police:tenForteenB'}
    },
    {
        id = "bennys:enter",
        displayName = "Enter Bennys",
        icon = "#ems-dead",
        functionName = "bennys:enter",
        enableMenu = function()
            return (polyChecks.bennys.isInside and IsPedInAnyVehicle(PlayerPedId(), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId() and not exports['warp-death']:GetDeathStatus())
        end
    },
    {
        id = "openGarageMenu",
        displayName = "Vehicle List",
        icon = "#Garage",
        functionName = "warp-garages:open",
        enableMenu = function()
            return (isAtGarage == true and not exports['warp-death']:GetDeathStatus())
        end
    },
    -- {
    --     id = "leave_var",
    --     displayName = "Leave VAR Environment",
    --     icon = "#VAR",
    --     functionName = "exit:varcompleteheist",
    --     enableMenu = function()
    --         return (exports['warp-heists']:GetVarStatus() and exports['warp-death']:GetDeathStatus())
    --     end,
    -- },
    --  {
    --     id = "k9_dog",
    --     displayName = "K9",
    --     icon = "#k9",
    --     functionName = "warp-police:k9_actions",
    --     enableMenu = function()
    --         return (exports['warp-police']:GetK9Status() and exports["isPed"]:isPed("myJob") == 'police' or exports["isPed"]:isPed("myJob") == 'sheriff' or exports["isPed"]:isPed("myJob") == 'state' and exports['warp-death']:GetDeathStatus())
    --     end,
    -- },
    {
        id = "animations",
        displayName = "Walk Style",
        icon = "#walking",
        enableMenu = function()
            return not exports['warp-death']:GetDeathStatus()
        end,
        subMenus = { "animations:brave", "animations:dreamsrp",  "animations:business", "animations:tipsy", "animations:injured","animations:tough", "animations:default", "animations:hobo", "animations:money", "animations:swagger", "animations:shady", "animations:maneater", "animations:chichi", "animations:sassy", "animations:sad", "animations:posh", "animations:alien",
        
        --new
        "animations:arrogant","animations:casual","animations:casual2","animations:casual3","animations:casual4","animations:casual5","animations:casual6","animations:confident","animations:business2","animations:business3","animations:femme","animations:flee","animations:gangster","animations:gangster2","animations:gangster3","animations:gangster4","animations:gangster5","animations:heels","animations:heels2","animations:muscle",--[["animations:quick",]]"animations:wide","animations:scared","animations:hurry","animations:quick",}
    },

    {
        id = "animationss",
        displayName = "Animations",
        icon = "#walking",
        enableMenu = function()
            return not exports['warp-death']:GetDeathStatus()
        end,
        functionName = "emotes:OpenMenu"
    },

    {
        id = "expressions",
        displayName = "Expressions",
        icon = "#expressions",
        enableMenu = function()
            return not exports['warp-death']:GetDeathStatus()
        end,
        subMenus = { "expressions:normal", "expressions:drunk", "expressions:angry", "expressions:dumb", "expressions:electrocuted", "expressions:grumpy", "expressions:happy", "expressions:injured", "expressions:joyful", "expressions:mouthbreather", "expressions:oneeye", "expressions:shocked", "expressions:sleeping", "expressions:smug", "expressions:speculative", "expressions:stressed", "expressions:sulking", "expressions:weird", "expressions:weird2"}
    },
    {
        id = "drivinginstructor",
        displayName = "Driving Instructor",
        icon = "#drivinginstructor",
        enableMenu = function()
            return (not exports['warp-death']:GetDeathStatus() and isInstructorMode)
        end,
        subMenus = { "drivinginstructor:drivingtest", "drivinginstructor:submittest", }
    },
    {
        id = "cuff",
        displayName = "Cuff Actions",
        icon = "#cuffs",
        enableMenu = function()
            return (not isHandcuffed and not isHandcuffedAndWalking and (exports["isPed"]:isPed("myJob") == 'police' or exports["isPed"]:isPed("myJob") == 'sheriff' or exports["isPed"]:isPed("myJob") == 'state' or exports["warp-inventory"]:hasEnoughOfItem("cuffs", 1, false)) and not exports['warp-death']:GetDeathStatus())
        end,
        subMenus = { "cuffs:uncuff", "cuffs:remmask", "cuffs:cuff" }
    },
    {
        id = "medic",
        displayName = "Medical",
        icon = "#medic",
        enableMenu = function()
            return (exports["isPed"]:isPed("myJob") == 'ems' and not exports['warp-death']:GetDeathStatus())
        end,
        subMenus = {"medic:revive", "medic:heal", "medic:heal2", "general:putinvehicle", "general:unseatnearest" }
    },
    {
        id = "news",
        displayName = "News",
        icon = "#news",
        enableMenu = function()
            return (exports["isPed"]:isPed("myJob") == 'news' and not exports['warp-death']:GetDeathStatus())
        end,
        subMenus = { "news:setCamera", "news:setMicrophone", "news:setBoom" }
    },
    {
        id = "vehicle",
        displayName = "Vehicle",
        icon = "#vehicle-options-vehicle",
        functionName = "veh:options",
        enableMenu = function()
            return ( IsPedInAnyVehicle(PlayerPedId(), false) and not exports['warp-death']:GetDeathStatus())
        end
    },

    {
        id = "impoundmenu",
        displayName = "Impound Options",
        icon = "#impound-vehicle",
        enableMenu = function()
            if not exports['warp-death']:GetDeathStatus() and exports["warp-vehicles"]:NearVehicle("Distance") and not IsPedInAnyVehicle(PlayerPedId()) then
                return (exports["isPed"]:isPed("myJob") == 'police' or exports["isPed"]:isPed("myJob") == 'sheriff' or exports["isPed"]:isPed("myJob") == 'state' or exports["isPed"]:isPed("myJob") == 'ems')
            end
        end,
        subMenus = { "police:impoundsc", "police:impoundnormal", "police:impoundpolice"}
    },

    {
        id = "enterrey",
        displayName = "Enter Recycle Center",
        icon = "#enter-general",
        functionName = "dreams-recycle:enter",
         enableMenu = function()
             for _,d in ipairs(enterrecy_locations) do
                if #(vector3(d[1],d[2],d[3]) - GetEntityCoords(PlayerPedId())) < 2 and not exports['warp-death']:GetDeathStatus() then
                     return true
                 end
             end
             return false
         end
    },

    {
        id = "leaverey",
        displayName = "Leave Recycle Center",
        icon = "#leave-general",
        functionName = "dreams-recycle:leave",
         enableMenu = function()
             for _,d in ipairs(leaverecy_locations) do
                if #(vector3(d[1],d[2],d[3]) - GetEntityCoords(PlayerPedId())) < 2 and not exports['warp-death']:GetDeathStatus() then
                     return true
                 end
             end
             return false
         end
    },

    {
        id = "flightschool",
        displayName = "Flight School Vehicles",
        icon = "#plane",
        functionName = "warp-menu:ShowVehicles",
         enableMenu = function()
             for _,d in ipairs(flightschool_locations) do
                if #(vector3(d[1],d[2],d[3]) - GetEntityCoords(PlayerPedId())) < 2 and exports["isPed"]:GroupRank("flight_school") > 0 and not exports['warp-death']:GetDeathStatus() then
                     return true
                 end
             end
             return false
         end
    },

    {
        id = "deleteplane",
        displayName = "Delete Vehicle",
        icon = "#impound-vehicle",
        functionName = "impoundsc",
         enableMenu = function()
             for _,d in ipairs(flightschool2_locations) do
                if #(vector3(d[1],d[2],d[3]) - GetEntityCoords(PlayerPedId())) < 5 and exports["isPed"]:GroupRank("flight_school") > 0 and not exports['warp-death']:GetDeathStatus() then
                     return true
                 end
             end
             return false
         end
    },

    {
        id = "enter",
        displayName = "Enter Job Center",
        icon = "#enter-general",
        functionName = "apartments:enterjobcenter",
         enableMenu = function()
             for _,d in ipairs(enter_locations) do
                if #(vector3(d[1],d[2],d[3]) - GetEntityCoords(PlayerPedId())) < 2 and not exports['warp-death']:GetDeathStatus() then
                     return true
                 end
             end
             return false
         end
    },

    {
        id = "towvehicle",
        displayName = "Tow Vehicle",
        icon = "#general-check-vehicle",
        functionName = "dreams-jobs:tow",
         enableMenu = function()
            if exports["isPed"]:isPed("myJob") == "towunion" then
                return exports["warp-vehicles"]:NearVehicle("Distance") and not exports['warp-death']:GetDeathStatus()
            end
            return false
         end
    },
    

    {
        id = "enter4",
        displayName = "Enter Court Room",
        icon = "#enter-general",
        functionName = "apartments:enterjobcenter4",
         enableMenu = function()
             for _,d in ipairs(enter_locations4) do
                if #(vector3(d[1],d[2],d[3]) - GetEntityCoords(PlayerPedId())) < 2 and not exports['warp-death']:GetDeathStatus() then
                     return true
                 end
             end
             return false
         end
    },

    {
        id = "enter5",
        displayName = "Lower Pillbox",
        icon = "#enter-general",
        functionName = "apartments:enterjobcenter5",
         enableMenu = function()
             for _,d in ipairs(enter_locations5) do
                if #(vector3(d[1],d[2],d[3]) - GetEntityCoords(PlayerPedId())) < 2 and not exports['warp-death']:GetDeathStatus() then
                     return true
                 end
             end
             return false
         end
    },

    {
        id = "enter6",
        displayName = "Roof Top",
        icon = "#enter-general",
        functionName = "apartments:enterjobcenter6",
         enableMenu = function()
             for _,d in ipairs(enter_locations6) do
                if #(vector3(d[1],d[2],d[3]) - GetEntityCoords(PlayerPedId())) < 2 and not exports['warp-death']:GetDeathStatus() then
                     return true
                 end
             end
             return false
         end
    },

    {
        id = "steal",
        displayName = "Rob Player",
        icon = "#steal-from-player",
        functionName = "police:stealrob",
         enableMenu = function()
            t, distance, closestPed = GetClosestPlayer()
            if not IsPedInAnyVehicle(PlayerPedId()) and distance ~= -1 and distance < 2 and ( IsEntityPlayingAnim(closestPed, "dead", "dead_d", 3) or IsEntityPlayingAnim(closestPed, "random@crash_rescue@car_death@std_car", "loop", 3) or IsEntityPlayingAnim(closestPed, "amb@code_human_cower@male@base", "base", 3) or IsEntityPlayingAnim(closestPed, "random@arrests@busted", "idle_a", 3) or IsEntityPlayingAnim(closestPed, "mp_arresting", "idle", 3) or IsEntityPlayingAnim(closestPed, "random@mugging3", "handsup_standing_base", 3) or IsEntityPlayingAnim(closestPed, "missfbi5ig_22", "hands_up_anxious_scientist", 3) or IsEntityPlayingAnim(closestPed, "missfbi5ig_22", "hands_up_loop_scientist", 3) or IsEntityPlayingAnim(closestPed, "missminuteman_1ig_2", "handsup_base", 3) ) then
                return true
             end
             return false
         end
    },

    {
        id = "escort",
        displayName = "Escort",
        icon = "#general-escort",
        functionName = "escortPlayer",
        enableMenu = function()
            t, distance, closestPed = GetClosestPlayer()
            if not IsPedInAnyVehicle(PlayerPedId()) and distance ~= -1 and distance < 2 and not exports['warp-death']:GetDeathStatus() then
                return true
             end
             return false
         end
    },

    -- {
    --     id = "zrevive",
    --     displayName = "Revive Player",
    --     icon = "#medic-revive",
    --     functionName = "revive2",
    --     enableMenu = function()
    --         t, distance, closestPed = GetClosestPlayer()
    --         if not IsPedInAnyVehicle(PlayerPedId()) and distance ~= -1 and distance < 2 and not exports['warp-death']:GetDeathStatus() and exports["warp-inventory"]:hasEnoughOfItem("medbeg", 1, false) then
    --             return true
    --          end
    --          return false
    --      end
    -- },

    {
        id = "leave",
        displayName = "Leave Job Center",
        icon = "#leave-general",
        functionName = "apartments:leavejobcenter",
         enableMenu = function()
             for _,d in ipairs(leave_locations) do
                if #(vector3(d[1],d[2],d[3]) - GetEntityCoords(PlayerPedId())) < 2 and not exports['warp-death']:GetDeathStatus() then
                     return true
                 end
             end
             return false
         end
    },

    {
        id = "leave2",
        displayName = "Leave Courthouse",
        icon = "#leave-general",
        functionName = "apartments:leavejobcenter2",
         enableMenu = function()
             for _,d in ipairs(leave_locations2) do
                if #(vector3(d[1],d[2],d[3]) - GetEntityCoords(PlayerPedId())) < 2 and not exports['warp-death']:GetDeathStatus() then
                     return true
                 end
             end
             return false
         end
    },

    {
        id = "leave3",
        displayName = "Leave Lawyer Officer",
        icon = "#leave-general",
        functionName = "apartments:leavejobcenter3",
         enableMenu = function()
             for _,d in ipairs(leave_locations3) do
                if #(vector3(d[1],d[2],d[3]) - GetEntityCoords(PlayerPedId())) < 2 and not exports['warp-death']:GetDeathStatus() then
                     return true
                 end
             end
             return false
         end
    },

    {
        id = "leave4",
        displayName = "Leave Court Room",
        icon = "#leave-general",
        functionName = "apartments:leavejobcenter4",
         enableMenu = function()
             for _,d in ipairs(leave_locations4) do
                if #(vector3(d[1],d[2],d[3]) - GetEntityCoords(PlayerPedId())) < 2 and not exports['warp-death']:GetDeathStatus() then
                     return true
                 end
             end
             return false
         end
    },

    {
        id = "leave5",
        displayName = "Upper Pillbox",
        icon = "#leave-general",
        functionName = "apartments:leavejobcenter5",
         enableMenu = function()
             for _,d in ipairs(leave_locations5) do
                if #(vector3(d[1],d[2],d[3]) - GetEntityCoords(PlayerPedId())) < 2 and not exports['warp-death']:GetDeathStatus() then
                     return true
                 end
             end
             return false
         end
    },

    {
        id = "leave6",
        displayName = "Main Pillbox",
        icon = "#leave-general",
        functionName = "apartments:leavejobcenter6",
         enableMenu = function()
             for _,d in ipairs(leave_locations6) do
                if #(vector3(d[1],d[2],d[3]) - GetEntityCoords(PlayerPedId())) < 2 and not exports['warp-death']:GetDeathStatus() then
                     return true
                 end
             end
             return false
         end
    },
    {
        id = "oxygentank",
        displayName = "Remove Oxygen Tank",
        icon = "#oxygen-mask",
        functionName = "RemoveOxyTank",
        enableMenu = function()
            return not exports['warp-death']:GetDeathStatus() and hasOxygenTankOn
        end
    }, 
    {
        id = "cocaine-status",
        displayName = "Request Status",
        icon = "#cocaine-status",
        functionName = "cocaine:currentStatusServer",
        enableMenu = function()
            if not exports['warp-death']:GetDeathStatus() and gangNum == 2 and #(GetEntityCoords(PlayerPedId()) - vector3(1087.3937988281,-3194.2138671875,-38.993473052979)) < 0.5 then
                return true
            end
            return false
        end
    }, 
    {
        id = "cocaine-crate",
        displayName = "Remove Crate",
        icon = "#cocaine-crate",
        functionName = "cocaine:methCrate",
        enableMenu = function()
            if not exports['warp-death']:GetDeathStatus() and gangNum == 2 and #(GetEntityCoords(PlayerPedId()) - vector3(1087.3937988281,-3194.2138671875,-38.993473052979)) < 0.5 then
                return true
            end
            return false
        end
    }, 
    {
        id = "mdt",
        displayName = "MDT",
        icon = "#mdt",
        functionName = "warp-mdt:RequestOpen",
        enableMenu = function()
            return ((exports["isPed"]:isPed("myJob") == 'police' or exports["isPed"]:isPed("myJob") == 'sheriff' or exports["isPed"]:isPed("myJob") == 'state' or exports["isPed"]:isPed("myJob") == 'judge' or exports["isPed"]:isPed("myJob") == 'district_attorney' or exports["isPed"]:isPed("myJob") == 'public_defender') and not exports['warp-death']:GetDeathStatus())
        end
    },
    {
        id = "mdtems",
        displayName = "MDT",
        icon = "#mdt",
        functionName = "warp-mdt:RequestOpen",
        enableMenu = function()
            return ((exports['isPed']:isPed("myJob") == 'ems') and not exports['warp-death']:GetDeathStatus())
        end
    },
    {
        id = "police-and-ems-radios",
        displayName = "Radio",
        icon="#radio-channel-icon",
        enableMenu = function()
            if not exports['warp-death']:GetDeathStatus() then
                return (exports["isPed"]:isPed("myJob") == 'police' or exports["isPed"]:isPed("myJob") == 'sheriff' or exports["isPed"]:isPed("myJob") == 'ems' or exports["isPed"]:isPed("myJob") == 'state')
            end
        end,
        subMenus = {'radio:1', 'radio:2', 'radio:3', 'radio:4', 'radio:5'}
    },
    {
        id = "dreams-water-and-power-work-veh",
        displayName = "Get Work Vehicle",
        icon = "#general-check-vehicle",
        functionName = "dreams-civjobs:waternpowercar",
        enableMenu = function()
            local player = PlayerPedId()
            local plyCoords = GetEntityCoords(player)
            local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,453.96923828125, -1966.2592773438, 22.961181640625,false)

            return (distance <= 3.0 and not exports['warp-death']:GetDeathStatus() and not IsPedInAnyVehicle(PlayerPedId()))
        end
    },

    {
         id = "storeVehicle",
         displayName = "Store Vehicle",
         icon = "#Store-Vehicle",
         functionName = "warp-garages:store",
         enableMenu = function()
             return (isAtGarage == true and exports["warp-vehicles"]:NearVehicle("Distance") and not exports['warp-death']:GetDeathStatus())
         end
    },

    {
        id = "benny:drift_school",
        displayName = "Repair Vehicle",
        icon = "#general-check-vehicle",
        functionName = "warp-driftschool:repair_vehicle",
        enableMenu = function()
            return (not isDead and IsPedInAnyVehicle(PlayerPedId()) and #(GetEntityCoords(PlayerPedId()) - RepairDriftSchool) <= 10)
        end,
    },

    {
        id = "benny:enter1",
        displayName = "Enter Benny's ($1350)",
        icon = "#general-check-vehicle",
        functionName = "dreams-public-bennys",
        enableMenu = function()
            return (not isDead and IsPedInAnyVehicle(PlayerPedId()) and #(GetEntityCoords(PlayerPedId()) - bennyLocation) <= 10)
        end,
    },
    {
        id = "benny:enter4",
        displayName = "Enter Benny's",
        icon = "#general-check-vehicle",
        functionName = "enter:benny:mrpd",
        enableMenu = function()
            return (not isDead and IsPedInAnyVehicle(PlayerPedId()) and #(GetEntityCoords(PlayerPedId()) - bennyLocationMRPD) <= 10)
        end,
    },

    {
        id = "benny:enter5",
        displayName = "Enter Tuner's",
        icon = "#general-check-vehicle",
        functionName = "enter:benny:tunershop",
        enableMenu = function()
            return (not isDead and IsPedInAnyVehicle(PlayerPedId()) and #(GetEntityCoords(PlayerPedId()) - bennyLocationTunershop) <= 4)
        end,
    },
    
    {
        id = "benny:enter8",
        displayName = "Enter Harmony Autos",
        icon = "#general-check-vehicle",
        functionName = "enter:benny:harmony",
        enableMenu = function()
            return (not isDead and IsPedInAnyVehicle(PlayerPedId()) and #(GetEntityCoords(PlayerPedId()) - bennyLocationHarmony) <= 3)
        end,
    },

    {
        id = "benny:enter9",
        displayName = "Enter Hayes Autos",
        icon = "#general-check-vehicle",
        functionName = "enter:benny:hayes",
        enableMenu = function()
            return (not isDead and IsPedInAnyVehicle(PlayerPedId()) and #(GetEntityCoords(PlayerPedId()) - bennyLocationHayes) <= 3)
        end,
    },

    {
        id = "benny:hayes_2",
        displayName = "Enter Hayes Autos",
        icon = "#general-check-vehicle",
        functionName = "enter:benny:hayes2",
        enableMenu = function()
            return (not isDead and IsPedInAnyVehicle(PlayerPedId()) and #(GetEntityCoords(PlayerPedId()) - bennyLocationHayes2) <= 3)
        end,
    },

    {
        id = "benny:enterSandyPd",
        displayName = "Enter Bennys",
        icon = "#general-check-vehicle",
        functionName = "warp-police:AttemptBennys:SandyPD",
        enableMenu = function()
            return (not isDead and IsPedInAnyVehicle(PlayerPedId()) and #(GetEntityCoords(PlayerPedId()) - bennysSandyShoresPD) <= 3)
        end,
    },

    {
        id = "benny:enterRacingWarehouse",
        displayName = "Enter Bennys",
        icon = "#general-check-vehicle",
        functionName = "enter:benny:illegal",
        enableMenu = function()
            return (not isDead and IsPedInAnyVehicle(PlayerPedId()) and #(GetEntityCoords(PlayerPedId()) - bennysRacingWarehouse) <= 3)
        end,
    },

    {
        id = "benny:enterHarmony2",
        displayName = "Enter Bennys",
        icon = "#general-check-vehicle",
        functionName = "enter:benny:harmony2",
        enableMenu = function()
            return (not isDead and IsPedInAnyVehicle(PlayerPedId()) and #(GetEntityCoords(PlayerPedId()) - bennysHarmony2) <= 3)
        end,
    },

    {
        id = "call_for_help",
        displayName = "Call For Help",
        icon = "#dead",
        functionName = "warp-death:alert",
        enableMenu = function()
            return (exports['warp-death']:GetDeathStatus())
        end,
    },

}

newSubMenus = {
    ['police:tenThirteenA'] = {
        title = "10-13A",
        icon = "#police-dead",
        functionName = "police:tenThirteenA",
    },
    ['police:tenThirteenB'] = {
        title = "10-13B",
        icon = "#police-dead",
        functionName = "police:tenThirteenB",
    },
    ['police:checkInventory'] = {
        title = "Search",
        icon = "#cuffs-check-inventory",
        functionName = "police:checkInventory"
    },   
    ['police:revive'] = {
        title = "Revive",
        icon = "#medic-revive",
        functionName = "revive"
    },
    ['police:tenForteenA'] = {
        title = "10-14A",
        icon = "#ems-dead",
        functionName = "police:tenForteenA"
    },
    ['police:tenForteenB'] = {
        title = "10-14B",
        icon = "#ems-dead",
        functionName = "police:tenForteenB"
    },
    ['police:remmask'] = {
        title = "Remove Mask Hat",
        icon = "#cuffs-remove-mask",
        functionName = "police:remmask"
    },
    ['police:checkBank'] = {
        title = "Check Bank",
        icon = "#police-check-bank",
        functionName = "police:checkBank"
    },
    ['police:checkLicenses'] = {
        title = "Check Licenses",
        icon = "#police-check-licenses",
        functionName = "police:checkLicenses"
    },
    ['police:gsr'] = {
        title = "GSR Check",
        icon = "#police-action-gsr",
        functionName = "police:gsr"
    },
    ['police:dnaSwab'] = {
        title = "DNA Swab",
        icon = "#police-action-dna-swab",
        functionName = "evidence:dnaSwab"
    },
    ['general:emotes'] = {
        title = "Emotes",
        icon = "#general-emotes",
        functionName = "emotes:OpenMenu"
    },    
    ['general:keysgive'] = {
        title = "Give Key",
        icon = "#general-keys-give",
        functionName = "keys:give"
    },
    ['general:apartgivekey'] = {
        title = "Give Key",
        icon = "#general-apart-givekey",
        functionName = "apart:giveKey"
    },
    ['general:checkoverself'] = {
        title = "Examine Self",
        icon = "#general-check-over-self",
        functionName = "Evidence:CurrentDamageList"
    },
    ['general:checktargetstates'] = {
        title = "Examine Target",
        icon = "#general-check-over-target",
        functionName = "requestWounds"
    },
    ['general:checkvehicle'] = {
        title = "Examine Vehicle",
        icon = "#general-check-vehicle",
        functionName = "towgarage:annoyedBouce"
    },
    ['general:escort'] = {
        title = "Escort",
        icon = "#general-escort",
        functionName = "escortPlayer"
    },
    ['general:putinvehicle'] = {
        title = "Seat Vehicle",
        icon = "#general-put-in-veh",
        functionName = "police:forceEnter"
    },
    ['general:unseatnearest'] = {
        title = "Unseat Nearest",
        icon = "#general-unseat-nearest",
        functionName = "unseatPlayer"
    },    
    ['general:flipvehicle'] = {
        title = "Flip Vehicle",
        icon = "#general-flip-vehicle",
        functionName = "FlipVehicle"
    },

    ['animations:joy'] = {
        title = "Joy",
        icon = "#animation-joy",
        functionName = "AnimSet:Joy"
    },
    ['animations:sexy'] = {
        title = "Sexy",
        icon = "#animation-sexy",
        functionName = "AnimSet:Sexy"
    },
    ['animations:moon'] = {
        title = "Moon",
        icon = "#animation-moon",
        functionName = "AnimSet:Moon"
    },
    ['animations:tired'] = {
        title = "Tired",
        icon = "#animation-tired",
        functionName = "AnimSet:Tired"
    },
    ['animations:arrogant'] = {
        title = "Arrogant",
        icon = "#animation-arrogant",
        functionName = "AnimSet:Arrogant"
    },
    
    ['animations:casual'] = {
        title = "Casual",
        icon = "#animation-casual",
        functionName = "AnimSet:Casual"
    },
    ['animations:casual2'] = {
        title = "Casual 2",
        icon = "#animation-casual",
        functionName = "AnimSet:Casual2"
    },
    ['animations:casual3'] = {
        title = "Casual 3",
        icon = "#animation-casual",
        functionName = "AnimSet:Casual3"
    },
    ['animations:casual4'] = {
        title = "Casual 4",
        icon = "#animation-casual",
        functionName = "AnimSet:Casual4"
    },
    ['animations:casual5'] = {
        title = "Casual 5",
        icon = "#animation-casual",
        functionName = "AnimSet:Casual5"
    },
    ['animations:casual6'] = {
        title = "Casual 6",
        icon = "#animation-casual",
        functionName = "AnimSet:Casual6"
    },
    ['animations:confident'] = {
        title = "Confident",
        icon = "#animation-confident",
        functionName = "AnimSet:Confident"
    },
    
    ['animations:business2'] = {
        title = "Business 2",
        icon = "#animation-business",
        functionName = "AnimSet:Business2"
    },
    ['animations:business3'] = {
        title = "Business 3",
        icon = "#animation-business",
        functionName = "AnimSet:Business3"
    },
    
    ['animations:femme'] = {
        title = "Femme",
        icon = "#animation-female",
        functionName = "AnimSet:Femme"
    },
    ['animations:flee'] = {
        title = "Flee",
        icon = "#animation-flee",
        functionName = "AnimSet:Flee"
    },
    ['animations:gangster'] = {
        title = "Gangster",
        icon = "#animation-gangster",
        functionName = "AnimSet:Gangster"
    },
    ['animations:gangster2'] = {
        title = "Gangster 2",
        icon = "#animation-gangster",
        functionName = "AnimSet:Gangster2"
    },
    ['animations:gangster3'] = {
        title = "Gangster 3",
        icon = "#animation-gangster",
        functionName = "AnimSet:Gangster3"
    },
    ['animations:gangster4'] = {
        title = "Gangster 4",
        icon = "#animation-gangster",
        functionName = "AnimSet:Gangster4"
    },
    ['animations:gangster5'] = {
        title = "Gangster 5",
        icon = "#animation-gangster",
        functionName = "AnimSet:Gangster5"
    },
    
    ['animations:heels'] = {
        title = "Heels",
        icon = "#animation-female",
        functionName = "AnimSet:Heels"
    },
    ['animations:heels2'] = {
        title = "Heels 2",
        icon = "#animation-female",
        functionName = "AnimSet:Heels2"
    },
    
    ['animations:hipster'] = {
        title = "Hipster",
        icon = "#animation-hipster",
        functionName = "AnimSet:Hipster"
    },
    ['animations:hiking'] = {
        title = "Hiking",
        icon = "#animation-hiking",
        functionName = "AnimSet:Hiking"
    },
    
    ['animations:jog'] = {
        title = "Jog",
        icon = "#animation-jog",
        functionName = "AnimSet:Jog"
    },
    
    ['animations:muscle'] = {
        title = "Muscle",
        icon = "#animation-tough",
        functionName = "AnimSet:Muscle"
    },
    
    ['animations:quick'] = {
        title = "Quick",
        icon = "#animation-chubby",
        functionName = "AnimSet:Quick"
    },
    ['animations:wide'] = {
        title = "Wide",
        icon = "#animation-wide",
        functionName = "AnimSet:Wide"
    },
    ['animations:scared'] = {
        title = "Scared",
        icon = "#animation-scared",
        functionName = "AnimSet:Scared"
    },
    ['animations:guard'] = {
        title = "Guard",
        icon = "#animation-guard",
        functionName = "AnimSet:Guard"
    },
    ['animations:brave'] = {
        title = "Brave",
        icon = "#animation-brave",
        functionName = "AnimSet:Brave"
    },
    ['animations:hurry'] = {
        title = "Hurry",
        icon = "#animation-chubby",
        functionName = "AnimSet:Hurry"
    },
    ['animations:business'] = {
        title = "Business",
        icon = "#animation-business",
        functionName = "AnimSet:Business"
    },
    ['animations:tipsy'] = {
        title = "Tipsy",
        icon = "#animation-tipsy",
        functionName = "AnimSet:Tipsy"
    },
    ['animations:injured'] = {
        title = "Injured",
        icon = "#animation-injured",
        functionName = "AnimSet:Injured"
    },
    ['animations:tough'] = {
        title = "Tough",
        icon = "#animation-tough",
        functionName = "AnimSet:ToughGuy"
    },
    ['animations:sassy'] = {
        title = "Sassy",
        icon = "#animation-sassy",
        functionName = "AnimSet:Sassy"
    },
    ['animations:sad'] = {
        title = "Sad",
        icon = "#animation-sad",
        functionName = "AnimSet:Sad"
    },
    ['animations:posh'] = {
        title = "Posh",
        icon = "#animation-posh",
        functionName = "AnimSet:Posh"
    },
    ['animations:alien'] = {
        title = "Alien",
        icon = "#animation-alien",
        functionName = "AnimSet:Alien"
    },
    ['animations:nonchalant'] =
    {
        title = "Nonchalant",
        icon = "#animation-nonchalant",
        functionName = "AnimSet:NonChalant"
    },
    ['animations:hobo'] = {
        title = "Hobo",
        icon = "#animation-hobo",
        functionName = "AnimSet:Hobo"
    },
    ['animations:dreamsrp'] = {
        title = "Chubby Walk",
        icon = "#animation-chubby",
        functionName = "AnimSet:DreamsRP"
    },
    ['animations:money'] = {
        title = "Money",
        icon = "#animation-money",
        functionName = "AnimSet:Money"
    },
    ['animations:swagger'] = {
        title = "Swagger",
        icon = "#animation-swagger",
        functionName = "AnimSet:Swagger"
    },
    ['animations:shady'] = {
        title = "Shady",
        icon = "#animation-shady",
        functionName = "AnimSet:Shady"
    },
    ['animations:maneater'] = {
        title = "Man Eater",
        icon = "#animation-maneater",
        functionName = "AnimSet:ManEater"
    },
    ['animations:chichi'] = {
        title = "ChiChi",
        icon = "#animation-chichi",
        functionName = "AnimSet:ChiChi"
    },
    ['animations:default'] = {
        title = "Default",
        icon = "#animation-default",
        functionName = "AnimSet:default"
    },
    ['blips:gasstations'] = {
        title = "Gas Stations",
        icon = "#blips-gasstations",
        functionName = "CarPlayerHud:ToggleGas"
    },    
    ['blips:trainstations'] = {
        title = "Train Stations",
        icon = "#blips-trainstations",
        functionName = "Trains:ToggleTainsBlip"
    },
    ['blips:garages'] = {
        title = "Garages",
        icon = "#blips-garages",
        functionName = "Garages:ToggleGarageBlip"
    },
    ['blips:barbershop'] = {
        title = "Barber Shop",
        icon = "#blips-barbershop",
        functionName = "hairDresser:ToggleHair"
    },    
    ['blips:tattooshop'] = {
        title = "Tattoo Shop",
        icon = "#blips-tattooshop",
        functionName = "tattoo:ToggleTattoo"
    },
    ['drivinginstructor:drivingtest'] = {
        title = "Driving Test",
        icon = "#drivinginstructor-drivingtest",
        functionName = "drivingInstructor:testToggle"
    },
    ['drivinginstructor:submittest'] = {
        title = "Submit Test",
        icon = "#drivinginstructor-submittest",
        functionName = "drivingInstructor:submitTest"
    },
    ['cuffs:cuff'] = {
        title = "Cuff",
        icon = "#cuffs-cuff",
        functionName = "civ:cuffFromMenu"
    },
    ['cuffs:uncuff'] = {
        title = "Uncuff",
        icon = "#cuffs-uncuff",
        functionName = "police:uncuffMenu"
    },
    ['cuffs:remmask'] = {
        title = "Remove Mask Hat",
        icon = "#cuffs-remove-mask",
        functionName = "police:remmask"
    },
    ['cuffs:checkinventory'] = {
        title = "Search Person",
        icon = "#cuffs-check-inventory",
        functionName = "police:checkInventory"
    },
    ['cuffs:unseat'] = {
        title = "Unseat",
        icon = "#cuffs-unseat-player",
        functionName = "unseatPlayerCiv"
    },
    ['medic:revive'] = {
        title = "Revive",
        icon = "#medic-revive",
        functionName = "warp-ems:emsRevive"
    },
    ['medic:heal'] = {
        title = "Small Heal",
        icon = "#medic-heal",
        functionName = "warp-ems:smallheal"
    },
    ['medic:heal2'] = {
        title = "Big Heal",
        icon = "#medic-heal",
        functionName = "warp-ems:bigheal"
    },
    ['medic:stomachpump'] = {
        title = "Stomach pump",
        icon = "#medic-stomachpump",
        functionName = "ems:stomachpump"
    },
    ['news:setCamera'] = {
        title = "Camera",
        icon = "#news-job-news-camera",
        functionName = "camera:setCamera"
    },
    ['news:setMicrophone'] = {
        title = "Microphone",
        icon = "#news-job-news-microphone",
        functionName = "camera:setMic"
    },
    ['news:setBoom'] = {
        title = "Microphone Boom",
        icon = "#news-job-news-boom",
        functionName = "camera:setBoom"
    },
    ['weed:currentStatusServer'] = {
        title = "Request Status",
        icon = "#weed-cultivation-request-status",
        functionName = "weed:currentStatusServer"
    },   
    ['weed:weedCrate'] = {
        title = "Remove A Crate",
        icon = "#weed-cultivation-remove-a-crate",
        functionName = "weed:weedCrate"
    },
    ['cocaine:currentStatusServer'] = {
        title = "Request Status",
        icon = "#meth-manufacturing-request-status",
        functionName = "cocaine:currentStatusServer"
    },
    ['cocaine:methCrate'] = {
        title = "Remove A Crate",
        icon = "#meth-manufacturing-remove-a-crate",
        functionName = "cocaine:methCrate"
    },
    ["expressions:angry"] = {
        title="Angry",
        icon="#expressions-angry",
        functionName = "expressions",
        functionParameters =  { "mood_angry_1" }
    },
    ["expressions:drunk"] = {
        title="Drunk",
        icon="#expressions-drunk",
        functionName = "expressions",
        functionParameters =  { "mood_drunk_1" }
    },
    ["expressions:dumb"] = {
        title="Dumb",
        icon="#expressions-dumb",
        functionName = "expressions",
        functionParameters =  { "pose_injured_1" }
    },
    ["expressions:electrocuted"] = {
        title="Electrocuted",
        icon="#expressions-electrocuted",
        functionName = "expressions",
        functionParameters =  { "electrocuted_1" }
    },
    ["expressions:grumpy"] = {
        title="Grumpy",
        icon="#expressions-grumpy",
        functionName = "expressions", 
        functionParameters =  { "mood_drivefast_1" }
    },
    ["expressions:happy"] = {
        title="Happy",
        icon="#expressions-happy",
        functionName = "expressions",
        functionParameters =  { "mood_happy_1" }
    },
    ["expressions:injured"] = {
        title="Injured",
        icon="#expressions-injured",
        functionName = "expressions",
        functionParameters =  { "mood_injured_1" }
    },
    ["expressions:joyful"] = {
        title="Joyful",
        icon="#expressions-joyful",
        functionName = "expressions",
        functionParameters =  { "mood_dancing_low_1" }
    },
    ["expressions:mouthbreather"] = {
        title="Mouthbreather",
        icon="#expressions-mouthbreather",
        functionName = "expressions",
        functionParameters = { "smoking_hold_1" }
    },
    ["expressions:normal"]  = {
        title="Normal",
        icon="#expressions-normal",
        functionName = "expressions:clear"
    },
    ["expressions:oneeye"]  = {
        title="One Eye",
        icon="#expressions-oneeye",
        functionName = "expressions",
        functionParameters = { "pose_aiming_1" }
    },
    ["expressions:shocked"]  = {
        title="Shocked",
        icon="#expressions-shocked",
        functionName = "expressions",
        functionParameters = { "shocked_1" }
    },
    ["expressions:sleeping"]  = {
        title="Sleeping",
        icon="#expressions-sleeping",
        functionName = "expressions",
        functionParameters = { "dead_1" }
    },
    ["expressions:smug"]  = {
        title="Smug",
        icon="#expressions-smug",
        functionName = "expressions",
        functionParameters = { "mood_smug_1" }
    },
    ["expressions:speculative"]  = {
        title="Speculative",
        icon="#expressions-speculative",
        functionName = "expressions",
        functionParameters = { "mood_aiming_1" }
    },
    ["expressions:stressed"]  = {
        title="Stressed",
        icon="#expressions-stressed",
        functionName = "expressions",
        functionParameters = { "mood_stressed_1" }
    },
    ["expressions:sulking"]  = {
        title="Sulking",
        icon="#expressions-sulking",
        functionName = "expressions",
        functionParameters = { "mood_sulk_1" },
    },
    ["expressions:weird"]  = {
        title="Weird",
        icon="#expressions-weird",
        functionName = "expressions",
        functionParameters = { "effort_2" }
    },
    ["expressions:weird2"]  = {
        title="Weird 2",
        icon="#expressions-weird2",
        functionName = "expressions",
        functionParameters = { "effort_3" }
    },
    ["police:impoundsc"]  = {
        title="Impound Scuff",
        icon="#vehicle-options",
        functionName = "impoundsc",
    },

    ["police:impoundnormal"]  = {
        title="Impound Normal $100",
        icon="#vehicle-options",
        functionName = "impoundVehicle",
    },

    ["police:impoundpolice"]  = {
        title="Impound Police $1500",
        icon="#vehicle-options",
        functionName = "fullimpoundVehicle",
    },

    -- PD Radios --

    ["radio:1"] = {
        title="Channel 1 (PD)",
        icon="#radio-channel-icon",
        functionName = "warp-radio:set_chan_1",
    },
    
    ["radio:2"] = {
        title="Channel 2 (EMS)",
        icon="#radio-channel-icon",
        functionName = "warp-radio:set_chan_2",
    },

    ["radio:3"] = {
        title="Channel 3",
        icon="#radio-channel-icon",
        functionName = "warp-radio:set_chan_3",
    },

    ["radio:4"] = {
        title="Channel 4",
        icon="#radio-channel-icon",
        functionName = "warp-radio:set_chan_4",
    },

    ["radio:5"] = {
        title="Channel 5",
        icon="#radio-channel-icon",
        functionName = "warp-radio:set_chan_5",
    },

    ---------------------------------

    ["license:grantWeapon"]  = {
        title="Grant Weapon License",
        icon="#judge-licenses-grant-weapon",
        functionName = "police:giveweaponlicense",
    },
    ["license:removeweapons"]  = {
        title="Revoke Weapon License",
        icon="#judge-licenses-remove-weapon",
        functionName = "police:removeweaponlicense",
    },
    ["license:granthunting"]  = {
        title="Grant Hunting License",
        icon="#judge-licenses-grant-weapon",
        functionName = "police:givehuntinglicense",
    },
    ["license:removehunting"]  = {
        title="Revoke Hunting License",
        icon="#judge-licenses-remove-weapon",
        functionName = "police:removehuntinglicense",
    },
    ["license:grantfishing"]  = {
        title="Grant Fishing License",
        icon="#judge-licenses-grant-weapon",
        functionName = "police:givefishinglicense",
    },
    ["license:removefishing"]  = {
        title="Revoke Fishing License",
        icon="#judge-licenses-remove-weapon",
        functionName = "police:removeLicensesfish",
    },
    ['police:toggleradar'] = {
        title = "Toggle Radar",
        icon = "#police-vehicle-radar",
        functionName = "startSpeedo"
    },
    ['police:riflerack'] = {
        title = "Rifle Rack",
        icon="#drivinginstructor-submittest",
        functionName = "police:RifleRack",
    },
}

RegisterNetEvent("menu:setCuffState")
AddEventHandler("menu:setCuffState", function(pTargetId, pState)
    cuffStates[pTargetId] = pState
end)

RegisterNetEvent("menu:hasOxygenTank")
AddEventHandler("menu:hasOxygenTank", function(pHasOxygenTank)
    hasOxygenTankOn = pHasOxygenTank
end)

RegisterNetEvent('enablegangmember')
AddEventHandler('enablegangmember', function(pGangNum)
    gangNum = pGangNum
end)

function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end

function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local closestPed = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        for index,value in ipairs(players) do
            local target = GetPlayerPed(value)
            if(target ~= ply) then
                local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
                local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
                if(closestDistance == -1 or closestDistance > distance) and not IsPedInAnyVehicle(target, false) then
                    closestPlayer = value
                    closestPed = target
                    closestDistance = distance
                end
            end
        end
        return closestPlayer, closestDistance, closestPed
    end
end

trainstations = {
    {-547.34057617188,-1286.1752929688,25.3059978411511},
    {-892.66284179688,-2322.5168457031,-13.246466636658},
    {-1100.2299804688,-2724.037109375,-8.3086919784546},
    {-1071.4924316406,-2713.189453125,-8.9240007400513},
    {-875.61907958984,-2319.8686523438,-13.241264343262},
    {-536.62890625,-1285.0009765625,25.301458358765},
    {270.09558105469,-1209.9177246094,37.465930938721},
    {-287.13568115234,-327.40936279297,8.5491418838501},
    {-821.34295654297,-132.45257568359,18.436864852905},
    {-1359.9794921875,-465.32354736328,13.531299591064},
    {-498.96591186523,-680.65930175781,10.295949935913},
    {-217.97073364258,-1032.1605224609,28.724565505981},
    {113.90325164795,-1729.9976806641,28.453630447388},
    {117.33223724365,-1721.9318847656,28.527353286743},
    {-209.84713745117,-1037.2414550781,28.722997665405},
    {-499.3971862793,-665.58514404297,10.295639038086},
    {-1344.5224609375,-462.10494995117,13.531820297241},
    {-806.85192871094,-141.39852905273,18.436403274536},
    {-302.21514892578,-327.28854370117,8.5495929718018},
    {262.01733398438,-1198.6135253906,37.448017120361},
--  {2072.4086914063,1569.0856933594,76.712524414063},
    {664.93090820313,-997.59942626953,22.261747360229},
    {190.62687683105,-1956.8131103516,19.520135879517},
--  {2611.0278320313,1675.3806152344,26.578210830688},
    {2615.3901367188,2934.8666992188,39.312232971191},
    {2885.5346679688,4862.0146484375,62.551517486572},
    {47.061096191406,6280.8969726563,31.580261230469},
    {2002.3624267578,3619.8029785156,38.568252563477},
    {2609.7016601563,2937.11328125,39.418235778809}
}

enter_locations = {
	{172.78, -26.89, 68.35},
}

enter_locations2 = {
    {232.85275268555,-411.33627319336,48.10107421875},
}

enter_locations3 = {
    {237.75823974609,-413.1428527832,48.10107421875},
}

enter_locations4 = {
    {249.0989074707,-364.82638549805,-44.151611328125},
}

enter_locations5 = {
    {332.29449462891,-595.71429443359,43.282104492188},
}

enter_locations6 = {
    {330.40878295898,-601.16046142578,43.282104492188},
    {344.33407592773,-586.33843994141,28.791259765625},
}

leave_locations = {
	{-1389.412, -475.6651, 72.04217},
}

leave_locations2 = {
    {269.03735351563,-371.78900146484,-44.151611328125},
}

leave_locations3 = {
    {224.9010925293,-419.55163574219,-118.20654296875},
}

leave_locations4 = {
    {313.21319580078,-1611.3099365234,-66.7978515625},
}

leave_locations5 = {
    {345.62637329102,-582.55383300781,28.791259765625},
    {341.38021850586,-581.03735351562,28.791259765625},
}

leave_locations6 = {
    {338.61099243164,-583.81976318359,74.15087890625},
}

enterrecy_locations = {
	{746.91430664062,-1399.3055419922,26.617553710938},
}

leaverecy_locations = {
	{997.4598, -3091.976, -38.99984},
}

flightschool_locations = {
	{-1242.1450195312,-3393.1516113281,13.9296875},
}

flightschool2_locations = {
	{-1274.4000244141,-3385.8989257812,14.8564453125},
}

RegisterNetEvent('apartments:enterjobcenter2')
AddEventHandler('apartments:enterjobcenter2', function()
  DoScreenFadeOut(1)
  SetEntityCoords(PlayerPedId(), 269.03735351563,-371.78900146484,-44.151611328125)
  DoScreenFadeIn(1000)
  Citizen.Wait(1000)
end)

RegisterNetEvent('apartments:leavejobcenter2')
AddEventHandler('apartments:leavejobcenter2', function()
  DoScreenFadeOut(1)
  Citizen.Wait(100)
  SetEntityCoords(PlayerPedId(),232.8659362793,-411.38900756836,48.10107421875)
  DoScreenFadeIn(1000)
  Citizen.Wait(1000)
end)

RegisterNetEvent('apartments:enterjobcenter3')
AddEventHandler('apartments:enterjobcenter3', function()
  DoScreenFadeOut(1)
  SetEntityCoords(PlayerPedId(),224.69010925293,-419.36703491211,-118.20654296875)
  DoScreenFadeIn(1000)
  Citizen.Wait(1000)
end)

RegisterNetEvent('apartments:leavejobcenter3')
AddEventHandler('apartments:leavejobcenter3', function()
  DoScreenFadeOut(1)
  Citizen.Wait(100)
  SetEntityCoords(PlayerPedId(),237.75823974609,-413.1428527832,48.10107421875)
  DoScreenFadeIn(1000)
  Citizen.Wait(1000)
end)

RegisterNetEvent('apartments:enterjobcenter4')
AddEventHandler('apartments:enterjobcenter4', function()
  DoScreenFadeOut(1)
  SetEntityCoords(PlayerPedId(),313.21319580078,-1611.3099365234,-66.7978515625)
  DoScreenFadeIn(1000)
  Citizen.Wait(1000)
end)

RegisterNetEvent('apartments:leavejobcenter4')
AddEventHandler('apartments:leavejobcenter4', function()
  DoScreenFadeOut(1)
  Citizen.Wait(100)
  SetEntityCoords(PlayerPedId(),249.08572387695,-364.70770263672,-44.151611328125)
  DoScreenFadeIn(1000)
  Citizen.Wait(1000)
end)

RegisterNetEvent('apartments:enterjobcenter5')
AddEventHandler('apartments:enterjobcenter5', function()
  DoScreenFadeOut(1)
  SetEntityCoords(PlayerPedId(),345.62637329102,-582.55383300781,28.791259765625)
  DoScreenFadeIn(1000)
  Citizen.Wait(1000)
end)

RegisterNetEvent('apartments:leavejobcenter5')
AddEventHandler('apartments:leavejobcenter5', function()
  DoScreenFadeOut(1)
  Citizen.Wait(100)
  SetEntityCoords(PlayerPedId(),332.29449462891,-595.71429443359,43.282104492188)
  DoScreenFadeIn(1000)
  Citizen.Wait(1000)
end)

RegisterNetEvent('apartments:enterjobcenter6')
AddEventHandler('apartments:enterjobcenter6', function()
  DoScreenFadeOut(1)
  SetEntityCoords(PlayerPedId(),338.61099243164,-583.81976318359,74.15087890625)
  DoScreenFadeIn(1000)
  Citizen.Wait(1000)
end)

RegisterNetEvent('apartments:leavejobcenter6')
AddEventHandler('apartments:leavejobcenter6', function()
  DoScreenFadeOut(1)
  Citizen.Wait(100)
  SetEntityCoords(PlayerPedId(),330.40878295898,-601.16046142578,43.282104492188)
  DoScreenFadeIn(1000)
  Citizen.Wait(1000)
end)

RegisterNetEvent('ems:spawnshitheli')
AddEventHandler('ems:spawnshitheli', function()
    if exports["isPed"]:isPed("myJob") == 'ems' then
	    local vehicle = veh
	    local veh = GetVehiclePedIsUsing(ped)

	    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))

	    FreezeEntityPosition(ped,false)
	    RequestModel('emsaw139')
	    while not HasModelLoaded('emsaw139') do
		    Citizen.Wait(0)
	    end
	    personalvehicle = CreateVehicle('emsaw139',351.0725402832, -588.01318359375, 74.15087890625, 252.2834777832,true,false)
	    SetModelAsNoLongerNeeded('emsaw139')

	    SetVehicleOnGroundProperly(personalvehicle)

	    local plate = GetVehicleNumberPlateText(personalvehicle)
	    local id = NetworkGetNetworkIdFromEntity(personalvehicle)
	    SetNetworkIdCanMigrate(id, true)
	    Citizen.InvokeNative(0x629BFA74418D6239,Citizen.PointerValueIntInitialized(personalvehicle))
	    TaskWarpPedIntoVehicle(PlayerPedId(),personalvehicle,-1)
	    SetEntityVisible(ped,true)			
	    TriggerEvent("keys:addNew",personalvehicle, plate)
    else
       TriggerEvent('DoShortHudText', 'You are not EMS ',2)
    end
end)


RegisterNetEvent('police:spawnshitheli')
AddEventHandler('police:spawnshitheli', function()
    if exports["isPed"]:isPed("myJob") == 'police' or exports["isPed"]:isPed("myJob") == 'sheriff' or exports["isPed"]:isPed("myJob") == 'state' then
	    local vehicle = veh
	    local veh = GetVehiclePedIsUsing(ped)

	    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))

	    FreezeEntityPosition(ped,false)
	    RequestModel('polas350')
	    while not HasModelLoaded('polas350') do
		    Citizen.Wait(0)
	    end
	    personalvehicle = CreateVehicle('polas350',450.33489, -981.3494, 43.792816, 90.478919,true,false)
	    SetModelAsNoLongerNeeded('polas350')

	    SetVehicleOnGroundProperly(personalvehicle)

	    local plate = GetVehicleNumberPlateText(personalvehicle)
	    local id = NetworkGetNetworkIdFromEntity(personalvehicle)
	    SetNetworkIdCanMigrate(id, true)
	    Citizen.InvokeNative(0x629BFA74418D6239,Citizen.PointerValueIntInitialized(personalvehicle))
	    TaskWarpPedIntoVehicle(PlayerPedId(),personalvehicle,-1)
	    SetEntityVisible(ped,true)			
	    TriggerEvent("keys:addNew",personalvehicle, plate)
    else
        TriggerEvent('DoShortHudText', 'You are not a cop ',2)
    end
end)

RegisterNetEvent('cayo:spawnshitheli')
AddEventHandler('cayo:spawnshitheli', function()
    local rank = exports["isPed"]:GroupRank("cartel")
    if rank >= 1 then    
	    local vehicle = veh
	    local veh = GetVehiclePedIsUsing(ped)

	    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))

	    FreezeEntityPosition(ped,false)
	    RequestModel('frogger')
	    while not HasModelLoaded('frogger') do
		    Citizen.Wait(0)
	    end
	    personalvehicle = CreateVehicle('frogger',4890.7861, -5735.645, 26.350883, 154.31636,true,false)
	    SetModelAsNoLongerNeeded('frogger')

	    SetVehicleOnGroundProperly(personalvehicle)

	    local plate = GetVehicleNumberPlateText(personalvehicle)
	    local id = NetworkGetNetworkIdFromEntity(personalvehicle)
	    SetNetworkIdCanMigrate(id, true)
	    Citizen.InvokeNative(0x629BFA74418D6239,Citizen.PointerValueIntInitialized(personalvehicle))
	    TaskWarpPedIntoVehicle(PlayerPedId(),personalvehicle,-1)
	    SetEntityVisible(ped,true)			
	    TriggerEvent("keys:addNew",personalvehicle, plate)
    else
        TriggerEvent('DoShortHudText', 'You are not a cop ',2)
    end
end)

local approvedGarages = {
    "garagea",
    "garageb",
    "garagec",
    "garaged",
    "garagee",
    "garagef",
    "garageg",
    "garageh",
    "garagei",
    "garagej",
    "garagek",
    "garagel",
    "garagem",
    "garageo",
    "garagep",
    "garageq",
    "garager",
    "garages",
    "garaget",
    "garageu",
    "garagepd",
    "garagesandy",
    "garagestate",
    "garageharm",
    "garagepier",
    "garagerich",
    "garageems",
    "garagecasino",
    "nomalimpound",
    "garagempg",
    "garagegallery",
    "garagelsp",
    "garagebahamas",
}

local pCurrentGarage = "None"


function polyZoneEnter(zoneName, zoneData)
    currentZone = zoneName
    for k, v in pairs (approvedGarages) do
        if zoneName == v then
            exports['warp-textui']:showInteraction('Parking')
            pCurrentGarage = zoneName
            print(pCurrentGarage)
            isAtGarage = true
        end
    end
end

function polyZoneExit(zoneName)
    if currentZone == zoneName then
        exports['warp-textui']:hideInteraction()
        isAtGarage = false
        pCurrentGarage = "None"
    end
end

exports("currentGarage", function()
    if isAtGarage then
        return pCurrentGarage
    elseif isAtHouseGarage then
        return pHouseNameGarage
    end
end)

exports("houseGarageCoords", function()
    return pHouseGarages
end)

exports("NearHouseGarage", function()
    return isAtHouseGarage
end)

RegisterNetEvent("menu:send:house:garages", function(pCoords, pGarageName)
    pHouseGarages = pCoords
    isAtHouseGarage = true
    pHouseNameGarage = pGarageName
end)

RegisterNetEvent("menu:housing", function(pState)
    isAtHouseGarage = pState
end)

AddEventHandler('warp-polyzone:entered:garages', polyZoneEnter)
AddEventHandler('warp-polyzone:exited:garages', polyZoneExit)



-- RegisterNetEvent('warp-menu:ShowVehicles')
-- AddEventHandler('warp-menu:ShowVehicles', function()
--     showVehicles()
-- end)

-- function showVehicles()
--     exports['warp-menuinteract']:AddButton("Take out", "Start Flying", "flight:test1", 'example button 1', "flight1")
--     exports['warp-menuinteract']:AddButton("Take out", "Start Flying", "flight:test2", 'example button 2', "flight2")
--     exports['warp-menuinteract']:AddButton("Take out", "Start Flying", "flight:test3", 'example button 3', "flight3")
--     exports['warp-menuinteract']:AddButton("Take out", "Start Flying", "flight:test4", 'example button 4', "flight4")
--     exports['warp-menuinteract']:AddButton("Take out", "Start Flying", "flight:test5", 'example button 5', "flight5")
--     exports['warp-menuinteract']:SubMenu("Velum" , "Select plane!" , "flight1")
--     exports['warp-menuinteract']:SubMenu("Frogger" , "Select plane!" , "flight2")
--     exports['warp-menuinteract']:SubMenu("Cargobob" , "Select plane!" , "flight3")
--     exports['warp-menuinteract']:SubMenu("Microlight" , "Select plane!" , "flight4")
--     exports['warp-menuinteract']:SubMenu("DoDo" , "Select plane!" , "flight5")
-- end

-- RegisterNetEvent('flight:test1')
-- AddEventHandler('flight:test1', function()
--     local veh = GetClosestVehicle(-1274.4659423828,-3386.0043945312,13.9296875, 3.000, 0, 70)
--     local model = GetHashKey('velum')
--     if not DoesEntityExist(veh) then
--         if IsModelInCdimage(model) and IsModelValid(model) then
--             RequestModel(model)
--             while (not HasModelLoaded(model)) do
--                 Citizen.Wait(0)
--             end
--         else
--             TriggerEvent('DoLongHudText', 'Error spawning car.', 2) 
--             return
--         end

--         veh = CreateVehicle(model, -1274.4659423828,-3386.0043945312,13.9296875,328.81890869141, true,false)
--         local vehplate = "FLIGHT"..math.random(100,999)
--         SetVehicleNumberPlateText(veh, vehplate)
--         local plate = GetVehicleNumberPlateText(veh, vehplate)
--         TriggerEvent("keys:addNew",vehplate, plate)
--         Citizen.Wait(100)
--         SetModelAsNoLongerNeeded(model)
--         SetVehicleOnGroundProperly(veh)
--         SetEntityAsMissionEntity(veh,false,true)
--         TaskWarpPedIntoVehicle(PlayerPedId(),veh,-1)
--     end
-- end)

-- RegisterNetEvent('flight:test2')
-- AddEventHandler('flight:test2', function()
--     local veh = GetClosestVehicle(-1274.4659423828,-3386.0043945312,13.9296875, 3.000, 0, 70)
--     local model = GetHashKey('frogger')
--     if not DoesEntityExist(veh) then
--         if IsModelInCdimage(model) and IsModelValid(model) then
--             RequestModel(model)
--             while (not HasModelLoaded(model)) do
--                 Citizen.Wait(0)
--             end
--         else
--             TriggerEvent('DoLongHudText', 'Error spawning car.', 2) 
--             return
--         end

--         veh = CreateVehicle(model, -1274.4659423828,-3386.0043945312,13.9296875,328.81890869141, true,false)
--         local vehplate = "FLIGHT"..math.random(100,999)
--         SetVehicleNumberPlateText(veh, vehplate)
--         local plate = GetVehicleNumberPlateText(veh, vehplate)
--         TriggerEvent("keys:addNew",vehplate, plate)
--         Citizen.Wait(100)
--         SetModelAsNoLongerNeeded(model)
--         SetVehicleOnGroundProperly(veh)
--         SetEntityAsMissionEntity(veh,false,true)
--         TaskWarpPedIntoVehicle(PlayerPedId(),veh,-1)
--     end
-- end)

-- RegisterNetEvent('flight:test3')
-- AddEventHandler('flight:test3', function()
--     local veh = GetClosestVehicle(-1274.4659423828,-3386.0043945312,13.9296875, 3.000, 0, 70)
--     local model = GetHashKey('cargobob')
--     if not DoesEntityExist(veh) then
--         if IsModelInCdimage(model) and IsModelValid(model) then
--             RequestModel(model)
--             while (not HasModelLoaded(model)) do
--                 Citizen.Wait(0)
--             end
--         else
--             TriggerEvent('DoLongHudText', 'Error spawning car.', 2) 
--             return
--         end

--         veh = CreateVehicle(model, -1274.4659423828,-3386.0043945312,13.9296875,328.81890869141, true,false)
--         local vehplate = "FLIGHT"..math.random(100,999)
--         SetVehicleNumberPlateText(veh, vehplate)
--         local plate = GetVehicleNumberPlateText(veh, vehplate)
--         TriggerEvent("keys:addNew",vehplate, plate)
--         Citizen.Wait(100)
--         SetModelAsNoLongerNeeded(model)
--         SetVehicleOnGroundProperly(veh)
--         SetEntityAsMissionEntity(veh,false,true)
--         TaskWarpPedIntoVehicle(PlayerPedId(),veh,-1)
--     end
-- end)

-- RegisterNetEvent('flight:test4')
-- AddEventHandler('flight:test4', function()
--     local veh = GetClosestVehicle(-1274.4659423828,-3386.0043945312,13.9296875, 3.000, 0, 70)
--     local model = GetHashKey('microlight')
--     if not DoesEntityExist(veh) then
--         if IsModelInCdimage(model) and IsModelValid(model) then
--             RequestModel(model)
--             while (not HasModelLoaded(model)) do
--                 Citizen.Wait(0)
--             end
--         else
--             TriggerEvent('DoLongHudText', 'Error spawning car.', 2) 
--             return
--         end

--         veh = CreateVehicle(model, -1274.4659423828,-3386.0043945312,13.9296875,328.81890869141, true,false)
--         local vehplate = "FLIGHT"..math.random(100,999)
--         SetVehicleNumberPlateText(veh, vehplate)
--         local plate = GetVehicleNumberPlateText(veh, vehplate)
--         TriggerEvent("keys:addNew",vehplate, plate)
--         Citizen.Wait(100)
--         SetModelAsNoLongerNeeded(model)
--         SetVehicleOnGroundProperly(veh)
--         SetEntityAsMissionEntity(veh,false,true)
--         TaskWarpPedIntoVehicle(PlayerPedId(),veh,-1)
--     end
-- end)

-- RegisterNetEvent('flight:test5')
-- AddEventHandler('flight:test5', function()
--     local veh = GetClosestVehicle(-1274.4659423828,-3386.0043945312,13.9296875, 3.000, 0, 70)
--     local model = GetHashKey('dodo')
--     if not DoesEntityExist(veh) then
--         if IsModelInCdimage(model) and IsModelValid(model) then
--             RequestModel(model)
--             while (not HasModelLoaded(model)) do
--                 Citizen.Wait(0)
--             end
--         else
--             TriggerEvent('DoLongHudText', 'Error spawning car.', 2) 
--             return
--         end

--         veh = CreateVehicle(model, -1274.4659423828,-3386.0043945312,13.9296875,328.81890869141, true,false)
--         local vehplate = "FLIGHT"..math.random(100,999)
--         SetVehicleNumberPlateText(veh, vehplate)
--         local plate = GetVehicleNumberPlateText(veh, vehplate)
--         TriggerEvent("keys:addNew",vehplate, plate)
--         Citizen.Wait(100)
--         SetModelAsNoLongerNeeded(model)
--         SetVehicleOnGroundProperly(veh)
--         SetEntityAsMissionEntity(veh,false,true)
--         TaskWarpPedIntoVehicle(PlayerPedId(),veh,-1)
--     end
-- end)

RegisterNetEvent('apartments:enterjobcenter')
AddEventHandler('apartments:enterjobcenter', function()
  DoScreenFadeOut(1)
  buildOfficeCentre2()
  SetEntityHeading(PlayerPedId(),180.0)
  DoScreenFadeIn(1000)
  Citizen.Wait(1000)
end)

RegisterNetEvent('apartments:leavejobcenter')
AddEventHandler('apartments:leavejobcenter', function()
  DoScreenFadeOut(1)
  Citizen.Wait(100)
  SetEntityCoords(PlayerPedId(),172.78, -26.89, 68.35)
  SetEntityHeading(PlayerPedId(),180.0)
  DoScreenFadeIn(1000)
  Citizen.Wait(1000)
end)

function buildOfficeCentre2()
	SetEntityCoords(PlayerPedId(),-1389.412, -475.6651, 72.04217)
  	Citizen.Wait(1000)
	local generator = { x = -1389.412 , y = -475.6651, z = 72.04217 }
  	SetEntityHeading(PlayerPedId(),267.0)
  	SetGameplayCamRelativeHeading(0.0)
end