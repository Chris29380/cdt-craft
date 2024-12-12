findjob = {}
blipsjobs = {}
startjob = {}

RegisterNetEvent("cdtcraft:checkJob")
AddEventHandler("cdtcraft:checkJob", function ()    
    Citizen.CreateThread(function ()
        for k,v in pairs(Options.zonescraftjobs) do
            startjob[k] = false
        end
        while true do
            local newJob = ESX.PlayerData.job.name
            local newGrade = ESX.PlayerData.job.grade
            for k,v in pairs(Options.zonescraftjobs) do
                findjob[k] = false
                for i,j in pairs(v.jobs) do
                    if newJob == j.name and newGrade >= j.grade then
                        findjob[k] = true
                    end
                end
            end
            if findjob then
                for k, v in pairs(findjob) do
                    if v == true then
                        if not startjob[k] then
                            startjob[k] = true
                            TriggerEvent("cdtcraft:generatemarkersjob", k)
                            TriggerEvent("cdtcraft:initBlipsjobs")
                        end
                    else
                        startjob[k] = false
                    end
                end
            end
            Citizen.Wait(5000)
        end
    end)
end)

--------------------------------------------------------------------
---  Blips
--------------------------------------------------------------------

RegisterNetEvent("cdtcraft:initBlipsjobs")
AddEventHandler("cdtcraft:initBlipsjobs", function ()
    if blipsjobs then
        for i = 1, #blipsjobs do
            if blipsjobs[i]["blipId"] ~= nil then
                RemoveBlip(blipsjobs[i]["blipId"])
            end
        end
        blipsjobs = {}
    end
    for k,v in pairs(Options.zonescraftjobs) do
        if v["showblip"] then
            if findjob[k] == true then
                TriggerEvent("cdtcraft:generateblipsjobs", v)
            end
        end
    end
end)

RegisterNetEvent("cdtcraft:generateblipsjobs")
AddEventHandler("cdtcraft:generateblipsjobs", function (data)
    local type = data["type"]
    local color = data["color"]
    local scale = data["scale"]
    local label = data["label"]
    local blip = AddBlipForCoord(data["coords"].x, data["coords"].y, data["coords"].z)
    SetBlipDisplay(blip, 4)
    SetBlipSprite(blip, tonumber(type))
    SetBlipColour(blip, tonumber(color))
    SetBlipScale(blip, tonumber(scale))
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(label)
    EndTextCommandSetBlipName(blip)
    table.insert(blips, {blipId = blip})
end)