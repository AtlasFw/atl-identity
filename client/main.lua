ATL = {
  Active = false,
  Cam = nil,
  Ipl = nil,
}

local function disableDefault()
  local ped = PlayerPedId()

  -- Emergency services
  DisablePlayerVehicleRewards(ped)
  SetMaxWantedLevel(0)
  for i = 1, 12 do
    EnableDispatchService(i, false)
  end

  -- PVP
  SetCanAttackFriendly(ped, true, false)
  NetworkSetFriendlyFireOption(true)

  -- Radar/HUD
  DisableIdleCamera(true)
  DisplayRadar(false)

  -- Set player's ped with default clothes
  SetPedDefaultComponentVariation(ped)
end

local function requestCamera(p, coords)
  RequestIpl(ATL.Ipl)
  local ped = PlayerPedId()
  if not DoesCamExist(ATL.Cam) then
    ATL.Cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', coords.x + 1.5, coords.y, coords.z + 1.5, 300.00, 0.00, 0.00, 80.00, false, 0)
    PointCamAtEntity(ATL.Cam, ped, -0.2, 0.0, 0.2, true)
    SetCamActive(ATL.Cam, true)
    RenderScriptCams(true, false, 0, true, true)
  end

  -- Set invincible too would be nice
  SetEntityVisible(ped, false)
  p:resolve(true)
end

local function startMulticharacter(playerData, identity, jobs)
  ATL.Active, ATL.Ipl = true, identity.IplName

  local p = promise.new()
  exports['spawnmanager']:spawnPlayer({
    model = 'mp_m_freemode_01',
    x = identity.IplCoords.x,
    y = identity.IplCoords.y,
    z = identity.IplCoords.z,
    heading = identity.IplCoords.w,
    skipFade = true,
  }, function(spawn)
    if not spawn then
      return p:resolve(false)
    end
    disableDefault()
    requestCamera(p, identity.IplCoords)
  end)

  local success = Citizen.Await(p)
  if success then
    SetNuiFocus(true, true)
    SendNUIMessage {
      action = 'startMulticharacter',
      playerData = playerData,
      identity = identity,
      jobs = jobs,
    }
    ShutdownLoadingScreenNui()
  end
end

RegisterNetEvent('atl-identity:client:startMulticharacter', startMulticharacter)