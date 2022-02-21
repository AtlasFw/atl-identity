ATL = {
    Active = false,
    Invisible = false,
    Cam = nil,
    Ipl = nil
}

local function disableDefault()
    local ped = PlayerPedId()
    for i = 1, 12 do
		EnableDispatchService(i, false)
	end
    SetCanAttackFriendly(ped, true, false)
    NetworkSetFriendlyFireOption(true)
    SetMaxWantedLevel(0)
    SetPedDefaultComponentVariation(ped)
    DisablePlayerVehicleRewards(PlayerPedId())
	DisableIdleCamera(true)
end

local function requestCamera(p, coords)
    RequestIpl(ATL.Ipl)
    if not DoesCamExist(ATL.Cam) then
        ATL.Cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', coords.x + 1.5, coords.y, coords.z + 1.5, 300.00, 0.00, 0.00, 60.00, false, 0)
        PointCamAtEntity(ATL.Cam, PlayerPedId(), -0.2, 0.0, 0.2, true)
        SetCamActive(ATL.Cam, true)
        RenderScriptCams(true, false, 0, true, true)
    end
    -- Set invincible too would be nice
    SetEntityVisible(PlayerPedId(), false)
    p:resolve({error = false})
end

local function startMulticharacter(playerData, identity)
    ATL = {Active = true, Ipl = identity.ipl}
    local p = promise.new()
    exports['spawnmanager']:spawnPlayer({
        model = 'mp_m_freemode_01',
        x = identity.Spawn.x,
        y = identity.Spawn.y,
        z = identity.Spawn.z,
        heading = identity.Spawn.w,
        skipFade = true
    }, function(spawn)
        if not spawn then return p:resolve({error = true}) end
        disableDefault()
        requestCamera(p, identity.Spawn)
    end)

    local error = Citizen.Await(p).error
    if not error then
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = 'startMulticharacter',
            playerData = playerData,
            identity = identity
        })
    end
    ShutdownLoadingScreenNui()
end

RegisterNetEvent('atl:client:startMulticharacter', startMulticharacter)
