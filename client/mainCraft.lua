stopcraft = false

RegisterNetEvent("cdtcraft:stateincraft")
AddEventHandler("cdtcraft:stateincraft", function ()
    stopcraft = not stopcraft
end)

RegisterNetEvent("cdtcraft:checkdistance")
AddEventHandler("cdtcraft:checkdistance", function (indexs)
    Citizen.CreateThread(function ()
        incheckdistance = true
        while true do
            local pos = GetEntityCoords(PlayerPedId())
            local poscraft = Options.zonescraft[indexs].coords
            local distance = #(pos - poscraft)
            if distance > Options.zonescraft[indexs].actiondistance then
                stopcraft = true
                break
            end
            if incheckdistance == false then
                break
            end
            Wait(1000)
        end
    end)
end)

RegisterNetEvent("cdtcraft:startCraft")
AddEventHandler("cdtcraft:startCraft", function (data)
    Citizen.CreateThread(function ()
        print("data craft : "..json.encode(data))
        local indexs = data.indexs
        local isjob = data.isjob
        local timer = data.datarecipe.timer or 3000
        local dict = data.datarecipe.anim.dict
        local anim = data.datarecipe.anim.animation
        local scenario = data.datarecipe.scenario
        local itemsneed = data.datarecipe.items
        local itemfinal = data.datarecipe.itemfinal
        local labelitemfinal = data.datarecipe.labelitemfinal
        local qtyfinal = data.datarecipe.qtyfinal
        local count = data.countCraft
        local loopcraft = 0 
        stopcraft = false
        inanim = false

        while true do
            loopcraft = loopcraft + 1
            if loopcraft == count + 1 then
                stopcraft = true
            end
            if stopcraft then
                cleanplayer()
                if inCraftUi then
                    TriggerEvent("cdtcraft:requestcloseUi")
                end
                break
            else
                TriggerServerEvent("cdtcraft:manageitems", indexs, isjob, itemsneed, itemfinal, qtyfinal, labelitemfinal, timer)
            end
            if dict and not inanim then
                startAnim(dict, anim)
                inanim = true
            elseif scenario and not inanim then
                startScenario(scenario)
                inanim = true
            end
            Wait(timer)
            if not stopcraft then
                TriggerEvent("cdtcraft:refreshUi")
            end
        end

    end)
end)

