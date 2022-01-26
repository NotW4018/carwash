local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterServerCallback('carwash_money', function(source, cb)
    local igrac = ESX.GetPlayerFromId(source)
    if igrac.getMoney() >= 40 then
      igrac.removeMoney(40)
      cb(true)
    else
      cb(false)
    end
end)
