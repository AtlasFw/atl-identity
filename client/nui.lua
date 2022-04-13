local function characterCompletion()
  if not ATL.Cam or not ATL.Ipl then
    return
  end

  DoScreenFadeOut(1500)
  Wait(1500)

  -- Clean up camera & IPL
  local ped = PlayerPedId()
  DestroyCam(ATL.Cam, false)
  RenderScriptCams(false, false, 0, true, true)
  SetNuiFocus(false, false)
  RemoveIpl(ATL.Ipl)
  SetEntityVisible(ped, true)
  FreezeEntityPosition(ped, false)
  SetBlockingOfNonTemporaryEvents(ped, false)
  DoScreenFadeIn(1500)

  ATL.Cam, ATL.Ipl, ATL.Active = nil, nil, false
end

RegisterNUICallback('update_character', function(data, cb)
  if not ATL.Active or not data then
    return cb({})
  end

  local ped = PlayerPedId()
  local appearance = data.appearance or {}
  if next(appearance) then
    local reload = GetEntityModel(ped) ~= joaat(appearance['model'])
    exports['atl-appearance']:setSkin(ped, data.appearance, reload)
    SetEntityVisible(PlayerPedId(), true) -- New ped needed
  else
    SetEntityVisible(ped, false)
  end
  cb({})
end)

RegisterNUICallback('select_character', function(data, cb)
  if not ATL.Active or not data then
    return cb({})
  end

  characterCompletion()
  TriggerServerEvent('atl-core:server:loadCharacter', data)
  cb({})
end)

RegisterNUICallback('create_character', function(data, cb)
  if not ATL.Active or not data then
    return cb({})
  end

  local p = promise.new()
  exports['atl-appearance']:startAppearance({
    exit = false,
  }, function(newSkin, skin)
    cb({})
    p:resolve({newSkin = newSkin, skin = skin})
  end, true)

  local resp = Citizen.Await(p)
  if resp.newSkin then
    characterCompletion()
    TriggerServerEvent('atl-core:server:registerCharacter', data, resp.skin)
  end
end)

RegisterNUICallback('delete_character', function(data, cb)
  if not ATL.Active or not data then
    return cb({})
  end

  characterCompletion()
  TriggerServerEvent('atl-core:server:deleteCharacter', data)
  cb({})
end)

RegisterNUICallback('leave_server', function(_, cb)
  if ATL.Active then
    characterCompletion()
    TriggerServerEvent('atl-core:server:playerExit')
  end
  cb({})
end)
