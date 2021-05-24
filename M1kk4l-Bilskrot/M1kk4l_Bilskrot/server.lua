--[[
	███╗   ███╗  ███╗  ██╗  ██╗██╗  ██╗  ██╗██╗██╗
	████╗ ████║ ████║  ██║ ██╔╝██║ ██╔╝ ██╔╝██║██║
	██╔████╔██║██╔██║  █████═╝ █████═╝ ██╔╝ ██║██║
	██║╚██╔╝██║╚═╝██║  ██╔═██╗ ██╔═██╗ ███████║██║
	██║ ╚═╝ ██║███████╗██║ ╚██╗██║ ╚██╗╚════██║███████╗
	╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝     ╚═╝╚══════╝
	M1kk4l © 2021 | Alle Rettigheder Forbeholdes.
--]]

M1kk4l.Webhook = "DIN WEBHOOK" -- Her kan du skrive din webhook ind

HT = nil
TriggerEvent('HT_base:getBaseObjects', function(obj)
    HT = obj
end)

local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","M1kk4l_Bilskrot")

HT.RegisterServerCallback('M1kk4l:Client:CheckJob', function(source, cb)
    local user_id = vRP.getUserId({source})

    if vRP.hasGroup({user_id, M1kk4l.Group}) then
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent('M1kk4l:BilskrotPenge')
AddEventHandler('M1kk4l:BilskrotPenge', function()
    local user_id = vRP.getUserId({source})
    if vRP.hasGroup({user_id, M1kk4l.Group}) then
        math.randomseed(os.time());math.random();math.random();math.random()
        local penge = math.random(M1kk4l.PengeMin, M1kk4l.PengeMax)
        vRP.giveMoney({user_id,penge})
        PerformHttpRequest(M1kk4l.Webhook, function(err, text, headers) end, 'POST', json.encode({username = "M1kk4l Skrot", content = "**ID: "..user_id.."**  Skrottede lige et køretøj! Og modtog **" ..penge.. "** DKK"}), { ['Content-Type'] = 'application/json' })
        TriggerClientEvent("pNotify:SendNotification", source,{text = "Du modtog <b style='color: #4E9350'>"..penge.." DKK</b>. For at skrotte køretøjet.", type = "success", queue = "global", timeout = 5000, layout = "centerRight",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    end
end)
