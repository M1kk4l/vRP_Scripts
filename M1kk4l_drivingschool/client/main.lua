HT = nil
Citizen.CreateThread(function()
    while HT == nil do
        TriggerEvent('HT_base:getBaseObjects', function(obj) HT = obj end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        sleeptimer = 500
        for k,v in pairs(cfg.location) do
            local dist = #(GetEntityCoords(PlayerPedId())-vector3(v[1],v[2],v[3]))
            if dist < 8 then
                sleeptimer = 0 
                DrawMarker(27, vector3(v[1], v[2], v[3]-0.99), 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 0.801, 26, 121, 217,255, 0, 0, 0, 1)
                if dist < 2 then
                    sleeptimer = 0
                    SetTextComponentFormat("STRING")
                    AddTextComponentString("Tryk ~INPUT_CONTEXT~ for at åbne køreskolen.")
                    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                    if IsControlJustPressed(1,38) then
                        HT.TriggerServerCallback('M1kk4l:Client:CheckJob', function(Job)    
                            if Job == true then
                                Menu()
                            end
                        end)
                    end
                end
            end
        end
        for k,v in pairs(cfg.despawncar) do
            local PedInVehicle = GetVehiclePedIsIn(PlayerPedId())
            if PedInVehicle ~= 0 then
                local dist = #(GetEntityCoords(PlayerPedId())-vector3(v[1],v[2],v[3]))
                if dist < 13 then
                    sleeptimer = 0 
                    DrawMarker(27, vector3(v[1], v[2], v[3]-0.99), 0, 0, 0, 0, 0, 0, 3.0001, 3.0001, 0.801, 26, 121, 217,255, 0, 0, 0, 1)
                    if dist < 2 then
                        sleeptimer = 0
                        SetTextComponentFormat("STRING")
                        AddTextComponentString("Tryk ~INPUT_CONTEXT~ for at parkere køretøj.")
                        DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                        if IsControlJustPressed(1,38) then
                            HT.TriggerServerCallback('M1kk4l:Client:CheckJob', function(Job)    
                                if Job == true then
                                    deleteCar(car) 
                                end
                            end)
                        end
                    end
                end
            end
        end
        Citizen.Wait(sleeptimer)
    end
end)

function Menu()
    local elements = {
        { label = "Start køreprøve", value = "startDriving" },
        { label = "Giv kørekort", value = "GiftDrivingLicense" },
        { label = "Fjern kørekort", value = "RemoveDrivingLicense" },
        { label = "Luk", value = "Luk" },
    }
    HT.UI.Menu.Open('default', GetCurrentResourceName(), "vrp_htmenu",
        {
            title    = "Køreskole",
            align    = "top-left",
            elements = elements
        },
    function(data, menu)
        menu = menu
        if(data.current.value == 'startDriving') then
            for k,v in pairs(cfg.spawncar) do
                menu.close()
                spawnCar(cfg.car,v[1],v[2],v[3],v[4],false)
            end
        end
        if(data.current.value == 'GiftDrivingLicense') then
            menu.close()
            HT.UI.Menu.Open('dialog', GetCurrentResourceName(), '', {
                title = "Id på person"
            }, function(data, menu)
                menu.close()
                if data ~= nil then
                    TriggerServerEvent("GiftDrivingLicense", data)
                end
            end)
        end
        if(data.current.value == 'RemoveDrivingLicense') then
            menu.close()
            HT.UI.Menu.Open('dialog', GetCurrentResourceName(), '', {
                title = "Id på person"
            }, function(data, menu)
                menu.close()
                if data ~= nil then
                    TriggerServerEvent("RemoveDrivingLicense", data)
                end
            end)
        end
        if(data.current.value == 'Luk') then
            menu.close()
        end
    end, function(data, menu)
        menu.close()
    end)
end

function spawnCar(model,x,y,z,h,spawnincar)

    local CheckClearArea = GetClosestVehicle(x,y,z,4.0, 0, 50)
    if not DoesEntityExist(CheckClearArea) then

        while not HasModelLoaded(model) do RequestModel(model) Citizen.Wait(100) end

        car = CreateVehicle(GetHashKey(model), x,y,z,h, 1,0)
        PlaceObjectOnGroundProperly(car)

        TriggerEvent("pNotify:SendNotification",{text = "Køretøj spawnet!",type = "error",timeout = (5000),layout = "centerRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})

        if spawnincar then
            TaskWarpPedIntoVehicle(PlayerPedId(), car, -1)
        end

        return car
    else
        TriggerEvent("pNotify:SendNotification",{text = "Der holder et køretøj i vejen!",type = "error",timeout = (5000),layout = "centerRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    end
end

function deleteCar(veh)
    TaskLeaveVehicle(PlayerPedId(), veh)
    Wait(1000)
    if DoesEntityExist(veh) then
        Citizen.Wait(100)
        DeleteVehicle(veh)
    end
end