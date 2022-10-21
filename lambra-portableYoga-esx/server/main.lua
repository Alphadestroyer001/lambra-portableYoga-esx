ESX = exports['es_extended']:getSharedObject()
local playerMats = {}

ESX.RegisterUsableItem("yogamat", function(source, item)
  local src = source
  local xPlayer = ESX.GetPlayerFromId(src)

  if playerMats[src] then
    --TriggerClientEvent("QBCore:Notify", src, Locales["alreadyOwnMat"], "error")
    return
  end
  
  if xPlayer.removeInventoryItem("yogamat", 1) then
    playerMats[src] = true
    --TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items["yogamat"], "remove")
    TriggerClientEvent("lambra-portableYoga:client:setMat", src)
  end
  playerMats[src] = true
  TriggerClientEvent("lambra-portableYoga:client:setMat", src)
end)

RegisterNetEvent("lambra-portableYoga:server:pickupMat", function()
  local src = source
  local xPlayer = ESX.GetPlayerFromId(src)
  
  if playerMats[src] then
    playerMats[src] = nil
    local xPlayer = ESX.GetPlayerFromId(src)
    xPlayer.addInventoryItem("yogamat", 1)
    --TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items["yogamat"], "add")
  end

end)

AddEventHandler('playerDropped', function()
  local src = source
  if playerMats[src] then playerMats[src] = nil end
end)