propsplayer = {}

function startAnim(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(ESX.PlayerData.ped, lib, anim, 8.0, -8.0, -1, 1, 0.0, false, false, false)
		RemoveAnimDict(lib)
	end)
end

function startScenario(anim)
	TaskStartScenarioInPlace(ESX.PlayerData.ped, anim, 0, false)
end

function LoadAnim(dict)
    if not DoesAnimDictExist(dict) then
        return false
    end

    local timeout = 2000
    while not HasAnimDictLoaded(dict) and timeout > 0 do
        RequestAnimDict(dict)
        Wait(5)
        timeout = timeout - 5
    end
    if timeout == 0 then
        return false
    else
        return true
    end
end

function LoadPropDict(model)
    -- load the model if it's not loaded and wait until it's loaded or timeout
    if not HasModelLoaded(joaat(model)) then
        RequestModel(joaat(model))
        local timeout = 2000
        while not HasModelLoaded(joaat(model)) and timeout > 0 do
            Wait(5)
            timeout = timeout - 5
        end
        if timeout == 0 then
            return
        end
    end
end

function AddPropToPlayer(prop1, bone, off1, off2, off3, rot1, rot2, rot3, textureVariation)
    local Player = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(Player))

    if not HasModelLoaded(prop1) then
        LoadPropDict(prop1)
    end

    prop = CreateObject(joaat(prop1), x, y, z + 0.2, true, true, true)
    table.insert(propsplayer, {idprop = prop})
    if textureVariation ~= nil then
        SetObjectTextureVariation(prop, textureVariation)
    end
    AttachEntityToEntity(prop, Player, GetPedBoneIndex(Player, bone), off1, off2, off3, rot1, rot2, rot3, true, true,
        false, true, 1, true)
    SetModelAsNoLongerNeeded(prop1)
end

function cleanplayer()
    ClearPedTasks(PlayerPedId())
    if propsplayer then
        for k,v in pairs(propsplayer) do
            DeleteEntity(v.idprop)
        end
    end
end