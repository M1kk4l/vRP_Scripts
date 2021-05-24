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

AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
	if vRP.isFirstSpawn({source}) then
		TriggerClientEvent("FirstSpawn", source)
	end
end)

RegisterServerEvent("Changename")
AddEventHandler("Changename", function(data)
	local source = source
	local user_id = vRP.getUserId({source})
	MySQL.Async.execute("UPDATE vrp_user_identities SET name = @name", {name = data.Lastname})
	MySQL.Async.execute("UPDATE vrp_user_identities SET firstname = @firstname", {firstname = data.Firname})
	MySQL.Async.execute("UPDATE vrp_user_identities SET age = @age", {age = data.Age})
	TriggerClientEvent("SpawnPlayer", source)
    vRP.setUData({user_id,"spawned_once",1})
end)