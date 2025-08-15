Citizen.CreateThread(function()
    local shellModelHash = GetHashKey("w_pi_singleshoth4_shell") 
    local offsetVector = vector3(0.1, 0.1, 0.0) 
    local ejectDir = vector3(1.0, 0.0, 0.5) 
    local rotVector = vector3(0.0, 90.0, 0.0) 

    local pistols = {
        GetHashKey("WEAPON_PISTOL"),
        GetHashKey("WEAPON_PISTOL_MK2"),
        GetHashKey("WEAPON_COMBATPISTOL"),
        GetHashKey("WEAPON_APPISTOL"),
        GetHashKey("WEAPON_PISTOL50"),
        GetHashKey("WEAPON_SNSPISTOL"),
        GetHashKey("WEAPON_HEAVYPISTOL"),
        GetHashKey("WEAPON_VINTAGEPISTOL"),
    }

    RequestModel(shellModelHash)
    while not HasModelLoaded(shellModelHash) do
        Citizen.Wait(100)
    end

    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()

        if IsPedShooting(playerPed) then
            local weapon = GetSelectedPedWeapon(playerPed)

            for _, pistolHash in ipairs(pistols) do
                if weapon == pistolHash then
                    local boneIndex = GetPedBoneIndex(playerPed, 57005)
                    local bonePos = GetWorldPositionOfEntityBone(playerPed, boneIndex) + offsetVector
                    local shell = CreateObject(shellModelHash, bonePos.x, bonePos.y, bonePos.z, true, true, false)
                    if DoesEntityExist(shell) then
                        SetEntityDynamic(shell, true)
                        SetEntityCollision(shell, true, true)
                        ApplyForceToEntity(shell, 1, ejectDir.x, ejectDir.y, ejectDir.z, 0.0, 0.0, 0.0, 0, false, true, true, false, true)
                        SetEntityRotation(shell, rotVector.x, rotVector.y, rotVector.z, 2, true)


                        Citizen.SetTimeout(10000, function()
                            if DoesEntityExist(shell) then
                                DeleteObject(shell)
                            end
                        end)
                    else

                    end

                    Citizen.Wait(500) 
                    break 
                end
            end
        end
    end
end)

function ShowNotification(message)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandThefeedPostTicker(true, false)
end