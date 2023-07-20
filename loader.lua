function githubRequest(url)
    if not isfile("test/"..url) then
        writefile("test/"..url, loadstring(game:HttpGet("https://raw.githubusercontent.com/cap2creates/random-bedwars-gui/main/lua-test/"..url,true))())
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
    local files = filenames
    local dothingname = "mainscript.lua"
    if (not isfolder("test")) then
        folder = makefolder("test")
    end
    for number,filename in pairs(filenames) do
        if (not isfile("test/"..filename)) then
            local suc, err = pcall(function() githubRequest(filename) end)
            if err then warn(err) else
                files[filename] = suc
            end
        end
    end
    return {folder,files}
end
load()
