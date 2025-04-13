local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Library = {
    Theme = {
        Primary = Color3.fromRGB(32, 33, 36),
        Secondary = Color3.fromRGB(48, 49, 54),
        Accent = Color3.fromRGB(86, 98, 246),
        Text = Color3.fromRGB(235, 235, 235),
        SubText = Color3.fromRGB(165, 165, 165),
        Success = Color3.fromRGB(72, 199, 142),
        Warning = Color3.fromRGB(255, 184, 57),
        Error = Color3.fromRGB(239, 68, 68),
        Hover = Color3.fromRGB(55, 57, 63),
        Selected = Color3.fromRGB(65, 67, 73),
        Border = Color3.fromRGB(70, 70, 70),
        Placeholder = Color3.fromRGB(120, 120, 120)
    },
    Font = {
        Regular = Enum.Font.GothamMedium,
        Bold = Enum.Font.GothamBold,
        SemiBold = Enum.Font.GothamSemibold,
        Light = Enum.Font.GothamLight
    },
    Animation = {
        TweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart),
        SpringInfo = {damping = 10, frequency = 4, speed = 15}
    },
    Flags = {},
    Elements = {},
    Connections = {},
    Size = UDim2.new(0, 550, 0, 345)
}

local Utils = {}

function Utils.IsMobile()
    return UserInputService.TouchEnabled and not UserInputService.MouseEnabled
end

function Utils.CreateTween(object, properties)
    return TweenService:Create(object, Library.Animation.TweenInfo, properties)
end

function Utils.Ripple(button)
    local ripple = Instance.new("Frame")
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.8
    ripple.BorderSizePixel = 0
    ripple.ZIndex = button.ZIndex + 1
    ripple.Parent = button
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    return function(input)
        spawn(function()
            local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 1.5
            local pos = input.Position
            local buttonPos = button.AbsolutePosition
            
            ripple.Size = UDim2.new(0, 0, 0, 0)
            ripple.Position = UDim2.new(0, pos.X - buttonPos.X, 0, pos.Y - buttonPos.Y)
            
            local tween = Utils.CreateTween(ripple, {
                Size = UDim2.new(0, size, 0, size),
                Position = UDim2.new(0.5, -size/2, 0.5, -size/2),
                BackgroundTransparency = 1
            })
            
            tween:Play()
            tween.Completed:Wait()
            ripple:Destroy()
        end)
    end
end

function Utils.Create(className, properties)
    local instance = Instance.new(className)
    for k, v in pairs(properties) do
        if k ~= "Parent" then instance[k] = v end
    end
    if properties.Parent then instance.Parent = properties.Parent end
    return instance
end

local Components = {}

function Components.CreateButton(config)
    local button = Utils.Create("TextButton", {
        Name = "Button",
        BackgroundColor3 = Library.Theme.Secondary,
        Size = UDim2.new(1, -20, 0, 32),
        Font = Library.Font.Regular,
        Text = config.Name,
        TextColor3 = Library.Theme.Text,
        TextSize = 14,
        AutoButtonColor = false
    })
    
    Utils.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = button
    })
    
    local ripple = Utils.Ripple(button)
    
    button.MouseButton1Click:Connect(function()
        ripple(UserInputService:GetMouseLocation())
        if config.Callback then config.Callback() end
    end)
    
    button.MouseEnter:Connect(function()
        Utils.CreateTween(button, {BackgroundColor3 = Library.Theme.Hover}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        Utils.CreateTween(button, {BackgroundColor3 = Library.Theme.Secondary}):Play()
    end)
    
    return button
end

function Components.CreateToggle(config)
    local toggle = Utils.Create("Frame", {
        Name = "Toggle",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 32)
    })
    
    local title = Utils.Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 42, 0, 0),
        Size = UDim2.new(1, -42, 1, 0),
        Font = Library.Font.Regular,
        Text = config.Name,
        TextColor3 = Library.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = toggle
    })
    
    local toggleButton = Utils.Create("Frame", {
        Name = "ToggleButton",
        BackgroundColor3 = Library.Theme.Secondary,
        Position = UDim2.new(0, 0, 0.5, -10),
        Size = UDim2.new(0, 32, 0, 20),
        Parent = toggle
    })
    
    Utils.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = toggleButton
    })
    
    local indicator = Utils.Create("Frame", {
        Name = "Indicator",
        BackgroundColor3 = Library.Theme.Text,
        Position = UDim2.new(0, 2, 0.5, -8),
        Size = UDim2.new(0, 16, 0, 16),
        Parent = toggleButton
    })
    
    Utils.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = indicator
    })
    
    local enabled = config.Default or false
    
    local function updateToggle()
        Utils.CreateTween(toggleButton, {
            BackgroundColor3 = enabled and Library.Theme.Accent or Library.Theme.Secondary
        }):Play()
        
        Utils.CreateTween(indicator, {
            Position = enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        }):Play()
        
        if config.Callback then config.Callback(enabled) end
    end
    
    updateToggle()
    
    toggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            enabled = not enabled
            updateToggle()
        end
    end)
    
    return toggle
end

function Components.CreateSlider(config)
    local slider = Utils.Create("Frame", {
        Name = "Slider",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 50)
    })
    
    local title = Utils.Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -50, 0, 20),
        Font = Library.Font.Regular,
        Text = config.Name,
        TextColor3 = Library.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = slider
    })
    
    local value = Utils.Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -50, 0, 0),
        Size = UDim2.new(0, 50, 0, 20),
        Font = Library.Font.Regular,
        Text = tostring(config.Default or config.Min),
        TextColor3 = Library.Theme.SubText,
        TextSize = 14,
        Parent = slider
    })
    
    local sliderBar = Utils.Create("Frame", {
        Name = "SliderBar",
        BackgroundColor3 = Library.Theme.Secondary,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(1, 0, 0, 4),
        Parent = slider
    })
    
    local fill = Utils.Create("Frame", {
        Name = "Fill",
        BackgroundColor3 = Library.Theme.Accent,
        Size = UDim2.new(0, 0, 1, 0),
        Parent = sliderBar
    })
    
    Utils.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = sliderBar
    })
    
    Utils.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = fill
    })
    
    local knob = Utils.Create("Frame", {
        Name = "Knob",
        BackgroundColor3 = Library.Theme.Accent,
        Position = UDim2.new(0, -6, 0.5, -6),
        Size = UDim2.new(0, 12, 0, 12),
        ZIndex = 2,
        Parent = fill
    })
    
    Utils.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = knob
    })
    
    local min, max = config.Min or 0, config.Max or 100
    local default = math.clamp(config.Default or min, min, max)
    local dragging = false
    
    local function update(input)
        local pos = input.Position.X
        local relative = math.clamp((pos - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
        local result = math.floor(min + (max - min) * relative)
        
        value.Text = tostring(result)
        fill.Size = UDim2.new(relative, 0, 1, 0)
        
        if config.Callback then config.Callback(result) end
    end
    
    local connection
    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            connection = RunService.RenderStepped:Connect(function()
                update(UserInputService:GetMouseLocation())
            end)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
            dragging = false
            if connection then connection:Disconnect() end
        end
    end)
    
    local relative = (default - min) / (max - min)
    fill.Size = UDim2.new(relative, 0, 1, 0)
    value.Text = tostring(default)
    
    return slider
end

function Components.CreateDropdown(config)
    local dropdown = Utils.Create("Frame", {
        Name = "Dropdown",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 32)
    })
    
    local button = Utils.Create("TextButton", {
        BackgroundColor3 = Library.Theme.Secondary,
        Size = UDim2.new(1, 0, 0, 32),
        Font = Library.Font.Regular,
        Text = config.Name,
        TextColor3 = Library.Theme.Text,
        TextSize = 14,
        Parent = dropdown
    })
    
    Utils.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = button
    })
    
    local arrow = Utils.Create("ImageLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -26, 0.5, -8),
        Size = UDim2.new(0, 16, 0, 16),
        Image = "rbxassetid://6034818372",
        ImageColor3 = Library.Theme.SubText,
        Parent = button
    })
    
    local list = Utils.Create("Frame", {
        Name = "List",
        BackgroundColor3 = Library.Theme.Secondary,
        Position = UDim2.new(0, 0, 1, 5),
        Size = UDim2.new(1, 0, 0, 0),
        ClipsDescendants = true,
        Visible = false,
        ZIndex = 2,
        Parent = button
    })
    
    Utils.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = list
    })
    
    local layout = Utils.Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        Parent = list
    })
    
    local open = false
    local selected = config.Default
    
    local function toggle()
        open = not open
        
        Utils.CreateTween(arrow, {
            Rotation = open and 180 or 0
        }):Play()
        
        if open then
            list.Visible = true
            Utils.CreateTween(list, {
                Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y + 10)
            }):Play()
        else
            Utils.CreateTween(list, {
                Size = UDim2.new(1, 0, 0, 0)
            }):Play()
            task.wait(0.3)
            list.Visible = false
        end
    end
    
    button.MouseButton1Click:Connect(toggle)
    
    for _, option in ipairs(config.Options) do
        local optionButton = Utils.Create("TextButton", {
            BackgroundColor3 = Library.Theme.Hover,
            Size = UDim2.new(1, -10, 0, 30),
            Position = UDim2.new(0, 5, 0, 5),
            Font = Library.Font.Regular,
            Text = option,
            TextColor3 = selected == option and Library.Theme.Accent or Library.Theme.Text,
            TextSize = 14,
            ZIndex = 2,
            Parent = list
        })
        
        Utils.Create("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = optionButton
        })
        
        optionButton.MouseButton1Click:Connect(function()
            selected = option
            button.Text = config.Name .. ": " .. option
            
            if config.Callback then config.Callback(option) end
            
            toggle()
        end)
    end
    
    if selected then
        button.Text = config.Name .. ": " .. selected
    end
    
    return dropdown
end

function Library.Create(config)
    local UI = {}
    UI.Tabs = {}
    
    local LinuxUI = Utils.Create("ScreenGui", {
        Name = "LinuxUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    if syn and syn.protect_gui then
        syn.protect_gui(LinuxUI)
        LinuxUI.Parent = CoreGui
    elseif gethui then
        LinuxUI.Parent = gethui()
    else
        LinuxUI.Parent = CoreGui
    end
    
    local Main = Utils.Create("Frame", {
        Name = "Main",
        BackgroundColor3 = Library.Theme.Primary,
        Position = UDim2.new(0.5, -275, 0.5, -172),
        Size = Library.Size,
        Parent = LinuxUI
    })
    
    Utils.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = Main
    })
    
    local Header = Utils.Create("Frame", {
        Name = "Header",
        BackgroundColor3 = Library.Theme.Secondary,
        Size = UDim2.new(1, 0, 0, 40),
        Parent = Main
    })
    
    Utils.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = Header
    })
    
    local Title = Utils.Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -30, 1, 0),
        Font = Library.Font.Bold,
        Text = config.Name,
        TextColor3 = Library.Theme.Text,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Header
    })
    
    local Subtitle = Utils.Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 1, -18),
        Size = UDim2.new(1, -30, 0, 15),
        Font = Library.Font.Regular,
        Text = config.Subtitle,
        TextColor3 = Library.Theme.SubText,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Header
    })
    
    local Content = Utils.Create("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 45),
        Size = UDim2.new(1, 0, 1, -45),
        Parent = Main
    })
    
    local TabButtons = Utils.Create("Frame", {
        Name = "TabButtons",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, config.TabWidth or 125, 1, 0),
        Parent = Content
    })
    
    local TabButtonLayout = Utils.Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        Parent = TabButtons
    })
    
    local TabContent = Utils.Create("Frame", {
        Name = "TabContent",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, config.TabWidth or 125, 0, 0),
        Size = UDim2.new(1, -(config.TabWidth or 125), 1, 0),
        Parent = Content
    })
    
    function UI.Tab(tabConfig)
        local tab = {}
        
        local button = Utils.Create("TextButton", {
            Name = "TabButton",
            BackgroundColor3 = Library.Theme.Secondary,
            Size = UDim2.new(1, -10, 0, 32),
            Position = UDim2.new(0, 5, 0, 5),
            Font = Library.Font.Regular,
            Text = tabConfig.Name,
            TextColor3 = Library.Theme.Text,
            TextSize = 14,
            Parent = TabButtons
        })
        
        Utils.Create("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = button
        })
        
        if tabConfig.Icon and tabConfig.Icon.Enabled then
            local icon = Utils.Create("ImageLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 8, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16),
                Image = tabConfig.Icon.Image,
                Parent = button
            })
            button.Text = "    " .. tabConfig.Name
        end
        
        local container = Utils.Create("ScrollingFrame", {
            Name = "Container",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 5, 0, 5),
            Size = UDim2.new(1, -10, 1, -10),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Library.Theme.Accent,
            Visible = false,
            Parent = TabContent
        })
        
        Utils.Create("UIListLayout", {
            Padding = UDim.new(0, 5),
            Parent = container
        })
        
        function tab.Section(sectionConfig)
            local section = Utils.Create("Frame", {
                Name = "Section",
                BackgroundColor3 = Library.Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 32),
                Parent = container
            })
            
            Utils.Create("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = section
            })
            
            Utils.Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(1, -30, 1, 0),
                Font = Library.Font.SemiBold,
                Text = sectionConfig.Name,
                TextColor3 = Library.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = section
            })
            
            return section
        end
        
        function tab.Button(config)
            return Components.CreateButton(config)
        end
        
        function tab.Toggle(config)
            return Components.CreateToggle(config)
        end
        
        function tab.Slider(config)
            return Components.CreateSlider(config)
        end
        
        function tab.Dropdown(config)
            return Components.CreateDropdown(config)
        end
        
        return tab
    end
    
    function UI:Notify(notifyConfig)
        local notification = Utils.Create("Frame", {
            Name = "Notification",
            BackgroundColor3 = Library.Theme.Secondary,
            Position = UDim2.new(1, 20, 1, -90),
            Size = UDim2.new(0, 300, 0, 80),
            Parent = LinuxUI
        })
        
        Utils.Create("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = notification
        })
        
        Utils.Create("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 10),
            Size = UDim2.new(1, -30, 0, 20),
            Font = Library.Font.Bold,
            Text = notifyConfig.Title,
            TextColor3 = Library.Theme.Text,
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = notification
        })
        
        Utils.Create("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 35),
            Size = UDim2.new(1, -30, 0, 35),
            Font = Library.Font.Regular,
            Text = notifyConfig.Content,
            TextColor3 = Library.Theme.SubText,
            TextSize = 14,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = notification
        })
        
        Utils.CreateTween(notification, {
            Position = UDim2.new(1, -320, 1, -90)
        }):Play()
        
        task.delay(notifyConfig.Duration or 3, function()
            local hideTween = Utils.CreateTween(notification, {
                Position = UDim2.new(1, 20, 1, -90)
            })
            hideTween:Play()
            hideTween.Completed:Wait()
            notification:Destroy()
        end)
    end
    
    return UI
end

return Library
