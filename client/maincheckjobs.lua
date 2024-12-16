findjob = {}
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
                        if startjob[k] == true then
                            startjob[k] = false
                            TriggerEvent("cdtcraft:generatemarkersjob", k)
                            TriggerEvent("cdtcraft:initBlipsjobs")
                        end
                    end
                end
            end
            Citizen.Wait(5000)
        end
    end)
end)
