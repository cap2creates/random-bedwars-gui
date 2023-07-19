function load()
    local folder
    local filenames = {
        "mainscript.lua",
        "functions.lua",
        "gui.lua",
    }
    if (not isfolder("test")) then
        folder = makefolder("test")
    else
        folder = isfolder("test")
    end
    for number,filename in pairs(filenames) do
        if (not isfile("test/"..filename)) then
            writefile("test/"..filename, game:HttpGet("https://raw.githubusercontent.com/cap2creates/random-bedwars-gui/main/lua-test/"..filename, true))
        end
    end
    return folder
end
load()