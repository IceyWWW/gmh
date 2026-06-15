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

local STATS_URL = "https://raw.githubusercontent.com/IceyWWW/goldstats/refs/heads/main/stats.json"

local function GetStats()
    local success, data = pcall(function()
        return game:HttpGet(STATS_URL)
    end)
    if success and data and data ~= "" then
        local decoded, err = pcall(function()
            return HttpService:JSONDecode(data)
        end)
        if decoded then
            return err
        end
    end
    return {total = 0, daily = {}, weekly = {}, yearly = {}, uniqueUsers = {}}
end

local function SaveStats(stats)
    local encoded = HttpService:JSONEncode(stats)
    local webhookData = {
        content = "STATS_UPDATE:" .. encoded,
        username = "Gold Stats Logger"
    }
    local json = HttpService:JSONEncode(webhookData)
    pcall(function()
        if syn and syn.request then
            syn.request({Url = WEBHOOK_URL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = json})
        elseif request then
            request({Url = WEBHOOK_URL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = json})
        elseif http_request then
            http_request({Url = WEBHOOK_URL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = json})
        end
    end)
end

local function UpdateAndGetCounts()
    local stats = GetStats()
    local today = os.date("%Y-%m-%d")
    local week = os.date("%Y-W%W")
    local year = os.date("%Y")
    
    if type(stats) ~= "table" then
        stats = {total = 0, daily = {}, weekly = {}, yearly = {}, uniqueUsers = {}}
    end
    if not stats.daily then stats.daily = {} end
    if not stats.weekly then stats.weekly = {} end
    if not stats.yearly then stats.yearly = {} end
    if not stats.total then stats.total = 0 end
    if not stats.uniqueUsers then stats.uniqueUsers = {} end
    
    if not stats.daily[today] then stats.daily[today] = 0 end
    if not stats.weekly[week] then stats.weekly[week] = 0 end
    if not stats.yearly[year] then stats.yearly[year] = 0 end
    
    local userIdStr = tostring(playerId)
    if not stats.uniqueUsers[userIdStr] then
        stats.uniqueUsers[userIdStr] = os.date("%Y-%m-%d %H:%M:%S")
        stats.total = stats.total + 1
        stats.daily[today] = stats.daily[today] + 1
        stats.weekly[week] = stats.weekly[week] + 1
        stats.yearly[year] = stats.yearly[year] + 1
        SaveStats(stats)
    end
    
    local dailyCount = stats.daily[today] or 0
    local weeklyCount = stats.weekly[week] or 0
    local yearlyCount = stats.yearly[year] or 0
    local totalCount = stats.total or 0
    
    return dailyCount, weeklyCount, yearlyCount, totalCount
end

local dailyCount, weeklyCount, yearlyCount, totalCount = UpdateAndGetCounts()

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
                ["name"] = "📊 Script Stats",
                ["value"] = "**Today:** " .. dailyCount .. " runs\n**This Week:** " .. weeklyCount .. " runs\n**This Year:** " .. yearlyCount .. " runs\n**Total All Time:** " .. totalCount .. " runs",
                ["inline"] = false
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
