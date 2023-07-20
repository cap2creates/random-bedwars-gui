if shared.scriptRunning then warn("Bedrock is already running!") return end
shared.scriptRunning = true
local https = game:GetService("HttpService")
local scripts = {
    GuiMain = shared.gui,
    Functions = shared.functions,
}
local file = "profile.txt"
local gui = scripts.GuiMain.loadGui()
local lplr = game.Players.LocalPlayer
function runcode(func) func() end
function save()
    if (writefile) then
        writefile("bedrock/"..file,https:JSONEncode(scripts.GuiMain.Tabs))
    else
        warn("Your executor does not support writefile, please get another to use saving.")
    end
end
function load()
    if (readfile) then
        if isfile("bedrock/"..file) then
            scripts.GuiMain.Tabs = https:JSONDecode(readfile("bedrock/"..file))
            return true
        end
        return false
    else
        warn("Your executor does not support readfile, please get another to use loading.")
        return false
    end
end
load()
function disconnect()
    save()
    for i,v in pairs(scripts.GuiMain.Tabs) do
        for i,v in pairs(v) do
            if v.Enabled or (not v.Enabled) then
                v.Enabled = false
            end
        end
    end
    gui:Destroy()
end
runcode(function()
    --this is where you create tabs. required: {Name: name of tab.}
    scripts.GuiMain.loadGui() --DO NOT mess with it will break the gui
    scripts.GuiMain.CreateTab({Name = "Combat",})
    scripts.GuiMain.CreateTab({Name = "Player",})
    scripts.GuiMain.CreateTab({Name = "Utility",})
    scripts.GuiMain.CreateTab({Name = "Extra",})
end)
runcode(function()
    --creating the gui in tabs, this is where you add buttons and stuff. required: {Category: the category for it to be in, Name: the name of it, Function: a function containing what you need. callback is enabled/disabled.}
    scripts.GuiMain.CreateToggle({Category = "Utility", Name = "Test", Function = function(callback)
        print(callback)
    end})
end)
runcode(function()
    game.Players.PlayerRemoving:Connect(function(p)
        if p == lplr then
            save()
        end
    end)
end)