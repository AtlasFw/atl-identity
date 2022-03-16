local function updateCamera()
  if not ATL.Cam then
    return
  end
  SetCamActive(ATL.Cam, false)
  RenderScriptCams(false, false, 0, true, true)
  RemoveIpl(ATL.Ipl)
  SetNuiFocus(false, false)
  ATL.Cam = nil
  ATL.Ipl = nil
  ATL.Active = false
end

RegisterNUICallback('update_character', function(data, cb)
  if ATL.Active then
    if data then
      if data.appearance and next(data.appearance) then
        -- exports['atl-appearance']:setSkin(ped, data)
        SetEntityVisible(PlayerPedId(), true)
      else
        SetEntityVisible(PlayerPedId(), false)
      end
    end
  end
  cb {}
end)

RegisterNUICallback('select_character', function(data, cb)
  if ATL.Active then
    if data then
      TriggerServerEvent('atl-core:server:loadCharacter', data)
      updateCamera()
      cb { done = true }

      -- Set player visible just in case he wasn't already
      SetEntityVisible(PlayerPedId(), true)
      -- Somewhat of a smooth transition
      DoScreenFadeOut(0)
      Wait(1500)
      DoScreenFadeIn(1500)
      return
    end
  end
  cb { { done = false } }
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

          -- Set player visible just in case he wasn't already
          SetEntityVisible(PlayerPedId(), true)
          cb { done = true }
          return
        end
      end)
    end
  end
  cb { done = true }
end)

RegisterNUICallback('delete_character', function(data, cb)
  if ATL.Active then
    if data then
      TriggerServerEvent('atl-core:server:deleteCharacter', data)
      updateCamera()

      cb { done = true }
      return
    end
  end
  cb { done = false }
end)

RegisterNUICallback('leave_server', function(_, cb)
  if ATL.Active then
    TriggerServerEvent 'atl-core:server:playerExit'
    updateCamera()
  end
  cb {}
end)
