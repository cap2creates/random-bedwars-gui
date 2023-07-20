function githubRequest(url)
    if not isfile("bedrock/"..url) then
        writefile("bedrock/"..url,game:HttpGet("https://raw.githubusercontent.com/cap2creates/random-bedwars-gui/main/bedrock-files/"..url,true))
    end
    return readfile("bedrock/"..url)
end
function load()
    local folder
    local filenames = {
        "mainscript.lua",
        "functions.lua",
        "gui.lua",
    }
    local dothingname = "mainscript.lua"
    if (not isfolder("bedrock")) then
        makefolder("bedrock")
    end
    folder = isfolder("bedrock")
    for number,filename in pairs(filenames) do
        if table.find(filenames,filename,1) and (not isfile("bedrock/"..filename)) then
            local suc, err = pcall(function() githubRequest(filename) end)
            if err then warn(err) end
        end
    end
	shared.gui = loadstring(readfile("bedrock/gui.lua"))()
	shared.functions = loadstring(readfile("bedrock/functions.lua"))()
	shared.mainscript = loadstring(readfile("bedrock/mainscript.lua"))()
    return
end
load()
