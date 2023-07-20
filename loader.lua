function githubRequest(url)
    if not isfile("test/"..url) then
        writefile("test/"..url,game:HttpGet("https://raw.githubusercontent.com/cap2creates/random-bedwars-gui/main/lua-test/"..url,true))
    end
    return readfile("test/"..url)
end
function load()
    local folder
    local filenames = {
        "mainscript.lua",
        "functions.lua",
        "gui.lua",
    }
    local dothingname = "mainscript.lua"
    if (not isfolder("test")) then
        makefolder("test")
    end
    folder = isfolder("test")
    for number,filename in pairs(filenames) do
        if table.find(filenames,filename,1) and (not isfile("test/"..filename)) then
            local suc, err = pcall(function() githubRequest(filename) end)
            if err then warn(err) end
        end
    end
	shared.gui = loadstring(readfile("test/gui.lua"))()
	shared.functions = loadstring(readfile("test/functions.lua"))()
	shared.mainscript = loadstring(readfile("test/mainscript.lua"))()
    return
end
load()
