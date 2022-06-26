--[[
cl_bennys.lua
Functionality that handles the player for Benny's.
Handles applying mods, etc.
]]

--#[Global Variables]#--
isPlyInBennys = false

--#[Local Variables]#--
local plyFirstJoin = false

isDev = false
local nearDefault = false
local nearImport = false
local nearAuto = false
local nearTuner = false
local playerCoords = GetEntityCoords(PlayerPedId())

local bennyLocation = vector3(546.61352539062, -189.59159851074, 53.77131652832)

local bennyLocation2 = vector3(450.0, -976.04833984375, 24.96630)

local bennyLocationBridge = vector3(727.74, -1088.95, 22.17)

local billyLocationPaleto = vector3(110.8, 6626.46, 31.89)

local bennyLocationMRPD = vector3(450.01, -976.04, 25.03)

local bennyLocationTunershop2 = vector3(135.87, -3030.35, 7.04)

local bennyLocationHarmonyBay1 = vector3(1174.78, 2639.96, 37.73)
local bennyLocationHarmonyBay2 = vector3(1182.4747314453, 2639.8022460938, 37.148681640625)

local civrepairbennys = vector3(-38.980415344238, -1054.4558105469, 27.67400932312) -- Repair shop for civs in bennys
local bennyHeading = 31.181098937988

local bennyLocationHayes1 = vector3(-1423.9516601562, -449.57800292969, 35.295288085938)
local bennyLocationHayes2 = vector3(-1417.7406005859, -445.55603027344, 35.295288085938)

local bennyLocationIllegalShop = vector3(1033.3187255859, -2528.9538574219, 27.712768554688)
local bennyLocationSandyPD = vector3(1878.4317, 3696.0478, 32.934951)

local originalCategory = nil
local originalMod = nil
local originalPrimaryColour = nil
local originalSecondaryColour = nil
local originalPearlescentColour = nil
local originalWheelColour = nil
local originalDashColour = nil
local originalInterColour = nil
local originalWindowTint = nil
local originalWheelCategory = nil
local originalWheel = nil
local originalWheelType = nil
local originalCustomWheels = nil
local originalNeonLightState = nil
local originalNeonLightSide = nil
local originalNeonColourR = nil
local originalNeonColourG = nil
local originalNeonColourB = nil
local originalXenonColour = nil
local originalOldLivery = nil
local originalPlateIndex = nil

local attemptingPurchase = false
local isPurchaseSuccessful = false

--#[Local Functions]#--
local function isNear(pos1, pos2, distMustBe)
    local diff = pos2 - pos1
	local dist = (diff.x * diff.x) + (diff.y * diff.y)

	return (dist < (distMustBe * distMustBe))
end

local function saveVehicle()
    local plyPed = PlayerPedId()
    local veh = GetVehiclePedIsIn(plyPed, false)
    local vehicleMods = exports['warp-base']:FetchVehProps(veh)
    TriggerServerEvent('updateVehicle',vehicleMods,GetVehicleNumberPlateText(veh))  
end

--#[Global Functions]#--
function AttemptPurchase(type, upgradeLevel)
    local cheap = false

    if nearImport or nearTuner then
        cheap = true
    end

    if upgradeLevel ~= nil then
        upgradeLevel = upgradeLevel + 2
    end
    TriggerServerEvent("warp-bennys:attemptPurchase", type, upgradeLevel)

    attemptingPurchase = true

    while attemptingPurchase do
        Citizen.Wait(1)
    end

    if not isPurchaseSuccessful then
        PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    end

    return isPurchaseSuccessful
end

function RepairVehicle()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    SetVehicleFixed(plyVeh)
    SetVehicleDirtLevel(plyVeh, 0.0)
    SetVehiclePetrolTankHealth(plyVeh, 4000.0)
    TriggerEvent('veh.randomDegredation',10,plyVeh,3)
end

function GetCurrentMod(id)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local mod = GetVehicleMod(plyVeh, id)
    local modName = GetLabelText(GetModTextLabel(plyVeh, id, mod))

    return mod, modName
end

function GetCurrentWheel()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local wheel = GetVehicleMod(plyVeh, 23)
    local wheelName = GetLabelText(GetModTextLabel(plyVeh, 23, wheel))
    local wheelType = GetVehicleWheelType(plyVeh)

    return wheel, wheelName, wheelType
end

function GetCurrentCustomWheelState()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local state = GetVehicleModVariation(plyVeh, 23)

    if state then
        return 1
    else
        return 0
    end
end

function GetOriginalWheel()
    return originalWheel
end

function GetOriginalCustomWheel()
    return originalCustomWheels
end

function GetCurrentWindowTint()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    return GetVehicleWindowTint(plyVeh)
end

function GetCurrentVehicleWheelSmokeColour()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local r, g, b = GetVehicleTyreSmokeColor(plyVeh)

    return r, g, b
end

function GetCurrentNeonState(id)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local isEnabled = IsVehicleNeonLightEnabled(plyVeh, id)

    if isEnabled then
        return 1
    else
        return 0
    end
end

function GetCurrentNeonColour()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local r, g, b = GetVehicleNeonLightsColour(plyVeh)

    return r, g, b
end

function GetCurrentXenonState()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local isEnabled = IsToggleModOn(plyVeh, 22)

    if isEnabled then
        return 1
    else
        return 0
    end
end

function GetCurrentXenonColour()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    return GetVehicleHeadlightsColour(plyVeh)
end

function GetCurrentTurboState()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local isEnabled = IsToggleModOn(plyVeh, 18)

    if isEnabled then
        return 1
    else
        return 0
    end
end

function GetCurrentExtraState(extra)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    return IsVehicleExtraTurnedOn(plyVeh, extra)
end

function CheckValidMods(category, id, wheelType)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local tempMod = GetVehicleMod(plyVeh, id)
    local tempWheel = GetVehicleMod(plyVeh, 23)
    local tempWheelType = GetVehicleWheelType(plyVeh)
    local tempWheelCustom = GetVehicleModVariation(plyVeh, 23)
    local validMods = {}
    local amountValidMods = 0
    local hornNames = {}

    if wheelType ~= nil then
        SetVehicleWheelType(plyVeh, wheelType)
    end

    if id == 14 then
        for k, v in pairs(vehicleCustomisation) do 
            if vehicleCustomisation[k].category == category then
                hornNames = vehicleCustomisation[k].hornNames

                break
            end
        end
    end

    local modAmount = GetNumVehicleMods(plyVeh, id)
    for i = 1, modAmount do
        local label = GetModTextLabel(plyVeh, id, (i - 1))
        local modName = GetLabelText(label)

        if modName == "NULL" then
            if id == 14 then
                if i <= #hornNames then
                    modName = hornNames[i].name
                else
                    modName = "Horn " .. i
                end
            else
                modName = category .. " " .. i
            end
        end

        validMods[i] = 
        {
            id = (i - 1),
            name = modName
        }

        amountValidMods = amountValidMods + 1
    end

    if modAmount > 0 then
        table.insert(validMods, 1, {
            id = -1,
            name = "Stock " .. category
        })
    end

    if wheelType ~= nil then
        SetVehicleWheelType(plyVeh, tempWheelType)
        SetVehicleMod(plyVeh, 23, tempWheel, tempWheelCustom)
    end

    return validMods, amountValidMods
end

function RestoreOriginalMod()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    SetVehicleMod(plyVeh, originalCategory, originalMod)
    SetVehicleDoorsShut(plyVeh, true)

    originalCategory = nil
    originalMod = nil
end

function RestoreOriginalWindowTint()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    SetVehicleWindowTint(plyVeh, originalWindowTint)

    originalWindowTint = nil
end

function RestoreOriginalColours()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    SetVehicleColours(plyVeh, originalPrimaryColour, originalSecondaryColour)
    SetVehicleExtraColours(plyVeh, originalPearlescentColour, originalWheelColour)
    SetVehicleDashboardColour(plyVeh, originalDashColour)
    SetVehicleInteriorColour(plyVeh, originalInterColour)

    originalPrimaryColour = nil
    originalSecondaryColour = nil
    originalPearlescentColour = nil
    originalWheelColour = nil
    originalDashColour = nil
    originalInterColour = nil
end

function RestoreOriginalWheels()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local doesHaveCustomWheels = GetVehicleModVariation(plyVeh, 23)

    SetVehicleWheelType(plyVeh, originalWheelType)

    if originalWheelCategory ~= nil then
        SetVehicleMod(plyVeh, originalWheelCategory, originalWheel, originalCustomWheels)
        
        if GetVehicleClass(plyVeh) == 8 then --Motorcycle
            SetVehicleMod(plyVeh, 24, originalWheel, originalCustomWheels)
        end

        originalWheelType = nil
        originalWheelCategory = nil
        originalWheel = nil
        originalCustomWheels = nil
    end
end

function RestoreOriginalNeonStates()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    SetVehicleNeonLightEnabled(plyVeh, originalNeonLightSide, originalNeonLightState)

    originalNeonLightState = nil
    originalNeonLightSide = nil
end

function RestoreOriginalNeonColours()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    SetVehicleNeonLightsColour(plyVeh, originalNeonColourR, originalNeonColourG, originalNeonColourB)

    originalNeonColourR = nil
    originalNeonColourG = nil
    originalNeonColourB = nil
end

function RestoreOriginalXenonColour()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    SetVehicleHeadlightsColour(plyVeh, originalXenonColour)
    SetVehicleLights(plyVeh, 0)

    originalXenonColour = nil
end

function RestoreOldLivery()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    SetVehicleLivery(plyVeh, originalOldLivery)
end

function RestorePlateIndex()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    SetVehicleNumberPlateTextIndex(plyVeh, originalPlateIndex)
end

function PreviewMod(categoryID, modID)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    if originalMod == nil and originalCategory == nil then
        originalCategory = categoryID
        originalMod = GetVehicleMod(plyVeh, categoryID)
    end

    if categoryID == 39 or categoryID == 40 or categoryID == 41 then
        SetVehicleDoorOpen(plyVeh, 4, false, true)
    elseif categoryID == 37 or categoryID == 38 then
        SetVehicleDoorOpen(plyVeh, 5, false, true)
    end

    SetVehicleMod(plyVeh, categoryID, modID)
end

function PreviewWindowTint(windowTintID)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    if originalWindowTint == nil then
        originalWindowTint = GetVehicleWindowTint(plyVeh)
    end

    SetVehicleWindowTint(plyVeh, windowTintID)
end

function PreviewColour(paintType, paintCategory, paintID)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    SetVehicleModKit(plyVeh, 0)
    if originalDashColour == nil and originalInterColour == nil and originalPrimaryColour == nil and originalSecondaryColour == nil and originalPearlescentColour == nil and originalWheelColour == nil then
        originalPrimaryColour, originalSecondaryColour = GetVehicleColours(plyVeh)
        originalPearlescentColour, originalWheelColour = GetVehicleExtraColours(plyVeh)
        originalDashColour = GetVehicleDashboardColour(plyVeh)
        originalInterColour = GetVehicleInteriorColour(plyVeh)
    end
    if paintType == 0 then --Primary Colour
        if paintCategory == 1 then --Metallic Paint
            SetVehicleColours(plyVeh, paintID, originalSecondaryColour)
            SetVehicleExtraColours(plyVeh, originalPearlescentColour, originalWheelColour)
        else
            SetVehicleColours(plyVeh, paintID, originalSecondaryColour)
        end
    elseif paintType == 1 then --Secondary Colour
        SetVehicleColours(plyVeh, originalPrimaryColour, paintID)
    elseif paintType == 2 then --Pearlescent Colour
        SetVehicleExtraColours(plyVeh, paintID, originalWheelColour)
    elseif paintType == 3 then --Wheel Colour
        SetVehicleExtraColours(plyVeh, originalPearlescentColour, paintID)
    elseif paintType == 4 then --Dash Colour
        SetVehicleDashboardColour(plyVeh, paintID)
    elseif paintType == 5 then --Interior Colour
        SetVehicleInteriorColour(plyVeh, paintID)
    end
end

function PreviewWheel(categoryID, wheelID, wheelType)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local doesHaveCustomWheels = GetVehicleModVariation(plyVeh, 23)

    if originalWheelCategory == nil and originalWheel == nil and originalWheelType == nil and originalCustomWheels == nil then
        originalWheelCategory = categoryID
        originalWheelType = GetVehicleWheelType(plyVeh)
        originalWheel = GetVehicleMod(plyVeh, 23)
        originalCustomWheels = GetVehicleModVariation(plyVeh, 23)
    end

    SetVehicleWheelType(plyVeh, wheelType)
    SetVehicleMod(plyVeh, categoryID, wheelID, doesHaveCustomWheels)

    if GetVehicleClass(plyVeh) == 8 then --Motorcycle
        SetVehicleMod(plyVeh, 24, wheelID, doesHaveCustomWheels)
    end
end

function PreviewNeon(side, enabled)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    if originalNeonLightState == nil and originalNeonLightSide == nil then
        if IsVehicleNeonLightEnabled(plyVeh, side) then
            originalNeonLightState = 1
        else
            originalNeonLightState = 0
        end

        originalNeonLightSide = side
    end

    SetVehicleNeonLightEnabled(plyVeh, side, enabled)
end

function PreviewNeonColour(r, g, b)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    if originalNeonColourR == nil and originalNeonColourG == nil and originalNeonColourB == nil then
        originalNeonColourR, originalNeonColourG, originalNeonColourB = GetVehicleNeonLightsColour(plyVeh)
    end

    SetVehicleNeonLightsColour(plyVeh, r, g, b)
end

function PreviewXenonColour(colour)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    if originalXenonColour == nil then
        originalXenonColour = GetVehicleHeadlightsColour(plyVeh)
    end

    SetVehicleLights(plyVeh, 2)
    SetVehicleHeadlightsColour(plyVeh, colour)
end

function PreviewOldLivery(liv)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    if originalOldLivery == nil then
        originalOldLivery = GetVehicleLivery(plyVeh)
    end

    SetVehicleLivery(plyVeh, tonumber(liv))
end

function PreviewPlateIndex(index)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    if originalPlateIndex == nil then
        originalPlateIndex = GetVehicleNumberPlateTextIndex(plyVeh)
    end

    SetVehicleNumberPlateTextIndex(plyVeh, tonumber(index))
end

function ApplyMod(categoryID, modID)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    if categoryID == 18 then
        ToggleVehicleMod(plyVeh, categoryID, modID)
    elseif categoryID == 11 or categoryID == 12 or categoryID== 13 or categoryID == 15 or categoryID == 16 then --Performance Upgrades
        originalCategory = categoryID
        originalMod = modID

        SetVehicleMod(plyVeh, categoryID, modID)
    else
        originalCategory = categoryID
        originalMod = modID

        SetVehicleMod(plyVeh, categoryID, modID)
    end
end

function ApplyExtra(extraID)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local isEnabled = IsVehicleExtraTurnedOn(plyVeh, extraID)
    if isEnabled == 1 then
        SetVehicleExtra(plyVeh, tonumber(extraID), 1)
        SetVehiclePetrolTankHealth(plyVeh,4000.0)
    else
        SetVehicleExtra(plyVeh, tonumber(extraID), 0)
        SetVehiclePetrolTankHealth(plyVeh,4000.0)
    end
end

function ApplyPreset(presetId)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    SetVehicleColourCombination(plyVeh, presetId)

    originalPrimaryColour, originalSecondaryColour = GetVehicleColours(plyVeh)
    originalPearlescentColour, originalWheelColour = GetVehicleExtraColours(plyVeh)
end

function ApplyWindowTint(windowTintID)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    originalWindowTint = windowTintID

    SetVehicleWindowTint(plyVeh, windowTintID)
end

function ApplyColour(paintType, paintCategory, paintID)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local vehPrimaryColour, vehSecondaryColour = GetVehicleColours(plyVeh)
    local vehPearlescentColour, vehWheelColour = GetVehicleExtraColours(plyVeh)

    if paintType == 0 then --Primary Colour
        if paintCategory == 1 then --Metallic Paint
            SetVehicleColours(plyVeh, paintID, vehSecondaryColour)
            -- SetVehicleExtraColours(plyVeh, paintID, vehWheelColour)
            SetVehicleExtraColours(plyVeh, originalPearlescentColour, vehWheelColour)
            originalPrimaryColour = paintID
            -- originalPearlescentColour = paintID
        else
            SetVehicleColours(plyVeh, paintID, vehSecondaryColour)
            originalPrimaryColour = paintID
        end
    elseif paintType == 1 then --Secondary Colour
        SetVehicleColours(plyVeh, vehPrimaryColour, paintID)
        originalSecondaryColour = paintID
    elseif paintType == 2 then --Pearlescent Colour
        SetVehicleExtraColours(plyVeh, paintID, vehWheelColour)
        originalPearlescentColour = paintID
    elseif paintType == 3 then --Wheel Colour
        SetVehicleExtraColours(plyVeh, vehPearlescentColour, paintID)
        originalWheelColour = paintID
    elseif paintType == 4 then --Dash Colour
        SetVehicleDashboardColour(plyVeh, paintID)
        originalDashColour = paintID
    elseif paintType == 5 then --Interior Colour
        SetVehicleInteriorColour(plyVeh, paintID)
        originalInterColour = paintID
    end
end

function ApplyWheel(categoryID, wheelID, wheelType)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local doesHaveCustomWheels = GetVehicleModVariation(plyVeh, 23)

    originalWheelCategory = categoryID
    originalWheel = wheelID
    originalWheelType = wheelType

    SetVehicleWheelType(plyVeh, wheelType)
    SetVehicleMod(plyVeh, categoryID, wheelID, doesHaveCustomWheels)
    
    if GetVehicleClass(plyVeh) == 8 then --Motorcycle
        SetVehicleMod(plyVeh, 24, wheelID, doesHaveCustomWheels)
    end
end

function RestoreOriginalColourPresets()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    SetVehicleColours(plyVeh, originalPrimaryColour, originalSecondaryColour)
    SetVehicleExtraColours(plyVeh, originalPearlescentColour, originalWheelColour)

    originalPrimaryColour = nil
    originalSecondaryColour = nil
    originalPearlescentColour = nil
    originalWheelColour = nil
end

function PreviewColourPresets(presetId)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    SetVehicleModKit(plyVeh, 0)

    if originalPrimaryColour == nil and originalSecondaryColour == nil and originalPearlescentColour == nil and originalWheelColour == nil then
        originalPrimaryColour, originalSecondaryColour = GetVehicleColours(plyVeh)
        originalPearlescentColour, originalWheelColour = GetVehicleExtraColours(plyVeh)
    end

    SetVehicleColourCombination(plyVeh, presetId)
end

function ApplyCustomWheel(state)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    SetVehicleMod(plyVeh, 23, GetVehicleMod(plyVeh, 23), state)
    
    if GetVehicleClass(plyVeh) == 8 then --Motorcycle
        SetVehicleMod(plyVeh, 24, GetVehicleMod(plyVeh, 24), state)
    end
end

function ApplyNeon(side, enabled)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    originalNeonLightState = enabled
    originalNeonLightSide = side

    SetVehicleNeonLightEnabled(plyVeh, side, enabled)
end

function ApplyNeonColour(r, g, b)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    originalNeonColourR = r
    originalNeonColourG = g
    originalNeonColourB = b

    SetVehicleNeonLightsColour(plyVeh, r, g, b)
end

function ApplyXenonLights(category, state)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    ToggleVehicleMod(plyVeh, category, state)
end

function ApplyXenonColour(colour)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    originalXenonColour = colour

    SetVehicleHeadlightsColour(plyVeh, colour)
end

function ApplyOldLivery(liv)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    originalOldLivery = liv

    SetVehicleLivery(plyVeh, liv)
end

function ApplyPlateIndex(index)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    originalPlateIndex = index
    SetVehicleNumberPlateTextIndex(plyVeh, index)
end

function ApplyTyreSmoke(r, g, b)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    ToggleVehicleMod(plyVeh, 20, true)
    SetVehicleTyreSmokeColor(plyVeh, r, g, b)
end

function ExitBennys()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    saveVehicle()

    DisplayMenuContainer(false)

    FreezeEntityPosition(plyVeh, false)
    SetEntityCollision(plyVeh, true, true)

    SetTimeout(100, function()
        DestroyMenus()
    end)

    isPlyInBennys = false
end

RegisterNetEvent('event:control:bennys')
AddEventHandler('event:control:bennys', function(useID)
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        bennyHeading = 87.4
        if useID == 1 and not isPlyInBennys then -- Harmony 
            bennyHeading = 0.0
            enterLocation(bennyLocationHarmonyBay2)
        elseif useID == 2 and not isPlyInBennys then -- Hayes 
            bennyHeading = 31.181102752686
            enterLocation(bennyLocationHayes2)
        elseif useID == 6 and not isPlyInBennys then -- Bennys
            bennyHeading = 90.5
            enterLocation(bennyLocationMRPD)
        elseif useID == 8 and not isPlyInBennys then -- PD Bennys
            bennyHeading = 160.64
            enterLocation(bennyLocation2)
        elseif useID == 9 and not isPlyInBennys then -- Tunershop
            bennyHeading = 0
            enterLocation(bennyLocationTunershop2)
        elseif useID == 11 and not isPlyInBennys then -- Harmony 
            bennyHeading = 5
            enterLocation(bennyLocationHarmonyBay1)
        elseif useID == 12 and not isPlyInBennys then -- Hayes 
            bennyHeading = 31.181102752686
            enterLocation(bennyLocationHayes1)
        elseif useID == 14 and not isPlyInBennys then -- Dev
            print('bennys')
        elseif useID == 15 and not isPlyInBennys then -- Hayes 
            bennyHeading = 263.6220703125
            enterLocation(bennyLocationIllegalShop)
        elseif useID == 16 and not isPlyInBennys then -- Hayes 
            bennyHeading = 121.17162
            enterLocation(bennyLocationSandyPD)
        end
    end
end)

function enterLocation(locationsPos)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local isMotorcycle = false

    SetVehicleModKit(plyVeh, 0)
    SetEntityCoords(plyVeh, locationsPos)
    SetEntityHeading(plyVeh, bennyHeading)
    FreezeEntityPosition(plyVeh, true)
    SetEntityCollision(plyVeh, false, true)

    if GetVehicleClass(plyVeh) == 8 then --Motorcycle
        isMotorcycle = true
    else
        isMotorcycle = false
    end

    InitiateMenus(isMotorcycle, GetVehicleBodyHealth(plyVeh))

    SetTimeout(100, function()
        if GetVehicleBodyHealth(plyVeh) < 1000.0 then
            DisplayMenu(true, "repairMenu")
        else
            DisplayMenu(true, "mainMenu")
        end
        
        DisplayMenuContainer(true)
        PlaySoundFrontend(-1, "OK", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    end)

    isPlyInBennys = true
end

function enterLocationDev(locationsPos)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local isMotorcycle = false

    SetVehicleModKit(plyVeh, 0)
    isDev = true

    -- SetEntityCollision(plyVeh, false, true)

    if GetVehicleClass(plyVeh) == 8 then --Motorcycle
        isMotorcycle = true
    else
        isMotorcycle = false
    end

    InitiateMenus(isMotorcycle, GetVehicleBodyHealth(plyVeh))

    SetTimeout(100, function()
        if GetVehicleBodyHealth(plyVeh) < 1000.0 then
            DisplayMenu(true, "repairMenu")
        else
            DisplayMenu(true, "mainMenu")
        end
        
        DisplayMenuContainer(true)
        PlaySoundFrontend(-1, "OK", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    end)

    isPlyInBennys = true
end


function disableControls()
    DisableControlAction(1, 38, true) --Key: E
    DisableControlAction(1, 172, true) --Key: Up Arrow
    DisableControlAction(1, 173, true) --Key: Down Arrow
    DisableControlAction(1, 177, true) --Key: Backspace
    DisableControlAction(1, 176, true) --Key: Enter
    DisableControlAction(1, 71, true) --Key: W (veh_accelerate)
    DisableControlAction(1, 72, true) --Key: S (veh_brake)
    DisableControlAction(1, 34, true) --Key: A
    DisableControlAction(1, 35, true) --Key: D
    DisableControlAction(1, 75, true) --Key: F (veh_exit)

    if IsDisabledControlJustReleased(1, 172) then --Key: Arrow Up
        MenuScrollFunctionality("up")
        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    end

    if IsDisabledControlJustReleased(1, 173) then --Key: Arrow Down
        MenuScrollFunctionality("down")
        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    end

    if IsDisabledControlJustReleased(1, 176) then --Key: Enter
        MenuManager(true)
        PlaySoundFrontend(-1, "OK", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    end

    if IsDisabledControlJustReleased(1, 177) then --Key: Backspace
        MenuManager(false)
        PlaySoundFrontend(-1, "NO", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    end
end

Citizen.CreateThread(function()
    while true do 
        local plyPed = PlayerPedId()

        if IsPedInAnyVehicle(plyPed, false) then
            local plyPos = GetEntityCoords(plyPed)

            nearBridge = isNear(plyPos, bennyLocationBridge, 10)

            if nearBridge then

                if not isPlyInBennys and nearBridge then
                    -- DrawMarker(21, bennyLocationBridge.x, bennyLocationBridge.y, bennyLocationBridge.z + 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 148, 0, 211, 255, true, false, 2, true, nil, nil, false)
                end

                if not isPlyInBennys then
                    -- Draw3DText(bennyLocationBridge.x, bennyLocationBridge.y, bennyLocationBridge.z + 0.5, "[Press ~p~E~w~ - Enter Benny's Motorworks]", 255, 255, 255, 255, 4, 0.45, true, true, true, true, 0, 0, 0, 0, 55)
                    if IsControlJustReleased(1, 38) then
                        -- TriggerEvent('event:control:bennys', 4)
                    end
                else
                    disableControls()
                end
            else
                Wait(1000)
            end
        else
            Wait(2000)
        end

        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do 
        local plyPed = PlayerPedId()

        if IsPedInAnyVehicle(plyPed, false) then
            local plyPos = GetEntityCoords(plyPed)

            nearDefault = isNear(plyPos, bennyLocation, 10) 

            if nearDefault then

                if not isPlyInBennys and nearDefault then
                    -- DrawMarker(21, bennyLocation.x, bennyLocation.y, bennyLocation.z + 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 148, 0, 211, 255, true, false, 2, true, nil, nil, false)
                end

                if not isPlyInBennys then
                    -- Draw3DText(bennyLocation.x, bennyLocation.y, bennyLocation.z + 0.5, "[Press ~p~E~w~ - Benny's Motorworks]", 255, 255, 255, 255, 4, 0.45, true, true, true, true, 0, 0, 0, 0, 55)
                    if IsControlJustReleased(1, 38) then
                        -- TriggerEvent('event:control:bennys', 1)
                    end
                else
                    disableControls()
                end
            else
                Wait(1000)
            end
        else
            Wait(2000)
        end

        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do 
        local plyPed = PlayerPedId()

        if IsPedInAnyVehicle(plyPed, false) then
            local plyPos = GetEntityCoords(plyPed)

            nearDefault = isNear(plyPos, bennyLocation2, 10) 

            if nearDefault and exports["isPed"]:isPed("myJob") == 'police' or exports["isPed"]:isPed("myJob") == 'sheriff' or exports["isPed"]:isPed("myJob") == 'state' or exports["isPed"]:isPed("myJob") == 'ems' then

                if not isPlyInBennys and nearDefault then
                    -- DrawMarker(21, bennyLocation2.x, bennyLocation2.y, bennyLocation2.z + 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 148, 0, 211, 255, true, false, 2, true, nil, nil, false)
                end

                if not isPlyInBennys then
                    -- Draw3DText(bennyLocation2.x, bennyLocation2.y, bennyLocation2.z + 0.5, "[Press ~p~E~w~ - Police Motorworks]", 255, 255, 255, 255, 4, 0.45, true, true, true, true, 0, 0, 0, 0, 55)
                    if IsControlJustReleased(1, 38) then
                        -- TriggerEvent('event:control:bennys', 3)
                    end
                else
                    disableControls()
                end
            else
                Wait(1000)
            end
        else
            Wait(2000)
        end

        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do 
        local plyPed = PlayerPedId()

        if IsPedInAnyVehicle(plyPed, false) then
            local plyPos = GetEntityCoords(plyPed)

            nearDefault = isNear(plyPos, bennyLocationHarmonyBay1, 1) 


            if nearDefault or isDev == true then

                if not isPlyInBennys and nearDefault then
                    -- DrawMarker(21, bennyLocationHarmonyBay1.x, bennyLocationHarmonyBay1.y, bennyLocationHarmonyBay1.z + 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 148, 0, 211, 255, true, false, 2, true, nil, nil, false)
                end

                if not isPlyInBennys then
                    -- Draw3DText(bennyLocationHarmonyBay1.x, bennyLocationHarmonyBay1.y, bennyLocationHarmonyBay1.z + 0.5, "[Press ~p~E~w~ - Benny's Motorworks]", 255, 255, 255, 255, 4, 0.45, true, true, true, true, 0, 0, 0, 0, 55)
                    if IsControlJustReleased(1, 38) then
                        -- TriggerEvent('event:control:bennys', 1)
                    end
                else
                    disableControls()
                end
            else
                Wait(1000)
            end
        else
            Wait(2000)
        end

        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do 
        local plyPed = PlayerPedId()

        if IsPedInAnyVehicle(plyPed, false) then
            local plyPos = GetEntityCoords(plyPed)

            nearDefault = isNear(plyPos, bennyLocationTunershop2, 1) 


            if nearDefault or isDev == true then

                if not isPlyInBennys and nearDefault then
                    -- DrawMarker(21, bennyLocationTunershop2.x, bennyLocationTunershop2.y, bennyLocationTunershop2.z + 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 148, 0, 211, 255, true, false, 2, true, nil, nil, false)
                end

                if not isPlyInBennys then
                    -- Draw3DText(bennyLocationTunershop2.x, bennyLocationTunershop2.y, bennyLocationTunershop2.z + 0.5, "[Press ~p~E~w~ - Benny's Motorworks]", 255, 255, 255, 255, 4, 0.45, true, true, true, true, 0, 0, 0, 0, 55)
                    if IsControlJustReleased(1, 38) then
                        -- TriggerEvent('event:control:bennys', 1)
                    end
                else
                    disableControls()
                end
            else
                Wait(1000)
            end
        else
            Wait(2000)
        end

        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do 
        local plyPed = PlayerPedId()

        if IsPedInAnyVehicle(plyPed, false) then
            local plyPos = GetEntityCoords(plyPed)

            nearDefault = isNear(plyPos, bennyLocationHarmonyBay2, 16) 


            if nearDefault or isDev == true then

                if not isPlyInBennys and nearDefault then
                    -- DrawMarker(21, bennyLocationHarmonyBay2.x, bennyLocationHarmonyBay2.y, bennyLocationHarmonyBay2.z + 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 148, 0, 211, 255, true, false, 2, true, nil, nil, false)
                end

                if not isPlyInBennys then
                    -- Draw3DText(bennyLocationHarmonyBay2.x, bennyLocationHarmonyBay2.y, bennyLocationHarmonyBay2.z + 0.5, "[Press ~p~E~w~ - Benny's Motorworks]", 255, 255, 255, 255, 4, 0.45, true, true, true, true, 0, 0, 0, 0, 55)
                    if IsControlJustReleased(1, 38) then
                        -- TriggerEvent('event:control:bennys', 1)
                    end
                else
                    disableControls()
                end
            else
                Wait(1000)
            end
        else
            Wait(2000)
        end

        Citizen.Wait(1)
    end
end)

-- Hayes Bay 1 --

Citizen.CreateThread(function()
    while true do 
        local plyPed = PlayerPedId()

        if IsPedInAnyVehicle(plyPed, false) then
            local plyPos = GetEntityCoords(plyPed)

            nearDefault = isNear(plyPos, bennyLocationHayes1, 12) 


            if nearDefault or isDev == true then

                if not isPlyInBennys and nearDefault then
                    -- DrawMarker(21, bennyLocationHayes1.x, bennyLocationHayes1.y, bennyLocationHayes1.z + 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 148, 0, 211, 255, true, false, 2, true, nil, nil, false)
                end

                if not isPlyInBennys then
                    -- Draw3DText(bennyLocationHayes1.x, bennyLocationHayes1.y, bennyLocationHayes1.z + 0.5, "[Press ~p~E~w~ - Benny's Motorworks]", 255, 255, 255, 255, 4, 0.45, true, true, true, true, 0, 0, 0, 0, 55)
                    if IsControlJustReleased(1, 38) then
                        -- TriggerEvent('event:control:bennys', 12)
                    end
                else
                    disableControls()
                end
            else
                Wait(1000)
            end
        else
            Wait(2000)
        end

        Citizen.Wait(1)
    end
end)

-- Illegal Shop --

Citizen.CreateThread(function()
    while true do 
        local plyPed = PlayerPedId()

        if IsPedInAnyVehicle(plyPed, false) then
            local plyPos = GetEntityCoords(plyPed)

            nearDefault = isNear(plyPos, bennyLocationIllegalShop, 15) 

            if nearDefault or isDev == true then

                if not isPlyInBennys and nearDefault then
                    -- DrawMarker(21, bennyLocationIllegalShop.x, bennyLocationIllegalShop.y, bennyLocationIllegalShop.z + 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 148, 0, 211, 255, true, false, 2, true, nil, nil, false)
                end

                if not isPlyInBennys then
                    -- Draw3DText(bennyLocationIllegalShop.x, bennyLocationIllegalShop.y, bennyLocationIllegalShop.z + 0.5, "[Press ~p~E~w~ - Benny's Motorworks]", 255, 255, 255, 255, 4, 0.45, true, true, true, true, 0, 0, 0, 0, 55)
                    if IsControlJustReleased(1, 38) then
                        -- TriggerEvent('event:control:bennys', 12)
                    end
                else
                    disableControls()
                end
            else
                Wait(1000)
            end
        else
            Wait(2000)
        end

        Citizen.Wait(1)
    end
end)

-- Sandy PD --

Citizen.CreateThread(function()
    while true do 
        local plyPed = PlayerPedId()

        if IsPedInAnyVehicle(plyPed, false) then
            local plyPos = GetEntityCoords(plyPed)

            nearDefault = isNear(plyPos, bennyLocationSandyPD, 15) 

            if nearDefault or isDev == true then

                if not isPlyInBennys and nearDefault then
                    -- DrawMarker(21, bennyLocationSandyPD.x, bennyLocationSandyPD.y, bennyLocationSandyPD.z + 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 148, 0, 211, 255, true, false, 2, true, nil, nil, false)
                end

                if not isPlyInBennys then
                    -- Draw3DText(bennyLocationSandyPD.x, bennyLocationSandyPD.y, bennyLocationSandyPD.z + 0.5, "[Press ~p~E~w~ - Benny's Motorworks]", 255, 255, 255, 255, 4, 0.45, true, true, true, true, 0, 0, 0, 0, 55)
                    if IsControlJustReleased(1, 38) then
                        -- TriggerEvent('event:control:bennys', 12)
                    end
                else
                    disableControls()
                end
            else
                Wait(1000)
            end
        else
            Wait(2000)
        end

        Citizen.Wait(1)
    end
end)

--#[Event Handlers]#--
RegisterNetEvent("warp-bennys:purchaseSuccessful")
AddEventHandler("warp-bennys:purchaseSuccessful", function()
    isPurchaseSuccessful = true
    attemptingPurchase = false
end)

RegisterNetEvent("warp-bennys:purchaseFailed")
AddEventHandler("warp-bennys:purchaseFailed", function()
    isPurchaseSuccessful = false
    attemptingPurchase = false
end)



Citizen.CreateThread(function()
    --FISHING
    exports["warp-polyzone"]:AddBoxZone("bennyslocation", vector3(-39.5, -1054.39, 28.4), 6, 4, {
        name="bennyslocation",
        heading=340,
        -- debugPoly=true,
        minZ=27.0,
        maxZ=31.0
    }) 
      
    exports["warp-polyzone"]:AddBoxZone("benny4", vector3(450.16, -975.93, 25.7), 10, 5, {
        name="benny4",
        heading=270,
        --debugPoly=true,
        minZ=24.7,
        maxZ=28.7
      })
      

    exports["warp-polyzone"]:AddBoxZone("benny7", vector3(921.81, -984.47, 38.89), 10, 5, {
        name="benny7",
        heading=270,
        --debugPoly=true,
        minZ=38.70,
        maxZ=41.23
      })
      
end)



AddEventHandler('warp-polyzone:enter', function(name)
        if name == "bennyslocation" and IsPedInAnyVehicle(PlayerPedId()) and not isPlyInBennys then
            exports['warp-textui']:showInteraction("Benny's")

        elseif name == "benny4" and IsPedInAnyVehicle(PlayerPedId()) and not isPlyInBennys then
            exports['warp-textui']:showInteraction("Benny's")

        elseif name == "benny7" and IsPedInAnyVehicle(PlayerPedId()) and not isPlyInBennys then
            exports['warp-textui']:showInteraction("TunerShop (Workers Only)")

    end
end)

RegisterNetEvent('enter:benny')
AddEventHandler('enter:benny', function()
    TriggerEvent('event:control:bennys', 1)
    disabled = true
    disableControls()
end)

RegisterNetEvent('enter:benny:mrpd')
AddEventHandler('enter:benny:mrpd', function()
    local job = exports["isPed"]:isPed("myJob")
	if (job == "police" or job == "sheriff" or job == "state" or exports["isPed"]:isPed("myJob") == 'ems') then
    TriggerEvent('event:control:bennys', 6)
    disabled = true
      disableControls()
    end 
end)

RegisterNetEvent('enter:benny:tunershop')
AddEventHandler('enter:benny:tunershop', function()
    local job = exports["isPed"]:GroupRank("tuner_shop")
    if job > 1 then 
    TriggerEvent('event:control:bennys', 9)
    disabled = true
      disableControls()
    else
        TriggerEvent('DoLongHudText','You Need A TunerShop Worker To Help You', 2)
    end
end)

RegisterNetEvent('enter:benny:hayes')
AddEventHandler('enter:benny:hayes', function()
    local job = exports["isPed"]:GroupRank("hayes_autos")
    if job > 1 then 
    TriggerEvent('event:control:bennys', 12)
    isPlyInBennys = true
    disabled = true
    disableControls()
    end
end)

RegisterNetEvent('enter:benny:hayes2')
AddEventHandler('enter:benny:hayes2', function()
    local job = exports["isPed"]:GroupRank("hayes_autos")
    if job > 1 then 
    TriggerEvent('event:control:bennys', 2)
    isPlyInBennys = true
    disabled = true
    disableControls()
    end
end)

RegisterNetEvent('enter:benny:illegal')
AddEventHandler('enter:benny:illegal', function()
    local job = exports["isPed"]:GroupRank("illegal_shop")
    if job > 2 then 
    TriggerEvent('event:control:bennys', 15)
    isPlyInBennys = true
    disabled = true
    disableControls()
    end
end)

RegisterNetEvent('enter:benny:harmony')
AddEventHandler('enter:benny:harmony', function()
    local job = exports["isPed"]:GroupRank("harmony_autos")
    if job > 1 then 
    TriggerEvent('event:control:bennys', 11)
    disabled = true
      disableControls()
    else
        TriggerEvent('DoLongHudText','You Need A Harmony Worker To Help You', 2)
    end
end)

RegisterNetEvent('enter:benny:harmony2')
AddEventHandler('enter:benny:harmony2', function()
    local job = exports["isPed"]:GroupRank("harmony_autos")
    if job > 1 then 
    TriggerEvent('event:control:bennys', 1)
    disabled = true
      disableControls()
    else
        TriggerEvent('DoLongHudText','You Need A Harmony Worker To Help You', 2)
    end
end)

RegisterNetEvent("bennys:civ:repair:cl", function()
    local car = GetVehiclePedIsIn(PlayerPedId(), false)
    if car ~= 0 then
        FreezeEntityPosition(car, true)
        SetEntityCoords(car, -39.454944610596, -1053.0329589844, 28.403686523438)
        SetEntityHeading(GetPlayerPed(-1), 158.74015808105)
        local finished = exports["warp-taskbar"]:taskBar(4000,"Repairing Engine",false,false,playerVeh)
        Citizen.Wait(1000)
        local finished = exports["warp-taskbar"]:taskBar(3000,"Repairing Body",false,false,playerVeh)
        if (finished == 100) then
            TriggerEvent("DoShortHudText", "Repair's complete !")
            SetVehicleFixed(car)
            SetVehicleDirtLevel(car, 0)
            SetVehicleDeformationFixed(car)
            SetVehicleUndriveable(car, false)
            FreezeEntityPosition(car, false)
        else
            FreezeEntityPosition(car, false)
        end
    end
end)

RegisterNetEvent('dreams-public-bennys')
AddEventHandler('dreams-public-bennys', function()
    TriggerServerEvent('dreams:bennys:pay1')
end)

--// Polyzones

-- Hayes

DreamsHayesShit = false

Citizen.CreateThread(function()
    exports["warp-polyzone"]:AddBoxZone("hayes_autos_bennys_shit_show_ui", vector3(-1423.92, -449.78, 35.88), 4, 8.0, {
        name="hayes_autos_bennys_shit_show_ui",
        heading=300,
        --debugPoly=true,
        minZ=34.08,
        maxZ=38.08
    })
end)

RegisterNetEvent('warp-polyzone:enter')
AddEventHandler('warp-polyzone:enter', function(name)
    if name == "hayes_autos_bennys_shit_show_ui" and IsPedInAnyVehicle(PlayerPedId(), false) then
        DreamsHayesShit = true     
            local rank = exports["isPed"]:GroupRank("hayes_autos")
            if rank > 1 then 
            exports['warp-textui']:showInteraction("Bennys")
        end
    end
end)

RegisterNetEvent('warp-polyzone:exit')
AddEventHandler('warp-polyzone:exit', function(name)
    if name == "hayes_autos_bennys_shit_show_ui" and IsPedInAnyVehicle(PlayerPedId(), false) then
        DreamsHayesShit = false
        exports['warp-textui']:hideInteraction()
    end
end)

DreamsHayesShit2 = false

Citizen.CreateThread(function()
    exports["warp-polyzone"]:AddBoxZone("hayes_autos_bennys_shit_show_ui2", vector3(-1417.49, -445.91, 35.91), 4, 6.8, {
        name="hayes_autos_bennys_shit_show_ui2",
        heading=300,
        --debugPoly=true,
        minZ=33.11,
        maxZ=37.11
    })
end)

RegisterNetEvent('warp-polyzone:enter')
AddEventHandler('warp-polyzone:enter', function(name)
    if name == "hayes_autos_bennys_shit_show_ui2" and IsPedInAnyVehicle(PlayerPedId(), false) then
        DreamsHayesShit2 = true     
            local rank = exports["isPed"]:GroupRank("hayes_autos")
            if rank > 1 then 
            exports['warp-textui']:showInteraction("Bennys")
        end
    end
end)

RegisterNetEvent('warp-polyzone:exit')
AddEventHandler('warp-polyzone:exit', function(name)
    if name == "hayes_autos_bennys_shit_show_ui2" and IsPedInAnyVehicle(PlayerPedId(), false) then
        DreamsHayesShit2 = false
        exports['warp-textui']:hideInteraction()
    end
end)

-- Harmony

DreamsHarmonyShit = false

Citizen.CreateThread(function()
    exports["warp-polyzone"]:AddBoxZone("harmony_bennys_shit_show_ui", vector3(1174.77, 2640.18, 37.75), 4, 6.8, {
        name="harmony_bennys_shit_show_ui",
        heading=270,
        --debugPoly=true,
        minZ=34.75,
        maxZ=38.75
    })
end)

RegisterNetEvent('warp-polyzone:enter')
AddEventHandler('warp-polyzone:enter', function(name)
    if name == "harmony_bennys_shit_show_ui" and IsPedInAnyVehicle(PlayerPedId()) then
        DreamsHarmonyShit = true     
            local rank = exports["isPed"]:GroupRank("harmony_autos")
            if rank > 1 then 
            exports['warp-textui']:showInteraction("Bennys")
        end
    end
end)

RegisterNetEvent('warp-polyzone:exit')
AddEventHandler('warp-polyzone:exit', function(name)
    if name == "harmony_bennys_shit_show_ui" then
        DreamsHarmonyShit = false
        exports['warp-textui']:hideInteraction()
    end
end)

-- 2 --

DreamsHarmonyShit2 = false

Citizen.CreateThread(function()
    exports["warp-polyzone"]:AddBoxZone("harmony_bennys_shit_show_ui2", vector3(1182.38, 2639.75, 37.75), 4, 6.8, {
        name="harmony_bennys_shit_show_ui2",
        heading=270,
        --debugPoly=true,
        minZ=35.75,
        maxZ=39.75
    })
end)

RegisterNetEvent('warp-polyzone:enter')
AddEventHandler('warp-polyzone:enter', function(name)
    if name == "harmony_bennys_shit_show_ui2" and IsPedInAnyVehicle(PlayerPedId()) then
        DreamsHarmonyShit2 = true     
            local rank = exports["isPed"]:GroupRank("harmony_autos")
            if rank > 1 then 
            exports['warp-textui']:showInteraction("Bennys")
        end
    end
end)

RegisterNetEvent('warp-polyzone:exit')
AddEventHandler('warp-polyzone:exit', function(name)
    if name == "harmony_bennys_shit_show_ui2" then
        DreamsHarmonyShit2 = false
        exports['warp-textui']:hideInteraction()
    end
end)

-- Racing Place

DreamsRacingPlace = false

Citizen.CreateThread(function()
    exports["warp-polyzone"]:AddBoxZone("dreams_racing_shit_warehouse", vector3(1032.62, -2528.45, 28.29), 3, 7.0, {
        name="dreams_racing_shit_warehouse",
        heading=355,
        --debugPoly=true,
        minZ=26.09,
        maxZ=30.09
    })
end)

RegisterNetEvent('warp-polyzone:enter')
AddEventHandler('warp-polyzone:enter', function(name)
    if name == "dreams_racing_shit_warehouse" and IsPedInAnyVehicle(PlayerPedId(), false) then
        DreamsRacingPlace = true     
            local rank = exports["isPed"]:GroupRank("illegal_shop")
            if rank > 1 then 
            exports['warp-textui']:showInteraction("Bennys")
        end
    end
end)

RegisterNetEvent('warp-polyzone:exit')
AddEventHandler('warp-polyzone:exit', function(name)
    if name == "dreams_racing_shit_warehouse" and IsPedInAnyVehicle(PlayerPedId(), false) then
        DreamsRacingPlace = false
        exports['warp-textui']:hideInteraction()
    end
end)

RegisterNetEvent("warp-driftschool:repair_vehicle")
AddEventHandler('warp-driftschool:repair_vehicle', function()
    local rank = exports["isPed"]:GroupRank("drift_school")
    if rank > 1 then 
        local car = GetVehiclePedIsIn(PlayerPedId(), false)
        if car ~= 0 then
            FreezeEntityPosition(car, true)
            SetEntityCoords(car, -167.4725189209,-2460.7648925781,5.9091796875)
            SetEntityHeading(GetPlayerPed(-1), 133.22833251953)
            local finished = exports["warp-taskbar"]:taskBar(4000,"Repairing Engine",false,false,playerVeh)
            Citizen.Wait(1000)
            local finished = exports["warp-taskbar"]:taskBar(3000,"Repairing Body",false,false,playerVeh)
            if (finished == 100) then
                TriggerEvent("DoShortHudText", "Repair Complete")
                SetVehicleFixed(car)
                SetVehicleDirtLevel(car, 0)
                SetVehicleDeformationFixed(car)
                SetVehicleUndriveable(car, false)
                FreezeEntityPosition(car, false)
            else
                FreezeEntityPosition(car, false)
                SetVehicleUndriveable(car, false)
            end
        end
    end
end)

DreamsDriftSchool = false

Citizen.CreateThread(function()
    exports["warp-polyzone"]:AddBoxZone("dreams_drift_bennys_repair", vector3(-167.33, -2460.88, 6.32), 5, 7, {
        name="dreams_drift_bennys_repair",
        heading=45,
        --debugPoly=true,
        minZ=5.12,
        maxZ=9.12
    })
end)

RegisterNetEvent('warp-polyzone:enter')
AddEventHandler('warp-polyzone:enter', function(name)
    if name == "dreams_drift_bennys_repair" and IsPedInAnyVehicle(PlayerPedId()) then
        DreamsDriftSchool = true     
            local rank = exports["isPed"]:GroupRank("drift_school")
            if rank > 1 then 
            exports['warp-textui']:showInteraction("Bennys")
        end
    end
end)

RegisterNetEvent('warp-polyzone:exit')
AddEventHandler('warp-polyzone:exit', function(name)
    if name == "dreams_drift_bennys_repair" then
        DreamsDriftSchool = false
        exports['warp-textui']:hideInteraction()
    end
end)