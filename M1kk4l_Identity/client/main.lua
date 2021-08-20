--[[
	███╗   ███╗  ███╗  ██╗  ██╗██╗  ██╗  ██╗██╗██╗
	████╗ ████║ ████║  ██║ ██╔╝██║ ██╔╝ ██╔╝██║██║
	██╔████╔██║██╔██║  █████═╝ █████═╝ ██╔╝ ██║██║
	██║╚██╔╝██║╚═╝██║  ██╔═██╗ ██╔═██╗ ███████║██║
	██║ ╚═╝ ██║███████╗██║ ╚██╗██║ ╚██╗╚════██║███████╗
	╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝     ╚═╝╚══════╝
--]]

RegisterCommand('test123', function()
    DoScreenFadeOut(500)
    Wait(500)
    SetTimecycleModifier("hud_def_blur")
    
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -1355.93,-1487.78,520.75, 300.00,0.00,0.00, 100.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(1, 0, 750, 1, 1)
    Wait(8000)
    SetDisplay(true)
    DoScreenFadeIn(500)
end)

RegisterNetEvent("M1kk4l_Identity:OpenUI")
AddEventHandler("M1kk4l_Identity:OpenUI", function()
    DoScreenFadeOut(500)
    Wait(500)
    SetTimecycleModifier("hud_def_blur")
    
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -1355.93,-1487.78,520.75, 300.00,0.00,0.00, 100.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(1, 0, 750, 1, 1)
    Wait(8000)
    SetDisplay(true)
    DoScreenFadeIn(500)
end)

RegisterNUICallback("close", function(data)
    SetDisplay(false)
end)

RegisterNUICallback("ChangenIdentity", function(data)
    SetDisplay(false)
    TriggerServerEvent("ChangenIdentity", data)
end)

RegisterNetEvent("M1kk4l_Identity:SpawnPlayer")
AddEventHandler("M1kk4l_Identity:SpawnPlayer", function()
    local coordsMe = GetEntityCoords(PlayerPedId(), false)

    SetTimecycleModifier("default")

    cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -1355.93,-1487.78,520.75, 300.00,0.00,0.00, 100.00, false, 0)
    PointCamAtCoord(cam2, coordsMe['x'], coordsMe['y'], coordsMe['z'])
    SetCamActiveWithInterp(cam2, cam, 900, true, true)

    Wait(1000)

    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coordsMe['x'], coordsMe['y'], coordsMe['z']+200, 300.00,0.00,0.00, 100.00, false, 0)
    PointCamAtCoord(cam, coordsMe['x'], coordsMe['y'], coordsMe['z']+2)
    SetCamActiveWithInterp(cam, cam2, 3700, true, true)

    Wait(3700)

    PlaySoundFrontend(-1, "Zoom_Out", "DLC_HEIST_PLANNING_BOARD_SOUNDS", 1)
    RenderScriptCams(false, true, 500, true, true)
    PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)
    FreezeEntityPosition(GetPlayerPed(-1), false)

    Wait(500)

    SetCamActive(cam, false)
    DestroyCam(cam, true)
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        SetDisplay(false)
    end
end)