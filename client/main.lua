ATL = { }
ATL.Active = {
    Multichar = false,
    Identity = false
}

local function startMulticharacter(playerData, identity)
    ATL.Active.Multichar = true
    DoScreenFadeOut(1500)
    Wait(1500)
    ShutdownLoadingScreenNui()
    ShutdownLoadingScreen()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'startMulticharacter',
        playerData = playerData,
        identity = identity
    })
end

RegisterNetEvent('atl:client:startMulticharacter', startMulticharacter)