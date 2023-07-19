function load()
    local folder
    local filenames = {
        "mainscript.lua",
        "functions.lua",
        "gui.lua",
    }
    local dothingname = "mainscript.lua"
    if (not isfolder("test")) then
        folder = makefolder("test")
    end
    for number,filename in pairs(filenames) do
        if (not isfile("test/"..filename)) then
            writefile("test/"..filename, game:HttpGet("https://raw.githubusercontent.com/cap2creates/random-bedwars-gui/main/lua-test/"..filename, true))
        end
    end
    print("e")
    local mainfile = readfile("test/"..dothingname)
    if mainfile then print(mainfile) end
    if not mainfile then print("fail") end
    mainfile.dothing()
    return folder
end
load()
