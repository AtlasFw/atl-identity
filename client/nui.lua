RegisterNUICallback('select_character', function(data, cb)
    if ATL.Active.Multichar then
        if data then
            TriggerServerEvent('atl:server:loadPlayer', data)
            ATL.Active.Multichar = false
            SetNuiFocus(false, false)
            cb({ done = true })
            return
        end
    end
    cb{{ done = false }}
end)

RegisterNUICallback('create_character', function(data, cb)
    if ATL.Active.Multichar then
        if data then
            TriggerServerEvent('atl:server:registerNewPlayer', data)
            ATL.Active.Multichar = false
            SetNuiFocus(false, false)
            cb({ done = true })
            return
        end
    end
    cb({ done = true })
end)

RegisterNUICallback('delete_character', function(data, cb)
    if ATL.Active.Multichar then
        if data then
            TriggerServerEvent('atl:server:deletePlayer', data)
            ATL.Active.Multichar = false
            SetNuiFocus(true, false)
            cb({ done = true })
            return
        end
    end
    cb({ done = false })
end)

RegisterNUICallback('leave_server', function(_, cb)
    if ATL.Active.Multichar then
        TriggerServerEvent('atl:server:leaveServer')
        ATL.Active.Multichar = false
        SetNuiFocus(false, false)
    end
    cb({})
end)