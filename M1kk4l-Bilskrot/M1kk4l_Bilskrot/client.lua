--[[
	███╗   ███╗  ███╗  ██╗  ██╗██╗  ██╗  ██╗██╗██╗
	████╗ ████║ ████║  ██║ ██╔╝██║ ██╔╝ ██╔╝██║██║
	██╔████╔██║██╔██║  █████═╝ █████═╝ ██╔╝ ██║██║
	██║╚██╔╝██║╚═╝██║  ██╔═██╗ ██╔═██╗ ███████║██║
	██║ ╚═╝ ██║███████╗██║ ╚██╗██║ ╚██╗╚════██║███████╗
	╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝     ╚═╝╚══════╝
	M1kk4l © 2021 | Alle Rettigheder Forbeholdes.
--]]
HT = nil

vRP = Proxy.getInterface("vRP")

Citizen.CreateThread(function()
    while HT == nil do
        TriggerEvent('HT_base:getBaseObjects', function(obj) HT = obj end)
        Citizen.Wait(0)
    end
end)

local Skrot = true

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if Skrot then
            for k,sted in pairs(M1kk4l.Steder) do
                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),sted.x,sted.y,sted.z, true) < 35 then
                    DrawMarker(36, sted.x,sted.y,sted.z, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5001, 60, 163, 49, 250, 0, 0, 0, 1)
                    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), sted.x,sted.y,sted.z, true ) < 1 then
                        DrawText3D(sted.x,sted.y,sted.z+1.0, "[~b~E~w~] Skrotte køretøjet")
                        if IsControlJustPressed (1, M1kk4l.Key) then
                            HT.TriggerServerCallback('M1kk4l:Client:CheckJob', function(Job)
                                if Job == true then
                                    Skrot = false
                                    local ped = GetPlayerPed(-1)
                                    local vehicle = GetVehiclePedIsIn(ped)
                                    if vehicle ~= 0 then
                                        exports['M1kk4l_progressBars']:startUI(10000, "Skrotter køretøjet...")

                                        RequestModel(GetHashKey('s_m_y_armymech_01'))
                                        while not HasModelLoaded('s_m_y_armymech_01') do
                                            Citizen.Wait(1)
                                        end

                                        RequestAnimDict("anim@amb@facility@missle_controlroom@")
                                        while not HasAnimDictLoaded("anim@amb@facility@missle_controlroom@") do
                                            Wait(1)
                                        end

                                        SetVehicleDoorOpen(vehicle, 4, false)
                                        ped = CreatePed(4, 0x62CC28E2, GetEntityCoords(ped), 0, false, true)
                                        
                                        local dimension = GetModelDimensions(GetEntityModel(vehicle))
                                        AttachEntityToEntity(ped, vehicle, GetPedBoneIndex(ped, 6286), 1.0, dimension.y * -1 + 0.1 , dimension.z + 1.3, 0.0, 0.0, 180.0, 0.0, false, false, true, false, true)                                

                                        FreezeEntityPosition(ped, true)
                                        SetEntityInvincible(ped, true)
                                        SetBlockingOfNonTemporaryEvents(ped, true)

                                        TaskPlayAnim(ped,"anim@amb@facility@missle_controlroom@", "idle", 8.0, 1.0, -1, 0, 0, 0, 0, 0)
                                        FreezeEntityPosition(vehicle, true)

                                        Wait(10000)

                                        FreezeEntityPosition(vehicle, false)
                                        SetVehicleDoorShut(vehicle, 4, true)
                                        TaskLeaveVehicle(ped, vehicle)

                                        Wait(1000)
                                        
                                        while DoesEntityExist(vehicle) do
                                            Wait(500)
                                            DeleteGivenVehicle(vehicle)
                                            DeleteEntity(ped)
                                            TriggerServerEvent("M1kk4l:BilskrotPenge")
                                            Skrot = true
                                        end
                                    else
                                        TriggerEvent("pNotify:SendNotification",{text = "Du skal sidde i et køretøj.",type = "error",timeout = (5000),layout = "centerRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})    
                                        Skrot = true
                                    end
                                else
                                    TriggerEvent("pNotify:SendNotification",{text = "Du er ikke Mekaniker",type = "error",timeout = (5000),layout = "centerRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})    
                                end
                            end)
                        end
                    end
                end
            end
        end
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 370
        DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
    end
end

function DeleteGivenVehicle(veh, timeoutMax)
    local timeout = 0 

    SetEntityAsMissionEntity(veh, true, true)
    DeleteVehicle(veh)

    if (DoesEntityExist(veh)) then
        TriggerEvent("pNotify:SendNotification",{text = "Kunne ikke skrotte køretøjet. Prøv igen.",type = "error",timeout = (5000),layout = "centerRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})    

        while (DoesEntityExist(veh) and timeout < timeoutMax) do
            DeleteVehicle(veh)

            if (not DoesEntityExist(veh) ) then
                TriggerEvent("pNotify:SendNotification",{text = "Køretøjet er skrottet.",type = "success",timeout = (5000),layout = "centerRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})    
            end

            timeout = timeout + 1
            Citizen.Wait(500)

            if (DoesEntityExist(veh) and (timeout == timeoutMax - 1)) then
                TriggerEvent("pNotify:SendNotification",{text = "Kunne ikke skrotte køretøjet. Prøv igen.",type = "error",timeout = (5000),layout = "centerRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})    
            end
        end
    else
        TriggerEvent("pNotify:SendNotification",{text = "Køretøjet er skrottet.",type = "success",timeout = (5000),layout = "centerRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})    
    end
end
