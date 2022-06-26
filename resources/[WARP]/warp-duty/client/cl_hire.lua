-- POLICE HIRE/FIRE --

RegisterNetEvent("warp-duty:HireLaw:Menu")
AddEventHandler("warp-duty:HireLaw:Menu", function()
    local valid = exports["warp-applications"]:KeyboardInput({
        header = "Hire Menu",
        rows = {
            {
                id = 0,
                txt = "Enter CID"
            },
            {
                id = 1,
                txt = "Enter Department"
            },
            {
                id = 2,
                txt = "Enter Rank"
            },
        }
    })
    if valid then
        TriggerServerEvent("warp-duty:HireLaw", valid[1].input, valid[2].input, valid[3].input)
    end
end)

RegisterNetEvent("warp-duty:FireLaw:Menu")
AddEventHandler("warp-duty:FireLaw:Menu", function()
    local valid = exports["warp-applications"]:KeyboardInput({
        header = "Fire Menu",
        rows = {
            {
                id = 0,
                txt = "Enter CID"
            },
        }
    })
    if valid then
        TriggerServerEvent("warp-duty:FireLaw", valid[1].input)
    end
end)

-- END POLICE HIRE/FIRE --

-- EMS HIRE/FIRE --

RegisterNetEvent("warp-duty:HireEMS:Menu")
AddEventHandler("warp-duty:HireEMS:Menu", function()
    local valid = exports["warp-applications"]:KeyboardInput({
        header = "Hire Menu",
        rows = {
            {
                id = 0,
                txt = "Enter CID"
            },
            {
                id = 1,
                txt = "Enter Rank"
            },
        }
    })
    if valid then
        TriggerServerEvent("warp-duty:HireEMS", valid[1].input, valid[2].input)
    end
end)

RegisterNetEvent("warp-duty:FireEMS:Menu")
AddEventHandler("warp-duty:FireEMS:Menu", function()
    local valid = exports["warp-applications"]:KeyboardInput({
        header = "Fire Menu",
        rows = {
            {
                id = 0,
                txt = "Enter CID"
            },
        }
    })
    if valid then
        TriggerServerEvent("warp-duty:FireEMS", valid[1].input)
    end
end)

-- END EMS HIRE/FIRE --

-- Burgershot HIRE/FIRE --

RegisterNetEvent("warp-duty:HireBurger:Menu")
AddEventHandler("warp-duty:HireBurger:Menu", function()
    local valid = exports["warp-applications"]:KeyboardInput({
        header = "Hire Menu",
        rows = {
            {
                id = 0,
                txt = "Enter CID"
            },
            {
                id = 1,
                txt = "Enter Rank"
            },
        }
    })
    if valid then
        TriggerServerEvent("warp-duty:HireBurger", valid[1].input, valid[2].input)
    end
end)

RegisterNetEvent("warp-duty:FireBurger:Menu")
AddEventHandler("warp-duty:FireBurger:Menu", function()
    local valid = exports["warp-applications"]:KeyboardInput({
        header = "Fire Menu",
        rows = {
            {
                id = 0,
                txt = "Enter CID"
            },
        }
    })
    if valid then
        TriggerServerEvent("warp-duty:FireBurger", valid[1].input)
    end
end)

-- END Burgershot HIRE/FIRE --

-- Art Gallery HIRE/FIRE --

RegisterNetEvent("warp-duty:HireArt:Menu")
AddEventHandler("warp-duty:HireArt:Menu", function()
    local valid = exports["warp-applications"]:KeyboardInput({
        header = "Hire Menu",
        rows = {
            {
                id = 0,
                txt = "Enter CID"
            },
            {
                id = 1,
                txt = "Enter Rank"
            },
        }
    })
    if valid then
        TriggerServerEvent("warp-duty:HireArt", valid[1].input, valid[2].input)
    end
end)

RegisterNetEvent("warp-duty:FireArt:Menu")
AddEventHandler("warp-duty:FireArt:Menu", function()
    local valid = exports["warp-applications"]:KeyboardInput({
        header = "Fire Menu",
        rows = {
            {
                id = 0,
                txt = "Enter CID"
            },
        }
    })
    if valid then
        TriggerServerEvent("warp-duty:FireArt", valid[1].input)
    end
end)

-- END Art Gallery HIRE/FIRE --

-- PDM HIRE/FIRE --

RegisterNetEvent("warp-duty:HirePDM:Menu")
AddEventHandler("warp-duty:HirePDM:Menu", function()
    local valid = exports["warp-applications"]:KeyboardInput({
        header = "Hire Menu",
        rows = {
            {
                id = 0,
                txt = "Enter CID"
            },
            {
                id = 1,
                txt = "Enter Rank"
            },
        }
    })
    if valid then
        TriggerServerEvent("warp-duty:HirePDM", valid[1].input, valid[2].input)
    end
end)

RegisterNetEvent("warp-duty:FirePDM:Menu")
AddEventHandler("warp-duty:FirePDM:Menu", function()
    local valid = exports["warp-applications"]:KeyboardInput({
        header = "Fire Menu",
        rows = {
            {
                id = 0,
                txt = "Enter CID"
            },
        }
    })
    if valid then
        TriggerServerEvent("warp-duty:FirePDM", valid[1].input)
    end
end)

-- END PDM HIRE/FIRE --

-- PDM HIRE/FIRE --

RegisterNetEvent("warp-duty:HireCosmic:Menu")
AddEventHandler("warp-duty:HireCosmic:Menu", function()
    local valid = exports["warp-applications"]:KeyboardInput({
        header = "Hire Menu",
        rows = {
            {
                id = 0,
                txt = "Enter CID"
            },
            {
                id = 1,
                txt = "Enter Rank"
            },
        }
    })
    if valid then
        TriggerServerEvent("warp-duty:HireCosmic", valid[1].input, valid[2].input)
    end
end)

RegisterNetEvent("warp-duty:FireCosmic:Menu")
AddEventHandler("warp-duty:FireCosmic:Menu", function()
    local valid = exports["warp-applications"]:KeyboardInput({
        header = "Fire Menu",
        rows = {
            {
                id = 0,
                txt = "Enter CID"
            },
        }
    })
    if valid then
        TriggerServerEvent("warp-duty:FireCosmic", valid[1].input)
    end
end)

-- END PDM HIRE/FIRE --