local GuiMain = {
    Tabs = {
        Utility = {
            Enabled = false,
        },
        Player = { 
            Enabled = false,
        },
        Combat = { 
            Enabled = false,
        },
        Extra = { 
            Enabled = false,
        },
    },
    GuiOpenableItems = {
        Utility = {},
        Player = {},
        Combat = {},
        Extra = {},
    },
    DefaultPositions = {
        Utility = {},
        Player = {},
        Combat = {},
        Extra = {},
    },
}
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local ts = game:GetService("TweenService")
local newTabPos = UDim2.new(0,0,0.325,0)
local tabAdd = UDim2.new(0.175,0,0,0)
local bedrock
local tabColors = {
    Disabled = Color3.fromRGB(75,75,75),
    Enabled = Color3.fromRGB(30,155,220),
}
local toggleColors = {
    Disabled = Color3.fromRGB(60,60,60),
    Enabled = Color3.fromRGB(30,155,220)
}
local toggleNotifications = false
local buttonNotifications = false
function runcode(func) task.spawn(func) end
function drag(input)
    local gui = input
    local dragging
    local dragInput
    local dragStart
    local startPos
    function lerp(a, b, m)
        return a + (b - a) * m
    end;
    local lastMousePos
    local lastGoalPos
    local DRAG_SPEED = (8);
    function update(dt)
        if not (startPos) then return end;
        if not (dragging) and (lastGoalPos) then
            gui.Position = UDim2.new(startPos.X.Scale, lerp(gui.Position.X.Offset, lastGoalPos.X.Offset, dt * DRAG_SPEED), startPos.Y.Scale, lerp(gui.Position.Y.Offset, lastGoalPos.Y.Offset, dt * DRAG_SPEED))
            return 
        end;
        local delta = (lastMousePos - uis:GetMouseLocation())
        local xGoal = (startPos.X.Offset - delta.X);
        local yGoal = (startPos.Y.Offset - delta.Y);
        lastGoalPos = UDim2.new(startPos.X.Scale, xGoal, startPos.Y.Scale, yGoal)
        gui.Position = UDim2.new(startPos.X.Scale, lerp(gui.Position.X.Offset, xGoal, dt * DRAG_SPEED), startPos.Y.Scale, lerp(gui.Position.Y.Offset, yGoal, dt * DRAG_SPEED))
    end;
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            lastMousePos = uis:GetMouseLocation()

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    rs.Heartbeat:Connect(update)
end
function getHighestLayoutOrder(cat)
    local tab = bedrock.Tabs[cat]
    if not tab then return nil end
    local highest
    if tab:FindFirstChild("Items") then
        for i,v in pairs(tab.Items:GetChildren()) do
            if v:IsA("Frame") then
                if GuiMain.Tabs[cat][v.Name] then
                    if highest == nil or (v.LayoutOrder > highest) then
                        highest = v.LayoutOrder
                    end
                end
            end
        end
        return highest+1 or 0
    end
    return nil
end
function GuiMain.loadGui()
    local Bedrock = Instance.new("ScreenGui")
    
    local Tabs = Instance.new("ScrollingFrame")
    local GuiLabel = Instance.new("TextButton")
    local Enabled = false

    Bedrock.Name = "Bedrock"
    Bedrock.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    Bedrock.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Bedrock.ResetOnSpawn = false

    Tabs.Name = "Tabs"
    Tabs.Parent = Bedrock
    Tabs.Active = true
    Tabs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Tabs.BackgroundTransparency = 1.000
    Tabs.Position = UDim2.new(1,0,0,0)
    Tabs.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Tabs.BorderSizePixel = 0
    Tabs.ClipsDescendants = false
    Tabs.Size = UDim2.new(1, 0, 0.158000007, 0)
    Tabs.CanvasSize = UDim2.new(0, 0, 0, 0)

    GuiLabel.Name = "GuiLabel"
    GuiLabel.Parent = Bedrock
    GuiLabel.BackgroundColor3 = Color3.fromRGB(75,75,75)
    GuiLabel.BackgroundTransparency = 0
    GuiLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    GuiLabel.BorderSizePixel = 0
    GuiLabel.Position = UDim2.new(0.424710423, 0, 0, 0)
    GuiLabel.Size = UDim2.new(0.150000006, 0, 0.0500000007, 0)
    GuiLabel.FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    GuiLabel.Text = "Bedrock"
    GuiLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    GuiLabel.TextScaled = true
    GuiLabel.TextSize = 14.000
    GuiLabel.TextWrapped = true
    bedrock = Bedrock
    local Blur = Instance.new("BlurEffect", game.Lighting)
    Blur.Name = "BedrockBlur"
    Blur.Size = 0
    local function changeBlur()
        if not shared.bedrockRunning then return end
        if Enabled == true then
            ts:Create(Blur,TweenInfo.new(0.15,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0),{Size = 30}):Play()
            ts:Create(Tabs,TweenInfo.new(0.15,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0),{Position = UDim2.new(0,0,0,0)}):Play()
            ts:Create(GuiLabel,TweenInfo.new(0.15,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0),{BackgroundColor3 = toggleColors.Enabled}):Play()
        else
            ts:Create(Blur,TweenInfo.new(0.15,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0),{Size = 0}):Play()
            ts:Create(Tabs,TweenInfo.new(0.15,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0),{Position = UDim2.new(1,0,0,0)}):Play() 
            ts:Create(GuiLabel,TweenInfo.new(0.15,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0),{BackgroundColor3 = Color3.fromRGB(75,75,75)}):Play() 
        end
    end
    GuiLabel.MouseButton1Click:Connect(function()
        Enabled = not Enabled
        changeBlur()
    end)
    uis.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.L then
            Enabled = not Enabled
            changeBlur()
        end
    end)
    return Bedrock
end
function GuiMain.MakeKeybindGui()
    local Keybind = Instance.new("Frame")
    local ItemName = Instance.new("TextButton")
    local Bind = Instance.new("TextButton")

    Keybind.Name = "Keybind"
    Keybind.Parent = game:GetService("ReplicatedStorage")
    Keybind.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Keybind.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Keybind.BorderSizePixel = 0
    Keybind.Size = UDim2.new(1, 0, 0.100000001, 0)
    Keybind.Visible = false

    ItemName.Name = "ItemName"
    ItemName.Parent = Keybind
    ItemName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ItemName.BackgroundTransparency = 1.000
    ItemName.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ItemName.BorderSizePixel = 0
    ItemName.LayoutOrder = 1
    ItemName.Size = UDim2.new(0.850000024, 0, 1, 0)
    ItemName.FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    ItemName.Text = "Keybind"
    ItemName.TextColor3 = Color3.fromRGB(0, 0, 0)
    ItemName.TextScaled = true
    ItemName.TextSize = 14.000
    ItemName.TextWrapped = true

    Bind.Name = "Bind"
    Bind.Parent = Keybind
    Bind.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Bind.BackgroundTransparency = 1.000
    Bind.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Bind.BorderSizePixel = 0
    Bind.Position = UDim2.new(0.850000024, 0, 0, 0)
    Bind.Size = UDim2.new(0.150000006, 0, 1, 0)
    Bind.FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    Bind.Text = ""
    Bind.TextColor3 = Color3.fromRGB(0, 0, 0)
    Bind.TextScaled = true
    Bind.TextSize = 14.000
    Bind.TextWrapped = true
    return Keybind
end
function GuiMain.CreateNotification(cat,info,time)
    local Notification = Instance.new("Frame")
    local Category = Instance.new("TextLabel")
    local Message = Instance.new("TextLabel")
    local Time = Instance.new("TextLabel")

    Notification.Name = "Notification"
    Notification.Parent = game.Players.LocalPlayer.PlayerGui.Bedrock
    Notification.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
    Notification.BackgroundTransparency = 0.400
    Notification.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Notification.BorderSizePixel = 0
    Notification.Position = UDim2.new(0.783616722, 0, 0.764890254, 0)
    Notification.Size = UDim2.new(0,0,0,0)

    Category.Name = "Category"
    Category.Parent = Notification
    Category.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Category.BackgroundTransparency = 1.000
    Category.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Category.BorderSizePixel = 0
    Category.Size = UDim2.new(1, 0, 0.270000011, 0)
    Category.FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    Category.Text = cat
    Category.TextColor3 = Color3.fromRGB(0, 0, 0)
    Category.TextScaled = true
    Category.TextSize = 14.000
    Category.TextWrapped = true

    Message.Name = "Message"
    Message.Parent = Notification
    Message.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Message.BackgroundTransparency = 1.000
    Message.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Message.BorderSizePixel = 0
    Message.Position = UDim2.new(0, 0, 0.343283564, 0)
    Message.Size = UDim2.new(0.800000012, 0, 0.649999976, 0)
    Message.FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    Message.Text = info
    Message.TextColor3 = Color3.fromRGB(0, 0, 0)
    Message.TextScaled = true
    Message.TextSize = 14.000
    Message.TextWrapped = true

    Time.Name = "Time"
    Time.Parent = Notification
    Time.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Time.BackgroundTransparency = 1.000
    Time.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Time.BorderSizePixel = 0
    Time.Position = UDim2.new(0.799999833, 0, 0.626865625, 0)
    Time.Size = UDim2.new(0.200000003, 0, 0.370000005, 0)
    Time.FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    Time.Text = time
    Time.TextColor3 = Color3.fromRGB(0, 0, 0)
    Time.TextScaled = true
    Time.TextSize = 14.000
    Time.TextWrapped = true
    task.spawn(function()
        ts:Create(Notification,TweenInfo.new(0.25,Enum.EasingStyle.Bounce,Enum.EasingDirection.Out,0),{Size = UDim2.new(0.192, 0,0.21, 0)}):Play()
        for i=1,time-1 do
            task.wait(0.98)
            time -= 1
            Time.Text = time
        end
        task.wait(0.98)
        Time.Text = "0"
        ts:Create(Notification,TweenInfo.new(0.25,Enum.EasingStyle.Bounce,Enum.EasingDirection.Out,0),{Size = UDim2.new(0,0,0,0)}):Play()
    end)
end
function GuiMain.CreateButton(info)
    local Toggle = Instance.new("Frame")
    local Item = Instance.new("TextButton")
    local Options = Instance.new("TextButton")
    if (not GuiMain.Tabs[info.Category][info.Name]) then
        GuiMain.Tabs[info.Category][info.Name] = {}
        GuiMain.Tabs[info.Category][info.Name].Keybind = nil
    end

    Toggle.Name = info.Name
    Toggle.Parent = bedrock.Tabs:WaitForChild(info.Category):WaitForChild("Items")
    Toggle.LayoutOrder = getHighestLayoutOrder(info.Category)
    Toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Toggle.BorderSizePixel = 0
    Toggle.Size = UDim2.new(1, 0, 0.100000001, 0)

    Item.Name = "ItemName"
    Item.Parent = Toggle
    Item.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Item.BackgroundTransparency = 1.000
    Item.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Item.BorderSizePixel = 0
    Item.LayoutOrder = 1
    Item.Size = UDim2.new(0.850000024, 0, 1, 0)
    Item.FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    Item.TextColor3 = Color3.fromRGB(0, 0, 0)
    Item.TextScaled = true
    Item.TextSize = 14.000
    Item.TextWrapped = true
    Item.Text = Toggle.Name

    Options.Name = "Options"
    Options.Parent = Toggle
    Options.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Options.BackgroundTransparency = 1.000
    Options.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Options.BorderSizePixel = 0
    Options.Position = UDim2.new(0.850000024, 0, 0, 0)
    Options.Rotation = 90.000
    Options.Size = UDim2.new(0.150000006, 0, 1, 0)
    Options.Font = Enum.Font.FredokaOne
    Options.Text = "..."
    Options.TextColor3 = Color3.fromRGB(0, 0, 0)
    Options.TextScaled = true
    Options.TextSize = 14.000
    Options.TextWrapped = true

    GuiMain.GuiOpenableItems[info.Category][info.Name] = {}
    GuiMain.GuiOpenableItems[info.Category][info.Name].Keybind = {}
    GuiMain.GuiOpenableItems[info.Category][info.Name].Keybind.Frame = GuiMain.MakeKeybindGui()
    GuiMain.GuiOpenableItems[info.Category][info.Name].Keybind.Frame.LayoutOrder = Toggle.LayoutOrder
    GuiMain.GuiOpenableItems[info.Category][info.Name].Keybind.Set = GuiMain.Tabs[info.Category][info.Name].Keybind
    GuiMain.GuiOpenableItems[info.Category][info.Name].Keybind.Frame.Bind.Text = GuiMain.Tabs[info.Category][info.Name].Keybind or ""

    Item.MouseButton1Click:Connect(function()
        task.spawn(function()
            info.Function()
        end)
    end)
    Options.MouseButton1Click:Connect(function()
        for i,v in pairs(GuiMain.GuiOpenableItems[info.Category][info.Name]) do
            v.Frame.Visible = not v.Frame.Visible
            v.Frame.Parent = Toggle.Parent
        end
    end)
    uis.InputEnded:Connect(function(input)
        if GuiMain.GuiOpenableItems[info.Category][info.Name].Keybind.Set ~= nil and input.KeyCode == Enum.KeyCode[GuiMain.Tabs[info.Category][info.Name].Keybind] then
            task.spawn(function()
                info.Function()
            end)
            if buttonNotifications then GuiMain.CreateNotification("Keybind", info.Name.." has been activated!", 4) end
        end
    end)
    local keybindRunning = false
    local function keybind()
        local keybindtable = GuiMain.GuiOpenableItems[info.Category][info.Name].Keybind
        if not keybindtable then return end
        local frame = keybindtable.Frame
        if not frame then return end
        frame.Bind.Text = "..."
        if keybindRunning == true then
            frame.Bind.Text = keybindtable.Set
        elseif keybindRunning == false then
            keybindRunning = true
            uis.InputEnded:Connect(function(input)
                if keybindRunning == true and not (input.KeyCode.Name == "Unknown") then
                    keybindRunning = false
                    keybindtable.Set = input.KeyCode.Name
                    frame.Bind.Text = input.KeyCode.Name
                    GuiMain.Tabs[info.Category][info.Name].Keybind = input.KeyCode.Name
                else
                    
                end
            end)
        end
    end
    GuiMain.GuiOpenableItems[info.Category][info.Name].Keybind.Frame.Bind.MouseButton1Click:Connect(keybind)
    GuiMain.GuiOpenableItems[info.Category][info.Name].Keybind.Frame.ItemName.MouseButton1Click:Connect(keybind)
    return Toggle
end
function GuiMain.CreateToggle(info)
    local Toggle = Instance.new("Frame")
    local Item = Instance.new("TextButton")
    local Options = Instance.new("TextButton")
    if (not GuiMain.Tabs[info.Category][info.Name]) then
        GuiMain.Tabs[info.Category][info.Name] = {}
        GuiMain.Tabs[info.Category][info.Name].Enabled = false
        GuiMain.Tabs[info.Category][info.Name].Keybind = nil
    end
    local Enabled = GuiMain.Tabs[info.Category][info.Name].Enabled

    Toggle.Name = info.Name
    Toggle.Parent = bedrock.Tabs:WaitForChild(info.Category):WaitForChild("Items")
    Toggle.LayoutOrder = getHighestLayoutOrder(info.Category)
    Toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Toggle.BorderSizePixel = 0
    Toggle.Size = UDim2.new(1, 0, 0.100000001, 0)

    Item.Name = "ItemName"
    Item.Parent = Toggle
    Item.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Item.BackgroundTransparency = 1.000
    Item.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Item.BorderSizePixel = 0
    Item.LayoutOrder = 1
    Item.Size = UDim2.new(0.850000024, 0, 1, 0)
    Item.FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    Item.TextColor3 = Color3.fromRGB(0, 0, 0)
    Item.TextScaled = true
    Item.TextSize = 14.000
    Item.TextWrapped = true
    Item.Text = Toggle.Name

    Options.Name = "Options"
    Options.Parent = Toggle
    Options.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Options.BackgroundTransparency = 1.000
    Options.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Options.BorderSizePixel = 0
    Options.Position = UDim2.new(0.850000024, 0, 0, 0)
    Options.Rotation = 90.000
    Options.Size = UDim2.new(0.150000006, 0, 1, 0)
    Options.Font = Enum.Font.FredokaOne
    Options.Text = "..."
    Options.TextColor3 = Color3.fromRGB(0, 0, 0)
    Options.TextScaled = true
    Options.TextSize = 14.000
    Options.TextWrapped = true

    GuiMain.GuiOpenableItems[info.Category][info.Name] = {}
    GuiMain.GuiOpenableItems[info.Category][info.Name].Keybind = {}
    GuiMain.GuiOpenableItems[info.Category][info.Name].Keybind.Frame = GuiMain.MakeKeybindGui()
    GuiMain.GuiOpenableItems[info.Category][info.Name].Keybind.Frame.LayoutOrder = Toggle.LayoutOrder
    GuiMain.GuiOpenableItems[info.Category][info.Name].Keybind.Set = GuiMain.Tabs[info.Category][info.Name].Keybind
    GuiMain.GuiOpenableItems[info.Category][info.Name].Keybind.Frame.Bind.Text = GuiMain.Tabs[info.Category][info.Name].Keybind or ""

    if Enabled == true then
        Toggle.BackgroundColor3 = toggleColors.Enabled
        task.spawn(function()
            info.Function(Enabled)
        end)
    end

    Item.MouseButton1Click:Connect(function()
        Enabled = not Enabled
        GuiMain.Tabs[info.Category][info.Name].Enabled = Enabled
        if Enabled == true then
            Toggle.BackgroundColor3 = toggleColors.Enabled
        else
            Toggle.BackgroundColor3 = toggleColors.Disabled
        end
        task.spawn(function()
            info.Function(Enabled)
        end)
    end)
    Options.MouseButton1Click:Connect(function()
        for i,v in pairs(GuiMain.GuiOpenableItems[info.Category][info.Name]) do
            v.Frame.Visible = not v.Frame.Visible
            v.Frame.Parent = Toggle.Parent
        end
    end)
    uis.InputEnded:Connect(function(input)
        if GuiMain.GuiOpenableItems[info.Category][info.Name].Keybind.Set ~= nil and input.KeyCode == Enum.KeyCode[GuiMain.Tabs[info.Category][info.Name].Keybind] then
            Enabled = not Enabled
            GuiMain.Tabs[info.Category][info.Name].Enabled = Enabled
            if Enabled == true then
                Toggle.BackgroundColor3 = toggleColors.Enabled
            else
                Toggle.BackgroundColor3 = toggleColors.Disabled
            end
            task.spawn(function()
                info.Function(Enabled)
            end)
            if toggleNotifications then GuiMain.CreateNotification("Keybind",info.Name.." has been toggled! Activated: "..tostring(Enabled), 4) end
        end
    end)
    local keybindRunning = false
    local function keybind()
        local keybindtable = GuiMain.GuiOpenableItems[info.Category][info.Name].Keybind
        if not keybindtable then return end
        local frame = keybindtable.Frame
        if not frame then return end
        frame.Bind.Text = "..."
        if keybindRunning == true then
            frame.Bind.Text = keybindtable.Set
        elseif keybindRunning == false then
            keybindRunning = true
            uis.InputEnded:Connect(function(input)
                if keybindRunning == true and not (input.KeyCode.Name == "Unknown") then
                    keybindRunning = false
                    keybindtable.Set = input.KeyCode.Name
                    frame.Bind.Text = input.KeyCode.Name
                    GuiMain.Tabs[info.Category][info.Name].Keybind = input.KeyCode.Name
                else
                    
                end
            end)
        end
    end
    GuiMain.GuiOpenableItems[info.Category][info.Name].Keybind.Frame.Bind.MouseButton1Click:Connect(keybind)
    GuiMain.GuiOpenableItems[info.Category][info.Name].Keybind.Frame.ItemName.MouseButton1Click:Connect(keybind)
    rs.RenderStepped:Connect(function()
        if shared.Disconnect == true and Enabled then
            task.spawn(function()
                info.Function(false)
            end)
        end
    end)
    return Toggle
end
function GuiMain.CreateTab(info)
    local Utility = Instance.new("TextButton")
    local Items = Instance.new("ScrollingFrame")
    local UIListLayout = Instance.new("UIListLayout")
    if (not GuiMain.Tabs[info.Name]) then
        GuiMain.Tabs[info.Name] = {}
        GuiMain.Tabs[info.Name].Enabled = false
    end
    if (not GuiMain.Tabs[info.Name].Position) then
        GuiMain.Tabs[info.Name].Position = {newTabPos.X.Scale,newTabPos.X.Offset,newTabPos.Y.Scale,newTabPos.Y.Offset}
    end
    if not GuiMain.GuiOpenableItems[info.Name] then
        GuiMain.GuiOpenableItems[info.Name] = {}
    end
    local Enabled = GuiMain.Tabs[info.Name].Enabled

    GuiMain.DefaultPositions[info.Name] = {info.Name,newTabPos.X.Scale, newTabPos.X.Offset, newTabPos.Y.Scale, newTabPos.Y.Offset}

    Utility.Name = info.Name
    Utility.Parent = bedrock.Tabs
    Utility.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
    Utility.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Utility.BorderSizePixel = 0
    Utility.Position = UDim2.new(GuiMain.Tabs[info.Name].Position[1],GuiMain.Tabs[info.Name].Position[2],GuiMain.Tabs[info.Name].Position[3],GuiMain.Tabs[info.Name].Position[4])
    Utility.Size = UDim2.new(0.135000005, 0, 0.349999994, 0)
    Utility.FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    Utility.Text = info.Name
    Utility.TextColor3 = Color3.fromRGB(0, 0, 0)
    Utility.TextScaled = true
    Utility.TextSize = 14.000
    Utility.TextWrapped = true

    Items.Name = "Items"
    Items.Parent = Utility
    Items.Active = true
    Items.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
    Items.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Items.BorderSizePixel = 0
    Items.ClipsDescendants = false
    Items.Position = UDim2.new(0, 0, 25, 0)
    Items.Size = UDim2.new(1, 0, 10, 0)
    Items.Visible = true
    Items.CanvasSize = UDim2.new(0, 0, 0, 0)

    UIListLayout.Parent = Items
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    newTabPos += tabAdd

    if Enabled == true then
        Utility.BackgroundColor3 = toggleColors.Enabled
        Items.Position = UDim2.new(0,0,1,0)
    end

    Utility.MouseButton1Click:Connect(function()
        Enabled = not Enabled
        GuiMain.Tabs[info.Name].Enabled = Enabled
        if Enabled == true then
            ts:Create(Utility,TweenInfo.new(0.15,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0),{BackgroundColor3 = toggleColors.Enabled}):Play()
            ts:Create(Items,TweenInfo.new(0.15,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0),{Position = UDim2.new(0,0,1,0)}):Play()
        else
            ts:Create(Utility,TweenInfo.new(0.15,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0),{BackgroundColor3 = toggleColors.Disabled}):Play()
            ts:Create(Items,TweenInfo.new(0.15,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0),{Position = UDim2.new(0,0,25,0)}):Play()
        end
    end)
    drag(Utility)
    game:GetService("RunService").RenderStepped:Connect(function()
        GuiMain.Tabs[info.Name].Position = {Utility.Position.X.Scale, Utility.Position.X.Offset, Utility.Position.Y.Scale, Utility.Position.Y.Offset}
    end)
    return Utility
end
runcode(function()
    repeat task.wait() until bedrock
    task.wait(0.5)
    GuiMain.CreateToggle({Category = "Extra", Name = "Toggle Notifications", Function = function(callback)
        toggleNotifications = callback
    end})
    GuiMain.CreateToggle({Category = "Extra", Name = "Button Notifications", Function = function(callback)
        buttonNotifications = callback
    end})
end)
return GuiMain
