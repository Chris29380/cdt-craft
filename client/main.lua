

CDT = exports['cdt-lib']:getCDTLib()


-- locals

local blips = {}
inCraftUi = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
    Citizen.Wait(2000)
    -- call triggers
    TriggerEvent("cdtcraft:initBlips")
    TriggerEvent("cdtcraft:initMarkers")
    TriggerEvent("cdtcraft:checkJob")
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
    ESX.PlayerLoaded = false
	ESX.PlayerData = {}
end)


RegisterNetEvent('onResourceStart')
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then 
        Citizen.Wait(300)
        -- call trigger
        TriggerEvent("cdtcraft:initBlips")
        TriggerEvent("cdtcraft:initMarkers")
        TriggerEvent("cdtcraft:checkJob")
    end
end)

RegisterNetEvent('onResourceStop')
AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then

    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

--------------------------------------------------------------------
---  Blips
--------------------------------------------------------------------

RegisterNetEvent("cdtcraft:initBlips")
AddEventHandler("cdtcraft:initBlips", function ()
    if blips then
        for i = 1, #blips do
            if blips[i]["blipId"] ~= nil then
                RemoveBlip(blips[i]["blipId"])
            end
        end
        blips = {}
    end
    for k,v in pairs(Options.zonescraft) do
        if v["showblip"] then
            TriggerEvent("cdtcraft:generateblips", v)
        end
    end
end)

RegisterNetEvent("cdtcraft:generateblips")
AddEventHandler("cdtcraft:generateblips", function (data)
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

--------------------------------------------------------------------
---  Markers
--------------------------------------------------------------------

RegisterNetEvent("cdtcraft:initMarkers")
AddEventHandler("cdtcraft:initMarkers", function ()
    if Options.zonescraft then
        for i = 1, #Options.zonescraft do
            local datazonemarker = Options.zonescraft[i]
            TriggerEvent("cdtcraft:generatemarkers", datazonemarker, i)
        end
    end	
end)

RegisterNetEvent("cdtcraft:generatemarkers")
AddEventHandler("cdtcraft:generatemarkers", function (data, indexs)
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