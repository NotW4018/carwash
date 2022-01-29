-- NOTW4018#5584

local ESX  = nil
local display = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)




function Prikazi(bool)
    display = bool
    SetNuiFocus(true,true)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end


WashCar = {}

WashCar.Locations = {
    vector3(26.5906, -1392.0261, 29.3634),
    vector3(171.0811, -1717.93, 29.291),
    vector3(-74.5693, 6427.8715, 31.4400),
    vector3(-699.6325, -932.7043, 19.0139)
}

CreateThread(function()
  for i=1, #WashCar.Locations, 1 do 
    carWashLocation = WashCar.Locations[i]

    local blip = AddBlipForCoord(carWashLocation)
    SetBlipSprite(blip, 100)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, true)


    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Car Wash')
    EndTextCommandSetBlipName(blip)
  end
end)

CreateThread(function()
  while true do
    Wait(0)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local canSleep = true

    if Autopraonica() then

      for i=1, #WashCar.Locations, 1 do
        local carWashLocation = WashCar.Locations[i]
        local distance = GetDistanceBetweenCoords(coords, carWashLocation, true)

        if distance < 20 then
            DrawMarker(20, carWashLocation, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 2.0, 50, 112, 207, 155, false, false, 2, false, false, false, false)
          canSleep = false
        end

        if distance < 5 then
          canSleep = false

          ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to ~y~Wash Vehicle~w~!')

          if IsControlJustReleased(0, 38) then
            local vozilo = GetVehiclePedIsIn(GetPlayerPed(-1),false)

            if GetVehicleDirtLevel(vozilo) > 2 then
                Prikazi(true)
            else
              ESX.ShowNotification('The vehicle is clean!')
            end
          end
        end
      end

      if canSleep then
        Wait(1000)
      end

    else
      Wait(1000)
    end
  end
end)


function Autopraonica()
  local playerPed = PlayerPedId()

  if IsPedSittingInAnyVehicle(playerPed) then
    local vozilo = GetVehiclePedIsIn(playerPed, false)

    if GetPedInVehicleSeat(vozilo, -1) == playerPed then
      return true
    end
  end

  return false
end



function OperiVozilo()
  ESX.TriggerServerCallback('carwash_money', function(novac)
    if novac then
      local vozilo = GetVehiclePedIsIn(GetPlayerPed(-1),false)
      SetVehicleDirtLevel(vozilo, 0.0)
      ESX.ShowNotification('Your vehicle has been washed!')
    else
      ESX.ShowNotification('You dont have enough money!')
    end
  end)
end


RegisterNUICallback('exit', function()
  zatvoriNui()
end)

RegisterNUICallback('clean', function()
    OperiVozilo()
end)

function zatvoriNui()
  Prikazi(false)
  SetNuiFocus(false,false)
end

RegisterNUICallback('escape', function(data, cb)   
  zatvoriNui() 
end)
