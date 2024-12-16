
RegisterNetEvent("cdtcraft:openUi")
AddEventHandler("cdtcraft:openUi", function (data, indexs)
    SendNUIMessage(
        {
            type = "openUi",
            data = data,
            indexs = indexs,
            isjob = false,
        }
    )
    SetNuiFocus(true, true)
    inCraftUi = true
end)

RegisterNetEvent("cdtcraft:openUiJob")
AddEventHandler("cdtcraft:openUiJob", function (data, indexs)
    SendNUIMessage(
        {
            type = "openUi",
            data = data,
            indexs = indexs,
            isjob = true,
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

RegisterNuiCallback("notifjs", function (data)   
    local type = data.datamg.type
    local msg = data.datamg.msg
    local timer = data.datamg.timer
    local id = math.random(1000,9999999)
    if type == "success" then
        Notifs("craftsuccess", msg, timer, id)
    elseif type == "info" then
        Notifs("craftinfo", msg, timer, id)
    elseif type == "error" then
        Notifs("crafterror", msg, timer, id)
    end
end)

RegisterNUICallback('openstash', function (data)
    local indexstash = data.index
    local isjob = data.isjob
    if isjob then
        exports.ox_inventory:openInventory("stash", "craftjob"..indexstash)
    else
        exports.ox_inventory:openInventory("stash", "craft"..indexstash)
    end
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
