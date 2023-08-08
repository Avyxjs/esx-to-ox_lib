local CurrentProgress = nil
local function Progressbar(message,length,Options)
    if CurrentProgress then
        return false
    end
    CurrentProgress = Options or {}
    if CurrentProgress.animation then 
        if CurrentProgress.animation.type == "anim" then
            ESX.Streaming.RequestAnimDict(CurrentProgress.animation.dict, function()
                TaskPlayAnim(ESX.PlayerData.ped, CurrentProgress.animation.dict, CurrentProgress.animation.lib, 1.0, 1.0, length, 1, 1.0, false,false,false)
                RemoveAnimDict(CurrentProgress.animation.dict)
            end)
        elseif CurrentProgress.animation.type == "Scenario" then
            TaskStartScenarioInPlace(ESX.PlayerData.ped, CurrentProgress.animation.Scenario, 0, true)
        end
    end
    if CurrentProgress.FreezePlayer then FreezeEntityPosition(PlayerPedId(), CurrentProgress.FreezePlayer) end
    lib.progressBar({
        duration = length or 3000,
        label = message,
        useWhileDead = false,
        canCancel = true,
    })
    CurrentProgress.length = length or 3000
    while CurrentProgress ~= nil do
        if CurrentProgress.length > 0 then 
            CurrentProgress.length -= 1000
        else
            ClearPedTasks(ESX.PlayerData.ped)
            if CurrentProgress.FreezePlayer then FreezeEntityPosition(PlayerPedId(), false) end
            if CurrentProgress.onFinish then CurrentProgress.onFinish() end
            CurrentProgress = nil
        end
        Wait(1000)
    end
end

exports('Progressbar', Progressbar)