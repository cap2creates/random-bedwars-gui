local scripts = {
    GuiMain = readfile("gui.lua"),
    Functions = readfile("functions.lua"),
}
local https = game:GetService("HttpService")
local file = "profile.txt"
function save()
    if (writefile) then
        writefile(file,https:JSONEncode(scripts.GuiMain.Tabs))
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
save()