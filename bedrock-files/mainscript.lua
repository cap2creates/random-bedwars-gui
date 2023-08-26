if shared.bedrockRunning then warn("Bedrock is already running!") return end
shared.bedrockRunning = true
shared.startTime = os.time()
repeat task.wait(.01) until game.Players.LocalPlayer and game.Players.LocalPlayer.Character
task.wait(1.2)
local https = game:GetService("HttpService")
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local cs = game:GetService("CollectionService")
local tcs = game:GetService("TextChatService")
local scripts = {
    GuiMain = shared.gui,
    Functions = shared.functions,
}
local file = "profile"
local gui = scripts.GuiMain:loadGui()
local maingui = shared.bedrock
repeat task.wait(0.005) until gui
local lplr = game.Players.LocalPlayer
local KnitClient
local Client
local cam = game:GetService("Workspace").CurrentCamera
local pFPS = 0
local antivoidYPos = 0
local function getremote(tab)
	for i,v in pairs(tab) do
		if v == "Client" then
			return tab[i + 1]
		end
	end
	return ""
end
local bedwarsStore = {
    localInventory = {
		inventory = {
			items = {},
			armor = {}
		},
		hotbar = {}
	},
    blockRaycast = RaycastParams.new(),
    pots = {},
}
local playerList = {}
if not lplr:FindFirstChild("Tags") then
    local f = Instance.new("Folder", lplr)
    f.Name = "Tags"
end
if not isfolder("bedrock/Profiles") then
    makefolder("bedrock/Profiles")
end
local chatTag = Instance.new("StringValue",lplr:WaitForChild("Tags"))
chatTag.Name = "1"
chatTag.Value = "<font color='rgb(50,50,50)'>[bedrock]</font>"
local bedwars = {}
task.spawn(function()
    local success, error = pcall(function()
        task.spawn(function()
            KnitClient = debug.getupvalue(require(lplr.PlayerScripts.TS.knit).setup, 6)
            Client = require(game:GetService("ReplicatedStorage").TS.remotes).default.Client
        end)
        bedwars = {
            ["PaintRemote"] = getremote(debug.getconstants(KnitClient.Controllers.PaintShotgunController.fire)),
            ["KnockbackTable"] = debug.getupvalue(require(game:GetService("ReplicatedStorage").TS.damage["knockback-util"]).KnockbackUtil.calculateKnockbackVelocity, 1),
            ["CombatConstant"] = require(game:GetService("ReplicatedStorage").TS.combat["combat-constant"]).CombatConstant,
            ["SprintController"] = KnitClient.Controllers.SprintController,
            ["ResetRemote"] = getremote(debug.getconstants(debug.getproto(KnitClient.Controllers.ResetController.createBindable, 1))),
            ["PickupRemote"] = getremote(debug.getconstants((require(lplr.PlayerScripts.TS.controllers.global["item-drop"]["item-drop-controller"]).ItemDropController).checkForPickup)),
            ["ShopItems"] = debug.getupvalue(require(game:GetService("ReplicatedStorage").TS.games.bedwars.shop["bedwars-shop"]).BedwarsShop.getShopItem, 2),
            ["DamageController"] = require(lplr.PlayerScripts.TS.controllers.global.damage["damage-controller"]).DamageController,
            ["DamageTypes"] = require(game:GetService("ReplicatedStorage").TS.damage["damage-type"]).DamageType,
            ["SwordRemote"] = getremote(debug.getconstants((KnitClient.Controllers.SwordController).attackEntity)),
            ["PingController"] = require(lplr.PlayerScripts.TS.controllers.game.ping["ping-controller"]).PingController,
            ["DamageIndicator"] = KnitClient.Controllers.DamageIndicatorController.spawnDamageIndicator,
            ["DaoController"] = KnitClient.Controllers.DaoController,
            ["ClientHandlerStore"] = require(lplr.PlayerScripts.TS.ui.store).ClientStore,
            ["SwordController"] = KnitClient.Controllers.SwordController,
            ["KnockbackUtil"] = require(game:GetService("ReplicatedStorage").TS.damage["knockback-util"]).KnockbackUtil,
            ["ItemTable"] = debug.getupvalue(require(game:GetService("ReplicatedStorage").TS.item["item-meta"]).getItemMeta, 1),
            ["QueryUtil"] = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out).GameQueryUtil,
            ["ClientHandler"] = Client,
            ["EquipItemRemote"] = getremote(debug.getconstants(debug.getproto(require(game:GetService("ReplicatedStorage").TS.entity.entities["inventory-entity"]).InventoryEntity.equipItem, 3))),
            ["ProjectileController"] = KnitClient.Controllers.ProjectileController,
            ["BowConstantsTable"] = debug.getupvalue(KnitClient.Controllers.ProjectileController.enableBeam, 6),
            ["BlockController"] = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out).BlockEngine,
            ["AnimationUtil"] = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out["shared"].util["animation-util"]).AnimationUtil,
            ["BlockEngineClientEvents"] =  require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out.client["block-engine-client-events"]).BlockEngineClientEvents,
            ["ClientHandlerDamageBlock"] = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out.shared.remotes).BlockEngineRemotes.Client,
            ["LobbyClientEvents"] =  KnitClient.Controllers.QueueController,
            ["QueueMeta"] = require(game:GetService("ReplicatedStorage").TS.game["queue-meta"]).QueueMeta,
            ["AttackRemote"] = getremote(debug.getconstants(KnitClient.Controllers.SwordController.sendServerRequest)),
        }
    end)
    if error then
        warn("The bedwars table and/or Client/KnitClient could not be set, you are either in the lobby, the wrong game, or bedwars has updated. If you are in a bedwars match and you see this, please edit the paths.")
    end
end)
local blacklistedblocks = {
	bed = true,
	ceramic = true
}
local cachedNormalSides = {}
local bedrockEvents = setmetatable({}, {
	__index = function(self, index)
		self[index] = Instance.new("BindableEvent")
		return self[index]
	end
})
local bedrockConnections = {}
for i,v in pairs(Enum.NormalId:GetEnumItems()) do if v.Name ~= "Bottom" then table.insert(cachedNormalSides, v) end end
local RunLoops = {RenderStepTable = {}, StepTable = {}, HeartTable = {}}
do
    for _, ent in pairs(cs:GetTagged("entity")) do 
		if ent.Name == "DesertPotEntity" then 
			table.insert(bedwarsStore.pots, ent)
		end
	end
	table.insert(bedrockConnections, cs:GetInstanceAddedSignal("entity"):Connect(function(ent)
		if ent.Name == "DesertPotEntity" then 
			table.insert(bedwarsStore.pots, ent)
		end
	end))
	table.insert(bedrockConnections, cs:GetInstanceRemovedSignal("entity"):Connect(function(ent)
		ent = table.find(bedwarsStore.pots, ent)
		if ent then 
			table.remove(bedwarsStore.pots, ent)
		end
	end))
end
if Client then
    for i,v in pairs({"MatchEndEvent", "EntityDeathEvent", "EntityDamageEvent", "BedwarsBedBreak", "BalloonPopped", "AngelProgress"}) do
        Client:WaitFor(v):andThen(function(connection)
            table.insert(bedrockConnections, connection:Connect(function(...)
                bedrockEvents[v]:Fire(...)
            end))
        end)
    end
end

do
	function RunLoops:BindToRenderStep(name, func)
		if RunLoops.RenderStepTable[name] == nil then
			RunLoops.RenderStepTable[name] = rs.RenderStepped:Connect(func)
		end
	end

	function RunLoops:UnbindFromRenderStep(name)
		if RunLoops.RenderStepTable[name] then
			RunLoops.RenderStepTable[name]:Disconnect()
			RunLoops.RenderStepTable[name] = nil
		end
	end

	function RunLoops:BindToStepped(name, func)
		if RunLoops.StepTable[name] == nil then
			RunLoops.StepTable[name] = rs.Stepped:Connect(func)
		end
	end

	function RunLoops:UnbindFromStepped(name)
		if RunLoops.StepTable[name] then
			RunLoops.StepTable[name]:Disconnect()
			RunLoops.StepTable[name] = nil
		end
	end

	function RunLoops:BindToHeartbeat(name, func)
		if RunLoops.HeartTable[name] == nil then
			RunLoops.HeartTable[name] = rs.Heartbeat:Connect(func)
		end
	end

	function RunLoops:UnbindFromHeartbeat(name)
		if RunLoops.HeartTable[name] then
			RunLoops.HeartTable[name]:Disconnect()
			RunLoops.HeartTable[name] = nil
		end
	end
end
do
    bedwarsStore.blocks = cs:GetTagged("block")
	bedwarsStore.blockRaycast.FilterDescendantsInstances = {bedwarsStore.blocks}
    bedwarsStore.blockRaycast.FilterType = Enum.RaycastFilterType.Include
end
local function matchState() return bedwars["ClientHandlerStore"]:getState().Game.matchState end
local function runcode(func) task.spawn(func) end
local function save()
    if (writefile) then
        if not isfolder("bedrock/Profiles/"..game.PlaceId) then
            makefolder("bedrock/Profiles/"..game.PlaceId)
        end
        writefile("bedrock/Profiles/"..game.PlaceId.."/"..file,https:JSONEncode(scripts.GuiMain.Tabs))
        writefile("bedrock/Profiles/"..game.PlaceId.."/sliderfile",https:JSONEncode(scripts.GuiMain.Sliders))
        writefile("bedrock/Profiles/"..game.PlaceId.."/togglefile",https:JSONEncode(scripts.GuiMain.Toggles))
        writefile("bedrock/Profiles/"..game.PlaceId.."/dropdownfile",https:JSONEncode(scripts.GuiMain.Dropdowns))
    else
        warn("Your executor does not support writefile, please get another to use saving.")
    end
end
local function load()
    if (readfile) and (isfile) then
        if isfolder("bedrock/Profiles/"..game.PlaceId) then
            if isfile("bedrock/Profiles/"..game.PlaceId.."/"..file) then scripts.GuiMain.Tabs = https:JSONDecode(readfile("bedrock/Profiles/"..game.PlaceId.."/"..file)) end
            if isfile("bedrock/Profiles/"..game.PlaceId.."/sliderfile") then scripts.GuiMain.Sliders = https:JSONDecode(readfile("bedrock/Profiles/"..game.PlaceId.."/sliderfile")) end
            if isfile("bedrock/Profiles/"..game.PlaceId.."/togglefile") then scripts.GuiMain.Toggles = https:JSONDecode(readfile("bedrock/Profiles/"..game.PlaceId.."/togglefile")) end
            if isfile("bedrock/Profiles/"..game.PlaceId.."/dropdownfile") then scripts.GuiMain.Dropdowns = https:JSONDecode(readfile("bedrock/Profiles/"..game.PlaceId.."/dropdownfile")) end
        end
    else
        warn("Your executor does not support readfile/isfile, please get another to use loading.")
        return false
    end
end
load()
local function isAlive(plr,isChar)
    if isChar then
        plr = game.Players:FindFirstChild(plr.Name) or lplr
    else
        plr = plr or lplr 
    end
	if not plr.Character then return false end
	if not plr.Character:FindFirstChild("Head") then return false end
	if not plr.Character:FindFirstChild("Humanoid") then return false end
	if plr.Character:FindFirstChild("Humanoid").Health < 0.11 then return false end
	return true
end
local function disconnect()
    save()
    maingui:Destroy()
    shared.bedrockRunning = false
    shared.Disconnect = true
    if game.Lighting:FindFirstChild("BedrockBlur") then
        game.Lighting.BedrockBlur:Destroy()
    end
    task.wait(.2)
    shared.Disconnect = false
end
local function getNearestPlayer(checkForTeam,blacklist,checkforantivoid)
    local closestDistance = math.huge
    local closestPlayer = nil
    for i,v in pairs(game.Players:GetPlayers()) do
        if v and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and isAlive(v)==true and lplr and lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart") and isAlive(lplr) == true and v~=lplr and (blacklist and (not blacklist[v]) or true) then
            if checkforantivoid and v.Character.HumanoidRootPart.Position.Y < antivoidYPos then continue end
            if checkForTeam and (v.Team==lplr.Team or v.TeamColor==lplr.TeamColor) then continue end
            if (v.Character.HumanoidRootPart.Position - lplr.Character.HumanoidRootPart.Position).magnitude < closestDistance then 
                closestDistance = (v.Character.HumanoidRootPart.Position - lplr.Character.HumanoidRootPart.Position).magnitude 
                closestPlayer = v
            end
        end
    end
    if closestPlayer == nil then return nil end
    return closestPlayer.Character
end
local function playerValid(p)
    return (p and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character:FindFirstChild("HumanoidRootPart") and isAlive(p) and true or false)
end
local tabs = {
    Combat = gui:CreateTab({Name = "Combat",}),
    Player = gui:CreateTab({Name = "Player",}),
    Util = gui:CreateTab({Name = "Utility",}),
    ESP = gui:CreateTab({Name = "ESP",}),
    Extra = gui:CreateTab({Name = "Extra",}),
    Arraylist = gui:CreateTab({Name = "Arraylist",}),
}
runcode(function()
    tabs.Extra:CreateButton({Name = "UnInject", Function = function(callback)
        disconnect()
    end})
    tabs.Extra:CreateToggle({Name = "Toggle Notifications", Function = function(callback)
        shared.toggleNotifications = callback
    end})
    tabs.Extra:CreateToggle({Name = "Button Notifications", Function = function(callback)
        shared.buttonNotifications = callback
    end})
end)
runcode(function()
    local Speed = false
    local SpeedBar = {Value = 14}
    local SpeedToggle
    local type = "CFrame"
    SpeedToggle = tabs.Player:CreateToggle({Name = "Speed", Function = function(callback)
        Speed = callback
        if Speed then
            task.wait(.5)
            RunLoops:BindToRenderStep("Speed",function()
                if playerValid(lplr) then
                    lplr.Character.HumanoidRootPart.CFrame += (type == "CFrame" and lplr.Character.Humanoid.MoveDirection*((1/pFPS)*(SpeedBar.Value-lplr.Character.Humanoid.WalkSpeed)) or Vector3.new(0,0,0))
                    lplr.Character.HumanoidRootPart.Velocity = (type == "Velocity" and Vector3.new((lplr.Character.Humanoid.MoveDirection*SpeedBar.Value).X,lplr.Character.HumanoidRootPart.Velocity.Y,(lplr.Character.Humanoid.MoveDirection*SpeedBar.Value).Z) or lplr.Character.HumanoidRootPart.Velocity)
                end
            end)
        else
            RunLoops:UnbindFromRenderStep("Speed")
        end
    end})
    SpeedBar.Toggle = SpeedToggle:CreateSlider({
        Name = "Speed",
        Min = 10,
        Max = 125,
        Changed = function(val)
            SpeedBar.Value = val
        end
    })
    SpeedToggle:CreateDropdown({
        Name = "Type",
        Default = "CFrame",
        Options = {"CFrame", "Velocity"},
        Function = function(typeOf)
            type = typeOf
        end
    })
end)
runcode(function()
    local NoFall = false
    local Toggle
    local delay = {Value = .5}
    Toggle = tabs.Util:CreateToggle({Name = "NoFall", Function = function(callback)
        NoFall = callback
        runcode(function()
            if matchState() == 0 then repeat task.wait(0.005) until matchState ~= 0 end
            repeat
                task.wait(delay.Value)
                require(game:GetService("ReplicatedStorage").TS.remotes).default.Client:Get("GroundHit"):SendToServer()
            until not NoFall
        end)
    end})
    delay.Slider = Toggle:CreateSlider({
        Name = "Tick",
        Min = 0.02,
        Max = 1,
        Changed = function(val)
            delay.Value = val
        end
    })
end)
                    runcode(function()
    local nametagESP = false
    local oldDistance = 150
    tabs.ESP:CreateToggle({Name = "NametagESP", Function = function(callback)
        nametagESP = callback
        if nametagESP then
            runcode(function()
                repeat
                    for i,v in pairs(game.Players:GetPlayers()) do
                        if v.Character and v.Character:FindFirstChild("Head") and v.Character.Head:FindFirstChild("Nametag") then
                            v.Character.Head.Nametag.MaxDistance = math.huge
                        end
                    end
                    task.wait(0.05)
                until not nametagESP
            end)
        elseif not nametagESP then
            for i,v in pairs(game.Players:GetPlayers()) do
                if v.Character and v.Character:FindFirstChild("Head") and v.Character.Head:FindFirstChild("Nametag") then
                    v.Character.Head.Nametag.MaxDistance = oldDistance
                end
            end
            task.wait(game.Players.RespawnTime)
            for i,v in pairs(game.Players:GetPlayers()) do
                if v.Character and v.Character:FindFirstChild("Head") and v.Character.Head:FindFirstChild("Nametag") then
                    v.Character.Head.Nametag.MaxDistance = oldDistance
                end
            end
        end
    end})
end)
                        runcode(function()
	local bedESP = false
	tabs.ESP:CreateToggle({Name = "BedESP", Function = function(callback)
		bedESP = callback
		if bedESP then
			for i,v in pairs(cs:GetTagged("bed")) do
				for i2,v2 in pairs(v:GetChildren()) do
                    if v2.ClassName ~= "ProximityPrompt" then
                        local h = Instance.new("Highlight",v)
                        h.OutlineTransparency = 1
                        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        h.FillTransparency = 0
                        h.Adornee = v2
                        h.FillColor = v2.Color
                    end
				end
			end
		else
			for i,v in pairs(cs:GetTagged("bed")) do
				for i2,v2 in pairs(v:GetChildren()) do
					if v2:IsA("Highlight") then
						v2:Destroy()
					end
				end
			end
		end
	end})
end)
runcode(function()
    while task.wait(1) do
        bedwarsStore.localInventory =  bedwars["ClientHandlerStore"]:getState().Inventory.observedInventory
    end
end)
runcode(function()
    local valid = true
    game.Players.PlayerRemoving:Connect(function(p)
        if p == lplr and valid then
            save()
        end
    end)
    repeat
        task.wait(0.05)
        if shared.Disconnect == true then
            valid = false
        end
    until not valid
end)
runcode(function()
    repeat
        task.wait(0.005)
    until matchState() ~= 0
    task.wait(1)
    local y = math.huge
    for i,v in pairs(workspace.Map.Worlds:FindFirstChildOfClass("Folder").Blocks:GetChildren()) do
        if v and v.Position and v.Position.Y < y then
            y = v.Position.Y
        end
    end
    antivoidYPos = y
end)
runcode(function()
    function getFPS()
        local oldTime
        game:GetService("RunService").RenderStepped:Connect(function()
            if not oldTime then
                oldTime = tick()
            elseif oldTime then
                pFPS = math.floor(1/(tick()-oldTime))
                oldTime = tick()
            end
        end)
    end
    task.spawn(getFPS)
end)
runcode(function()
    bedwarsStore.queueType = bedwars["ClientHandlerStore"]:getState().Game.queueType or "bedwars_test"
end)
runcode(function()
    --player list handler
    local function doThing(p)
        runcode(function()
            local inJump = false
            if p == nil then return end
            playerList[p.Name] = {Alive = false, JumpTick = 0, Valid = false, Jumps = 0, Jumping = false,}
            local c = nil or p.Character
            if not c then repeat c = nil or p.Character task.wait(0.005) until c end
            repeat
                task.wait(0.005)
                if p == nil then return end
                if not isAlive(p) or not playerValid(p) then break end
                playerList[p.Name].Alive = isAlive(p)
                playerList[p.Name].Valid = playerValid(p)
                local state = c.Humanoid:GetState()
                playerList[p.Name].JumpTick = (state ~= Enum.HumanoidStateType.Running and state ~= Enum.HumanoidStateType.Landed) and tick() or playerList[p.Name].JumpTick
                playerList[p.Name].Jumping = (tick() - playerList[p.Name].JumpTick) < 0.2 and playerList[p.Name].Jumps > 1
                if (tick() - playerList[p.Name].JumpTick) > 0.2 then 
                    playerList[p.Name].Jumps = 0
                end
                if state == Enum.HumanoidStateType.Jumping and (not inJump) then
                    inJump = true
                    runcode(function()
                        repeat
                            task.wait(0.005)
                            if p == nil or not playerValid(p) then return end
                        until c.Humanoid:GetState() == Enum.HumanoidStateType.Landed
                        playerList[p.Name].Jumps += 1
                        inJump = false
                    end)
                end
            until not isAlive(p) or not playerValid(p)
            if p == nil then return end
            playerList[p.Name].Alive = isAlive(p)
            playerList[p.Name].Valid = playerValid(p)
            repeat
                if p == nil then return end
                task.wait(0.005)
                playerList[p.Name].Alive = isAlive(p)
                playerList[p.Name].Valid = playerValid(p)
            until isAlive(p)
            if p == nil then return end
            doThing(p)
        end)
    end
    repeat
        task.wait(0.005)
    until matchState() ~= 0
    for i,v in pairs(game.Players:GetPlayers()) do
        doThing(v)
    end
    game.Players.PlayerAdded:Connect(function(p)
        doThing(p)
    end)
    game.Players.PlayerRemoving:Connect(function(p)
        if playerList[p.Name] then
            playerList[p.Name] = nil
        end
    end)
end)
