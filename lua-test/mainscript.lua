if shared.scriptRunning then warn("This script is already running!") end
shared.scriptRunning = true
local https = game:GetService("HttpService")
local scripts = {
    GuiMain = shared.gui,
    Functions = shared.functions,
}
local file = "profile.txt"
local gui = scripts.GuiMain.loadGui()
function runcode(func) func() end
function save()
    if (writefile) then
        writefile("test/"..file,https:JSONEncode(scripts.GuiMain.Tabs))
    else
        warn("Your executor does not support writefile, please get another to use this script.")
    end
end
function load()
    if (readfile) then
        scripts.GuiMain.Tabs = https:JSONDecode(readfile(file)).Tabs
        return true
    else
        warn("Your executor does not support readfile, please get another to use this script.")
        return false
    end
end
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
    scripts.Functions.print("hello2lo")
end)
