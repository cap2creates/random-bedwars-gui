f shared.bedrockRunning then warn("Bedrock is already running!") return end
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
                if playerValid(lplr) and not scripts.GuiMain.Tabs.Player.Fly.Enabled and not scripts.GuiMain.Tabs.Player.InfiniteFly.Enabled then
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
