local scripts = {
    GuiMain = readfile("test/gui.lua"),
    Functions = readfile("test/functions.lua"),
}
local https = game:GetService("HttpService")
local file = "profile.txt"
function save()
    print("e2")
    if (writefile) then
        print("e3")
        writefile("test/"..file,https:JSONEncode(scripts.GuiMain.Tabs))
    else
        print("e4")
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
print("e1")
save()
