local WEBHOOK_URL = "https://discord.com/api/webhooks/1515882139856408703/eyCBhTvIrUqi6VWpiTGpaL1UleBV_v11dAa8qj6S7ZT1mgSUh3ciHtCYP9pvC9a8k4Yt"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local playerId = LocalPlayer.UserId
local playerName = LocalPlayer.Name
local playerDisplayName = LocalPlayer.DisplayName
local gameName = game.Name
local placeId = game.PlaceId
local jobId = game.JobId
local avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. playerId .. "&width=420&height=420&format=png"

local function SendWebhook(action)
    local embed = {
        ["title"] = "Gold Main Hub",
        ["description"] = "**" .. action .. "**",
        ["color"] = 0xffaa00,
        ["thumbnail"] = {
            ["url"] = avatarUrl
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
        avatar_url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. playerId .. "&width=128&height=128&format=png",
        embeds = {embed}
    }
    
    local json = HttpService:JSONEncode(data)
    
    if syn and syn.request then
        syn.request({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = json
        })
    elseif request then
        request({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = json
        })
    elseif http_request then
        http_request({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = json
        })
    elseif HttpService and HttpService.PostAsync then
        pcall(function()
            HttpService:PostAsync(WEBHOOK_URL, json, Enum.HttpContentType.ApplicationJson)
        end)
    end
end

SendWebhook("Script executed")

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/orialdev/windui-boreal/refs/heads/main/WindUI-Boreal.lua"))()

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
        loadstring(game:HttpGet('https://raw.githubusercontent.com/IceyWWW/goldeasyhub/refs/heads/main/easyhub.lua'))()
    end
})

MainTab:Button({
    Title = "Gold Combat Script",
    Desc = "Gold's Universal Combat Script",
    Locked = false,
    Callback = function()
        SendWebhook("Loaded: Gold Combat Script")
        loadstring(game:HttpGet('https://raw.githubusercontent.com/IceyWWW/gcs/refs/heads/main/gcs.lua'))()
    end
})
