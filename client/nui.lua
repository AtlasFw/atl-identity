local function updateCamera()
    if not ATL.Cam then return end
    SetCamActive(ATL.Cam, false)
    RenderScriptCams(false, false, 0, true, true)
    RemoveIpl(ATL.Ipl)
    ATL.Cam = nil
    ATL.Ipl = nil
end

RegisterNUICallback('update_character', function(data, cb)
    if ATL.Active then
        if data then
            -- Needs some type of validation
            if data.appearance then
                -- exports['atl-appearance']:setAppearance(ped, data)
            end
            SetEntityVisible(PlayerPedId(), data.state)
        end
    end
    cb({})
end)

RegisterNUICallback('select_character', function(data, cb)
    if ATL.Active then
        if data then
            TriggerServerEvent('atl:server:loadCharacter', data)
            updateCamera()
            ATL.Active = false
            SetNuiFocus(false, false)
            cb({ done = true })
            DoScreenFadeOut(0)
            Wait(2000)
            DoScreenFadeIn(1500)
            return
        end
    end
    cb{{ done = false }}
end)

RegisterNUICallback('create_character', function(data, cb)
    if ATL.Active then
        if data then
            TriggerServerEvent('atl:server:registerNewCharacter', data)
            updateCamera()
            ATL.Active = false
            SetNuiFocus(false, false)
            cb({ done = true })
            SetEntityVisible(PlayerPedId(), true)
            return
        end
    end
    cb({ done = true })
end)

RegisterNUICallback('delete_character', function(data, cb)
    if ATL.Active then
        if data then
            TriggerServerEvent('atl:server:deleteCharacter', data)
            updateCamera()
            ATL.Active = false
            SetNuiFocus(true, false)
            cb({ done = true })
            return
        end
    end
    cb({ done = false })
end)

RegisterNUICallback('leave_server', function(_, cb)
    if ATL.Active then
        TriggerServerEvent('atl:server:leaveServer')
        ATL.Active = false
        SetNuiFocus(false, false)
    end
    cb({})
end)