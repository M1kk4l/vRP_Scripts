local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", "HT_base")

HT = {}
HT.ServerCallbacks = {}

RegisterServerEvent('HT:triggerServerCallback')
AddEventHandler('HT:triggerServerCallback', function(name, requestId, ...)
	local _source = source
    HT.TriggerServerCallback(name, requestID, _source, function(...)
		TriggerClientEvent('HT:serverCallback', _source, requestId, ...)
	end, ...)
end)

HT.TriggerServerCallback = function(name, requestId, source, cb, ...)
    if HT.ServerCallbacks[name] ~= nil then
        HT.ServerCallbacks[name](source, cb, ...)
    else
    end
end

HT.RegisterServerCallback = function(name, cb)
    HT.ServerCallbacks[name] = cb
end
RegisterServerEvent('HT_base:getBaseObjects')
AddEventHandler('HT_base:getBaseObjects', function(cb)
    cb(HT)
end)

AddEventHandler('HT_base:playerLoaded', function(source)
    local xPlayer = vRP.getUserId({source})
end)

HT.RegisterServerCallback('HT:JobCallback', function(source, cb, data)
    local user_id = vRP.getUserId({source})
    local job = vRP.getUserGroupByType({user_id,"job"})
    cb(job)
end) 