local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

HT = nil
TriggerEvent('HT_base:getBaseObjects', function(obj)
    HT = obj
end)

HT.RegisterServerCallback('M1kk4l:Client:CheckJob', function(source, cb)
    local user_id = vRP.getUserId({source})

    if vRP.hasGroup({user_id, cfg.Job}) then
        cb(true)
    else
        TriggerClientEvent("pNotify:SendNotification", source,{text = "Du har ikke adgang!", type = "error", queue = "global", timeout = 5000, layout = "centerRight",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        cb(false)
    end
end)

RegisterServerEvent("GiftDrivingLicense")
AddEventHandler("GiftDrivingLicense", function(data)
    local id = json.encode(tonumber(data.value))
    local user_id = vRP.getUserId({source})

    if data.value == " " or data.value == "" or data.value == null or data.value == 0 or data.value == nil then
        TriggerClientEvent("pNotify:SendNotification", source,{text = "Du skal indtaste et id!", type = "error", queue = "global", timeout = 5000, layout = "centerRight",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    else
        PerformHttpRequest(cfg.Webhook, function(o,p,q) end,'POST',json.encode(
        {
            username = "M1kk4l Drivingschool",
            embeds = {
                {              
                    title = "M1kk4l Drivingschool";
                    description = 'Id: '..id..' fik kørekort tilsendt af '..user_id;
                    color = 3993603;
                }
            }
        }), { ['Content-Type'] = 'application/json' })

        MySQL.Async.execute("UPDATE vrp_users SET DmvTest='1' WHERE id = @id", {id = id})

        TriggerClientEvent("pNotify:SendNotification", source,{text = "Du gav kørekort til id "..id.."!", type = "success", queue = "global", timeout = 5000, layout = "centerRight",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    end
end)

RegisterServerEvent("RemoveDrivingLicense")
AddEventHandler("RemoveDrivingLicense", function(data)
    local id = json.encode(tonumber(data.value))
    local user_id = vRP.getUserId({source})
    
    if data.value == " " or data.value == "" or data.value == null or data.value == 0 or data.value == nil then
        TriggerClientEvent("pNotify:SendNotification", source,{text = "Du skal indtaste et id!", type = "error", queue = "global", timeout = 5000, layout = "centerRight",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    else
        PerformHttpRequest(cfg.Webhook, function(o,p,q) end,'POST',json.encode(
        {
            username = "M1kk4l Drivingschool",
            embeds = {
                {              
                    title = "M1kk4l Drivingschool";
                    description = 'Id: '..id..' fik kørekort fjernet af '..user_id;
                    color = 16711680;
                }
            }
        }), { ['Content-Type'] = 'application/json' })

        MySQL.Async.execute("UPDATE vrp_users SET DmvTest='0' WHERE id = @id", {id = id})

        TriggerClientEvent("pNotify:SendNotification", source,{text = "Du fjernede kørekort fra id "..id.."!", type = "success", queue = "global", timeout = 5000, layout = "centerRight",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    end
end)