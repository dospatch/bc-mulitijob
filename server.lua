-- ==========================================
-- 1. INITIALIZATION & VARIABLES
-- ==========================================
local QBCore = exports['qb-core']:GetCoreObject()

-- ==========================================
-- 2. HELPER FUNCTIONS (Internal Logic)
-- ==========================================
local function getPlayerJobs(Player)
    local jobs = Player.PlayerData.metadata["multijobs"] or {}
    local currentJob = Player.PlayerData.job
    local hasCurrent = false
    
    for _, j in ipairs(jobs) do
        if j.name == currentJob.name then
            hasCurrent = true
            break
        end
    end
    
    -- Sync current active job to metadata profile seamlessly if missing
    if not hasCurrent and currentJob.name ~= "unemployed" then
        table.insert(jobs, {
            name = currentJob.name,
            label = currentJob.label,
            grade = currentJob.grade.level,
            gradeLabel = currentJob.grade.name
        })
        Player.Functions.SetMetaData("multijobs", jobs)
    end
    
    return jobs
end

-- ==========================================
-- 3. NET EVENTS (Client -> Server)
-- ==========================================
RegisterNetEvent('qb-multijob:server:openMenu', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local myJobs = getPlayerJobs(Player)
    local currentJob = Player.PlayerData.job

    TriggerClientEvent('qb-multijob:client:openMenu', src, myJobs, currentJob)
end)

RegisterNetEvent('qb-multijob:server:switchJob', function(jobName, jobGrade)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local myJobs = getPlayerJobs(Player)
    local canSwitch = false

    for _, j in ipairs(myJobs) do
        if j.name == jobName and j.grade == jobGrade then
            canSwitch = true
            break
        end
    end

    if canSwitch then
        Player.Functions.SetJob(jobName, jobGrade)
        TriggerClientEvent('QBCore:Notify', src, "Switched role to " .. jobName, "success")
    else
        TriggerClientEvent('QBCore:Notify', src, "Action rejected: Invalid job authentication.", "error")
    end
end)

RegisterNetEvent('qb-multijob:server:quitJob', function(jobName)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local jobs = getPlayerJobs(Player)
    local currentJob = Player.PlayerData.job

    if currentJob.name == jobName then
        TriggerClientEvent('QBCore:Notify', src, "You cannot quit an active job slot!", "error")
        return
    end

    for i, j in ipairs(jobs) do
        if j.name == jobName then
            table.remove(jobs, i)
            Player.Functions.SetMetaData("multijobs", jobs)
            TriggerClientEvent('QBCore:Notify', src, "You have permanently resigned from your position.", "success")
            return
        end
    end
end)

-- ==========================================
-- 4. EXPORTS (External Integration)
-- ==========================================
exports('AddJobToPlayer', function(source, jobName, jobGrade)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return false end

    local jobs = getPlayerJobs(Player)
    
    for _, j in ipairs(jobs) do
        if j.name == jobName then
            j.grade = jobGrade
            Player.Functions.SetMetaData("multijobs", jobs)
            return true
        end
    end

    if #jobs >= Config.MaxJobs then
        TriggerClientEvent('QBCore:Notify', source, "Maximum job tracking profile space reached.", "error")
        return false
    end

    local jobInfo = QBCore.Shared.Jobs[jobName]
    if not jobInfo then return false end

    table.insert(jobs, {
        name = jobName,
        label = jobInfo.label,
        grade = jobGrade,
        gradeLabel = jobInfo.grades[tostring(jobGrade)] and jobInfo.grades[tostring(jobGrade)].name or "Employee"
    })

    Player.Functions.SetMetaData("multijobs", jobs)
    return true
end)

-- Admin Command: Give a job to a slot manually
QBCore.Commands.Add('addjob', 'Give a job to a player slot (Admin Only)', {
    {name = 'id', help = 'Player Server ID'}, 
    {name = 'job', help = 'Job Name'}, 
    {name = 'grade', help = 'Job Grade Level'}
}, true, function(source, args)
    local targetId = tonumber(args[1])
    local jobName = tostring(args[2])
    local jobGrade = tonumber(args[3]) or 0

    local success = exports['bc-multijob']:AddJobToPlayer(targetId, jobName, jobGrade)
    if success then
        TriggerClientEvent('QBCore:Notify', source, "Successfully added job to target.", "success")
    else
        TriggerClientEvent('QBCore:Notify', source, "Failed to add job. Check slots or job name.", "error")
    end
end, 'admin')

-- Admin Command: Reset player multi-jobs entirely
QBCore.Commands.Add('clearjobs', 'Clear all saved multi-jobs for a player (Admin Only)', {
    {name = 'id', help = 'Player Server ID'}
}, true, function(source, args)
    local targetId = tonumber(args[1])
    local Player = QBCore.Functions.GetPlayer(targetId)
    
    if Player then
        Player.Functions.SetMetaData("multijobs", {})
        TriggerClientEvent('QBCore:Notify', targetId, "Your multi-job slots have been cleared by an admin.", "error")
        TriggerClientEvent('QBCore:Notify', source, "Cleared jobs for ID " .. targetId, "success")
    end
end, 'admin')