Citizen.CreateThread(function()
    Wait(10000)
    -- RequestIpl('vw_casino_main')
    -- RequestIpl('vw_dlc_casino_door')
    -- RequestIpl('hei_dlc_casino_door')
    RequestIpl("hei_dlc_windows_casino")
    -- RequestIpl("vw_casino_penthouse")
    SetIplPropState(274689, "Set_Pent_Tint_Shell", true, true)
    SetInteriorEntitySetColor(274689, "Set_Pent_Tint_Shell", 3)
    -- RequestIpl("vw_casino_carpark")
    -- RequestIpl("vw_casino_garage")
    -- RequestIpl("hei_dlc_windows_casino_lod")
    -- RequestIpl("hei_dlc_casino_aircon")
    -- RequestIpl("hei_dlc_casino_aircon_lod")
    -- RequestIpl("hei_dlc_casino_door")
    -- RequestIpl("hei_dlc_casino_door_lod")
    -- RequestIpl("hei_dlc_vw_roofdoors_locked")
    -- RequestIpl("vw_ch3_additions")
    -- RequestIpl("vw_ch3_additions_long_0")
    -- RequestIpl("vw_ch3_additions_strm_0")
    -- RequestIpl("vw_dlc_casino_door")
    -- RequestIpl("vw_dlc_casino_door_lod")
    -- RequestIpl("vw_casino_billboard")
    -- RequestIpl("vw_casino_billboard_lod(1)")
    -- RequestIpl("vw_casino_billboard_lod")
    -- RequestIpl("vw_int_placement_vw")
    -- RequestIpl("vw_dlc_casino_apart")
    local interiorId = GetInteriorAtCoords(1032.22,40.71,69.87)
    casinoInteriorId = interiorId
  
    if IsValidInterior(interiorId) then
      RefreshInterior(interiorId)
    end
  end)


  function IsTable(T)
    return type(T) == 'table'
  end
  function SetIplPropState(interiorId, props, state, refresh)
    if refresh == nil then refresh = false end
    if IsTable(interiorId) then
        for key, value in pairs(interiorId) do
            SetIplPropState(value, props, state, refresh)
        end
    else
        if IsTable(props) then
            for key, value in pairs(props) do
                SetIplPropState(interiorId, value, state, refresh)
            end
        else
            if state then
                if not IsInteriorPropEnabled(interiorId, props) then EnableInteriorProp(interiorId, props) end
            else
                if IsInteriorPropEnabled(interiorId, props) then DisableInteriorProp(interiorId, props) end
            end
        end
        if refresh == true then RefreshInterior(interiorId) end
    end
  end