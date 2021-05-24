--[[
	███╗   ███╗  ███╗  ██╗  ██╗██╗  ██╗  ██╗██╗██╗
	████╗ ████║ ████║  ██║ ██╔╝██║ ██╔╝ ██╔╝██║██║
	██╔████╔██║██╔██║  █████═╝ █████═╝ ██╔╝ ██║██║
	██║╚██╔╝██║╚═╝██║  ██╔═██╗ ██╔═██╗ ███████║██║
	██║ ╚═╝ ██║███████╗██║ ╚██╗██║ ╚██╗╚════██║███████╗
	╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝     ╚═╝╚══════╝
--]]

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

RegisterServerEvent("server:GetMoney")
AddEventHandler("server:GetMoney", function()
    local source = source
    local user_id = vRP.getUserId({source})
    local mymoney = vRP.getBankMoney({user_id})
    MySQL.Async.fetchAll("SELECT * FROM politibox", {}, function(result)
        if result[1].money ~= nil then
            TriggerClientEvent("client:GetMoney", source, result[1].money, mymoney)
        end
    end)
end)

RegisterServerEvent("InsætPenge")
AddEventHandler("InsætPenge", function(Antal)
    local source = source
    local user_id = vRP.getUserId({source})
    if vRP.tryWithdraw({user_id,tonumber(Antal)}) then
        TriggerClientEvent("pNotify:SendNotification", source,{text = "Du betalte <b style='color: #c40808'>"..Antal.." ,-</b> til Politibox.", type = "error", queue = "global", timeout = 5000, layout = "centerRight",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        MySQL.Async.execute("UPDATE politibox SET money = @money + money", {money = Antal})

        vRP.getUserIdentity({user_id, function(identity)
            local ids = ExtractIdentifiers(source);
            local playerSteam = ids.steam;
            local playerDisc = ids.discord;
            local discord = ids.discord;
            PerformHttpRequest(cfg.Webhook, function(o,p,q) end,'POST',json.encode(
            {
                username = "M1kk4l Politibox",
                embeds = {
                    {              
                        title = "M1kk4l Politibox";
                        description = '**Id:** '..user_id..'\n**Indsatte:** '..Antal..' \n**Ingame Navn:** '.. identity.firstname .. ' ' .. identity.name ..'\n**Discord:** <@' ..discord:gsub('discord:', '')..'> \n **Steam Id:** '..playerSteam..'';
                        color = 2031360;
                    }
                }
            }), { ['Content-Type'] = 'application/json' })
        end})
    end
end)

RegisterServerEvent("HævPenge")
AddEventHandler("HævPenge", function(Antal)
    local source = source
    local user_id = vRP.getUserId({source})
    MySQL.Async.fetchAll("SELECT * FROM politibox", {}, function(result)
        if result[1].money ~= nil then
            if result[1].money - Antal <= 0 then
                TriggerClientEvent("pNotify:SendNotification", source,{text = "Du kan ikke hæve så mange penge fra Politibox!", type = "success", queue = "global", timeout = 5000, layout = "centerRight",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                return
            else
                vRP.giveBankMoney({user_id,tonumber(Antal)})

                TriggerClientEvent("pNotify:SendNotification", source,{text = "Du modtog <b style='color: #4E9350'>"..Antal.." ,-</b> fra Politibox.", type = "success", queue = "global", timeout = 5000, layout = "centerRight",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                
                MySQL.Async.execute("UPDATE politibox SET money = money - @money", {money = Antal})

                vRP.getUserIdentity({user_id, function(identity)
                    local ids = ExtractIdentifiers(source);
                    local playerSteam = ids.steam;
                    local playerDisc = ids.discord;
                    local discord = ids.discord;
                    PerformHttpRequest(cfg.Webhook, function(o,p,q) end,'POST',json.encode(
                    {
                        username = "M1kk4l Politibox",
                        embeds = {
                            {              
                                title = "M1kk4l Politibox";
                                description = '**Id:** '..user_id..'\n**Hævede:** '..Antal..' \n**Ingame Navn:** '.. identity.firstname .. ' ' .. identity.name ..'\n**Discord:** <@' ..discord:gsub('discord:', '')..'> \n **Steam Id:** '..playerSteam..'';
                                color = 13175049;
                            }
                        }
                    }), { ['Content-Type'] = 'application/json' })
                end})
            end
        end
    end)
end)


function ExtractIdentifiers(source)
    local identifiers = {
        steam = "",
        discord = "",
    }
    
    for i = 0, GetNumPlayerIdentifiers(source) - 1 do
        local id = GetPlayerIdentifier(source, i)

        --Convert it to a nice table.
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        end
    end

    return identifiers
end
