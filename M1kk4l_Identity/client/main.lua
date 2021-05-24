--[[
	███╗   ███╗  ███╗  ██╗  ██╗██╗  ██╗  ██╗██╗██╗
	████╗ ████║ ████║  ██║ ██╔╝██║ ██╔╝ ██╔╝██║██║
	██╔████╔██║██╔██║  █████═╝ █████═╝ ██╔╝ ██║██║
	██║╚██╔╝██║╚═╝██║  ██╔═██╗ ██╔═██╗ ███████║██║
	██║ ╚═╝ ██║███████╗██║ ╚██╗██║ ╚██╗╚════██║███████╗
	╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝     ╚═╝╚══════╝
--]]

RegisterNetEvent("FirstSpawn")
AddEventHandler("FirstSpawn", function()
    SetEntityInvincible(PlayerPedId(),true)
	SetEntityVisible(PlayerPedId(),false)
    FreezeEntityPosition(PlayerPedId(), true)
    SetCam(true,cfg.setcam1[1],cfg.setcam1[2],cfg.setcam1[3],cfg.setcam1[4])
    TriggerEvent("pNotify:SendNotification",{text = "Indlæser...",type = "success",timeout = (5000),layout = "center",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    Wait(5000)
    DoScreenFadeOut(500)
    Wait(1000)
    SetCam(false)
    SetCam(true,cfg.setcam2[1],cfg.setcam2[2],cfg.setcam2[3],cfg.setcam2[4])
    Wait(2000)
    SetDisplay(true)
    DoScreenFadeIn(500)
end)

RegisterNUICallback("close", function(data)
    SetDisplay(false)
end)

RegisterNUICallback("Changename", function(data)
    SetDisplay(false)
    TriggerServerEvent("Changename", data)
end)

RegisterNetEvent("SpawnPlayer")
AddEventHandler("SpawnPlayer", function()
    TriggerEvent("pNotify:SendNotification",{text = "Karakter lavet!",type = "success",timeout = (5000),layout = "centerRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    Wait(5000) 
    SetEntityInvincible(PlayerPedId(),false)
	SetEntityVisible(PlayerPedId(),true)
    FreezeEntityPosition(PlayerPedId(), false)
    SetCam(false)
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        SetDisplay(false)
    end
end)