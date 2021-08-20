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
	local source = source
	local user_id = vRP.getUserId({source})
	vRP.getUserIdentity({user_id, function(identity)
		if identity.firstname == "Skift" or identity.name == "Navn" or identity == nil then
			TriggerClientEvent('M1kk4l_Identity:OpenUI', source)
		end
	end})
end)

RegisterServerEvent("ChangenIdentity")
AddEventHandler("ChangenIdentity", function(data)
	local source = source
	local user_id = vRP.getUserId({source})
	MySQL.Async.execute("UPDATE vrp_user_identities SET firstname = @firstname ", {firstname = data.Firname})
	MySQL.Async.execute("UPDATE vrp_user_identities SET name = @name ", {name = data.Lastname})
	MySQL.Async.execute("UPDATE vrp_user_identities SET age = @age", {age = data.Age})
	TriggerClientEvent("M1kk4l_Identity:SpawnPlayer", source)
end)