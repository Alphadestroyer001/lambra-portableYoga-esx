local ESX = exports['es_extended']:getSharedObject()

local ownMat
local ownMatState = false

local isDelayed = false
local doingYoga = false
local closestMat = 0

CreateThread(function() -- Entity Spawning

    RequestModel(GetHashKey("prop_yoga_mat_03"))
	while not HasModelLoaded(GetHashKey("prop_yoga_mat_03")) do
		Wait(1)
	end

    RequestModel(GetHashKey("v_res_fa_yogamat1"))
	while not HasModelLoaded(GetHashKey("v_res_fa_yogamat1")) do
		Wait(1)
	end

    RequestModel(GetHashKey("prop_yoga_mat_01"))
	while not HasModelLoaded(GetHashKey("prop_yoga_mat_01")) do
		Wait(1)
	end

    LoadAnimDict('amb@medic@standing@kneel@base')
	LoadAnimDict('anim@gangops@facility@servers@bodysearch@')

    while true do
        local pCoords = GetEntityCoords(PlayerPedId())

        for i, mat in pairs(Config.staticMats) do
            if #(pCoords - vector3(mat.coords.x, mat.coords.y, mat.coords.z)) < 50 then
                if not mat.isSpawned then
                    mat.isSpawned = true
                    CreateThread(function()
                        mat.entity = CreateObject(GetHashKey("prop_yoga_mat_03"), mat.coords.x, mat.coords.y, mat.coords.z, false, true, false)
                        while not mat.entity do Wait(1) end
                        SetEntityHeading(mat.entity, mat.coords.w)
                        FreezeEntityPosition(true)
                    end)
                end
            elseif mat.isSpawned then
                mat.isSpawned = false
                DeleteEntity(mat.entity)
            end
        end

        Wait(5000)
    end
end)

CreateThread(function() -- closest Mat
    while true do
        local pCoords = GetEntityCoords(PlayerPedId())

        if ownMat then
            closestMat = ownMat
        else
            closestMat = GetClosestObjectOfType(pCoords.x, pCoords.y, pCoords.z, 3.0, GetHashKey("prop_yoga_mat_03"), 0, 0, 0)
        end
        Wait(2000)
    end
end)

CreateThread(function() -- Mat interaction
    while true do
        local inRange = false
        local ped = PlayerPedId()
        local pCoords = GetEntityCoords(ped)

        if closestMat ~= 0 then
            local coords = GetEntityCoords(closestMat)
            if #(pCoords - coords) <= 1.5 then
                inRange = true
                if closestMat == ownMat then
                    if not ownMatState then
                        DrawText3D(vector3(coords.x, coords.y, coords.z + 0.2), Locales["startYoga"])
                        if IsControlJustReleased(0, 38) then
                            TaskPlayAnim(ped, "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
	                        TaskPlayAnim(ped, "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )
                            Wait(2000)
                            ClearPedTasks(ped)
                            local matCoords = GetEntityCoords(ownMat)
                            local matHeading = GetEntityHeading(ownMat)
                            DeleteEntity(ownMat)
                            ownMatState = true
                            ownMat = CreateObject(GetHashKey("prop_yoga_mat_01"), vector3(matCoords.x, matCoords.y, matCoords.z - 0.08), false, true, false)
                            while not ownMat do Wait(1) end
                            SetEntityHeading(ownMat, matHeading)
                            FreezeEntityPosition(true)
                        end

                        DrawText3D(coords, Locales["pickupMat"])
                        if IsControlJustReleased(0, 47) then
                            TaskPlayAnim(ped, "pickup_object", "pickup_low", 8.0, 8.0, -1, 50, 0, false, false, false)
                            Wait(1000)
                            DeleteEntity(ownMat)
                            ClearPedTasks(ped)
                            ownMat = nil
                            TriggerServerEvent("lambra-portableYoga:server:pickupMat")
                        end
                    else
                        if not doingYoga then
                            DrawText3D(vector3(coords.x, coords.y, coords.z + 0.2), Locales["startYoga"])
                            if IsControlJustReleased(0, 38) then
                                exports['an_progBar']:run(10,'Doing Yoga','#E14127')
                                if not isDelayed then
                                    if Config.Delay.enabled then isDelayed = true end
                                    local pickedAnim = Config.Anims[math.random(1, #Config.Anims)]
                                    LoadAnimDict(pickedAnim.dict)
                                    TaskPlayAnim(ped, pickedAnim.dict, pickedAnim.anim, 8.0, 1.0, -1, 1, 0, 0, 0, 0)
                                    doingYoga = true
                                    
                                    Citizen.Wait(10000)
                                    --exports['an_progBar']:stop()
                                    -- code after the progress bar
                                    ClearPedTasks(ped)
                                    
                                    -- Trigger Below to add either heal/stress relief/etc

                                    --TriggerServerEvent('hud:server:RelieveStress', Config.reliefAmount)
                                    doingYoga = false
                                    Citizen.SetTimeout(Config.Delay.amount, function() isDelayed = false end)
                                end
                                Wait(1000)
                            end

                            DrawText3D(coords, Locales["rollMat"])
                            if IsControlJustReleased(0, 47) then
                                TaskPlayAnim(ped, "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
	                            TaskPlayAnim(ped, "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )
                                Wait(2000)
                                ClearPedTasks(ped)
                                local matCoords = GetEntityCoords(ownMat)
                                local matHeading = GetEntityHeading(ownMat)
                                DeleteEntity(ownMat)
                                ownMatState = false
                                ownMat = CreateObject(GetHashKey("v_res_fa_yogamat1"), vector3(matCoords.x, matCoords.y, matCoords.z - 0.08), false, true, false)
                                while not ownMat do Wait(1) end
                                SetEntityHeading(ownMat, matHeading)
                                FreezeEntityPosition(true)
                            end
                        end
                    end
                else
                    if not doingYoga then
                        DrawText3D(coords, Locales["startYoga"])
                        if IsControlJustReleased(0, 38) then
                            exports['an_progBar']:run(10,'Doing Yoga','#E14127')
                                if not isDelayed then
                                    if Config.Delay.enabled then isDelayed = true end
                                    local pickedAnim = Config.Anims[math.random(1, #Config.Anims)]
                                    LoadAnimDict(pickedAnim.dict)
                                    TaskPlayAnim(ped, pickedAnim.dict, pickedAnim.anim, 8.0, 1.0, -1, 1, 0, 0, 0, 0)
                                    doingYoga = true
                                    
                                    Citizen.Wait(10000)
                                    --exports['an_progBar']:stop()
                                    -- code after the progress bar
                                    ClearPedTasks(ped)
                                    
                                    -- Trigger Below to add either heal/stress relief/etc

                                    --TriggerServerEvent('hud:server:RelieveStress', Config.reliefAmount)
                                    doingYoga = false
                                    Citizen.SetTimeout(Config.Delay.amount, function() isDelayed = false end)
                                end
                                Wait(1000)
                            end
                    end
                end
            end
        end

        if not inRange then Wait(2000) end
        Wait(3)
    end
end)

RegisterNetEvent("lambra-portableYoga:client:setMat", function()
    CreateThread(function()
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local heading = GetEntityHeading(ped)
        coords = vector3(coords.x + (GetEntityForwardX(ped) *0.9), coords.y + (GetEntityForwardY(ped)*0.9), coords.z -1)

        TaskPlayAnim(ped, "pickup_object", "pickup_low", 8.0, 8.0, -1, 50, 0, false, false, false)
        Wait(1000)
        ClearPedTasks(ped)

        ownMat = CreateObject(GetHashKey("v_res_fa_yogamat1"), coords, false, true, false)
        while not ownMat do Wait(1) end
        SetEntityHeading(ownMat, heading + 90)
        FreezeEntityPosition(true)
    end)
end)


AddEventHandler('onResourceStop', function(resourceName) -- Entity Forced removal
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end

    for i, mat in pairs(Config.staticMats) do
        if mat.isSpawned then DeleteEntity(mat.entity) end
    end

    if ownMat then DeleteEntity(ownMat) end
end)

function LoadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

function DrawText3D(coords, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(coords, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 100)
    ClearDrawOrigin()
end


