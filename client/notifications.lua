RegisterNetEvent("cdtcraft:notifcraftok")
AddEventHandler("cdtcraft:notifcraftok", function (data)
    Notifs("craftsuccess", data.msg, data.timer, data.id)
end)

RegisterNetEvent("cdtcraft:notifcraftinfo")
AddEventHandler("cdtcraft:notifcraftinfo", function (data)
    Notifs("craftinfo", data.msg, data.timer, data.id)
end)

RegisterNetEvent("cdtcraft:notifcrafterror")
AddEventHandler("cdtcraft:notifcrafterror", function (data)
    Notifs("crafterror", data.msg, data.timer, data.id)
end)