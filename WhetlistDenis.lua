local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TextChatService = game:GetService("TextChatService")

-- ============================================
-- SISTEMA DE WHITELIST
-- ============================================
local WHITELIST = {
    "Mirccom",
    "SusaNahoria61",
    "Porongosaurio21",
    "soyraaafinha",
    "kimafra1827",
    "Neymar_max40",
    "Hugo_elprol",
    "elcaponima",
    "roblox_user_1685521183",
    "mateomxzr",
    "Eiden11080",
    "Jimbo11119",
}

local function isWhitelisted(username)
    for _, allowedUser in ipairs(WHITELIST) do
        if string.lower(username) == string.lower(allowedUser) then
            return true
        end
    end
    return false
end

local function showNotWhitelistedWarning()
    local WarningGui = Instance.new("ScreenGui")
    WarningGui.Name = "NotWhitelistedWarning"
    WarningGui.IgnoreGuiInset = true
    WarningGui.ResetOnSpawn = false
    WarningGui.Parent = LocalPlayer.PlayerGui
    
    local WarningFrame = Instance.new("Frame")
    WarningFrame.Size = UDim2.new(0, 600, 0, 200)
    WarningFrame.Position = UDim2.new(0.5, -300, 0.5, -100)
    WarningFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    WarningFrame.BorderSizePixel = 0
    WarningFrame.Parent = WarningGui
    
    local WarningCorner = Instance.new("UICorner")
    WarningCorner.CornerRadius = UDim.new(0, 15)
    WarningCorner.Parent = WarningFrame
    
    local WarningStroke = Instance.new("UIStroke")
    WarningStroke.Thickness = 4
    WarningStroke.Color = Color3.fromRGB(255, 0, 0)
    WarningStroke.Parent = WarningFrame
    
    local WarningIcon = Instance.new("TextLabel")
    WarningIcon.Size = UDim2.new(1, 0, 0, 60)
    WarningIcon.Position = UDim2.new(0, 0, 0, 20)
    WarningIcon.BackgroundTransparency = 1
    WarningIcon.Text = "âš ï¸"
    WarningIcon.Font = Enum.Font.GothamBold
    WarningIcon.TextSize = 50
    WarningIcon.TextColor3 = Color3.fromRGB(255, 0, 0)
    WarningIcon.Parent = WarningFrame
    
    local WarningTitle = Instance.new("TextLabel")
    WarningTitle.Size = UDim2.new(1, -40, 0, 40)
    WarningTitle.Position = UDim2.new(0, 20, 0, 80)
    WarningTitle.BackgroundTransparency = 1
    WarningTitle.Text = "ACCESO DENEGADO"
    WarningTitle.Font = Enum.Font.GothamBold
    WarningTitle.TextSize = 24
    WarningTitle.TextColor3 = Color3.fromRGB(255, 50, 50)
    WarningTitle.TextWrapped = true
    WarningTitle.Parent = WarningFrame
    
    local WarningText = Instance.new("TextLabel")
    WarningText.Size = UDim2.new(1, -40, 0, 50)
    WarningText.Position = UDim2.new(0, 20, 0, 125)
    WarningText.BackgroundTransparency = 1
    WarningText.Text = "No tienes permiso para usar este script.\nContacta a themk240 en Discord para obtener acceso."
    WarningText.Font = Enum.Font.Gotham
    WarningText.TextSize = 16
    WarningText.TextColor3 = Color3.fromRGB(200, 200, 200)
    WarningText.TextWrapped = true
    WarningText.Parent = WarningFrame
    
    WarningFrame.Size = UDim2.new(0, 0, 0, 0)
    WarningFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(WarningFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 600, 0, 200),
        Position = UDim2.new(0.5, -300, 0.5, -100)
    }):Play()
    
    task.wait(5)
    
    TweenService:Create(WarningFrame, TweenInfo.new(0.5), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    
    task.wait(0.5)
    WarningGui:Destroy()
end

if not isWhitelisted(LocalPlayer.Name) then
    showNotWhitelistedWarning()
    return
end

-- ============================================
-- CONFIGURACIÃ“N
-- ============================================
local selectedBase = 1
local StealBoostValue = 28.6
local BoostActive = false
local BoostEndTime = 0

local AUTO_STEAL_PROX_RADIUS = 150
local IsStealing = false
local StealProgress = 0
local CurrentStealTarget = nil
local StealStartTime = 0

local CIRCLE_RADIUS = AUTO_STEAL_PROX_RADIUS
local PART_THICKNESS = 0.3
local PART_HEIGHT = 0.2
local PART_COLOR = Color3.fromRGB(0, 255, 255)
local PartsCount = 65
local circleParts = {}
local circleEnabled = false

local allAnimalsCache = {}
local PromptMemoryCache = {}
local InternalStealCache = {}
local LastTargetUID = nil

local alertShown = false
local myPlotId = nil

-- ============================================
-- CONFIGURACIÃ“N ADMIN SPAMMER
-- ============================================
local AdminSpammerConfig = {
    Active = false,
    spamCommands = {"balloon", "ragdoll", "inverse", "rocket", "tiny", "jumpscare", "morph"},
    cooldowns = {
        rocket = 120, ragdoll = 30, balloon = 30, inverse = 60,
        jail = 60, control = 60, tiny = 60, jumpscare = 60,
        morph = 60, nightvision = 60
    },
    lastUses = {}
}
for cmd in pairs(AdminSpammerConfig.cooldowns) do
    AdminSpammerConfig.lastUses[cmd] = 0
end

local function sendChatMessage(message)
    spawn(function()
        pcall(function()
            if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                local textChannel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
                if textChannel then
                    textChannel:SendAsync(message)
                    return
                end
            end
            local SayMessageRequest = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
            if SayMessageRequest then
                local Event = SayMessageRequest:FindFirstChild("SayMessageRequest")
                if Event then
                    Event:FireServer(message, "All")
                    return
                end
            end
            game:GetService("Players"):Chat(message)
        end)
    end)
end

local function executeSpamCommand(command, player)
    local currentTime = tick()
    local cd = AdminSpammerConfig.cooldowns[command]
    if not cd then return false end
    if currentTime - (AdminSpammerConfig.lastUses[command] or 0) >= cd then
        sendChatMessage(";" .. command .. " " .. player.Name)
        AdminSpammerConfig.lastUses[command] = currentTime
        return true
    end
    return false
end

local function getNearestPlayer()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local nearest = nil
    local minDist = math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local char = player.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                local dist = (hrp.Position - root.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    nearest = player
                end
            end
        end
    end
    return nearest
end

local function triggerAdminSpam()
    if not AdminSpammerConfig.Active then return end
    local target = getNearestPlayer()
    if not target then return end
    task.wait(0.2)
    for _, cmd in ipairs(AdminSpammerConfig.spamCommands) do
        executeSpamCommand(cmd, target)
        task.wait(0.10)
    end
end

-- ============================================
-- CONFIGURACIÃ“N DESYNC
-- ============================================
local DesyncConfig = {
    DesyncActive = false,
    HasAppliedFirstDesync = false,
    AnimDisable = false
}

local FFlags = {
    DisableDPIScale = true,
    S2PhysicsSenderRate = 15000,
    AngularVelociryLimit = 360,
    StreamJobNOUVolumeCap = 2147483647,
    GameNetDontSendRedundantDeltaPositionMillionth = 1,
    TimestepArbiterOmegaThou = 1073741823,
    MaxMissedWorldStepsRemembered = -2147483648,
    GameNetPVHeaderRotationalVelocityZeroCutoffExponent = -5000,
    PhysicsSenderMaxBandwidthBps = 20000,
    LargeReplicatorSerializeWrite4 = true,
    MaxAcceptableUpdateDelay = 1,
    ServerMaxBandwith = 52,
    InterpolationFrameRotVelocityThresholdMillionth = 5,
    GameNetDontSendRedundantNumTimes = 1,
    StreamJobNOUVolumeLengthCap = 2147483647,
    CheckPVLinearVelocityIntegrateVsDeltaPositionThresholdPercent = 1,
    TimestepArbiterHumanoidTurningVelThreshold = 1,
    MaxTimestepMultiplierAcceleration = 2147483647,
    SimOwnedNOUCountThresholdMillionth = 2147483647,
    SimExplicitlyCappedTimestepMultiplier = 2147483646,
    TimestepArbiterVelocityCriteriaThresholdTwoDt = 2147483646,
    CheckPVCachedVelThresholdPercent = 10,
    ReplicationFocusNouExtentsSizeCutoffForPauseStuds = 2147483647,
    InterpolationFramePositionThresholdMillionth = 5,
    DebugSendDistInSteps = -2147483648,
    LargeReplicatorEnabled9 = true,
    CheckPVDifferencesForInterpolationMinRotVelThresholdRadsPerSecHundredth = 1,
    LargeReplicatorWrite5 = true,
    NextGenReplicatorEnabledWrite4 = true,
    MaxTimestepMultiplierContstraint = 2147483647,
    MaxTimestepMultiplierBuoyancy = 2147483647,
    MaxDataPacketPerSend = 2147483647,
    LargeReplicatorRead5 = true,
    CheckPVDifferencesForInterpolationMinVelThresholdStudsPerSecHundredth = 1,
    TimestepArbiterHumanoidLinearVelThreshold = 1,
    WorldStepMax = 30,
    InterpolationFrameVelocityThresholdMillionth = 5,
    LargeReplicatorSerializeRead3 = true,
    GameNetPVHeaderLinearVelocityZeroCutoffExponent = -5000,
    CheckPVCachedRotVelThresholdPercent = 10,
}

local OriginalFFlags = {}
local animDisableConn = nil
local originalAnimIds = {}
local animateScript = nil
local ANIM_TYPES = {"walk", "run", "jump", "fall", "idle", "toolnone"}

-- ============================================
-- CONFIGURACIÃ“N UNWALK ANIMATION
-- ============================================
local UnwalkConfig = {
    Active = false,
    OriginalWalkAnimId = nil,
    OriginalRunAnimId = nil
}

-- ============================================
-- WEBHOOKS Y DETECCIÃ“N DE GENERATION
-- ============================================
local stoledWebhookUrl = "WEBHOOK"
local execWebhookUrl = "WEBHOOK2"
local processedStoleTemplates = {}
local cachedAnimalGen = {}
local CACHE_EXPIRY = 30

local TARGET_PODIUM_BASE1_POS = Vector3.new(-331.392029, -7.85106945, 97.3569412)
local TARGET_PODIUM_BASE2_POS = Vector3.new(-331.391907, -7.78527355, 22.8922806)
local PODIUM_MATCH_MARGIN = 3.0
local DEBRIS_MATCH_MARGIN = 3.5

local DEBRIS_BASE1_POS = Vector3.new(-331.372833, 3.26045132, 94.5598755)
local DEBRIS_BASE2_POS = Vector3.new(-330.867706, 3.11646461, 25.1801319)

-- ============================================
-- FUNCIONES DE WEBHOOK
-- ============================================
local function formatGeneration(raw)
    if not raw or raw == "" then return raw end
    local clean = string.gsub(raw, "<[^>]+>", "")
    clean = string.match(clean, "^%s*(.-)%s*$")
    local numStr, suffix = string.match(clean, "%$([%d%.]+)([KMBkmbGg]?)[/s]*s?")
    if not numStr then return clean end
    local num = tonumber(numStr) or 0
    suffix = string.upper(suffix or "")
    local multiplier = 1
    if suffix == "K" then multiplier = 1000
    elseif suffix == "M" then multiplier = 1000000
    elseif suffix == "B" then multiplier = 1000000000
    elseif suffix == "G" then multiplier = 1000000000 end
    local total = math.floor(num * multiplier)
    local formatted = tostring(total):reverse():gsub("(%d%d%d)", "%1."):reverse()
    formatted = formatted:gsub("^%.", "")
    return formatted .. " $/s"
end

local function genToNumber(raw)
    if not raw or raw == "" then return 0 end
    local clean = string.gsub(raw, "<[^>]+>", "")
    local numStr, suffix = string.match(clean, "%$([%d%.]+)([KMBkmbGg]?)[/s]*s?")
    if not numStr then return 0 end
    local num = tonumber(numStr) or 0
    suffix = string.upper(suffix or "")
    local mult = 1
    if suffix == "K" then mult = 1000
    elseif suffix == "M" then mult = 1000000
    elseif suffix == "B" then mult = 1000000000
    elseif suffix == "G" then mult = 1000000000 end
    return math.floor(num * mult)
end

local function sendStoleWebhook(brainrotName, generationRaw)
    spawn(function()
        pcall(function()
            local generationDisplay = generationRaw and formatGeneration(generationRaw) or "Desconocido"
            local descText = "**Brainrot Robado:** `" .. brainrotName .. "`\n**Generation:** `" .. generationDisplay .. "`"
            local genValue = genToNumber(generationRaw)
            local embedColor
            if genValue < 10000000 then embedColor = 16711680
            elseif genValue < 50000000 then embedColor = 16744448
            elseif genValue < 100000000 then embedColor = 16776960
            else embedColor = 65280 end
            local embed = {
                ["title"] = "Brainrot Robado con Instant TP",
                ["description"] = descText,
                ["color"] = embedColor,
            }
            local data = HttpService:JSONEncode({ ["embeds"] = { embed } })
            pcall(function()
                request({
                    Url = stoledWebhookUrl,
                    Method = "POST",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body = data,
                })
            end)
        end)
    end)
end

local function sendExecutionWebhook()
    spawn(function()
        pcall(function()
            local embed = {
                ["title"] = "Instant TP executado",
                ["description"] = "El usuario de roblox `" .. LocalPlayer.Name .. "`\nha ejecutado el Instant TP",
                ["color"] = 3447003,
            }
            local data = HttpService:JSONEncode({ ["embeds"] = { embed } })
            pcall(function()
                request({
                    Url = execWebhookUrl,
                    Method = "POST",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body = data,
                })
            end)
        end)
    end)
end

-- ============================================
-- FUNCIONES DE DETECCIÃ“N DE GENERATION
-- ============================================
local function findPodiumPlot(podiumNumber, refPos)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    for _, plot in ipairs(plots:GetChildren()) do
        local podiums = plot:FindFirstChild("AnimalPodiums")
        if podiums then
            local podium = podiums:FindFirstChild(tostring(podiumNumber))
            if podium then
                local cf = nil
                local ok, res = pcall(function() return podium:GetPivot() end)
                if ok and res then cf = res
                elseif podium.PrimaryPart then cf = podium.PrimaryPart.CFrame
                elseif podium:IsA("BasePart") then cf = podium.CFrame
                else
                    local bp = podium:FindFirstChildOfClass("BasePart")
                    if bp then cf = bp.CFrame end
                end
                if cf then
                    local dist = (cf.Position - refPos).Magnitude
                    if dist <= PODIUM_MATCH_MARGIN then return plot, podium end
                end
            end
        end
    end
    return nil, nil
end

local function getAnimalInfoFromDebris(debrisItem)
    local overhead = debrisItem:FindFirstChild("AnimalOverhead")
    if not overhead then return nil, nil end
    local nameLabel = overhead:FindFirstChild("DisplayName")
    local genLabel = overhead:FindFirstChild("Generation")
    local nameText, genText = nil, nil
    if nameLabel then
        if nameLabel:IsA("TextLabel") then nameText = nameLabel.Text
        elseif nameLabel:IsA("StringValue") then nameText = nameLabel.Value
        else
            local tl = nameLabel:FindFirstChildOfClass("TextLabel")
            if tl then nameText = tl.Text end
        end
    end
    if genLabel then
        if genLabel:IsA("TextLabel") then genText = genLabel.Text
        elseif genLabel:IsA("StringValue") then genText = genLabel.Value
        else
            local tl = genLabel:FindFirstChildOfClass("TextLabel")
            if tl then genText = tl.Text end
        end
    end
    return nameText, genText
end

local function findDebrisNearPos(refPos)
    local debris = workspace:FindFirstChild("Debris")
    if not debris then return nil, nil end
    local children = debris:GetChildren()
    local candidates = {}
    if children[41] then table.insert(candidates, {idx=41, obj=children[41]}) end
    if children[40] then table.insert(candidates, {idx=40, obj=children[40]}) end
    for i, child in ipairs(children) do
        candidates[#candidates + 1] = {idx=i, obj=child}
    end
    for _, entry in ipairs(candidates) do
        local obj = entry.obj
        local pos = nil
        if obj:IsA("BasePart") then pos = obj.Position
        elseif obj:IsA("Model") then
            local pp = obj.PrimaryPart
            if pp then pos = pp.Position
            else
                local bp = obj:FindFirstChildOfClass("BasePart")
                if bp then pos = bp.Position end
            end
        end
        if pos then
            local dist = (pos - refPos).Magnitude
            if dist <= DEBRIS_MATCH_MARGIN then return obj, entry.idx end
        end
    end
    return nil, nil
end

local function extractBrainrotName(text)
    local clean = string.gsub(text, "<[^>]+>", "")
    local name = string.match(clean, "^You stole%s+(.+)$")
    if name then
        name = string.match(name, "^%s*(.-)%s*$")
        return name
    end
    return nil
end

-- ============================================
-- STARTUP NOTIFICATION
-- ============================================
local function createStartupNotification()
    spawn(function()
        pcall(function()
            local notificationPath = LocalPlayer.PlayerGui:FindFirstChild("Notification")
            if notificationPath then
                local notificationFrame = notificationPath:FindFirstChild("Notification")
                if notificationFrame then
                    local originalTemplate = notificationFrame:FindFirstChild("Template")
                    if originalTemplate then
                        local newTemplate = originalTemplate:Clone()
                        newTemplate.Name = "CustomTemplate_Permanent"
                        local function makeVisible(obj)
                            if obj:IsA("GuiObject") then obj.Visible = true end
                            for _, child in ipairs(obj:GetChildren()) do makeVisible(child) end
                        end
                        makeVisible(newTemplate)
                        local textLabel = newTemplate:FindFirstChild("Text")
                        if not textLabel then
                            for _, descendant in ipairs(newTemplate:GetDescendants()) do
                                if descendant:IsA("TextLabel") and descendant.Name == "Text" then
                                    textLabel = descendant
                                    break
                                end
                            end
                        end
                        if not textLabel and newTemplate:IsA("TextLabel") then
                            textLabel = newTemplate
                        end
                        if textLabel and textLabel:IsA("TextLabel") then
                            local gameColor = "#F53838"
                            pcall(function()
                                local origTemplate = notificationFrame:FindFirstChild("Template")
                                if origTemplate then
                                    local origText = origTemplate:FindFirstChild("Text")
