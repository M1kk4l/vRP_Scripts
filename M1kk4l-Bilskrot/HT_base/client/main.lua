HT = {}
HT.Game = {}
HT.ServerCallbacks = {}
HT.CurrentRequestId = 0

HT.UI = {}
HT.UI.Menu = {}
HT.UI.Menu.RegisteredTypes = {}
HT.UI.Menu.Opened = {}

HT.TimeoutCallbacks = {}

HT.Math = {}

HT.Streaming = {}

HT.Game.Utils = {}

HT.Game.GetPedMugshot = function(ped)
	local mugshot = RegisterPedheadshot(ped)
	while not IsPedheadshotReady(mugshot) do
		Citizen.Wait(0)
	end
	return mugshot, GetPedheadshotTxdString(mugshot)
end

HT.TriggerServerCallback = function(name, cb, ...)
	HT.ServerCallbacks[HT.CurrentRequestId] = cb

	TriggerServerEvent('HT:triggerServerCallback', name, HT.CurrentRequestId, ...)

	if HT.CurrentRequestId < 65535 then
		HT.CurrentRequestId = HT.CurrentRequestId + 1
	else
		HT.CurrentRequestId = 0
	end
end

HT.UI.Menu.RegisterType = function(type, open, close)
	HT.UI.Menu.RegisteredTypes[type] = {
		open   = open,
		close  = close
	}
end

HT.UI.Menu.Open = function(type, namespace, name, data, submit, cancel, change, close)
	local menu = {}
	menu.type = type
	menu.namespace = namespace
	menu.name = name
	menu.data = data
	menu.submit = submit
	menu.cancel = cancel
	menu.change = change
	menu.close = function()
		HT.UI.Menu.RegisteredTypes[type].close(namespace, name)
		for i = 1, #HT.UI.Menu.Opened, 1 do
			if HT.UI.Menu.Opened[i] ~= nil then
				if HT.UI.Menu.Opened[i].type == type and HT.UI.Menu.Opened[i].namespace == namespace and HT.UI.Menu.Opened[i].name == name then
					HT.UI.Menu.Opened[i] = nil
				end
			end
		end
		if close ~= nil then
			close()
		end
	end
	menu.update = function(query, newData)
		for i = 1, #menu.data.elements, 1 do
			local match = true
			for k, v in pairs(query) do
				if menu.data.elements[i][k] ~= v then
					match = false
				end
			end
			if match then
				for k, v in pairs(newData) do
					menu.data.elements[i][k] = v
				end
			end
		end
	end
	menu.refresh = function()
		HT.UI.Menu.RegisteredTypes[type].open(namespace, name, menu.data)
	end
	menu.setElement = function(i, key, val)
		menu.data.elements[i][key] = val
	end
	menu.setTitle = function(val)
		menu.data.title = val
	end
	menu.removeElement = function(query)
		for i=1, #menu.data.elements, 1 do
			for k,v in pairs(query) do
				if menu.data.elements[i] then
					if menu.data.elements[i][k] == v then
						table.remove(menu.data.elements, i)
						break
					end
				end

			end
		end
	end
	table.insert(HT.UI.Menu.Opened, menu)
	HT.UI.Menu.RegisteredTypes[type].open(namespace, name, menu.data)
	return menu
end

HT.UI.Menu.Close = function(type, namespace, name)
	for i = 1, #HT.UI.Menu.Opened, 1 do
		if HT.UI.Menu.Opened[i] ~= nil then
			if HT.UI.Menu.Opened[i].type == type and HT.UI.Menu.Opened[i].namespace == namespace and HT.UI.Menu.Opened[i].name == name then
				HT.UI.Menu.Opened[i].close()
				HT.UI.Menu.Opened[i] = nil
			end
		end
	end
end

HT.UI.Menu.CloseAll = function()
	for i = 1, #HT.UI.Menu.Opened, 1 do
		if HT.UI.Menu.Opened[i] ~= nil then
			HT.UI.Menu.Opened[i].close()
			HT.UI.Menu.Opened[i] = nil
		end
	end
end

HT.UI.Menu.GetOpened = function(type, namespace, name)
	for i = 1, #HT.UI.Menu.Opened, 1 do
		if HT.UI.Menu.Opened[i] ~= nil then
			if HT.UI.Menu.Opened[i].type == type and HT.UI.Menu.Opened[i].namespace == namespace and HT.UI.Menu.Opened[i].name == name then
				return HT.UI.Menu.Opened[i]
			end
		end
	end
end

HT.UI.Menu.GetOpenedMenus = function()
	return HT.UI.Menu.Opened
end

HT.UI.Menu.IsOpen = function(type, namespace, name)
	return HT.UI.Menu.GetOpened(type, namespace, name) ~= nil
end

HT.SetTimeout = function(msec, cb)
	table.insert(HT.TimeoutCallbacks, {
		time = GetGameTimer() + msec,
		cb   = cb
	})
	return #HT.TimeoutCallbacks
end

HT.ClearTimeout = function(i)
	HT.TimeoutCallbacks[i] = nil
end

HT.Math.Round = function(value, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", value))
end

HT.Math.GroupDigits = function(value)
	local left,num,right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')

	return left..(num:reverse():gsub('(%d%d%d)','%1' .. ","):reverse())..right
end

HT.Math.Trim = function(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end

HT.Game.Utils.DrawText3D = function(coords, text, size)
	local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
	local camCoords = GetGameplayCamCoords()
	local dist = GetDistanceBetweenCoords(camCoords, coords.x, coords.y, coords.z, true)
	local size = size
	if size == nil then
		size = 1
	end
	local scale = (size / dist) * 2
	local fov = (1 / GetGameplayCamFov()) * 100
	local scale = scale * fov
	if onScreen then
		SetTextScale(0.0 * scale, 0.55 * scale)
		SetTextFont(0)
		SetTextColour(255, 255, 255, 255)
		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry('STRING')
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(x, y)
	end
end

function HT.Game.GetClosestPlayer(radius)
	local p = nil
  
	local players = {}--tvRP.getNearestPlayers(radius)
	local min = radius+10.0
	for k,v in pairs(players) do
	  if v < min then
		min = v
		p = k
	  end
	end
  
	return p
  end


function HT.Streaming.RequestAnimDict(animDict, cb)
	if not HasAnimDictLoaded(animDict) then
		RequestAnimDict(animDict)

		while not HasAnimDictLoaded(animDict) do
			Citizen.Wait(1)
		end
	end

	if cb ~= nil then
		cb()
	end
end

HT.Game.GetPlayers = function()
	local players = {}
	for _, player in ipairs(GetActivePlayers()) do
		local ped = GetPlayerPed(player)
		if DoesEntityExist(ped) then
			table.insert(players, player)
		end
	end
	return players
end

HT.Game.GetPlayersInArea = function(coords, area)
	local players = HT.Game.GetPlayers()
	local playersInArea = {}
	for i = 1, #players, 1 do
		local target = GetPlayerPed(players[i])
		local targetCoords = GetEntityCoords(target)
		local distance = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)
		if distance <= area then
			table.insert(playersInArea, players[i])
		end
	end
	return playersInArea
end

HT.Game.GetObjects = function()
	local objects = {}
	for object in EnumerateObjects() do
		table.insert(objects, object)
	end
	return objects
end

HT.Game.GetClosestObject = function(filter, coords)
	local objects = HT.Game.GetObjects()
	local closestDistance = -1
	local closestObject = -1
	local filter = filter
	local coords = coords
	if type(filter) == 'string' then
		if filter ~= '' then
			filter = {filter}
		end
	end
	if coords == nil then
		local playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
	end
	for i = 1, #objects, 1 do
		local foundObject = false
		if filter == nil or (type(filter) == 'table' and #filter == 0) then
			foundObject = true
		else
			local objectModel = GetEntityModel(objects[i])
			for j = 1, #filter, 1 do
				if objectModel == GetHashKey(filter[j]) then
					foundObject = true
				end
			end
		end
		if foundObject then
			local objectCoords = GetEntityCoords(objects[i])
			local distance = GetDistanceBetweenCoords(objectCoords, coords.x, coords.y, coords.z, true)
			if closestDistance == -1 or closestDistance > distance then
				closestObject = objects[i]
				closestDistance = distance
			end
		end
	end
	return closestObject, closestDistance
end

function HT.Streaming.RequestModel(modelHash, cb)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))
	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)
		while not HasModelLoaded(modelHash) do
			Citizen.Wait(1)
		end
	end
	if cb ~= nil then
		cb()
	end
end

HT.Game.SpawnLocalVehicle = function(modelName, coords, heading, cb)
	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))
	Citizen.CreateThread(function()
		HT.Streaming.RequestModel(model)
		local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, false, false)
		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetModelAsNoLongerNeeded(model)
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)
		while not HasCollisionLoadedAroundEntity(vehicle) do
			RequestCollisionAtCoord(coords.x, coords.y, coords.z)
			Citizen.Wait(0)
		end
		SetVehRadioStation(vehicle, 'OFF')
		if cb ~= nil then
			cb(vehicle)
		end
	end)
end

HT.Game.SpawnVehicle = function(modelName, coords, heading, cb)
	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))

	Citizen.CreateThread(function()
		HT.Streaming.RequestModel(model)

		local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false)
		local id      = NetworkGetNetworkIdFromEntity(vehicle)

		SetNetworkIdCanMigrate(id, true)
		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetModelAsNoLongerNeeded(model)

		RequestCollisionAtCoord(coords.x, coords.y, coords.z)

		while not HasCollisionLoadedAroundEntity(vehicle) do
			RequestCollisionAtCoord(coords.x, coords.y, coords.z)
			Citizen.Wait(0)
		end

		SetVehRadioStation(vehicle, 'OFF')

		if cb ~= nil then
			cb(vehicle)
		end
	end)
end

HT.Game.DeleteVehicle = function(vehicle)
	SetEntityAsMissionEntity(vehicle, false, true)
	DeleteVehicle(vehicle)
end

function HT.Streaming.RequestModel(modelHash, cb)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(1)
		end
	end

	if cb ~= nil then
		cb()
	end
end

HT.Game.SpawnLocalObject = function(model, coords, cb)
	local model = (type(model) == 'number' and model or GetHashKey(model))

	Citizen.CreateThread(function()
		HT.Streaming.RequestModel(model)

		local obj = CreateObject(model, coords.x, coords.y, coords.z, false, false, true)

		if cb ~= nil then
			cb(obj)
		end
	end)
end

HT.Game.DeleteObject = function(object)
	SetEntityAsMissionEntity(object, false, true)
	DeleteObject(object)
end

RegisterNetEvent('HT:serverCallback')
AddEventHandler('HT:serverCallback', function(requestId, ...)
	HT.ServerCallbacks[requestId](...)
	HT.ServerCallbacks[requestId] = nil
end)

RegisterNetEvent('HT_base:getBaseObjects')
AddEventHandler('HT_base:getBaseObjects', function(cb)
	cb(HT)
end)

local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end

		enum.destructor = nil
		enum.handle = nil
	end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
		coroutine.yield(id)
		next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
	return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
	return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

HT.GetJob = function()
	HT.TriggerServerCallback('HT:JobCallbac', function(data)
		return data
	end)
end

HT.Game.GetVehicleProperties = function(vehicle)
	local color1, color2 = GetVehicleColours(vehicle)
	local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
	local extras = {}

	for id=0, 12 do
		if DoesExtraExist(vehicle, id) then
			local state = IsVehicleExtraTurnedOn(vehicle, id) == 1
			extras[tostring(id)] = state
		end
	end

	local tyres = {}
	tyres[1] = {burst = IsVehicleTyreBurst(vehicle, 0, false), id = 0}
	tyres[2] = {burst = IsVehicleTyreBurst(vehicle, 1, false), id = 1}
	tyres[3] = {burst = IsVehicleTyreBurst(vehicle, 4, false), id = 4}
	tyres[4] = {burst = IsVehicleTyreBurst(vehicle, 5, false), id = 5}

	local doors = {}
	for i = 0, 5, 1 do
		doors[tostring(i)] = IsVehicleDoorDamaged(vehicle, i)
	end

	local windows = {}
	for i = 0, 5, 1 do
		windows[tostring(i)] = IsVehicleWindowIntact(vehicle, i)
	end

	return {

		model             = GetEntityModel(vehicle),

		plate             = HT.Math.Trim(GetVehicleNumberPlateText(vehicle)),
		plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),

		health            = GetEntityHealth(vehicle),
		dirtLevel         = GetVehicleDirtLevel(vehicle),

		color1            = color1,
		color2            = color2,

		pearlescentColor  = pearlescentColor,
		wheelColor        = wheelColor,

		wheels            = GetVehicleWheelType(vehicle),
		windowTint        = GetVehicleWindowTint(vehicle),

		neonEnabled       = {
			IsVehicleNeonLightEnabled(vehicle, 0),
			IsVehicleNeonLightEnabled(vehicle, 1),
			IsVehicleNeonLightEnabled(vehicle, 2),
			IsVehicleNeonLightEnabled(vehicle, 3)
		},

		extras            = extras,

		neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),
		tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),

		modSpoilers       = GetVehicleMod(vehicle, 0),
		modFrontBumper    = GetVehicleMod(vehicle, 1),
		modRearBumper     = GetVehicleMod(vehicle, 2),
		modSideSkirt      = GetVehicleMod(vehicle, 3),
		modExhaust        = GetVehicleMod(vehicle, 4),
		modFrame          = GetVehicleMod(vehicle, 5),
		modGrille         = GetVehicleMod(vehicle, 6),
		modHood           = GetVehicleMod(vehicle, 7),
		modFender         = GetVehicleMod(vehicle, 8),
		modRightFender    = GetVehicleMod(vehicle, 9),
		modRoof           = GetVehicleMod(vehicle, 10),

		modEngine         = GetVehicleMod(vehicle, 11),
		modBrakes         = GetVehicleMod(vehicle, 12),
		modTransmission   = GetVehicleMod(vehicle, 13),
		modHorns          = GetVehicleMod(vehicle, 14),
		modSuspension     = GetVehicleMod(vehicle, 15),
		modArmor          = GetVehicleMod(vehicle, 16),

		modTurbo          = IsToggleModOn(vehicle, 18),
		modSmokeEnabled   = IsToggleModOn(vehicle, 20),
		modXenon          = IsToggleModOn(vehicle, 22),
		modHeadlight 	  = GetVehicleHeadlightsColour(vehicle),

		modFrontWheels    = GetVehicleMod(vehicle, 23),
		modBackWheels     = GetVehicleMod(vehicle, 24),

		modPlateHolder    = GetVehicleMod(vehicle, 25),
		modVanityPlate    = GetVehicleMod(vehicle, 26),
		modTrimA          = GetVehicleMod(vehicle, 27),
		modOrnaments      = GetVehicleMod(vehicle, 28),
		modDashboard      = GetVehicleMod(vehicle, 29),
		modDial           = GetVehicleMod(vehicle, 30),
		modDoorSpeaker    = GetVehicleMod(vehicle, 31),
		modSeats          = GetVehicleMod(vehicle, 32),
		modSteeringWheel  = GetVehicleMod(vehicle, 33),
		modShifterLeavers = GetVehicleMod(vehicle, 34),
		modAPlate         = GetVehicleMod(vehicle, 35),
		modSpeakers       = GetVehicleMod(vehicle, 36),
		modTrunk          = GetVehicleMod(vehicle, 37),
		modHydrolic       = GetVehicleMod(vehicle, 38),
		modEngineBlock    = GetVehicleMod(vehicle, 39),
		modAirFilter      = GetVehicleMod(vehicle, 40),
		modStruts         = GetVehicleMod(vehicle, 41),
		modArchCover      = GetVehicleMod(vehicle, 42),
		modAerials        = GetVehicleMod(vehicle, 43),
		modTrimB          = GetVehicleMod(vehicle, 44),
		modTank           = GetVehicleMod(vehicle, 45),
		modWindows        = GetVehicleMod(vehicle, 46),
		modTires 		  = GetVehicleModVariation(vehicle, 23),
		modLivery         = GetVehicleLivery(vehicle),
		engine 			  =	GetVehicleEngineHealth(vehicle),
		body 			  = GetVehicleBodyHealth(vehicle),
		tyres			  = tyres,
		doors			  = doors,
		windows 		  = windows
	}
end