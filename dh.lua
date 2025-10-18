local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local isRunning = true
local joinedServers = {}
local failedGames = {}
local messagesPerUser = 2
local targetGameId = "9825515356"
local messageVariations = {}

local function generateMessageVariations(baseMessage)
    local variations = {}
    local unicodeSubstitutions = {
        ["a"] = {"а", "α", "ᴀ"},
        ["e"] = {"е", "ε"},
        ["o"] = {"о", "ο"},
        ["i"] = {"і", "ι"},
        ["u"] = {"υ"},
        ["c"] = {"с"},
        ["p"] = {"р"},
        ["x"] = {"х"},
        ["y"] = {"у"}
    }
    
    local prefixes = {"hh ", "aa ", "ss ", "bb ", ""}
    local suffixes = {" gg", " ee", " hh", " xx", ""}
    
    for i = 1, 8 do
        local variation = baseMessage:lower()
        
        if math.random() > 0.6 then
            for char, subs in pairs(unicodeSubstitutions) do
                if math.random() > 0.8 then
                    variation = variation:gsub(char, subs[1], 1)
                end
            end
        end
        
        if math.random() > 0.6 then
            local prefix = prefixes[math.random(#prefixes)]
            variation = prefix .. variation
        end
        
        if math.random() > 0.6 then
            local suffix = suffixes[math.random(#suffixes)]
            variation = variation .. suffix
        end
        
        if math.random() > 0.4 then
            variation = variation .. string.rep(".", math.random(1, 2))
        end
        
        table.insert(variations, variation)
    end
    
    return variations
end

local function initializeMessageVariations()
    local baseMessages = {
        "BRO THEY ARE ON CAM LOOOLO /relief",
        "bro what are they doing on vc?☠️ /relief",
        "SHES TUUCHING HE RSELF /relief",
        "ageplayer heaven in /relief",
        "ageplay and cnc in chat/call ;3 /relief",
        "get active /relief",
        "addddd shame18 if you want $$",
        "hiuii shame18 for promo like this"
    }
    
    messageVariations = {}
    
    for _, msg in ipairs(baseMessages) do
        local variations = generateMessageVariations(msg)
        for _, variation in ipairs(variations) do
            table.insert(messageVariations, variation)
        end
    end
end

local function applyNetworkOptimizations()
    local flags = {
        DFIntTaskSchedulerTargetFps = 15,
        FFlagDebugDisableInGameMenuV2 = true,
        DFIntTextureQualityOverride = 1,
        FFlagRenderNoLights = true,
        FFlagRenderNoShadows = true
    }
    
    for flag, value in pairs(flags) do
        pcall(function()
            game:SetFastFlag(flag, value)
        end)
    end
end

local function optimizeClientPerformance()
    pcall(function()
        settings().Network.IncomingReplicationLag = 0
        settings().Rendering.QualityLevel = 1
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
        settings().Rendering.MaterialQualityLevel = Enum.MaterialQualityLevel.Level01
    end)
end

local function forceChatFeatures()
    spawn(function()
        while wait(0.2) do
            pcall(function()
                StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
            end)
            
            pcall(function()
                local playerGui = player:FindFirstChild("PlayerGui")
                if playerGui then
                    local chatGui = playerGui:FindFirstChild("Chat")
                    if chatGui then
                        chatGui.Enabled = true
                    end
                end
            end)
            
            if TextChatService.ChatInputBarConfiguration and TextChatService.ChatInputBarConfiguration.TargetTextChannel then
                break
            end
        end
    end)
end

local queueteleport = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)

local function queueScript()
    pcall(function()
        if queueteleport and type(queueteleport) == "function" then
            queueteleport([[
wait(2)
local success = pcall(function()
    loadstring(readfile("dh.lua"))()
end)
]])
        end
    end)
end

local function saveScriptData()
    local data = {
        joinedServers = joinedServers,
        timestamp = tick()
    }
    pcall(function()
        if writefile then
            writefile("dh_spammer_data.json", HttpService:JSONEncode(data))
        end
    end)
end

local function loadScriptData()
    local success, content = pcall(function()
        if isfile and readfile and isfile("dh_spammer_data.json") then
            return readfile("dh_spammer_data.json")
        end
        return nil
    end)
    
    if success and content then
        local success2, data = pcall(function()
            return HttpService:JSONDecode(content)
        end)
        
        if success2 and data then
            joinedServers = data.joinedServers or {}
        end
    end
end

local function waitForCharacter()
    local attempts = 0
    while (not player.Character or not player.Character:FindFirstChild("Humanoid")) and attempts < 40 do
        wait(0.2)
        attempts = attempts + 1
    end
    
    if not player.Character then
        return false
    end
    
    return true
end

local function waitForChatReady()
    local chatAttempts = 0
    while chatAttempts < 25 do
        local chatReady = false
        pcall(function()
            if TextChatService.ChatInputBarConfiguration and TextChatService.ChatInputBarConfiguration.TargetTextChannel then
                chatReady = true
            end
        end)
        
        if chatReady then
            print("Chat system ready!")
            return true
        end
        
        wait(0.4)
        chatAttempts = chatAttempts + 1
    end
    
    return false
end

local function findAndClickButton()
    print("Looking for Casual frame and Button...")
    local attempts = 0
    
    while attempts < 30 and isRunning do
        local success = pcall(function()
            local playerGui = player:FindFirstChild("PlayerGui")
            if playerGui then
                for _, gui in pairs(playerGui:GetDescendants()) do
                    if gui.Name == "Casual" and gui:IsA("Frame") then
                        local button = gui:FindFirstChild("Button")
                        if button and button:IsA("GuiButton") then
                            print("Found Button in Casual frame, clicking...")
                            
                            for i = 1, 3 do
                                pcall(function()
                                    firesignal(button.MouseButton1Click)
                                end)
                                pcall(function()
                                    button.Activated:Fire()
                                end)
                                wait(0.1)
                            end
                            
                            print("Button clicked successfully!")
                            return true
                        end
                    end
                end
            end
        end)
        
        if success then
            return true
        end
        
        wait(0.5)
        attempts = attempts + 1
    end
    
    print("Could not find or click button")
    return false
end

local function sendMessage(message)
    local success = false
    local attempts = 0
    
    while not success and attempts < 5 do
        success = pcall(function()
            if TextChatService.ChatInputBarConfiguration and TextChatService.ChatInputBarConfiguration.TargetTextChannel then
                local stealthMessage = message
                
                if math.random() > 0.5 then
                    stealthMessage = stealthMessage .. string.char(math.random(8203, 8205))
                end
                
                TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(stealthMessage)
                return true
            end
        end)
        
        if not success then
            attempts = attempts + 1
            wait(0.2)
        end
    end
    
    return success
end

local function getRandomMessage()
    if #messageVariations > 0 then
        local randomIndex = math.random(1, #messageVariations)
        return messageVariations[randomIndex]
    end
    return nil
end

local function teleportToPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    local success = pcall(function()
        local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
        local newPosition = targetPosition + Vector3.new(math.random(-3, 3), 5, math.random(-3, 3))
        character.HumanoidRootPart.CFrame = CFrame.new(newPosition)
    end)
    
    return success
end

local function processAllPlayers()
    local allPlayers = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(allPlayers, p)
        end
    end
    
    if #allPlayers == 0 then
        print("No players to process")
        return false
    end
    
    print("Processing " .. #allPlayers .. " players...")
    
    for _, targetPlayer in ipairs(allPlayers) do
        if not isRunning then break end
        
        if teleportToPlayer(targetPlayer) then
            print("Teleported to " .. targetPlayer.Name)
            wait(0.3)
            
            for i = 1, messagesPerUser do
                if not isRunning then break end
                
                local message = getRandomMessage()
                if message then
                    local sent = sendMessage(message)
                    if sent then
                        print("Sent message " .. i .. "/" .. messagesPerUser .. " to " .. targetPlayer.Name)
                    end
                end
                
                wait(0.4)
            end
            
            wait(0.2)
        else
            print("Failed to teleport to " .. targetPlayer.Name)
        end
    end
    
    return true
end

local function cleanupOldServers()
    local currentTime = tick()
    for serverId, joinTime in pairs(joinedServers) do
        if currentTime - joinTime >= 300 then
            joinedServers[serverId] = nil
        end
    end
end

local function getAvailableServers()
    local availableServers = {}
    local httpAttempts = 0
    
    while httpAttempts < 3 do
        local success, result = pcall(function()
            return game:HttpGet("https://games.roblox.com/v1/games/" .. targetGameId .. "/servers/Public?sortOrder=Asc&limit=100", true)
        end)
        
        if success then
            local parseSuccess, data = pcall(function()
                return HttpService:JSONDecode(result)
            end)
            
            if parseSuccess and data and data.data then
                for _, server in ipairs(data.data) do
                    if server and server.id and server.playing and server.maxPlayers and
                       server.playing >= 3 and server.playing < server.maxPlayers * 0.9 and
                       server.id ~= game.JobId and not joinedServers[server.id] then
                        table.insert(availableServers, {
                            id = server.id,
                            playing = server.playing,
                            maxPlayers = server.maxPlayers,
                            priority = server.playing
                        })
                    end
                end
                
                table.sort(availableServers, function(a, b)
                    return a.priority > b.priority
                end)
                break
            end
        end
        
        httpAttempts = httpAttempts + 1
        if httpAttempts < 3 then
            wait(2)
        end
    end
    
    return availableServers
end

local function teleportToNewServer()
    cleanupOldServers()
    saveScriptData()
    queueScript()
    
    wait(1)
    
    local attempts = 0
    local maxAttempts = 5
    
    while attempts < maxAttempts and isRunning do
        print("Searching for new server (attempt " .. (attempts + 1) .. ")...")
        
        local availableServers = getAvailableServers()
        
        if #availableServers > 0 then
            local selectedServer = availableServers[math.random(1, math.min(3, #availableServers))]
            
            if selectedServer then
                joinedServers[selectedServer.id] = tick()
                saveScriptData()
                
                print("Joining new server with " .. selectedServer.playing .. " players...")
                local success = pcall(function()
                    TeleportService:TeleportToPlaceInstance(tonumber(targetGameId), selectedServer.id, player)
                end)
                
                if success then
                    return
                end
            end
        end
        
        attempts = attempts + 1
        wait(3)
    end
    
    print("Trying random rejoin...")
    pcall(function()
        TeleportService:Teleport(tonumber(targetGameId), player)
    end)
end

local function startSpamming()
    spawn(function()
        pcall(function()
            print("Starting spam process for game " .. targetGameId)
            
            applyNetworkOptimizations()
            optimizeClientPerformance()
            forceChatFeatures()
            
            if not waitForCharacter() then
                print("Character load failed")
                wait(2)
                teleportToNewServer()
                return
            end
            
            print("Character loaded")
            wait(3)
            
            if not waitForChatReady() then
                print("Chat failed to load")
                wait(2)
                teleportToNewServer()
                return
            end
            
            wait(2)
            
            if findAndClickButton() then
                print("Button clicked, waiting for game start...")
                wait(5)
            else
                print("Button not found, continuing anyway...")
                wait(2)
            end
            
            if not isRunning then return end
            
            processAllPlayers()
            
            if isRunning then
                print("Finished processing all players, server hopping...")
                wait(1)
                teleportToNewServer()
            end
        end)
    end)
end

local function stopSpamming()
    isRunning = false
    saveScriptData()
    print("Script stopped")
end

local function onKeyPress(key)
    if key.KeyCode == Enum.KeyCode.Q then
        stopSpamming()
    elseif key.KeyCode == Enum.KeyCode.R then
        if not isRunning then
            isRunning = true
            startSpamming()
        else
            teleportToNewServer()
        end
    end
end

local function initialize()
    print("Initializing spam bot for game " .. targetGameId)
    
    pcall(function()
        initializeMessageVariations()
        loadScriptData()
        
        UserInputService.InputBegan:Connect(onKeyPress)
        
        if game.JobId and game.JobId ~= "" then
            joinedServers[game.JobId] = tick()
        end
        
        print("Starting in 2 seconds...")
        print("Press Q to stop, R to restart/server hop")
        
        wait(2)
        startSpamming()
    end)
end

initialize()

