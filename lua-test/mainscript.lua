local scripts = {
    GuiMain = dofile("gui.lua"),
    Functions = dofile("functions.lua"),
}
local https = game:GetService("HttpService")
function save()
    --[[local data = {
        ["Tabs"] = scripts["GuiMain"]["Tabs"],
    }
    for i,v in pairs(scripts["GuiMain"]["Tabs"]) do
        local tabdata = {}
        for i2,v2 in pairs(scripts["GuiMain"]["Tabs"][v]) do

        end
        data["Tabs"][v] = tabdata
    end]]
    io.output("profile.lua")
    io.write(https:JSONEncode(scripts.GuiMain.Tabs))
    io.close()
end
save()