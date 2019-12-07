RegisterCommand("open", function()
	TriggerEvent("skinshop:toggleMenu")
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- Menu toggle
-----------------------------------------------------------------------------------------------------------------------------------------
local cor = 0
local menuactive = false
RegisterNetEvent("skinshop:toggleMenu")
AddEventHandler("skinshop:toggleMenu", function()
	menuactive = not menuactive
	if menuactive then
		SetNuiFocus(true,true)

		local ped = PlayerPedId()
		if IsPedMale(ped) then
			SendNUIMessage({ showMenu = true, masc = true })
		else
			SendNUIMessage({ showMenu = true, masc = false })		
		end
	else
		cor = 0
		dados, tipo = nil
		SetNuiFocus(false)
		SendNUIMessage({ showMenu = false, masc = true })
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if menuactive then InvalidateIdleCam() end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- Retornos
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback("exit", function()
	TriggerEvent("skinshop:toggleMenu")
end)

RegisterNUICallback("rotate", function(data, cb)
	local ped = PlayerPedId()
	local heading = GetEntityHeading(ped)
	if data == "left" then
		SetEntityHeading(ped, heading + 15)
	elseif data == "right" then
		SetEntityHeading(ped, heading - 15)
	end
end)

RegisterNUICallback("update", function(data, cb)
	dados = tonumber(json.encode(data[1]))
	tipo = tonumber(json.encode(data[2]))
	cor = 0
	setRoupa(dados, tipo, cor)
end)

RegisterNUICallback("color", function(data, cb)
	if data == "left" then
		if cor ~= 0 then cor = cor - 1 else cor = 3 end
	elseif data == "right" then
		if cor ~= 3 then cor = cor + 1 else cor = 0 end
	end
	if dados and tipo then setRoupa(dados, tipo, cor) end
end)

function setRoupa(dados, tipo, cor)
	local ped = PlayerPedId()
	if dados < 100 then		
		SetPedComponentVariation(ped, dados, tipo, cor, 1)
	else
		SetPedPropIndex(ped, dados-100, tipo, cor, 1)
	end
end