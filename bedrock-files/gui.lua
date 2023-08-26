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
    Sliders = {
        Utility = {},
        Player = {},
        Combat = {},
        Extra = {},
    },
    Toggles = {
        Utility = {},
        Player = {},
        Combat = {},
        Extra = {},
    },
    Dropdowns = {
        Utility = {},
        Player = {},
        Combat = {},
        Extra = {},
    }
}
local arrayList
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local ts = game:GetService("TweenService")
local newTabPos = UDim2.new(0,0,0.25,0)
local tabAdd = UDim2.new(0.1,0,0,0)
local bedrock
local tabColors = {
    Disabled = Color3.fromRGB(75,75,75),
    Enabled = Color3.fromRGB(30,155,220),
}
local toggleColors = {
    Disabled = Color3.fromRGB(60,60,60),
    Enabled = Color3.fromRGB(30,155,220)
}
local toggleColors_2 = {
    Disabled = Color3.fromRGB(75,75,75),
    Enabled = Color3.fromRGB(25,160,230)
}
local strokeColor = Color3.fromRGB(0, 0, 0)
local toggleNotifications = shared.toggleNotifications
local buttonNotifications = shared.buttonNotifications
local function runcode(func) task.spawn(func) end
runcode(function()
    while task.wait() do
        toggleNotifications = shared.toggleNotifications
        buttonNotifications = shared.buttonNotifications
    end
end)
local function drag(input)
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
local function getHighestLayoutOrder(cat)
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
local function RelativeXY(GuiObject, location)
    local x, y = location.X - GuiObject.AbsolutePosition.X, location.Y - GuiObject.AbsolutePosition.Y
    local x2 = 0
    local xm, ym = GuiObject.AbsoluteSize.X, GuiObject.AbsoluteSize.Y
    x2 = math.clamp(x, 4, xm - 6)
    x = math.clamp(x, 0, xm)
    y = math.clamp(y, 0, ym)
    return x, y, x/xm, y/ym, x2/xm
end
function GuiMain:loadGui()
    local Bedrock = Instance.new("ScreenGui")
    local g = {}
    local Tabs = Instance.new("ScrollingFrame")
    local GuiLabel = Instance.new("TextButton")
    local Enabled = false

    Bedrock.Name = "Bedrock"
    Bedrock.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    Bedrock.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Bedrock.ResetOnSpawn = false
    Bedrock.IgnoreGuiInset = true

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
    GuiLabel.Position = UDim2.new(.465, 0, .0125, 0)
    GuiLabel.Size = UDim2.new(.09,0,.035,0)
    GuiLabel.FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    GuiLabel.Text = "Bedrock"
    GuiLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    GuiLabel.TextScaled = true
    GuiLabel.TextSize = 14.000
    GuiLabel.TextWrapped = true
    bedrock = Bedrock
    shared.bedrock = bedrock
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
    drag(GuiLabel)
    function g:CreateTab(info)
        local g2 = {}
        local Utility = Instance.new("TextButton")
        local Items = Instance.new("ScrollingFrame")
        local UIListLayout = Instance.new("UIListLayout")
        if (not GuiMain.Tabs[info.Name]) then
            GuiMain.Tabs[info.Name] = {}
            GuiMain.Tabs[info.Name].Enabled = false
        end
        if not GuiMain.GuiOpenableItems[info.Name] then
            GuiMain.GuiOpenableItems[info.Name] = {}
        end
        local Enabled = GuiMain.Tabs[info.Name].Enabled
        Utility.Parent = bedrock.Tabs
        Utility.Size = UDim2.new(.09, 0,.2, 0)
        Items.Size = UDim2.new(1, 0, 10, 0)
        if info.Name == "Arraylist" then
            if not GuiMain.DefaultPositions[info.Name] then
                GuiMain.DefaultPositions[info.Name] = {info.Name,.454, 0,.9, 0}
            end
            if not GuiMain.Tabs[info.Name].Position then
                GuiMain.Tabs[info.Name].Position = {.454, 0,.9, 0}
            end
            arrayList = Utility
            Utility.Parent = bedrock
            Items.Size = UDim2.new(1, 0,10.25, 0)
            Utility.Size = UDim2.new(.09, 0,.031, 0)
        end
        if not GuiMain.DefaultPositions[info.Name] then
            GuiMain.DefaultPositions[info.Name] = {info.Name,newTabPos.X.Scale, newTabPos.X.Offset, newTabPos.Y.Scale, newTabPos.Y.Offset}
        end
        if (not GuiMain.Tabs[info.Name].Position) then
            GuiMain.Tabs[info.Name].Position = {newTabPos.X.Scale,newTabPos.X.Offset,newTabPos.Y.Scale,newTabPos.Y.Offset}
        end
        Utility.Position = UDim2.new(GuiMain.Tabs[info.Name].Position[1],GuiMain.Tabs[info.Name].Position[2],GuiMain.Tabs[info.Name].Position[3],GuiMain.Tabs[info.Name].Position[4])
        Utility.Name = info.Name
        Utility.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
        Utility.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Utility.BorderSizePixel = 0
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
        Items.ClipsDescendants = true
        Items.Position = UDim2.new(0, 0, 35, 0)
        Items.Visible = true
        Items.CanvasSize = UDim2.new(0, 0, 0, 0)
        Items.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Items.ScrollBarThickness = 4
        Items.ScrollBarImageTransparency = .15
        Items.ScrollBarImageColor3 = Color3.fromRGB(0,0,0)
    
        UIListLayout.Parent = Items
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        newTabPos += tabAdd
        UIListLayout.Padding = UDim.new(0.005,0)
    
        if Enabled == true then
            Utility.BackgroundColor3 = toggleColors.Enabled
            Items.Position = UDim2.new(0,0,1,0)
        end
    
        Utility.MouseButton1Click:Connect(function()
            Enabled = not Enabled
            GuiMain.Tabs[info.Name].Enabled = Enabled
            if Enabled == true then
                ts:Create(Utility,TweenInfo.new(0.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0),{BackgroundColor3 = toggleColors.Enabled}):Play()
                ts:Create(Items,TweenInfo.new(0.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0),{Position = UDim2.new(0,0,1,0)}):Play()
            else
                ts:Create(Utility,TweenInfo.new(0.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0),{BackgroundColor3 = toggleColors.Disabled}):Play()
                ts:Create(Items,TweenInfo.new(0.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0),{Position = UDim2.new(0,0,35,0)}):Play()
            end
        end)
        drag(Utility)
        game:GetService("RunService").RenderStepped:Connect(function()
            GuiMain.Tabs[info.Name].Position = {Utility.Position.X.Scale, Utility.Position.X.Offset, Utility.Position.Y.Scale, Utility.Position.Y.Offset}
        end)
        function g2:CreateButton(info2)
            local g3 = {}
            local Toggle = Instance.new("Frame")
            local Item = Instance.new("TextButton")
            local Options = Instance.new("ImageButton")
            local UIStroke = Instance.new("UIStroke")
            if (not GuiMain.Tabs[info.Name][info2.Name]) then
                GuiMain.Tabs[info.Name][info2.Name] = {}
                GuiMain.Tabs[info.Name][info2.Name].Keybind = nil
            end
        
            Toggle.Name = info2.Name
            Toggle.Parent = bedrock.Tabs:WaitForChild(info.Name):WaitForChild("Items")
            Toggle.LayoutOrder = getHighestLayoutOrder(info.Name)
            Toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Toggle.BorderSizePixel = 0
            Toggle.Size = UDim2.new(1, 0, 0.08, 0)
        
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
            Options.Size = UDim2.new(0.150000006, 0, 1, 0)
            Options.Image = "http://www.roblox.com/asset/?id=6085182125"

            UIStroke.Name = "UIStroke"
            UIStroke.Parent = Toggle
            UIStroke.Color = strokeColor
            UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            UIStroke.LineJoinMode = Enum.LineJoinMode.Round
            UIStroke.Thickness = 2
            UIStroke.Transparency = 0
        
            GuiMain.GuiOpenableItems[info.Name][info2.Name] = {}
            GuiMain.GuiOpenableItems[info.Name][info2.Name].Keybind = {}
            GuiMain.GuiOpenableItems[info.Name][info2.Name].Keybind.Frame = GuiMain.MakeKeybindGui()
            GuiMain.GuiOpenableItems[info.Name][info2.Name].Keybind.Frame.LayoutOrder = Toggle.LayoutOrder
            GuiMain.GuiOpenableItems[info.Name][info2.Name].Keybind.Set = GuiMain.Tabs[info.Name][info2.Name].Keybind
            GuiMain.GuiOpenableItems[info.Name][info2.Name].Keybind.Frame.Bind.Text = GuiMain.Tabs[info.Name][info2.Name].Keybind or ""
        
            Item.MouseButton1Click:Connect(function()
                task.spawn(function()
                    info2.Function()
                end)
            end)
            Options.MouseButton1Click:Connect(function()
                for i,v in pairs(GuiMain.GuiOpenableItems[info.Name][info2.Name]) do
                    v.Frame.Visible = not v.Frame.Visible
                    v.Frame.Parent = Toggle.Parent
                end
            end)
            uis.InputEnded:Connect(function(input)
                if GuiMain.GuiOpenableItems[info.Name][info2.Name].Keybind.Set ~= nil and GuiMain.Tabs[info.Name][info2.Name].Keybind and input and input.KeyCode and input.KeyCode == Enum.KeyCode[GuiMain.Tabs[info.Name][info2.Name].Keybind] and bedrock and uis:GetFocusedTextBox() == nil then
                    task.spawn(function()
                        info2.Function()
                    end)
                    if buttonNotifications then GuiMain.CreateNotification("Keybind", info2.Name.." has been activated!", 2) end
                end
            end)
            local keybindRunning = false
            local function keybind()
                local keybindtable = GuiMain.GuiOpenableItems[info.Name][info2.Name].Keybind
                local keybind = GuiMain.Tabs[info.Name][info2.Name]
                if not keybindtable then return end
                local frame = keybindtable.Frame
                if not frame then return end
                frame.Bind.Text = "..."
                if keybindRunning == true then
                    frame.Bind.Text = ""
                    keybindtable.Set = nil
                    keybindRunning = false
                    keybind.Keybind = nil
                elseif keybindRunning == false then
                    keybindRunning = true
                    uis.InputEnded:Connect(function(input)
                        if keybindRunning == true and not (input.KeyCode.Name == "Unknown") and uis:GetFocusedTextBox() == nil then
                            keybindRunning = false
                            keybindtable.Set = input.KeyCode.Name
                            frame.Bind.Text = input.KeyCode.Name
                            keybind.Keybind = input.KeyCode.Name
                        else
                            return
                        end
                    end)
                end
            end
            GuiMain.GuiOpenableItems[info.Name][info2.Name].Keybind.Frame.Bind.MouseButton1Click:Connect(keybind)
            GuiMain.GuiOpenableItems[info.Name][info2.Name].Keybind.Frame.ItemName.MouseButton1Click:Connect(keybind)
            function g3:Activate(silent)
                runcode(function()
                    info2.Function()
                    if not silent then GuiMain.CreateNotification("Button", info2.Name.." has been activated!",2) end
                end)
            end
            function g3:CreateSlider(info3)
                local sliderapi = {}
                local Slider = Instance.new("TextButton")
                local SliderBar = Instance.new("TextButton")

                Slider.Name = "Slider"
                Slider.Parent = game.ReplicatedStorage
                Slider.LayoutOrder = Toggle.LayoutOrder
                Slider.BackgroundColor3 = Color3.fromRGB(60,60,60)
                Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Slider.BorderSizePixel = 0
                Slider.Size = UDim2.new(1, 0, 0.07, 0)
                Slider.Visible = false
                Slider.BackgroundTransparency = 1
                Slider.Text = ""

                SliderBar.Name = "SliderBar"
                SliderBar.Parent = Slider
                SliderBar.BackgroundColor3 = Color3.fromRGB(30, 155, 220)
                SliderBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
                SliderBar.BorderSizePixel = 0
                SliderBar.Position = UDim2.new(0, 0, 0, 0)
                SliderBar.Size = UDim2.new(1, 0, 1, 0)
                SliderBar.FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                SliderBar.Text = ""
                SliderBar.TextColor3 = Color3.fromRGB(0, 0, 0)
                SliderBar.TextScaled = true
                SliderBar.TextSize = 14.000
                SliderBar.TextWrapped = true
                local Name = Instance.new("TextLabel")
                local Amount = Instance.new("TextLabel")

                Name.Name = "Name"
                Name.Parent = Slider
                Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Name.BackgroundTransparency = 1.000
                Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Name.BorderSizePixel = 0
                Name.Position = UDim2.new(0.300000012, 0, 0, 0)
                Name.Size = UDim2.new(0.699999988, 0, 1, 0)
                Name.FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                Name.Text = info3.Name
                Name.TextColor3 = Color3.fromRGB(0, 0, 0)
                Name.TextScaled = true
                Name.TextSize = 14.000
                Name.TextWrapped = true

                Amount.Name = "Amount"
                Amount.Parent = Slider
                Amount.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Amount.BackgroundTransparency = 1.000
                Amount.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Amount.BorderSizePixel = 0
                Amount.Position = UDim2.new(0, 0, 0, 0)
                Amount.Size = UDim2.new(0.300000012, 0, 1, 0)
                Amount.FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                if not GuiMain.Sliders[info.Name] or not GuiMain.Sliders[info.Name][info2.Name] or not GuiMain.Sliders[info.Name][info2.Name][info3.Name] or not GuiMain.Sliders[info.Name][info2.Name][info3.Name].Amount then
                    if not GuiMain.Sliders[info.Name] then
                        GuiMain.Sliders[info.Name] = {}
                    end
                    if not GuiMain.Sliders[info.Name][info2.Name] then
                        GuiMain.Sliders[info.Name][info2.Name] = {}
                    end
                    if not GuiMain.Sliders[info.Name][info2.Name][info3.Name] then
                        GuiMain.Sliders[info.Name][info2.Name][info3.Name] = {}
                    end
                    if not GuiMain.Sliders[info.Name][info2.Name][info3.Name].Amount then
                        GuiMain.Sliders[info.Name][info2.Name][info3.Name].Amount = info3.Min
                    end
                end
                if not GuiMain.GuiOpenableItems[info.Name] or not GuiMain.GuiOpenableItems[info.Name][info2.Name] or not GuiMain.GuiOpenableItems[info.Name][info2.Name]["Slider "..info3.Name] or not GuiMain.GuiOpenableItems[info.Name][info2.Name]["Slider "..info3.Name].Frame then
                    if not GuiMain.GuiOpenableItems[info.Name] then
                        GuiMain.GuiOpenableItems[info.Name] = {}
                    end
                    if not GuiMain.GuiOpenableItems[info.Name][info2.Name] then
                        GuiMain.GuiOpenableItems[info.Name][info2.Name] = {}
                    end
                    if not GuiMain.GuiOpenableItems[info.Name][info2.Name]["Slider "..info3.Name] then
                        GuiMain.GuiOpenableItems[info.Name][info2.Name]["Slider "..info3.Name] = {}
                    end
                    if not GuiMain.GuiOpenableItems[info.Name][info2.Name]["Slider "..info3.Name].Frame then
                        GuiMain.GuiOpenableItems[info.Name][info2.Name]["Slider "..info3.Name].Frame = Slider
                    end
                end
                Amount.Text = GuiMain.Sliders[info.Name][info2.Name][info3.Name].Amount.."/"..info3.Max
                Amount.TextColor3 = Color3.fromRGB(0, 0, 0)
                Amount.TextScaled = true
                Amount.TextSize = 14.000
                Amount.TextWrapped = true
                GuiMain.GuiOpenableItems[info.Name][info2.Name]["Slider "..info3.Name].Frame = Slider
                sliderapi.SetValue = function(val)
					sliderapi.Value = val
                    GuiMain.Sliders[info.Name][info2.Name][info3.Name].Amount = sliderapi.Value
					Amount.Text = GuiMain.Sliders[info.Name][info2.Name][info3.Name].Amount.."/"..info3.Max
					info3.Changed(val)
				end
                if GuiMain.Sliders[info.Name][info2.Name][info3.Name].Amount then
                    sliderapi.SetValue(GuiMain.Sliders[info.Name][info2.Name][info3.Name].Amount)
                    SliderBar.Size = UDim2.new((GuiMain.Sliders[info.Name][info2.Name][info3.Name].Amount - info3.Min) / (info3.Max - info3.Min), 0, 1, 0)
                end
                local move
                local kill
                local function slide()
                    local sizeX = math.clamp((uis:GetMouseLocation().X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1)
                    SliderBar.Size = UDim2.new(sizeX, 0, 1, 0)
                    local value = math.floor(((((info3.Max - info3.Min) * sizeX) + info3.Min) * (10 ^ 2)) +0.5)/(10 ^ 2)
					sliderapi.SetValue(value)
					Amount.Text = GuiMain.Sliders[info.Name][info2.Name][info3.Name].Amount.."/"..info3.Max
                    move = uis.InputChanged:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseMovement then 
                            local sizeX = math.clamp((uis:GetMouseLocation().X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, .95)+.05
                            SliderBar.Size = UDim2.new(sizeX, 0, 1, 0)
                            local value = math.floor(((((info3.Max - info3.Min) * sizeX) + info3.Min) * (10 ^ 2)) +0.5)/(10 ^ 2)
                            sliderapi.SetValue(value)
                            Amount.Text = GuiMain.Sliders[info.Name][info2.Name][info3.Name].Amount.."/"..info3.Max
						end
					end)
					kill = uis.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							move:Disconnect()
							kill:Disconnect()
						end
					end)
                end
				Slider.MouseButton1Down:Connect(slide)
                SliderBar.MouseButton1Down:Connect(slide)
            end
            function g3:CreateToggle(info3)
                local Toggle_2 = Instance.new("Frame")
                local Item = Instance.new("TextButton")
                if not GuiMain.Toggles[info.Name] or not GuiMain.Toggles[info.Name][info2.Name] or not GuiMain.Toggles[info.Name][info2.Name][info3.Name] or not GuiMain.Toggles[info.Name][info2.Name][info3.Name].Enabled then
                    if not GuiMain.Toggles[info.Name] then
                        GuiMain.Toggles[info.Name] = {}
                    end
                    if not GuiMain.Toggles[info.Name][info2.Name] then
                        GuiMain.Toggles[info.Name][info2.Name] = {}
                    end
                    if not GuiMain.Toggles[info.Name][info2.Name][info3.Name] then
                        GuiMain.Toggles[info.Name][info2.Name][info3.Name] = {}
                    end
                    if not GuiMain.Toggles[info.Name][info2.Name][info3.Name].Enabled then
                        GuiMain.Toggles[info.Name][info2.Name][info3.Name].Enabled = false
                    end
                end
                if not GuiMain.GuiOpenableItems[info.Name] or not GuiMain.GuiOpenableItems[info.Name][info2.Name] or not GuiMain.GuiOpenableItems[info.Name][info2.Name]["Toggle "..info3.Name] or not GuiMain.GuiOpenableItems[info.Name][info2.Name]["Toggle "..info3.Name].Frame then
                    if not GuiMain.GuiOpenableItems[info.Name] then
                        GuiMain.GuiOpenableItems[info.Name] = {}
                    end
                    if not GuiMain.GuiOpenableItems[info.Name][info2.Name] then
                        GuiMain.GuiOpenableItems[info.Name][info2.Name] = {}
                    end
                    if not GuiMain.GuiOpenableItems[info.Name][info2.Name]["Toggle "..info3.Name] then
                        GuiMain.GuiOpenableItems[info.Name][info2.Name]["Toggle "..info3.Name] = {}
                    end
                    if not GuiMain.GuiOpenableItems[info.Name][info2.Name]["Toggle "..info3.Name].Frame then
                        GuiMain.GuiOpenableItems[info.Name][info2.Name]["Toggle "..info3.Name].Frame = Toggle_2
                    end
                end
                local Enabled = GuiMain.Toggles[info.Name][info2.Name][info3.Name].Enabled
            
                Toggle_2.Name = info2.Name
                Toggle_2.Parent = game.ReplicatedStorage
                Toggle_2.LayoutOrder = Toggle.LayoutOrder
                Toggle_2.BackgroundColor3 = Color3.fromRGB(60,60,60)
                Toggle_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Toggle_2.BorderSizePixel = 0
                Toggle_2.Size = UDim2.new(1, 0, 0.07, 0)
                Toggle_2.Visible = false
            
                Item.Name = "ItemName"
                Item.Parent = Toggle_2
                Item.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Item.BackgroundTransparency = 1.000
                Item.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Item.BorderSizePixel = 0
                Item.LayoutOrder = 1
                Item.Size = UDim2.new(1, 0, 1, 0)
                Item.FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                Item.TextColor3 = Color3.fromRGB(0, 0, 0)
                Item.TextScaled = true
                Item.TextSize = 14.000
                Item.TextWrapped = true
                Item.Text = info3.Name
                if Enabled == true then
                    Toggle_2.BackgroundColor3 = toggleColors_2.Enabled
                    GuiMain.Toggles[info.Name][info2.Name][info3.Name].Enabled = Enabled
                    task.spawn(function()
                        info3.Function(Enabled)
                    end)
                end
                Item.MouseButton1Click:Connect(function()
                    Enabled = not Enabled
                    GuiMain.Toggles[info.Name][info2.Name][info3.Name].Enabled = Enabled
                    if Enabled == true then
                        ts:Create(Toggle_2,TweenInfo.new(.15,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0),{BackgroundColor3 = toggleColors_2.Enabled}):Play()
                    else
                        ts:Create(Toggle_2,TweenInfo.new(.15,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0),{BackgroundColor3 = toggleColors_2.Disabled}):Play()
                    end
                    task.spawn(function()
                        info3.Function(Enabled)
                    end)
                end)
            end
            function g3:CreateDropdown(info3)
                local Dropdown = Instance.new("ScrollingFrame")
                local UIListLayout = Instance.new("UIListLayout")
                local dropdownAPI = {}

                Dropdown.Name = "Dropdown"
                Dropdown.Parent = bedrock
                Dropdown.Active = true
                Dropdown.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                Dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Dropdown.BorderSizePixel = 0
                Dropdown.Position = UDim2.new(0.294161111, 0, 0.274294674, 0)
                Dropdown.Size = UDim2.new(0.100000001, 0, 0.25, 0)
                Dropdown.CanvasSize = UDim2.new(0, 0, 0, 0)
                Dropdown.ScrollBarThickness = 4
                Dropdown.ScrollBarImageTransparency = .15
                Dropdown.Visible = false

                UIListLayout.Parent = Dropdown
                UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout.Padding = UDim.new(0.00499999989, 0)

                local function createOption(clickFunc,name)
                    local Option = Instance.new("TextButton")
                    local UIStroke = Instance.new("UIStroke")
                    Option.Name = "Option"
                    Option.Parent = Dropdown
                    Option.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                    Option.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    Option.BorderSizePixel = 0
                    Option.Size = UDim2.new(1, 0, 0.100000001, 0)
                    Option.FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                    Option.Text = name
                    Option.TextColor3 = Color3.fromRGB(0, 0, 0)
                    Option.TextScaled = true
                    Option.TextSize = 14.000
                    Option.TextWrapped = true 
                    Option.MouseButton1Click:Connect(function()
                        clickFunc(name)
                    end)
                    UIStroke.Name = "UIStroke"
                    UIStroke.Parent = Option
                    UIStroke.Color = strokeColor
                    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    UIStroke.LineJoinMode = Enum.LineJoinMode.Round
                    UIStroke.Thickness = 2
                    UIStroke.Transparency = 0
                end

                local Toggle_2 = Instance.new("Frame")
                local Item = Instance.new("TextButton")
                if not GuiMain.Dropdowns[info.Name] or not GuiMain.Dropdowns[info.Name][info2.Name] or not GuiMain.Dropdowns[info.Name][info2.Name][info3.Name] or not GuiMain.Dropdowns[info.Name][info2.Name][info3.Name].Selected then
                    if not GuiMain.Dropdowns[info.Name] then
                        GuiMain.Dropdowns[info.Name] = {}
                    end
                    if not GuiMain.Dropdowns[info.Name][info2.Name] then
                        GuiMain.Dropdowns[info.Name][info2.Name] = {}
                    end
                    if not GuiMain.Dropdowns[info.Name][info2.Name][info3.Name] then
                        GuiMain.Dropdowns[info.Name][info2.Name][info3.Name] = {}
                    end
                    if not GuiMain.Dropdowns[info.Name][info2.Name][info3.Name].Selected then
                        GuiMain.Dropdowns[info.Name][info2.Name][info3.Name].Selected = info3.Default
                    end
                end
                if not GuiMain.GuiOpenableItems[info.Name] or not GuiMain.GuiOpenableItems[info.Name][info2.Name] or not GuiMain.GuiOpenableItems[info.Name][info2.Name]["Dropdown "..info3.Name] or not GuiMain.GuiOpenableItems[info.Name][info2.Name]["Dropdown "..info3.Name].Frame then
                    if not GuiMain.GuiOpenableItems[info.Name] then
                        GuiMain.GuiOpenableItems[info.Name] = {}
                    end
                    if not GuiMain.GuiOpenableItems[info.Name][info2.Name] then
                        GuiMain.GuiOpenableItems[info.Name][info2.Name] = {}
                    end
                    if not GuiMain.GuiOpenableItems[info.Name][info2.Name]["Dropdown "..info3.Name] then
                        GuiMain.GuiOpenableItems[info.Name][info2.Name]["Dropdown "..info3.Name] = {}
                    end
                    if not GuiMain.GuiOpenableItems[info.Name][info2.Name]["Dropdown "..info3.Name].Frame then
                        GuiMain.GuiOpenableItems[info.Name][info2.Name]["Dropdown "..info3.Name].Frame = Toggle_2
                    end
                end

                dropdownAPI.currentlySelected = GuiMain.Dropdowns[info.Name][info2.Name][info3.Name].Selected
            
                Toggle_2.Name = info2.Name
                Toggle_2.Parent = game.ReplicatedStorage
                Toggle_2.LayoutOrder = Toggle.LayoutOrder
                Toggle_2.BackgroundColor3 = Color3.fromRGB(60,60,60)
                Toggle_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Toggle_2.BorderSizePixel = 0
                Toggle_2.Size = UDim2.new(1, 0, 0.07, 0)
                Toggle_2.Visible = false
            
                Item.Name = "ItemName"
                Item.Parent = Toggle_2
                Item.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Item.BackgroundTransparency = 1.000
                Item.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Item.BorderSizePixel = 0
                Item.LayoutOrder = 1
                Item.Size = UDim2.new(1, 0, 1, 0)
                Item.FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                Item.TextColor3 = Color3.fromRGB(0, 0, 0)
                Item.TextScaled = true
                Item.TextSize = 14.000
                Item.TextWrapped = true
                Item.Text = info3.Name..": "..dropdownAPI.currentlySelected

                local inDropdown = false
                local function clickFunc(selectedOption)
                    Dropdown.Visible = false
                    dropdownAPI.currentlySelected = selectedOption
                    GuiMain.Dropdowns[info.Name][info2.Name][info3.Name].Selected = dropdownAPI.currentlySelected
                    Item.Text = info3.Name..": "..dropdownAPI.currentlySelected
                    inDropdown = not inDropdown
                    task.spawn(function()
                        info3.Function(selectedOption)
                    end)
                    for i,v in pairs(Dropdown:GetChildren()) do
                        if v:IsA("TextButton") then
                            v:Destroy()
                        end
                    end
                end

                local function loadOptions()
                    local options = {}
                    for i,v in pairs(info3.Options) do
                        createOption(clickFunc,v)
                    end
                end

                local connection
                connection = Item.MouseButton1Click:Connect(function()
                    inDropdown = not inDropdown
                    if inDropdown then
                        Dropdown.Position = UDim2.new(0,uis:GetMouseLocation().X,0,uis:GetMouseLocation().Y)
                        Dropdown.Visible = true
                        loadOptions()
                    else
                        Dropdown.Visible = false
                        for i,v in pairs(Dropdown:GetChildren()) do
                            if v:IsA("TextButton") then
                                v:Destroy()
                            end
                        end
                    end
                end)
            end
            return g3
        end
        function g2:CreateToggle(info2)
            local g3 = {}
            local Toggle = Instance.new("Frame")
            local Item = Instance.new("TextButton")
            local Options = Instance.new("ImageButton")
            local UIStroke = Instance.new("UIStroke")
            if (not GuiMain.Tabs[info.Name][info2.Name]) then
                GuiMain.Tabs[info.Name][info2.Name] = {}
                GuiMain.Tabs[info.Name][info2.Name].Enabled = false
                GuiMain.Tabs[info.Name][info2.Name].Keybind = nil
            end
            local Enabled = GuiMain.Tabs[info.Name][info2.Name].Enabled
        
            Toggle.Name = info2.Name
            Toggle.Parent = bedrock.Tabs:WaitForChild(info.Name):WaitForChild("Items")
            Toggle.LayoutOrder = getHighestLayoutOrder(info.Name)
            Toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Toggle.BorderSizePixel = 0
            Toggle.Size = UDim2.new(1, 0, 0.08, 0)
        
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
            Options.Size = UDim2.new(0.150000006, 0, 1, 0)
            Options.Image = "http://www.roblox.com/asset/?id=6085182125"

            UIStroke.Name = "UIStroke"
            UIStroke.Parent = Toggle
            UIStroke.Color = strokeColor
            UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            UIStroke.LineJoinMode = Enum.LineJoinMode.Round
            UIStroke.Thickness = 2
            UIStroke.Transparency = 0
        
            GuiMain.GuiOpenableItems[info.Name][info2.Name] = {}
            GuiMain.GuiOpenableItems[info.Name][info2.Name].Keybind = {}
            GuiMain.GuiOpenableItems[info.Name][info2.Name].Keybind.Frame = GuiMain.MakeKeybindGui()
            GuiMain.GuiOpenableItems[info.Name][info2.Name].Keybind.Frame.LayoutOrder = Toggle.LayoutOrder
            GuiMain.GuiOpenableItems[info.Name][info2.Name].Keybind.Set = GuiMain.Tabs[info.Name][info2.Name].Keybind
            GuiMain.GuiOpenableItems[info.Name][info2.Name].Keybind.Frame.Bind.Text = GuiMain.Tabs[info.Name][info2.Name].Keybind or ""
        
            if Enabled == true then
                Toggle.BackgroundColor3 = toggleColors.Enabled
                task.spawn(function()
                    runcode(function()
                        if not arrayList then
                            repeat task.wait() until arrayList
                        end
                        local Item = Instance.new("TextLabel",arrayList:WaitForChild("Items"))
                        Item.Name = Toggle.Name
                        Item.BackgroundTransparency = 1.000
                        Item.BorderColor3 = Color3.fromRGB(0, 0, 0)
                        Item.BorderSizePixel = 0
                        Item.Size = UDim2.new(1, 0, 0.100000001, 0)
                        Item.FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                        Item.TextColor3 = Color3.fromRGB(0, 0, 0)
                        Item.TextScaled = true
                        Item.TextSize = 14.000
                        Item.TextWrapped = true
                        Item.Text = Toggle.Name
                        Item.LayoutOrder = -#Item.Text
                    end)
                    info2.Function(Enabled)
                end)
            end
        
            Item.MouseButton1Click:Connect(function()
                Enabled = not Enabled
                GuiMain.Tabs[info.Name][info2.Name].Enabled = Enabled
                if Enabled == true then
                    ts:Create(Toggle,TweenInfo.new(.15,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0),{BackgroundColor3 = toggleColors.Enabled}):Play()
                else
                    ts:Create(Toggle,TweenInfo.new(.15,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0),{BackgroundColor3 = toggleColors.Disabled}):Play()
                end
                task.spawn(function()
                    runcode(function()
                        if not arrayList then
                            repeat task.wait() until arrayList
                        end
                        if arrayList and Enabled then
                            local Item = Instance.new("TextLabel",arrayList:WaitForChild("Items"))
                            Item.Name = Toggle.Name
                            Item.BackgroundTransparency = 1.000
                            Item.BorderColor3 = Color3.fromRGB(0, 0, 0)
                            Item.BorderSizePixel = 0
                            Item.Size = UDim2.new(1, 0, 0.100000001, 0)
                            Item.FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                            Item.TextColor3 = Color3.fromRGB(0, 0, 0)
                            Item.TextScaled = true
                            Item.TextSize = 14.000
                            Item.TextWrapped = true
                            Item.Text = Toggle.Name
                            Item.LayoutOrder = -#Item.Text
                        elseif arrayList and not Enabled then
                            if arrayList.Items:FindFirstChild(Toggle.Name) then
                                arrayList.Items[Toggle.Name]:Destroy()
                            end
                        end
                    end)
                    info2.Function(Enabled)
                end)
            end)
            Options.MouseButton1Click:Connect(function()
                for i,v in pairs(GuiMain.GuiOpenableItems[info.Name][info2.Name]) do
                    v.Frame.Visible = not v.Frame.Visible
                    v.Frame.Parent = Toggle.Parent
                end
            end)
            uis.InputEnded:Connect(function(input)
                if GuiMain.GuiOpenableItems[info.Name][info2.Name].Keybind.Set ~= nil and GuiMain.Tabs[info.Name][info2.Name].Keybind ~= nil and input and input.KeyCode and input.KeyCode == Enum.KeyCode[GuiMain.Tabs[info.Name][info2.Name].Keybind] and bedrock and uis:GetFocusedTextBox() == nil then
                    Enabled = not Enabled
                    GuiMain.Tabs[info.Name][info2.Name].Enabled = Enabled
                    if Enabled == true then
                        ts:Create(Toggle,TweenInfo.new(.15,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0),{BackgroundColor3 = toggleColors.Enabled}):Play()
                    else
                        ts:Create(Toggle,TweenInfo.new(.15,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0),{BackgroundColor3 = toggleColors.Disabled}):Play()
                    end
                    task.spawn(function()
                        runcode(function()
                            if not arrayList then
                                repeat task.wait() until arrayList
                            end
                            if arrayList and Enabled then
                                local Item = Instance.new("TextLabel",arrayList:WaitForChild("Items"))
                                Item.Name = Toggle.Name
                                Item.BackgroundTransparency = 1.000
                                Item.BorderColor3 = Color3.fromRGB(0, 0, 0)
                                Item.BorderSizePixel = 0
                                Item.Size = UDim2.new(1, 0, 0.100000001, 0)
                                Item.FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                                Item.TextColor3 = Color3.fromRGB(0, 0, 0)
                                Item.TextScaled = true
                                Item.TextSize = 14.000
                                Item.TextWrapped = true
                                Item.Text = Toggle.Name
                                Item.LayoutOrder = -#Item.Text
                            elseif arrayList and not Enabled then
                                if arrayList.Items:FindFirstChild(Toggle.Name) then
                                    arrayList.Items[Toggle.Name]:Destroy()
                                end
                            end
                        end)
                        info2.Function(Enabled)
                    end)
                    if toggleNotifications then GuiMain.CreateNotification("Keybind",info2.Name.." has been toggled! Activated: "..tostring(Enabled), 2) end
                end
            end)
            local keybindRunning = false
            local function keybind()
                local keybindtable = GuiMain.GuiOpenableItems[info.Name][info2.Name].Keybind
                local keybind = GuiMain.Tabs[info.Name][info2.Name]
                if not keybindtable then return end
                local frame = keybindtable.Frame
                if not frame then return end
                frame.Bind.Text = "..."
                if keybindRunning == true then
                    frame.Bind.Text = ""
                    keybindtable.Set = nil
                    keybindRunning = false
                    keybind.Keybind = nil
                elseif keybindRunning == false then
                    keybindRunning = true
                    uis.InputEnded:Connect(function(input)
                        if keybindRunning == true and not (input.KeyCode.Name == "Unknown") and uis:GetFocusedTextBox() == nil then
                            keybindRunning = false
                            keybindtable.Set = input.KeyCode.Name
                            frame.Bind.Text = input.KeyCode.Name
                            keybind.Keybind = input.KeyCode.Name
                        else
                            return
                        end
                    end)
                end
            end
            GuiMain.GuiOpenableItems[info.Name][info2.Name].Keybind.Frame.Bind.MouseButton1Click:Connect(keybind)
            GuiMain.GuiOpenableItems[info.Name][info2.Name].Keybind.Frame.ItemName.MouseButton1Click:Connect(keybind)
            local doneDisconnect = false
            rs.RenderStepped:Connect(function()
                if shared.Disconnect == true and Enabled and doneDisconnect == false then
                    doneDisconnect = true
                    task.spawn(function()
                        info2.Function(false)
                    end)
                end
                if doneDisconnect == true then
                    return
                end
            end)
            function g3:Toggle(tf,silent)
                runcode(function()
                    if Enabled ~= tf then
                        Enabled = tf
                        if Enabled == true then
                            Toggle.BackgroundColor3 = toggleColors.Enabled
                        else
                            Toggle.BackgroundColor3 = toggleColors.Disabled
                        end
                        info2.Function(tf)
                        if not silent then GuiMain.CreateNotification("Toggle", info2.Name.." has been toggled! Activated: "..tostring(tf),2) end
                        if arrayList and Enabled then
                            local Item = Instance.new("TextLabel",arrayList:WaitForChild("Items"))
                            Item.Name = Toggle.Name
                            Item.BackgroundTransparency = 1.000
                            Item.BorderColor3 = Color3.fromRGB(0, 0, 0)
                            Item.BorderSizePixel = 0
                            Item.Size = UDim2.new(1, 0, 0.100000001, 0)
                            Item.FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                            Item.TextColor3 = Color3.fromRGB(0, 0, 0)
                            Item.TextScaled = true
                            Item.TextSize = 14.000
                            Item.TextWrapped = true
                            Item.Text = Toggle.Name
                            Item.LayoutOrder = -#Item.Text
                        elseif arrayList and not Enabled then
                            if arrayList.Items:FindFirstChild(Toggle.Name) then
                                arrayList.Items[Toggle.Name]:Destroy()
                            end
                        end
                    end
                end)
            end
            function g3:CreateSlider(info3)
                local sliderapi = {}
                local Slider = Instance.new("TextButton")
                local SliderBar = Instance.new("TextButton")

                Slider.Name = "Slider"
                Slider.Parent = game.ReplicatedStorage
                Slider.LayoutOrder = Toggle.LayoutOrder
                Slider.BackgroundColor3 = Color3.fromRGB(60,60,60)
                Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Slider.BorderSizePixel = 0
                Slider.Size = UDim2.new(1, 0, 0.07, 0)
                Slider.Visible = false
                Slider.BackgroundTransparency = 1
                Slider.Text = ""

                SliderBar.Name = "SliderBar"
                SliderBar.Parent = Slider
                SliderBar.BackgroundColor3 = Color3.fromRGB(30, 155, 220)
                SliderBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
                SliderBar.BorderSizePixel = 0
                SliderBar.Position = UDim2.new(0, 0, 0, 0)
                SliderBar.Size = UDim2.new(1, 0, 1, 0)
                SliderBar.FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                SliderBar.Text = ""
                SliderBar.TextColor3 = Color3.fromRGB(0, 0, 0)
                SliderBar.TextScaled = true
                SliderBar.TextSize = 14.000
                SliderBar.TextWrapped = true
                local Name = Instance.new("TextLabel")
                local Amount = Instance.new("TextLabel")

                Name.Name = "Name"
                Name.Parent = Slider
                Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Name.BackgroundTransparency = 1.000
                Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Name.BorderSizePixel = 0
                Name.Position = UDim2.new(0.300000012, 0, 0, 0)
                Name.Size = UDim2.new(0.699999988, 0, 1, 0)
                Name.FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                Name.Text = info3.Name
                Name.TextColor3 = Color3.fromRGB(0, 0, 0)
                Name.TextScaled = true
                Name.TextSize = 14.000
                Name.TextWrapped = true

                Amount.Name = "Amount"
                Amount.Parent = Slider
                Amount.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Amount.BackgroundTransparency = 1.000
                Amount.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Amount.BorderSizePixel = 0
                Amount.Position = UDim2.new(0, 0, 0, 0)
                Amount.Size = UDim2.new(0.300000012, 0, 1, 0)
                Amount.FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                if not GuiMain.Sliders[info.Name] or not GuiMain.Sliders[info.Name][info2.Name] or not GuiMain.Sliders[info.Name][info2.Name][info3.Name] or not GuiMain.Sliders[info.Name][info2.Name][info3.Name].Amount then
                    if not GuiMain.Sliders[info.Name] then
                        GuiMain.Sliders[info.Name] = {}
                    end
                    if not GuiMain.Sliders[info.Name][info2.Name] then
                        GuiMain.Sliders[info.Name][info2.Name] = {}
                    end
                    if not GuiMain.Sliders[info.Name][info2.Name][info3.Name] then
                        GuiMain.Sliders[info.Name][info2.Name][info3.Name] = {}
                    end
                    if not GuiMain.Sliders[info.Name][info2.Name][info3.Name].Amount then
                        GuiMain.Sliders[info.Name][info2.Name][info3.Name].Amount = info3.Min
                    end
                end
                if not GuiMain.GuiOpenableItems[info.Name] or not GuiMain.GuiOpenableItems[info.Name][info2.Name] or not GuiMain.GuiOpenableItems[info.Name][info2.Name]["Slider "..info3.Name] or not GuiMain.GuiOpenableItems[info.Name][info2.Name]["Slider "..info3.Name].Frame then
                    if not GuiMain.GuiOpenableItems[info.Name] then
                        GuiMain.GuiOpenableItems[info.Name] = {}
                    end
                    if not GuiMain.GuiOpenableItems[info.Name][info2.Name] then
                        GuiMain.GuiOpenableItems[info.Name][info2.Name] = {}
                    end
                    if not GuiMain.GuiOpenableItems[info.Name][info2.Name]["Slider "..info3.Name] then
                        GuiMain.GuiOpenableItems[info.Name][info2.Name]["Slider "..info3.Name] = {}
                    end
                    if not GuiMain.GuiOpenableItems[info.Name][info2.Name]["Slider "..info3.Name].Frame then
                        GuiMain.GuiOpenableItems[info.Name][info2.Name]["Slider "..info3.Name].Frame = Slider
                    end
                end
                Amount.Text = GuiMain.Sliders[info.Name][info2.Name][info3.Name].Amount.."/"..info3.Max
                Amount.TextColor3 = Color3.fromRGB(0, 0, 0)
                Amount.TextScaled = true
                Amount.TextSize = 14.000
                Amount.TextWrapped = true
                GuiMain.GuiOpenableItems[info.Name][info2.Name]["Slider "..info3.Name].Frame = Slider
                sliderapi.SetValue = function(val)
					sliderapi.Value = val
                    GuiMain.Sliders[info.Name][info2.Name][info3.Name].Amount = sliderapi.Value
					Amount.Text = GuiMain.Sliders[info.Name][info2.Name][info3.Name].Amount.."/"..info3.Max
					info3.Changed(val)
				end
                if GuiMain.Sliders[info.Name][info2.Name][info3.Name].Amount then
                    sliderapi.SetValue(GuiMain.Sliders[info.Name][info2.Name][info3.Name].Amount)
                    SliderBar.Size = UDim2.new((GuiMain.Sliders[info.Name][info2.Name][info3.Name].Amount - info3.Min) / (info3.Max - info3.Min), 0, 1, 0)
                end
                local move
                local kill
                local function slide()
                    local sizeX = math.clamp((uis:GetMouseLocation().X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1)
                    SliderBar.Size = UDim2.new(sizeX, 0, 1, 0)
                    local value = math.floor(((((info3.Max - info3.Min) * sizeX) + info3.Min) * (10 ^ 2)) +0.5)/(10 ^ 2)
					sliderapi.SetValue(value)
					Amount.Text = GuiMain.Sliders[info.Name][info2.Name][info3.Name].Amount.."/"..info3.Max
                    move = uis.InputChanged:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseMovement then 
                            local sizeX = math.clamp((uis:GetMouseLocation().X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, .95)+.05
                            SliderBar.Size = UDim2.new(sizeX, 0, 1, 0)
                            local value = math.floor(((((info3.Max - info3.Min) * sizeX) + info3.Min) * (10 ^ 2)) +0.5)/(10 ^ 2)
                            sliderapi.SetValue(value)
                            Amount.Text = GuiMain.Sliders[info.Name][info2.Name][info3.Name].Amount.."/"..info3.Max
						end
					end)
					kill = uis.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							move:Disconnect()
							kill:Disconnect()
						end
					end)
                end
				Slider.MouseButton1Down:Connect(slide)
                SliderBar.MouseButton1Down:Connect(slide)
            end
            function g3:CreateToggle(info3)
                local Toggle_2 = Instance.new("Frame")
                local Item = Instance.new("TextButton")
                if not GuiMain.Toggles[info.Name] or not GuiMain.Toggles[info.Name][info2.Name] or not GuiMain.Toggles[info.Name][info2.Name][info3.Name] or not GuiMain.Toggles[info.Name][info2.Name][info3.Name].Enabled then
                    if not GuiMain.Toggles[info.Name] then
                        GuiMain.Toggles[info.Name] = {}
                    end
                    if not GuiMain.Toggles[info.Name][info2.Name] then
                        GuiMain.Toggles[info.Name][info2.Name] = {}
                    end
                    if not GuiMain.Toggles[info.Name][info2.Name][info3.Name] then
                        GuiMain.Toggles[info.Name][info2.Name][info3.Name] = {}
                    end
                    if not GuiMain.Toggles[info.Name][info2.Name][info3.Name].Enabled then
                        GuiMain.Toggles[info.Name][info2.Name][info3.Name].Enabled = false
                    end
                end
                if not GuiMain.GuiOpenableItems[info.Name] or not GuiMain.GuiOpenableItems[info.Name][info2.Name] or not GuiMain.GuiOpenableItems[info.Name][info2.Name]["Toggle "..info3.Name] or not GuiMain.GuiOpenableItems[info.Name][info2.Name]["Toggle "..info3.Nameame].Frame then
                    if not GuiMain.GuiOpenableItems[info.Name] then
                        GuiMain.GuiOpenableItems[info.Name] = {}
                    end
                    if not GuiMain.GuiOpenableItems[info.Name][info2.Name] then
                        GuiMain.GuiOpenableItems[info.Name][info2.Name] = {}
                    end
                    if not GuiMain.GuiOpenableItems[info.Name][info2.Name]["Toggle "..info3.Name] then
                        GuiMain.GuiOpenableItems[info.Name][info2.Name]["Toggle "..info3.Name] = {}
                    end
                    if not GuiMain.GuiOpenableItems[info.Name][info2.Name]["Toggle "..info3.Name].Frame then
                        GuiMain.GuiOpenableItems[info.Name][info2.Name]["Toggle "..info3.Name].Frame = Toggle_2
                    end
                end
                local Enabled = GuiMain.Toggles[info.Name][info2.Name][info3.Name].Enabled
            
                Toggle_2.Name = info2.Name
                Toggle_2.Parent = game.ReplicatedStorage
                Toggle_2.LayoutOrder = Toggle.LayoutOrder
                Toggle_2.BackgroundColor3 = Color3.fromRGB(60,60,60)
                Toggle_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Toggle_2.BorderSizePixel = 0
                Toggle_2.Size = UDim2.new(1, 0, 0.07, 0)
                Toggle_2.Visible = false
            
                Item.Name = "ItemName"
                Item.Parent = Toggle_2
                Item.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Item.BackgroundTransparency = 1.000
                Item.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Item.BorderSizePixel = 0
                Item.LayoutOrder = 1
                Item.Size = UDim2.new(1, 0, 1, 0)
                Item.FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                Item.TextColor3 = Color3.fromRGB(0, 0, 0)
                Item.TextScaled = true
                Item.TextSize = 14.000
                Item.TextWrapped = true
                Item.Text = info3.Name
                if Enabled == true then
                    Toggle_2.BackgroundColor3 = toggleColors_2.Enabled
                    GuiMain.Toggles[info.Name][info2.Name][info3.Name].Enabled = Enabled
                    task.spawn(function()
                        info3.Function(Enabled)
                    end)
                end
                Item.MouseButton1Click:Connect(function()
                    Enabled = not Enabled
                    GuiMain.Toggles[info.Name][info2.Name][info3.Name].Enabled = Enabled
                    if Enabled == true then
                        ts:Create(Toggle_2,TweenInfo.new(.15,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0),{BackgroundColor3 = toggleColors_2.Enabled}):Play()
                    else
                        ts:Create(Toggle_2,TweenInfo.new(.15,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0),{BackgroundColor3 = toggleColors_2.Disabled}):Play()
                    end
                    task.spawn(function()
                        info3.Function(Enabled)
                    end)
                end)
            end
            function g3:CreateDropdown(info3)
                local Dropdown = Instance.new("ScrollingFrame")
                local UIListLayout = Instance.new("UIListLayout")
                local dropdownAPI = {}

                Dropdown.Name = "Dropdown"
                Dropdown.Parent = bedrock
                Dropdown.Active = true
                Dropdown.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                Dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Dropdown.BorderSizePixel = 0
                Dropdown.Position = UDim2.new(0.294161111, 0, 0.274294674, 0)
                Dropdown.Size = UDim2.new(0.100000001, 0, 0.25, 0)
                Dropdown.CanvasSize = UDim2.new(0, 0, 0, 0)
                Dropdown.ScrollBarThickness = 4
                Dropdown.ScrollBarImageTransparency = .15
                Dropdown.Visible = false

                UIListLayout.Parent = Dropdown
                UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout.Padding = UDim.new(0.00499999989, 0)

                local function createOption(clickFunc,name)
                    local Option = Instance.new("TextButton")
                    local UIStroke = Instance.new("UIStroke")
                    Option.Name = "Option"
                    Option.Parent = Dropdown
                    Option.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                    Option.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    Option.BorderSizePixel = 0
                    Option.Size = UDim2.new(1, 0, 0.100000001, 0)
                    Option.FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                    Option.Text = name
                    Option.TextColor3 = Color3.fromRGB(0, 0, 0)
                    Option.TextScaled = true
                    Option.TextSize = 14.000
                    Option.TextWrapped = true 
                    Option.MouseButton1Click:Connect(function()
                        clickFunc(name)
                    end)
                    UIStroke.Name = "UIStroke"
                    UIStroke.Parent = Option
                    UIStroke.Color = strokeColor
                    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    UIStroke.LineJoinMode = Enum.LineJoinMode.Round
                    UIStroke.Thickness = 2
                    UIStroke.Transparency = 0
                end

                local Toggle_2 = Instance.new("Frame")
                local Item = Instance.new("TextButton")
                if not GuiMain.Dropdowns[info.Name] or not GuiMain.Dropdowns[info.Name][info2.Name] or not GuiMain.Dropdowns[info.Name][info2.Name][info3.Name] or not GuiMain.Dropdowns[info.Name][info2.Name][info3.Name].Selected then
                    if not GuiMain.Dropdowns[info.Name] then
                        GuiMain.Dropdowns[info.Name] = {}
                    end
                    if not GuiMain.Dropdowns[info.Name][info2.Name] then
                        GuiMain.Dropdowns[info.Name][info2.Name] = {}
                    end
                    if not GuiMain.Dropdowns[info.Name][info2.Name][info3.Name] then
                        GuiMain.Dropdowns[info.Name][info2.Name][info3.Name] = {}
                    end
                    if not GuiMain.Dropdowns[info.Name][info2.Name][info3.Name].Selected then
                        GuiMain.Dropdowns[info.Name][info2.Name][info3.Name].Selected = info3.Default
                    end
                end
                if not GuiMain.GuiOpenableItems[info.Name] or not GuiMain.GuiOpenableItems[info.Name][info2.Name] or not GuiMain.GuiOpenableItems[info.Name][info2.Name]["Dropdown "..info3.Name] or not GuiMain.GuiOpenableItems[info.Name][info2.Name]["Dropdown "..info3.Name].Frame then
                    if not GuiMain.GuiOpenableItems[info.Name] then
                        GuiMain.GuiOpenableItems[info.Name] = {}
                    end
                    if not GuiMain.GuiOpenableItems[info.Name][info2.Name] then
                        GuiMain.GuiOpenableItems[info.Name][info2.Name] = {}
                    end
                    if not GuiMain.GuiOpenableItems[info.Name][info2.Name]["Dropdown "..info3.Name] then
                        GuiMain.GuiOpenableItems[info.Name][info2.Name]["Dropdown "..info3.Name] = {}
                    end
                    if not GuiMain.GuiOpenableItems[info.Name][info2.Name]["Dropdown "..info3.Name].Frame then
                        GuiMain.GuiOpenableItems[info.Name][info2.Name]["Dropdown "..info3.Name].Frame = Toggle_2
                    end
                end

                dropdownAPI.currentlySelected = GuiMain.Dropdowns[info.Name][info2.Name][info3.Name].Selected
                info3.Function(dropdownAPI.currentlySelected)
            
                Toggle_2.Name = info2.Name
                Toggle_2.Parent = game.ReplicatedStorage
                Toggle_2.LayoutOrder = Toggle.LayoutOrder
                Toggle_2.BackgroundColor3 = Color3.fromRGB(60,60,60)
                Toggle_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Toggle_2.BorderSizePixel = 0
                Toggle_2.Size = UDim2.new(1, 0, 0.07, 0)
                Toggle_2.Visible = false
            
                Item.Name = "ItemName"
                Item.Parent = Toggle_2
                Item.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Item.BackgroundTransparency = 1.000
                Item.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Item.BorderSizePixel = 0
                Item.LayoutOrder = 1
                Item.Size = UDim2.new(1, 0, 1, 0)
                Item.FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                Item.TextColor3 = Color3.fromRGB(0, 0, 0)
                Item.TextScaled = true
                Item.TextSize = 14.000
                Item.TextWrapped = true
                Item.Text = info3.Name..": "..dropdownAPI.currentlySelected

                local inDropdown = false
                local function clickFunc(selectedOption)
                    Dropdown.Visible = false
                    dropdownAPI.currentlySelected = selectedOption
                    GuiMain.Dropdowns[info.Name][info2.Name][info3.Name].Selected = dropdownAPI.currentlySelected
                    Item.Text = info3.Name..": "..dropdownAPI.currentlySelected
                    inDropdown = not inDropdown
                    task.spawn(function()
                        info3.Function(selectedOption)
                    end)
                    for i,v in pairs(Dropdown:GetChildren()) do
                        if v:IsA("TextButton") then
                            v:Destroy()
                        end
                    end
                end

                local function loadOptions()
                    local options = {}
                    for i,v in pairs(info3.Options) do
                        createOption(clickFunc,v)
                    end
                end

                local connection
                connection = Item.MouseButton1Click:Connect(function()
                    inDropdown = not inDropdown
                    if inDropdown then
                        Dropdown.Position = UDim2.new(0,uis:GetMouseLocation().X,0,uis:GetMouseLocation().Y)
                        Dropdown.Visible = true
                        loadOptions()
                    else
                        Dropdown.Visible = false
                        for i,v in pairs(Dropdown:GetChildren()) do
                            if v:IsA("TextButton") then
                                v:Destroy()
                            end
                        end
                    end
                end)
            end
            return g3
        end
        return g2
    end
    return g
end
function GuiMain.MakeKeybindGui()
    local Keybind = Instance.new("Frame")
    local ItemName = Instance.new("TextButton")
    local Bind = Instance.new("TextButton")

    Keybind.Name = "Keybind"
    Keybind.Parent = game:GetService("ReplicatedStorage")
    Keybind.BackgroundColor3 = Color3.fromRGB(60,60,60)
    Keybind.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Keybind.BorderSizePixel = 0
    Keybind.Size = UDim2.new(1, 0, 0.07, 0)
    Keybind.Visible = false
    Keybind.BackgroundTransparency = 1

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
        task.wait(.25)
        Notification:Destroy()
    end)
end
return GuiMain
