local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

RegisterServerCallback('test', function(source, cb)
    local user_id = vRP.getUserId({source})
    if vRP.hasGroup({user_id,cfg.Job}) then
        cb(true)
    else
        cb(false)
        TriggerClientEvent("pNotify:SendNotification", source,{text = "Du har ikke adgang!", type = "error", queue = "global", timeout = 5000, layout = "centerRight",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    end
end)