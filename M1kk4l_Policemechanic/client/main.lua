Citizen.CreateThread(function()
    while true do
        sleeptimer = 500
        for k,v in pairs(cfg.location) do
            local dist = #(GetEntityCoords(PlayerPedId())-vector3(v[1],v[2],v[3]))
            if dist < 13 then
                sleeptimer = 0 
                DrawMarker(27, vector3(v[1], v[2], v[3]-0.89), 0, 0, 0, 0, 0, 0, 2.0001, 2.0001, 0.801, 26, 121, 217,255, 0, 0, 0, 1)
                if dist < 2 then
                    sleeptimer = 0
                    SetTextComponentFormat("STRING")
                    AddTextComponentString("Tryk ~INPUT_CONTEXT~ for at åbne Mekanikeren.")
                    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                    if IsControlJustPressed(1,38) then
                        TriggerServerCallback('test', function(bool)
                            if bool then
                                if IsPedInAnyVehicle(PlayerPedId(), true) then
                                    SetDisplay(true)
                                else
                                    TriggerEvent("pNotify:SendNotification",{text = "Du skal sidde i et køretøj!",type = "error",timeout = (5000),layout = "centerRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                                end
                            end
                        end, 'hey')
                    end
                end
            end
        end
        Citizen.Wait(sleeptimer)
    end
end)

RegisterNUICallback("close", function(data)
    SetDisplay(false)
end)

RegisterNUICallback("Repair", function(data)
    SetDisplay(false)
    RepairVeh()
end)

RegisterNUICallback("Wash", function(data)
    for k,v in pairs(cfg.location) do   
        local dist = #(GetEntityCoords(PlayerPedId())-vector3(v[1],v[2],v[3]))
        if dist < 13 then
            SetDisplay(false)
            WashVeh(v[1],v[2],v[3])
        end
    end
end)

RegisterNUICallback("primaryColor", function(data)
    vehicle = GetVehiclePedIsIn(PlayerPedId())
        SetVehicleCustomPrimaryColour(vehicle, tonumber(data.rgb[1]), tonumber(data.rgb[2]), tonumber(data.rgb[3]))
end)
  
RegisterNUICallback("SecondaryColor", function(data)
    vehicle = GetVehiclePedIsIn(PlayerPedId())
        SetVehicleCustomSecondaryColour(vehicle, tonumber(data.rgb[1]), tonumber(data.rgb[2]), tonumber(data.rgb[3]))
end)