CDT = exports['cdt-lib']:getCDTLib()


-- locals

local ox_inventory = exports.ox_inventory
local incraft = {}

function round(x, n)
    return tonumber(string.format("%." .. n .. "f", x))
end

RegisterNetEvent("cdtcraft:initstashes")
AddEventHandler("cdtcraft:initstashes", function ()
    if Options.zonescraft then
        for i = 1, #Options.zonescraft do
            local zone = Options.zonescraft[i]
            local stash = Options.zonescraft[i].stash
            local id = "craft"..i
            local label = zone.label
            local slots = stash.slots
            local maxWeight = stash.maxweight
            local owner = stash.owner
            local groups = null
            local coords = zone.coords
            ox_inventory:RegisterStash(id, label, slots, maxWeight, owner, groups, coords)
        end
    end
    if Options.zonescraftjobs then
        for i = 1, #Options.zonescraftjobs do
            local zone = Options.zonescraftjobs[i]
            local stash = Options.zonescraftjobs[i].stash
            local id = "craftjob"..i
            local label = zone.label
            local slots = stash.slots
            local maxWeight = stash.maxweight
            local owner = stash.owner
            local groups = null
            local coords = zone.coords
            ox_inventory:RegisterStash(id, label, slots, maxWeight, owner, groups, coords)
        end
    end
end)

RegisterNetEvent('onResourceStart')
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then 
        TriggerEvent("cdtcraft:initstashes")
    end
end)

RegisterNetEvent("cdtcraft:checkcraft")
AddEventHandler("cdtcraft:checkcraft", function (data)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if data then
            print("data : "..json.encode(data))
            local countCraft = 0
            local countItem = {}
            local itemsP = CDT.Functions.getItemsPlayer(xPlayer.source)
            local index = data.index
            local itemsCraft = data.data.items
            local dataitems = {}
            print("data items : "..json.encode(data.data.items))
            if itemsP and itemsCraft then
                for i = 1, #itemsCraft do
                    local findItem = false
                    local nameIC = itemsCraft[i].name 
                    local qtyIC = itemsCraft[i].qty
                    for k,v in pairs(itemsP) do
                        local nameIP = v.name
                        local qtyIP = v.count
                        if nameIC == nameIP then
                            findItem = true
                            local prop = tonumber(qtyIP / qtyIC)
                            if prop >= 1 then 
                                local qtyC = round(prop, 0)
                                table.insert(countItem, {qtyCraft = tonumber(qtyC)})
                            else
                                table.insert(countItem, {qtyCraft = 0})
                            end
                            table.insert(dataitems, {name = nameIC, qty = qtyIC, bag = v.count})
                        end
                    end
                    if findItem == false then
                        table.insert(countItem, {qtyCraft = 0})
                        table.insert(dataitems, {name = nameIC, qty = qtyIC, bag = 0})
                    end
                end
                if next(countItem) ~= nil then
                    table.sort(countItem, function(a,b)
                        return a.qtyCraft < b.qtyCraft
                    end)
                    countCraft = countItem[1].qtyCraft
                else
                    countCraft = 0
                end
                TriggerClientEvent("cdtcraft:responsecheckcraft", xPlayer.source, index, countCraft, dataitems)
            else
                print("no itemsP or itemsCraft - cdtcraft:checkcraft")
            end
        else
            print('no data - cdtcraft:checkcraft')
        end
    else
        print('no xPlayer - cdtcraft:checkcraft')
    end
end)

RegisterNetEvent("cdtcraft:manageitems")
AddEventHandler("cdtcraft:manageitems", function (indexs, isjob, itemsneed, itemfinal, qtyfinal, labelitemfinal, timer)
    local xPlayer = ESX.GetPlayerFromId(source)
    local canAdd = true
    print("indexs : "..indexs)
    print("itemsneed : "..json.encode(itemsneed))
    print("itemfinal : "..json.encode(itemfinal))
    print("qtyfinal : "..qtyfinal)
    print("labelitemfinal : "..labelitemfinal)
    print("timer : "..timer)
    if xPlayer then
        if not incraft[xPlayer.source] then
            incraft[xPlayer.source] = true

            local itemsP = CDT.Functions.getItemsPlayer(xPlayer.source)
            if itemsP and itemsneed then
                local findItem = {}
                for i = 1, #itemsneed do
                    findItem[i] = false
                    local nameIC = itemsneed[i].name 
                    local qtyIC = itemsneed[i].qty
                    for k,v in pairs(itemsP) do
                        local nameIP = v.name
                        local qtyIP = v.count
                        if nameIC == nameIP then
                            if qtyIP >= qtyIC then
                                findItem[i] = true
                            else
                                findItem[i] = false
                            end
                        end
                    end
                end
                for j = 1, #itemsneed do
                    if findItem[j] == false then
                        canAdd = false
                        break
                    end
                end
                if canAdd then
                    for l = 1, #itemsneed do
                        ox_inventory:RemoveItem(xPlayer.source, itemsneed[l].name, itemsneed[l].qty)
                    end
                    Wait(timer - 300)
                    if isjob then
                        local inventory = ox_inventory:GetInventory({id = 'craftjob'..indexs, owner = xPlayer.identifier})
                        exports.ox_inventory:AddItem(inventory.id, itemfinal, qtyfinal)
                        local rd = math.random(1000,9999999)
                        local data = {
                            msg = qtyfinal.." "..labelitemfinal.." ajouté(s) au stockage",
                            timer = 2500,
                            id = "craftok"..rd
                        }
                        TriggerClientEvent("cdtcraft:notifcraftok", xPlayer.source, data)
                    else
                        local inventory = ox_inventory:GetInventory({id = 'craft'..indexs, owner = xPlayer.identifier})
                        exports.ox_inventory:AddItem(inventory.id, itemfinal, qtyfinal)
                        local rd = math.random(1000,9999999)
                        local data = {
                            msg = qtyfinal.." "..labelitemfinal.." ajouté(s) au stockage",
                            timer = 2500,
                            id = "craftok"..rd
                        }
                        TriggerClientEvent("cdtcraft:notifcraftok", xPlayer.source, data)
                    end
                else
                    Wait(timer - 300)
                    TriggerClientEvent("cdtcraft:stateincraft", xPlayer.source)
                    local rd = math.random(1000,9999999)
                    local data = {
                        msg = "Il vous manque des ingrédients...",
                        timer = 2500,
                        id = "crafterror"..rd
                    }
                    TriggerClientEvent("cdtcraft:notifcrafterror", xPlayer.source, data)
                end
                incraft[xPlayer.source] = false

            else
                Wait(timer - 300)
                TriggerClientEvent("cdtcraft:stateincraft", xPlayer.source)
                incraft[xPlayer.source] = false
                local rd = math.random(1000,9999999)
                local data = {
                    msg = "Il vous manque des ingrédients...",
                    timer = 2500,
                    id = "crafterror"..rd
                }
                TriggerClientEvent("cdtcraft:notifcrafterror", xPlayer.source, data)
            end
        end
    else
        print('no xPlayer - cdtcraft:manageitems')
    end
end)
