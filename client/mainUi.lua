
RegisterNetEvent("cdtcraft:openUi")
AddEventHandler("cdtcraft:openUi", function (data, indexs)
    SendNUIMessage(
        {
            type = "openUi",
            data = data,
            indexs = indexs,
        }
    )
    SetNuiFocus(true, true)
    inCraftUi = true
end)

RegisterNetEvent("cdtcraft:requestcloseUi")
AddEventHandler("cdtcraft:requestcloseUi", function ()
    SendNUIMessage(
        {
            type = "closeUi",
        }
    )
end)

RegisterNuiCallback('closeUI', function ()
    SetNuiFocus(false, false)
    inCraftUi = false
    stopcraft = true
    incheckdistance = false
end)

RegisterNUICallback('checkcraft', function (data)
	TriggerServerEvent("cdtcraft:checkcraft", data)
end)

RegisterNetEvent("cdtcraft:responsecheckcraft")
AddEventHandler("cdtcraft:responsecheckcraft", function (index, countCraft, dataitems)
    SendNUIMessage(
        {
            type = "responsecheckcraft",
            index = index,
            countCraft = countCraft,
            dataitems = dataitems,
        }
    )
end)

RegisterNUICallback('openstash', function (indexstash)
	exports.ox_inventory:openInventory("stash", "craft"..indexstash.index)
end)

RegisterNuiCallback("startcraft", function (data)   
    TriggerEvent("cdtcraft:startCraft", data)
end)

RegisterNetEvent("cdtcraft:refreshUi")
AddEventHandler("cdtcraft:refreshUi", function ()
    SendNUIMessage(
        {
            type = "refreshUi",
        }
    )
end)
