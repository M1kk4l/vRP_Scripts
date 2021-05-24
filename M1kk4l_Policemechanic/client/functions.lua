function SetDisplay(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "container",
        status = bool,
    })
end

function RepairVeh()
    exports['M1kk4l_progressBars']:startUI(10000, "Reparerer køretøj...")

    FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId()), true)

    Wait(10000)

    FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId()), false)

    SetVehicleEngineHealth(GetVehiclePedIsIn(PlayerPedId()), 9999)
    SetVehiclePetrolTankHealth(GetVehiclePedIsIn(PlayerPedId()), 9999)
    SetVehicleFixed(GetVehiclePedIsIn(PlayerPedId()))

    TriggerEvent("pNotify:SendNotification",{text = "Køretøj er blevet fikset!",type = "success",timeout = (5000),layout = "centerRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
end

function WashVeh(x,y,z)
    exports['M1kk4l_progressBars']:startUI(10000, "Vasker køretøj...")

    FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId()), true)

    UseParticleFxAssetNextCall("core")
    particles  = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p", x,y,z, 0.0, 0.0, 0.0, 0.5, false, false, false, false)


    Wait(10000)

    StopParticleFxLooped(particles, 0)

    FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId()), false)

    local dirt = GetVehicleDirtLevel(GetVehiclePedIsIn(PlayerPedId()))

    SetVehicleDirtLevel(GetVehiclePedIsIn(PlayerPedId()), 0.0)
    SetVehicleUndriveable(GetVehiclePedIsIn(PlayerPedId()), false)

    TriggerEvent("pNotify:SendNotification",{text = "Køretøj er blevet gjort helt rent!",type = "success",timeout = (5000),layout = "centerRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
end