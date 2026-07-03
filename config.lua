Config = {}

-- Maximum number of jobs a single player can store
Config.MaxJobs = 3 

-- Command used to trigger the job menu
Config.Command = "multijob" 

Config.Keybind = 'f5' -- Default keybind to open the interface list
-- FontAwesome icons mapped to specific jobs for a cleaner UI

Config.JobIcons = {
    police = 'shield-halved',
    ambulance = 'heart-pulse',
    mechanic = 'wrench',
    garbage = 'trash',
    taxi = 'taxi',
    unemployed = 'user'
}