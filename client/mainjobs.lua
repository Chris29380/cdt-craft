RegisterNetEvent("cdtcraft:generatemarkersjob")
AddEventHandler("cdtcraft:generatemarkersjob", function (indexs)
    local data = Options.zonescraftjobs[indexs]
    local type = data["markertype"]
    local color = data["markercolor"]
    local scalex = data["scalex"]
    local scaley = data["scaley"]
    local scalez = data["scalez"]
    local coords = data["coords"]

    Citizen.CreateThread(function ()
        while true do
            local coordsp = GetEntityCoords(PlayerPedId())
            local dist = #(coordsp - coords)
            if findjob[indexs] == false then
                TriggerEvent("cdtcraft:initBlipsjobs")
                break
            end
            if dist and dist > data["drawdistance"] + 100 then
                Wait(3000)
            elseif dist and dist < data["drawdistance"] + 100 and dist >= data["drawdistance"] + 50 then
                Wait(1000)
            elseif dist and dist < data["drawdistance"] + 50 and dist >= data["drawdistance"] + 20 then
                Wait(500)
            elseif dist and dist < data["drawdistance"] + 20 and dist >= data["drawdistance"] + 10 then
                Wait(100)
            elseif dist and dist < data["drawdistance"] + 10 and dist >= data["drawdistance"] then
                Wait(50)
            elseif dist and dist < data["drawdistance"] and dist > data["actiondistance"] then
                DrawMarker(type, coords.x, coords.y, coords.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, scalex, scaley, scalez, color.R, color.G, color.B, color.A, false, true, 2, false, nil, nil, false)
            elseif dist <= data["actiondistance"] then
                if not inCraftUi then
                    DrawMarker(type, coords.x, coords.y, coords.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, scalex, scaley, scalez, color.R, color.G, color.B, color.A, false, true, 2, false, nil, nil, false)
                    local textaction = "[<C>"..data.keyaction.."</C>] "..data.labelaction
                    CDT.Functions.DrawText3D(coords.x, coords.y, coords.z + 1.0, textaction, 4, 255,255,255,255, false)
                    if IsControlJustPressed(1, data.keycode) then
                        TriggerEvent("cdtcraft:openUi", data, indexs)
                        inCraftUi = true
                    end
                else
                    Wait(1000)
                end                 
            end
            Citizen.Wait(0)
        end
    end)
end)