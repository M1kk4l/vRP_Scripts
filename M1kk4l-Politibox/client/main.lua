--[[
	███╗   ███╗  ███╗  ██╗  ██╗██╗  ██╗  ██╗██╗██╗
	████╗ ████║ ████║  ██║ ██╔╝██║ ██╔╝ ██╔╝██║██║
	██╔████╔██║██╔██║  █████═╝ █████═╝ ██╔╝ ██║██║
	██║╚██╔╝██║╚═╝██║  ██╔═██╗ ██╔═██╗ ███████║██║
	██║ ╚═╝ ██║███████╗██║ ╚██╗██║ ╚██╗╚════██║███████╗
	╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝     ╚═╝╚══════╝
--]]

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
        for k,v in pairs(cfg.Location) do
            local dist = #(GetEntityCoords(PlayerPedId())-vector3(v[1], v[2], v[3]))
            if dist < 7 then    
                sleeptimer = 0 
                DrawMarker(27, vector3(v[1], v[2], v[3]-0.99), 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 0.801, 26, 121, 217,255, 0, 0, 0, 1)
                if dist < 1.5 then     
                    SetTextComponentFormat("STRING")
                    AddTextComponentString("Tryk ~INPUT_CONTEXT~ for at åbne statskasse.")
                    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                    if IsControlJustPressed(1,38) then
                        HT.TriggerServerCallback('M1kk4l:Client:CheckJob', function(Job)    
                            if Job == true then
                                SetDisplay(true)
                            end
                        end)
                    end
                end
            end
        end
        Citizen.Wait(sleeptimer)
    end
end)

TriggerServerEvent("server:GetMoney")

RegisterCommand("stat", function(source, args, rawCommandString)
    SetDisplay(true)
end)

RegisterNUICallback("exit", function(data)
    SetDisplay(false)
    Wait(500)
    TriggerServerEvent("server:GetMoney")
end)

RegisterNUICallback("Indset", function(data)
    Antal = data.Antal
    TriggerServerEvent("InsætPenge", Antal)
end)

RegisterNUICallback("Hev", function(data)
    Antal = data.Antal
    TriggerServerEvent("HævPenge", Antal)
end)

RegisterNetEvent("client:GetMoney")
AddEventHandler("client:GetMoney", function(money, mymoney)
    function SetDisplay(bool)
        show = bool
        SetNuiFocus(bool, bool)
        SendNUIMessage({
            type = "ui",
            status = bool,

            Money = money,

            MyMoney = mymoney
        })
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        SetDisplay(false)
    end
end)