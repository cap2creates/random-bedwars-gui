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

    Bedrock.Name = "Bedrock"
    Bedrock.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    Bedrock.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

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
    Blur.Size = 0
    GuiLabel.MouseButton1Click:Connect(function()
        if Blur.Size == 0 then
            ts:Create(Blur,TweenInfo.new(0.15,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0),{Size = 30}):Play()
            ts:Create(Tabs,TweenInfo.new(0.15,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0),{Position = UDim2.new(0,0,0,0)}):Play()
            ts:Create(GuiLabel,TweenInfo.new(0.15,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0),{BackgroundColor3 = toggleColors.Enabled}):Play()
        else
            ts:Create(Blur,TweenInfo.new(0.15,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0),{Size = 0}):Play()
            ts:Create(Tabs,TweenInfo.new(0.15,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0),{Position = UDim2.new(1,0,0,0)}):Play() 
            ts:Create(GuiLabel,TweenInfo.new(0.15,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0),{BackgroundColor3 = Color3.fromRGB(75,75,75)}):Play() 
        end
    end)
end
function GuiMain.CreateToggle(info)
    local Toggle = Instance.new("Frame")
    local Item = Instance.new("TextButton")
    local Options = Instance.new("TextButton")
    if (not GuiMain.Tabs[info.Category][info.Name]) then
        GuiMain.Tabs[info.Category][info.Name] = {}
        GuiMain.Tabs[info.Category][info.Name].Enabled = false
    end
    local Enabled = GuiMain.Tabs[info.Category][info.Name].Enabled

    Toggle.Name = info.Name
    Toggle.Parent = bedrock.Tabs[info.Category].Items
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

    if Enabled == true then
        Toggle.BackgroundColor3 = toggleColors.Enabled
        info.Function(Enabled)
    end

    Item.MouseButton1Click:Connect(function()
        Enabled = not Enabled
        GuiMain.Tabs[info.Category][info.Name].Enabled = Enabled
        if Enabled == true then
            Toggle.BackgroundColor3 = toggleColors.Enabled
        else
            Toggle.BackgroundColor3 = toggleColors.Disabled
        end
        info.Function(Enabled)
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
    local Enabled = GuiMain.Tabs[info.Name].Enabled

    Utility.Name = info.Name
    Utility.Parent = bedrock.Tabs
    Utility.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
    Utility.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Utility.BorderSizePixel = 0
    Utility.Position = newTabPos
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
    return Utility
end
return GuiMain
