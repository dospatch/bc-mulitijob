local QBCore = exports['qb-core']:GetCoreObject()

local function notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

RegisterNetEvent('bc-multijob:client:Notify', function(text)
    notify(text)
end)

-- Visual Context Menu via ox_lib synced to your server metadata events
RegisterNetEvent('qb-multijob:client:openMenu', function(savedJobs, currentJob)
    local options = {}

    for _, jobData in ipairs(savedJobs) do
        local isCurrent = (jobData.name == currentJob.name)
        
        table.insert(options, {
            title = jobData.label or jobData.name,
            description = isCurrent and "⚠️ Currently Active" or "Click to switch to this job role",
            disabled = isCurrent,
            icon = Config.JobIcons[jobData.name] or 'briefcase',
            onSelect = function()
                TriggerServerEvent('qb-multijob:server:switchJob', jobData.name, jobData.grade)
            end
        })
    end

    lib.registerContext({
        id = 'bc_multijob_menu',
        title = 'Job Management Profile',
        options = options
    })

    lib.showContext('bc_mult_job_menu')
    lib.showContext('bc_multijob_menu')
end)

-- Command to open the menu
RegisterCommand(Config.Command, function()
    if lib.contextMenuActive() then return end
    TriggerServerEvent('qb-multijob:server:openMenu')
end, false)

-- Keybind hook matching your config file setting (F5)
if Config.Keybind then
    RegisterKeyMapping(Config.Command, 'Open MultiJob Menu', 'keyboard', Config.Keybind)
end