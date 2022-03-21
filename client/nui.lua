local function updateCamera()
  if not ATL.Cam then
    return
  end
  RemoveIpl(ATL.Ipl)
  DestroyCam(ATL.Cam, false)
  RenderScriptCams(false, false, 0, true, true)
  SetNuiFocus(false, false)
  SetEntityVisible(PlayerPedId(), true)
  ATL.Cam = nil
  ATL.Ipl = nil
  ATL.Active = false
end

RegisterNUICallback('update_character', function(data, cb)
  if ATL.Active then
    if data then
      local ped = PlayerPedId()
      if data.appearance and next(data.appearance) then
        local reload = GetEntityModel(ped) ~= joaat(data.appearance.model)
        exports['atl-appearance']:setSkin(
          ped,
          data.appearance,
          reload
        )
        SetEntityVisible(PlayerPedId(), true)
      else
        SetEntityVisible(ped, false)
      end
    end
  end
  cb({})
end)

RegisterNUICallback('select_character', function(data, cb)
  if ATL.Active then
    if data then
      TriggerServerEvent('atl-core:server:loadCharacter', data)
      updateCamera()
    end
  end
  cb({})
end)

RegisterNUICallback('create_character', function(data, cb)
  if ATL.Active then
    if data then
      exports['atl-appearance']:startAppearance({
        exit = false,
      }, function(skin)
        if skin then
          TriggerServerEvent('atl-core:server:registerCharacter', data, skin)
          updateCamera()
          cb({})
        end
      end)
    else
      cb({})
    end
  end
end)

RegisterNUICallback('delete_character', function(data, cb)
  if ATL.Active then
    if data then
      TriggerServerEvent('atl-core:server:deleteCharacter', data)
      updateCamera()
    end
  end
  cb({})
end)

RegisterNUICallback('leave_server', function(_, cb)
  if ATL.Active then
    TriggerServerEvent 'atl-core:server:playerExit'
    updateCamera()
  end
  cb({})
end)
