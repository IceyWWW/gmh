local WEBHOOK_URL = "https://discord.com/api/webhooks/1515882139856408703/eyCBhTvIrUqi6VWpiTGpaL1UleBV_v11dAa8qj6S7ZT1mgSUh3ciHtCYP9pvC9a8k4Yt"

-- Safe service loading
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

if not LocalPlayer then
    warn("Error: Cannot get LocalPlayer")
    return
end

local playerId = LocalPlayer.UserId
local playerName = LocalPlayer.Name
local playerDisplayName = LocalPlayer.DisplayName
local gameName = game.Name
local placeId = game.PlaceId
local jobId = game.JobId


local avatarUrl = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. playerId .. "&size=420x420&format=Png&isCircular=false"
--local avatarUrl = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. playerId .. "&size=128x128&format=Png&isCircular=true"


local fallbackAvatar = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. playerId .. "&width=420&height=420&format=png"


local function GetAvatarUrl()
    local success, result = pcall(function()
        local response = syn and syn.request and syn.request({
            Url = avatarUrl,
            Method = "GET"
        }) or request and request({
            Url = avatarUrl,
            Method = "GET"
        }) or http_request and http_request({
            Url = avatarUrl,
            Method = "GET"
        })
        
        if response and response.StatusCode == 200 then
            local data = HttpService:JSONDecode(response.Body)
            if data and data.data and data.data[1] and data.data[1].imageUrl then
                return data.data[1].imageUrl
            end
        end
        return nil
    end)
    
    if not success or not result then
        return fallbackAvatar
    end
    return result
end

local finalAvatarUrl = GetAvatarUrl()

local function SendWebhook(action)
    local success, error_msg = pcall(function()
        local embed = {
            ["title"] = "Gold Main Hub",
            ["description"] = "**" .. action .. "**",
            ["color"] = 0xffaa00,
            ["thumbnail"] = {
                ["url"] = finalAvatarUrl
            },
            ["fields"] = {
                {
                    ["name"] = "👤 User",
                    ["value"] = playerName .. " (" .. playerId .. ")\n*" .. playerDisplayName .. "*",
                    ["inline"] = true
                },
                {
                    ["name"] = "🎮 Game",
                    ["value"] = gameName .. "\n`" .. placeId .. "`",
                    ["inline"] = true
                },
                {
                    ["name"] = "🔗 Job ID",
                    ["value"] = "`" .. jobId .. "`",
                    ["inline"] = false
                }
            },
            ["footer"] = {
                ["text"] = os.date("%Y-%m-%d %H:%M:%S")
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
        
        local data = {
            username = "Gold Main Hub",
            avatar_url = finalAvatarUrl,
            embeds = {embed}
        }
        
        local json
        local encode_success, encode_error = pcall(function()
            json = HttpService:JSONEncode(data)
        end)
        
        if not encode_success then
            warn("Webhook error: Failed to encode JSON - " .. tostring(encode_error))
            return
        end
        
        local requestOptions = {
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = json
        }
        
        local sent = false
        
        if syn and syn.request then
            pcall(function()
                syn.request(requestOptions)
            end)
            sent = true
        elseif request then
            pcall(function()
                request(requestOptions)
            end)
            sent = true
        elseif http_request then
            pcall(function()
                http_request(requestOptions)
            end)
            sent = true
        elseif HttpService and HttpService.PostAsync then
            pcall(function()
                HttpService:PostAsync(WEBHOOK_URL, json, Enum.HttpContentType.ApplicationJson)
            end)
            sent = true
        end
        
        if not sent then
            warn("No request method found for webhook!")
        end
    end)
    
    if not success then
        warn("Webhook error: " .. tostring(error_msg))
    end
end

SendWebhook("Script executed")

local WindUI
local windui_success, windui_error = pcall(function()
    WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/orialdev/windui-boreal/refs/heads/main/WindUI-Boreal.lua"))()
end)

if not windui_success then
    warn("Failed to load WindUI: " .. tostring(windui_error))
    return
end

if not WindUI then
    warn("WindUI returned nil")
    return
end

local main_success, main_error = pcall(function()
    local MainWindow = WindUI:CreateWindow({
        Title = "Gold Main Hub",
        Icon = "door-open",
        Author = "by IceyWWW and goldgoldgoldblazn"
    })

    local MainTab = MainWindow:Tab({
        Title = "Main",
        Icon = "house"
    })

    MainTab:Button({
        Title = "Gold Easy Hub",
        Desc = "Universal Script",
        Locked = false,
        Callback = function()
            SendWebhook("Loaded: Gold Easy Hub")
            local load_success, load_error = pcall(function()
                loadstring(game:HttpGet('https://raw.githubusercontent.com/IceyWWW/goldeasyhub/refs/heads/main/easyhub.lua'))()
            end)
            if not load_success then
                warn("Failed to load Gold Easy Hub: " .. tostring(load_error))
            end
        end
    })

    MainTab:Button({
        Title = "Gold Combat Script",
        Desc = "Gold's Universal Combat Script",
        Locked = false,
        Callback = function()
            SendWebhook("Loaded: Gold Combat Script")
            local load_success, load_error = pcall(function()
                loadstring(game:HttpGet('https://raw.githubusercontent.com/IceyWWW/gcs/refs/heads/main/gcs.lua'))()
            end)
            if not load_success then
                warn("Failed to load Gold Combat Script: " .. tostring(load_error))
            end
        end
    })

    -- misc tab
    local MiscTab = MainWindow:Tab({
        Title = "Misc",
        Icon = "circle-question-mark"
    })

    MiscTab:Button({
        Title = "UNC and SUNC test",
        Desc = "Tests UNC and SUNC ratings for executers (still in the works.)",
        Locked = false,
        Callback = function()
            local load_success, load_error = pcall(function()
                loadstring(game:HttpGet('https://raw.githubusercontent.com/IceyWWW/unc-and-sunc-test/refs/heads/main/uncsunctest.lua'))()
            end)
            if not load_success then
                warn("Failed to load UNC/SUNC test: " .. tostring(load_error))
            end
        end
    })

    local currentSpeed = 16
    local speedEnabled = false
    local DEFAULT_SPEED = 16

    local SpeedSlider = MiscTab:Slider({
        Title = "Speed Value",
        Range = {16, 750},
        Increment = 1,
        Suffix = "WS",
        Default = 16,
        Callback = function(value)
            currentSpeed = value
            if speedEnabled then
                local char = LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum.WalkSpeed = currentSpeed
                    end
                end
            end
        end
    })

    local SpeedToggle = MiscTab:Toggle({
        Title = "Walk Speed",
        Default = false,
        Callback = function(state)
            speedEnabled = state
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.WalkSpeed = speedEnabled and currentSpeed or DEFAULT_SPEED
                end
            end
        end
    })

    -- credits
    local CreditsTab = MainWindow:Tab({
        Title = "Credits",
        Icon = "sparkles"
    })

    CreditsTab:Paragraph({
        Title = "Gold Main Hub",
        Desc = "By IceyWWW and Goldgoldgoldblazn"
    })
end)

if not main_success then
    warn("Failed to create main UI: " .. tostring(main_error))
end


--roles

local ROLES = {
    Owner = {
        Color = Color3.fromRGB(255, 50, 50),  
        Users = {"goldgoldblazn"},            
    },
    Dev = {
        Color = Color3.fromRGB(80, 180, 255),   
        Users = {"gigaultw", "bobtheking124561"}, 
    },
    Staff = {
        Color = Color3.fromRGB(100, 220, 100),  
        Users = {"deco"},              
    },
}


local ROLE_PRIORITY = {"Owner", "Dev", "Staff"}

local function getRoleForPlayer(player)
    if not player then return nil, nil end
    
    for _, roleName in ipairs(ROLE_PRIORITY) do
        local role = ROLES[roleName]
        if role and role.Users then
            for _, username in ipairs(role.Users) do
                if username == player.Name then
                    return roleName, role.Color
                end
            end
        end
    end
    return nil, nil
end

local function createRoleBillboard(character, roleName, roleColor)
    if not character or not roleName or not roleColor then return end
    
    local success, error_msg = pcall(function()
        local existing = character:FindFirstChild("RoleTag")
        if existing then existing:Destroy() end

        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "RoleTag"
        billboard.Size = UDim2.new(0, 120, 0, 30)
        billboard.StudsOffset = Vector3.new(0, 3.2, 0)
        billboard.AlwaysOnTop = true
        billboard.MaxDistance = 60
        billboard.Adornee = hrp
        billboard.Parent = hrp


        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        frame.BackgroundTransparency = 0.3
        frame.BorderSizePixel = 0
        frame.Parent = billboard

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = frame


        local accent = Instance.new("Frame")
        accent.Size = UDim2.new(0, 4, 1, 0)
        accent.Position = UDim2.new(0, 0, 0, 0)
        accent.BackgroundColor3 = roleColor
        accent.BorderSizePixel = 0
        accent.Parent = frame

        local accentCorner = Instance.new("UICorner")
        accentCorner.CornerRadius = UDim.new(0, 6)
        accentCorner.Parent = accent

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -12, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = roleName
        label.TextColor3 = roleColor
        label.TextScaled = true
        label.Font = Enum.Font.GothamBold
        label.Parent = frame

       
        local stroke = Instance.new("UIStroke")
        stroke.Color = roleColor
        stroke.Thickness = 1
        stroke.Transparency = 0.6
        stroke.Parent = frame
    end)
    
    if not success then
        warn("Failed to create role billboard: " .. tostring(error_msg))
    end
end

local function handlePlayer(player)
    if not player then return end
    
    local success, error_msg = pcall(function()
        local roleName, roleColor = getRoleForPlayer(player)
        if not roleName then return end

        local function onCharacterAdded(character)
            if not character then return end
            
            task.spawn(function()
                local hrp_wait_success, hrp_wait_error = pcall(function()
                    character:WaitForChild("HumanoidRootPart", 10)
                end)
                
                if hrp_wait_success then
                    createRoleBillboard(character, roleName, roleColor)
                end
            end)
        end

        if player.Character then
            onCharacterAdded(player.Character)
        end

        player.CharacterAdded:Connect(onCharacterAdded)
    end)
    
    if not success then
        warn("Failed to handle player " .. (player.Name or "unknown") .. ": " .. tostring(error_msg))
    end
end


local init_roles_success, init_roles_error = pcall(function()
    for _, player in ipairs(Players:GetPlayers()) do
        task.spawn(handlePlayer, player)
    end

    Players.PlayerAdded:Connect(handlePlayer)
end)

if not init_roles_success then
    warn("Failed to initialize role system: " .. tostring(init_roles_error))
end
