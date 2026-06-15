local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/orialdev/windui-boreal/refs/heads/main/WindUI-Boreal.lua"))()

local MainWindow = WindUI:CreateWindow({
    Title = "Gold Main Hub",
    Icon = "door-open",
    Author = "by IceyWWW and goldgoldgoldblazn"

})

local MainTab = Window:Tab({
    Title = "Main",
    Icon = "house", -- optional
})

local Button = MainTab:Button({
    Title = "Gold Easy Hub",
    Desc = "Universal Script",
    Locked = false,
    Callback = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/IceyWWW/goldeasyhub/refs/heads/main/easyhub.lua'))()
    end
})

local Button = MainTab:Button({
    Title = "Gold Combat Script",
    Desc = "Gold's Universal Combat Script",
    Locked = false,
    Callback = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/IceyWWW/gcs/refs/heads/main/gcs.lua'))()
    end
})
