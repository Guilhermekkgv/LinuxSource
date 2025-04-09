local TweenService = game:GetService("TweenService")
local InputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Linux = {
    Theme = {
        Background = Color3.fromRGB(20, 20, 25),
        Element = Color3.fromRGB(30, 30, 35),
        Accent = Color3.fromRGB(255, 85, 85),
        Text = Color3.fromRGB(200, 200, 200),
        Toggle = Color3.fromRGB(45, 45, 50),
        TabInactive = Color3.fromRGB(25, 25, 30),
        DropdownOption = Color3.fromRGB(35, 35, 40),
        Shadow = Color3.fromRGB(0, 0, 0),
        GradientStart = Color3.fromRGB(25, 25, 30),
        GradientEnd = Color3.fromRGB(20, 20, 25)
    }
}

function Linux.Instance(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    return inst
end

function Linux:SafeCallback(Function, ...)
    if not Function then return end
    local Success, Error = pcall(Function, ...)
    if not Success then
        self:Notify({
            Title = "Callback Error",
            Content = tostring(Error),
            Duration = 5
        })
    end
end

function Linux:Notify(config)
    local isMobile = InputService.TouchEnabled and not InputService.KeyboardEnabled
    local notificationWidth = isMobile and 250 or 350
    local notificationHeight = config.SubContent and 90 or 70
    local startPosX = isMobile and 15 or 25

    local NotificationHolder = Linux.Instance("ScreenGui", {
        Name = "NotificationHolder",
        Parent = RunService:IsStudio() and LocalPlayer.PlayerGui or game:GetService("CoreGui"),
        ResetOnSpawn = false,
        Enabled = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    local Notification = Linux.Instance("Frame", {
        Parent = NotificationHolder,
        BackgroundColor3 = Linux.Theme.Element,
        Size = UDim2.new(0, notificationWidth, 0, notificationHeight),
        Position = UDim2.new(1, 10, 1, -notificationHeight - 15),
        ZIndex = 100,
        BorderSizePixel = 0
    })

    Linux.Instance("UICorner", {Parent = Notification, CornerRadius = UDim.new(0, 8)})
    Linux.Instance("UIStroke", {Parent = Notification, Color = Linux.Theme.Accent, Thickness = 1, Transparency = 0.8})
    Linux.Instance("UIGradient", {Parent = Notification, Color = ColorSequence.new(Linux.Theme.GradientStart, Linux.Theme.GradientEnd)})

    local Shadow = Linux.Instance("ImageLabel", {
        Parent = Notification,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 20, 1, 20),
        Position = UDim2.new(0, -10, 0, -10),
        Image = "rbxassetid://1316045217",
        ImageColor3 = Linux.Theme.Shadow,
        ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118),
        ZIndex = 99
    })

    Linux.Instance("TextLabel", {
        Parent = Notification,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 10, 0, 10),
        Font = Enum.Font.GothamBold,
        Text = config.Title or "Notification",
        TextColor3 = Linux.Theme.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 101
    })

    Linux.Instance("TextLabel", {
        Parent = Notification,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 10, 0, 35),
        Font = Enum.Font.Gotham,
        Text = config.Content or "Content",
        TextColor3 = Linux.Theme.Text,
        TextSize = 14,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 101
    })

    if config.SubContent then
        Linux.Instance("TextLabel", {
            Parent = Notification,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 0, 20),
            Position = UDim2.new(0, 10, 0, 55),
            Font = Enum.Font.Gotham,
            Text = config.SubContent,
            TextColor3 = Color3.fromRGB(160, 160, 160),
            TextSize = 12,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 101
        })
    end

    local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    TweenService:Create(Notification, tweenInfo, {Position = UDim2.new(0, startPosX, 1, -notificationHeight - 15)}):Play()

    if config.Duration then
        task.delay(config.Duration, function()
            TweenService:Create(Notification, tweenInfo, {Position = UDim2.new(1, 10, 1, -notificationHeight - 15)}):Play()
            task.wait(0.6)
            NotificationHolder:Destroy()
        end)
    end
end

function Linux.Create(config)
    local randomName = "UI_" .. tostring(math.random(100000, 999999))

    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name:match("^UI_%d+$") then
            v:Destroy()
        end
    end

    local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end

    local LinuxUI = Linux.Instance("ScreenGui", {
        Name = randomName,
        Parent = RunService:IsStudio() and LocalPlayer.PlayerGui or game:GetService("CoreGui"),
        ResetOnSpawn = false,
        Enabled = true
    })

    ProtectGui(LinuxUI)

    local FakeUI = Instance.new("ScreenGui", game:GetService("CoreGui"))
    FakeUI.Name = "FakeUI"
    FakeUI.Enabled = false
    FakeUI.ResetOnSpawn = false

    local tabWidth = config.TabWidth or 130
    local isMobile = InputService.TouchEnabled and not InputService.KeyboardEnabled
    local uiSize = isMobile and (config.SizeMobile or UDim2.fromOffset(320, 520)) or (config.SizePC or UDim2.fromOffset(600, 400))

    local Main = Linux.Instance("Frame", {
        Parent = LinuxUI,
        BackgroundColor3 = Linux.Theme.Background,
        Size = uiSize,
        Position = UDim2.new(0.5, -uiSize.X.Offset / 2, 0.5, -uiSize.Y.Offset / 2),
        Active = true,
        Draggable = true,
        ZIndex = 1,
        BorderSizePixel = 0
    })

    Linux.Instance("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 10)})
    Linux.Instance("UIGradient", {Parent = Main, Color = ColorSequence.new(Linux.Theme.GradientStart, Linux.Theme.GradientEnd)})
    Linux.Instance("UIStroke", {Parent = Main, Color = Linux.Theme.Accent, Thickness = 1, Transparency = 0.9})

    local Shadow = Linux.Instance("ImageLabel", {
        Parent = Main,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 30, 1, 30),
        Position = UDim2.new(0, -15, 0, -15),
        Image = "rbxassetid://1316045217",
        ImageColor3 = Linux.Theme.Shadow,
        ImageTransparency = 0.7,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118),
        ZIndex = 0
    })

    local TopBar = Linux.Instance("Frame", {
        Parent = Main,
        BackgroundColor3 = Linux.Theme.Background,
        Size = UDim2.new(1, 0, 0, 30),
        ZIndex = 2,
        BorderSizePixel = 0
    })

    Linux.Instance("UICorner", {Parent = TopBar, CornerRadius = UDim.new(0, 10)})
    Linux.Instance("UIGradient", {Parent = TopBar, Color = ColorSequence.new(Linux.Theme.GradientStart, Linux.Theme.GradientEnd)})

    local TitleLabel = Linux.Instance("TextLabel", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Font = Enum.Font.GothamBold,
        Text = config.Name or "Linux UI",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutomaticSize = Enum.AutomaticSize.X,
        ZIndex = 2
    })

    local SubtitleLabel = Linux.Instance("TextLabel", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        Position = UDim2.new(0, 10 + TitleLabel.TextBounds.X + 5, 0, 0),
        Font = Enum.Font.Gotham,
        Text = config.Subtitle or "v1.0",
        TextColor3 = Linux.Theme.Accent,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutomaticSize = Enum.AutomaticSize.X,
        ZIndex = 2
    })

    local MinimizeButton = Linux.Instance("TextButton", {
        Parent = TopBar,
        BackgroundColor3 = Linux.Theme.Element,
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -60, 0, 3),
        ZIndex = 3,
        AutoButtonColor = false
    })

    Linux.Instance("UICorner", {Parent = MinimizeButton, CornerRadius = UDim.new(0, 6)})
    Linux.Instance("UIStroke", {Parent = MinimizeButton, Color = Linux.Theme.Accent, Thickness = 1, Transparency = 0.9})

    local MinimizeIcon = Linux.Instance("ImageLabel", {
        Parent = MinimizeButton,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0.5, -8, 0.5, -8),
        Image = "rbxassetid://10734895698",
        ImageColor3 = Linux.Theme.Text,
        ZIndex = 3
    })

    local CloseButton = Linux.Instance("TextButton", {
        Parent = TopBar,
        BackgroundColor3 = Linux.Theme.Element,
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -30, 0, 3),
        ZIndex = 3,
        AutoButtonColor = false
    })

    Linux.Instance("UICorner", {Parent = CloseButton, CornerRadius = UDim.new(0, 6)})
    Linux.Instance("UIStroke", {Parent = CloseButton, Color = Linux.Theme.Accent, Thickness = 1, Transparency = 0.9})

    Linux.Instance("ImageLabel", {
        Parent = CloseButton,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0.5, -8, 0.5, -8),
        Image = "rbxassetid://10747384394",
        ImageColor3 = Linux.Theme.Text,
        ZIndex = 3
    })

    local TabsBar = Linux.Instance("Frame", {
        Parent = Main,
        BackgroundColor3 = Linux.Theme.Background,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(0, tabWidth, 1, -30),
        ZIndex = 2,
        BorderSizePixel = 0
    })

    Linux.Instance("UICorner", {Parent = TabsBar, CornerRadius = UDim.new(0, 8)})
    Linux.Instance("UIGradient", {Parent = TabsBar, Color = ColorSequence.new(Linux.Theme.GradientStart, Linux.Theme.GradientEnd)})

    local TabHolder = Linux.Instance("ScrollingFrame", {
        Parent = TabsBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 0,
        ZIndex = 2,
        BorderSizePixel = 0
    })

    Linux.Instance("UIListLayout", {
        Parent = TabHolder,
        Padding = UDim.new(0, 5),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    Linux.Instance("UIPadding", {
        Parent = TabHolder,
        PaddingLeft = UDim.new(0, 5),
        PaddingTop = UDim.new(0, 10)
    })

    local Content = Linux.Instance("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, tabWidth, 0, 30),
        Size = UDim2.new(1, -tabWidth, 1, -30),
        ZIndex = 1,
        BorderSizePixel = 0
    })

    local isMinimized = false
    local originalSize = Main.Size
    local originalPos = Main.Position
    local isHidden = false

    MinimizeButton.MouseButton1Click:Connect(function()
        local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        if not isMinimized then
            TweenService:Create(Main, tweenInfo, {Size = UDim2.new(0, 220, 0, 30), Position = UDim2.new(0.5, -110, 0, 10)}):Play()
            TabsBar.Visible = false
            Content.Visible = false
            MinimizeIcon.Image = "rbxassetid://10734886735"
            isMinimized = true
        else
            TweenService:Create(Main, tweenInfo, {Size = originalSize, Position = originalPos}):Play()
            TabsBar.Visible = true
            Content.Visible = true
            MinimizeIcon.Image = "rbxassetid://10734895698"
            isMinimized = false
        end
    end)

    CloseButton.MouseButton1Click:Connect(function()
        LinuxUI:Destroy()
        FakeUI:Destroy()
    end)

    InputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.LeftAlt then
            isHidden = not isHidden
            Main.Visible = not isHidden
        end
    end)

    local LinuxLib = {}
    local Tabs = {}
    local CurrentTab = nil
    local tabOrder = 0

    function LinuxLib.Tab(config)
        tabOrder = tabOrder + 1
        local tabIndex = tabOrder

        local TabBtn = Linux.Instance("TextButton", {
            Parent = TabHolder,
            BackgroundColor3 = Linux.Theme.TabInactive,
            Size = UDim2.new(1, -10, 0, 35),
            Font = Enum.Font.Gotham,
            Text = "",
            TextColor3 = Linux.Theme.Text,
            TextSize = 14,
            ZIndex = 2,
            AutoButtonColor = false,
            LayoutOrder = tabIndex
        })

        Linux.Instance("UICorner", {Parent = TabBtn, CornerRadius = UDim.new(0, 6)})
        Linux.Instance("UIStroke", {Parent = TabBtn, Color = Linux.Theme.Accent, Thickness = 1, Transparency = 0.9})

        local TabIcon
        if config.Icon and config.Icon.Enabled then
            TabIcon = Linux.Instance("ImageLabel", {
                Parent = TabBtn,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0, 10, 0.5, -10),
                Image = config.Icon.Image or "rbxassetid://10747384394",
                ImageColor3 = Linux.Theme.Text,
                ZIndex = 2
            })
        end

        local TabText = Linux.Instance("TextLabel", {
            Parent = TabBtn,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, config.Icon and config.Icon.Enabled and -40 or -20, 1, 0),
            Position = UDim2.new(0, config.Icon and config.Icon.Enabled and 35 or 10, 0, 0),
            Font = Enum.Font.Gotham,
            Text = config.Name,
            TextColor3 = Color3.fromRGB(160, 160, 160),
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 2
        })

        local TabContent = Linux.Instance("ScrollingFrame", {
            Parent = Content,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 0,
            Visible = false,
            ZIndex = 1,
            BorderSizePixel = 0
        })

        local TitleFrame = Linux.Instance("Frame", {
            Parent = Content,
            BackgroundColor3 = Linux.Theme.Background,
            Size = UDim2.new(1, -10, 0, 40),
            Position = UDim2.new(0, 5, 0, 0),
            Visible = false,
            ZIndex = 3,
            BorderSizePixel = 0
        })

        Linux.Instance("UICorner", {Parent = TitleFrame, CornerRadius = UDim.new(0, 8)})
        Linux.Instance("UIGradient", {Parent = TitleFrame, Color = ColorSequence.new(Linux.Theme.GradientStart, Linux.Theme.GradientEnd)})

        local TitleLabel = Linux.Instance("TextLabel", {
            Parent = TitleFrame,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -10, 1, 0),
            Position = UDim2.new(0, 5, 0, 0),
            Font = Enum.Font.GothamBold,
            Text = config.Name,
            TextColor3 = Linux.Theme.Text,
            TextSize = 24,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            ZIndex = 4
        })

        local ElementContainer = Linux.Instance("Frame", {
            Parent = TabContent,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, -40),
            Position = UDim2.new(0, 0, 0, 40),
            ZIndex = 1,
            BorderSizePixel = 0
        })

        Linux.Instance("UIListLayout", {
            Parent = ElementContainer,
            Padding = UDim.new(0, 6),
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        Linux.Instance("UIPadding", {
            Parent = ElementContainer,
            PaddingLeft = UDim.new(0, 10),
            PaddingTop = UDim.new(0, 10)
        })

        local function SelectTab()
            for _, tab in pairs(Tabs) do
                tab.Content.Visible = false
                tab.TitleFrame.Visible = false
                tab.Button.BackgroundColor3 = Linux.Theme.TabInactive
                tab.Text.TextColor3 = Color3.fromRGB(160, 160, 160)
            end
            TabContent.Visible = true
            TitleFrame.Visible = true
            TabBtn.BackgroundColor3 = Linux.Theme.Element
            TabText.TextColor3 = Linux.Theme.Accent
            CurrentTab = tabIndex
        end

        TabBtn.MouseButton1Click:Connect(SelectTab)

        Tabs[tabIndex] = {
            Name = config.Name,
            Button = TabBtn,
            Text = TabText,
            Icon = TabIcon,
            Content = TabContent,
            TitleFrame = TitleFrame
        }

        if tabOrder == 1 then
            SelectTab()
        end

        local TabElements = {}
        local elementOrder = 0

        function TabElements.Button(config)
            elementOrder = elementOrder + 1
            local BtnFrame = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Accent,
                Size = UDim2.new(1, -10, 0, 35),
                ZIndex = 1,
                LayoutOrder = elementOrder,
                BorderSizePixel = 0
            })

            Linux.Instance("UICorner", {Parent = BtnFrame, CornerRadius = UDim.new(0, 6)})
            Linux.Instance("UIStroke", {Parent = BtnFrame, Color = Linux.Theme.Accent, Thickness = 1, Transparency = 0.8})

            local Btn = Linux.Instance("TextButton", {
                Parent = BtnFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.Gotham,
                Text = config.Name,
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1,
                AutoButtonColor = false
            })

            Linux.Instance("UIPadding", {Parent = Btn, PaddingLeft = UDim.new(0, 10)})

            Linux.Instance("ImageLabel", {
                Parent = BtnFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(1, -25, 0.5, -8),
                Image = "rbxassetid://10709791437",
                ImageColor3 = Linux.Theme.Text,
                ZIndex = 1
            })

            Btn.MouseButton1Click:Connect(function()
                spawn(function() Linux:SafeCallback(config.Callback) end)
            end)

            return Btn
        end

        function TabElements.Toggle(config)
            elementOrder = elementOrder + 1
            local Toggle = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -10, 0, 35),
                ZIndex = 1,
                LayoutOrder = elementOrder,
                BorderSizePixel = 0
            })

            Linux.Instance("UICorner", {Parent = Toggle, CornerRadius = UDim.new(0, 6)})
            Linux.Instance("UIStroke", {Parent = Toggle, Color = Linux.Theme.Accent, Thickness = 1, Transparency = 0.9})

            Linux.Instance("TextLabel", {
                Parent = Toggle,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.8, 0, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                Font = Enum.Font.Gotham,
                Text = config.Name,
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1
            })

            local ToggleBox = Linux.Instance("Frame", {
                Parent = Toggle,
                BackgroundColor3 = Linux.Theme.Toggle,
                Size = UDim2.new(0, 45, 0, 20),
                Position = UDim2.new(1, -55, 0.5, -10),
                ZIndex = 1,
                BorderSizePixel = 0
            })

            Linux.Instance("UICorner", {Parent = ToggleBox, CornerRadius = UDim.new(1, 0)})
            Linux.Instance("UIStroke", {Parent = ToggleBox, Color = Linux.Theme.Accent, Thickness = 1, Transparency = 0.9})

            local ToggleFill = Linux.Instance("Frame", {
                Parent = ToggleBox,
                BackgroundColor3 = Linux.Theme.Toggle,
                Size = UDim2.new(0, 0, 1, 0),
                ZIndex = 1,
                BorderSizePixel = 0
            })

            Linux.Instance("UICorner", {Parent = ToggleFill, CornerRadius = UDim.new(1, 0)})

            local Knob = Linux.Instance("Frame", {
                Parent = ToggleBox,
                BackgroundColor3 = Color3.fromRGB(180, 180, 180),
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(0, 2, 0, 1),
                ZIndex = 2,
                BorderSizePixel = 0
            })

            Linux.Instance("UICorner", {Parent = Knob, CornerRadius = UDim.new(1, 0)})

            local State = config.Default or false

            local function UpdateToggle()
                local tween = TweenInfo.new(0.3, Enum.EasingStyle.Quint)
                if State then
                    TweenService:Create(ToggleFill, tween, {BackgroundColor3 = Linux.Theme.Accent, Size = UDim2.new(1, 0, 1, 0)}):Play()
                    TweenService:Create(Knob, tween, {Position = UDim2.new(1, -20, 0, 1), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                else
                    TweenService:Create(ToggleFill, tween, {BackgroundColor3 = Linux.Theme.Toggle, Size = UDim2.new(0, 0, 1, 0)}):Play()
                    TweenService:Create(Knob, tween, {Position = UDim2.new(0, 2, 0, 1), BackgroundColor3 = Color3.fromRGB(180, 180, 180)}):Play()
                end
            end

            UpdateToggle()

            Toggle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    State = not State
                    UpdateToggle()
                    spawn(function() Linux:SafeCallback(config.Callback, State) end)
                end
            end)

            return Toggle
        end

        function TabElements.Dropdown(config)
            elementOrder = elementOrder + 1
            local Dropdown = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -10, 0, 35),
                ZIndex = 2,
                LayoutOrder = elementOrder,
                BorderSizePixel = 0
            })

            Linux.Instance("UICorner", {Parent = Dropdown, CornerRadius = UDim.new(0, 6)})
            Linux.Instance("UIStroke", {Parent = Dropdown, Color = Linux.Theme.Accent, Thickness = 1, Transparency = 0.9})

            Linux.Instance("TextLabel", {
                Parent = Dropdown,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.8, 0, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                Font = Enum.Font.Gotham,
                Text = config.Name,
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 2
            })

            local Selected = Linux.Instance("TextLabel", {
                Parent = Dropdown,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -50, 1, 0),
                Font = Enum.Font.Gotham,
                Text = config.Default or (config.Options and config.Options[1]) or "None",
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 2
            })

            local Arrow = Linux.Instance("ImageLabel", {
                Parent = Dropdown,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(1, -25, 0.5, -8),
                Image = "rbxassetid://10709767827",
                ImageColor3 = Linux.Theme.Text,
                ZIndex = 2
            })

            local DropFrame = Linux.Instance("ScrollingFrame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -10, 0, 0),
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 0,
                ClipsDescendants = true,
                ZIndex = 3,
                LayoutOrder = elementOrder + 1,
                BorderSizePixel = 0
            })

            Linux.Instance("UICorner", {Parent = DropFrame, CornerRadius = UDim.new(0, 6)})
            Linux.Instance("UIStroke", {Parent = DropFrame, Color = Linux.Theme.Accent, Thickness = 1, Transparency = 0.9})

            Linux.Instance("UIListLayout", {
                Parent = DropFrame,
                Padding = UDim.new(0, 4),
                HorizontalAlignment = Enum.HorizontalAlignment.Left
            })

            Linux.Instance("UIPadding", {
                Parent = DropFrame,
                PaddingLeft = UDim.new(0, 5),
                PaddingTop = UDim.new(0, 5)
            })

            local Options = config.Options or {}
            local IsOpen = false
            local SelectedValue = config.Default or (Options[1] or "None")

            local function UpdateDropSize()
                local optionHeight = 30
                local paddingBetween = 4
                local paddingTop = 5
                local maxHeight = 160
                local numOptions = #Options
                local calculatedHeight = numOptions * optionHeight + (numOptions - 1) * paddingBetween + paddingTop
                local finalHeight = math.min(calculatedHeight, maxHeight)
                if finalHeight < 0 then finalHeight = 0 end

                local tween = TweenInfo.new(0.3, Enum.EasingStyle.Quint)
                if IsOpen then
                    TweenService:Create(DropFrame, tween, {Size = UDim2.new(1, -10, 0, finalHeight)}):Play()
                    TweenService:Create(Arrow, tween, {Rotation = 180}):Play()
                else
                    TweenService:Create(DropFrame, tween, {Size = UDim2.new(1, -10, 0, 0)}):Play()
                    TweenService:Create(Arrow, tween, {Rotation = 0}):Play()
                end
                task.wait(0.3)
                TabContent.CanvasSize = UDim2.new(0, 0, 0, ElementContainer.AbsoluteSize.Y + ElementContainer:GetChildren()[1].AbsoluteContentSize.Y)
            end

            local function PopulateOptions()
                for _, child in pairs(DropFrame:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                if IsOpen then
                    for _, opt in pairs(Options) do
                        local OptBtn = Linux.Instance("TextButton", {
                            Parent = DropFrame,
                            BackgroundColor3 = Linux.Theme.DropdownOption,
                            Size = UDim2.new(1, -5, 0, 30),
                            Font = Enum.Font.Gotham,
                            Text = tostring(opt),
                            TextColor3 = opt == SelectedValue and Linux.Theme.Accent or Linux.Theme.Text,
                            TextSize = 14,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            ZIndex = 3,
                            AutoButtonColor = false
                        })

                        Linux.Instance("UICorner", {Parent = OptBtn, CornerRadius = UDim.new(0, 6)})
                        Linux.Instance("UIPadding", {Parent = OptBtn, PaddingLeft = UDim.new(0, 5)})

                        OptBtn.MouseButton1Click:Connect(function()
                            SelectedValue = opt
                            Selected.Text = tostring(opt)
                            for _, btn in pairs(DropFrame:GetChildren()) do
                                if btn:IsA("TextButton") then
                                    btn.TextColor3 = btn.Text == tostring(opt) and Linux.Theme.Accent or Linux.Theme.Text
                                end
                            end
                            spawn(function() Linux:SafeCallback(config.Callback, opt) end)
                        end
                    end
                end
                UpdateDropSize()
            end

            if #Options > 0 then
                PopulateOptions()
            end

            Dropdown.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    IsOpen = not IsOpen
                    PopulateOptions()
                end
            end)

            local function SetOptions(newOptions)
                Options = newOptions or {}
                SelectedValue = config.Default or (Options[1] or "None")
                Selected.Text = tostring(SelectedValue)
                PopulateOptions()
            end

            local function SetValue(value)
                if table.find(Options, value) then
                    SelectedValue = value
                    Selected.Text = tostring(value)
                    for _, btn in pairs(DropFrame:GetChildren()) do
                        if btn:IsA("TextButton") then
                            btn.TextColor3 = btn.Text == tostring(value) and Linux.Theme.Accent or Linux.Theme.Text
                        end
                    end
                    spawn(function() Linux:SafeCallback(config.Callback, value) end)
                end
            end

            return {
                Instance = Dropdown,
                SetOptions = SetOptions,
                SetValue = SetValue,
                GetValue = function() return SelectedValue end
            }
        end

        function TabElements.MultiDropdown(config)
            elementOrder = elementOrder + 1
            local MultiDropdown = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -10, 0, 35),
                ZIndex = 2,
                LayoutOrder = elementOrder,
                BorderSizePixel = 0
            })

            Linux.Instance("UICorner", {Parent = MultiDropdown, CornerRadius = UDim.new(0, 6)})
            Linux.Instance("UIStroke", {Parent = MultiDropdown, Color = Linux.Theme.Accent, Thickness = 1, Transparency = 0.9})

            Linux.Instance("TextLabel", {
                Parent = MultiDropdown,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.8, 0, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                Font = Enum.Font.Gotham,
                Text = config.Name,
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 2
            })

            local Selected = Linux.Instance("TextLabel", {
                Parent = MultiDropdown,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -50, 1, 0),
                Font = Enum.Font.Gotham,
                Text = config.Default and table.concat(config.Default, ", ") or "None",
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 2
            })

            local Arrow = Linux.Instance("ImageLabel", {
                Parent = MultiDropdown,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(1, -25, 0.5, -8),
                Image = "rbxassetid://10709767827",
                ImageColor3 = Linux.Theme.Text,
                ZIndex = 2
            })

            local DropFrame = Linux.Instance("ScrollingFrame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -10, 0, 0),
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 0,
                ClipsDescendants = true,
                ZIndex = 3,
                LayoutOrder = elementOrder + 1,
                BorderSizePixel = 0
            })

            Linux.Instance("UICorner", {Parent = DropFrame, CornerRadius = UDim.new(0, 6)})
            Linux.Instance("UIStroke", {Parent = DropFrame, Color = Linux.Theme.Accent, Thickness = 1, Transparency = 0.9})

            Linux.Instance("UIListLayout", {
                Parent = DropFrame,
                Padding = UDim.new(0, 4),
                HorizontalAlignment = Enum.HorizontalAlignment.Left
            })

            Linux.Instance("UIPadding", {
                Parent = DropFrame,
                PaddingLeft = UDim.new(0, 5),
                PaddingTop = UDim.new(0, 5)
            })

            local Options = config.Options or {}
            local IsOpen = false
            local SelectedValues = config.Default or {}

            local function UpdateDropSize()
                local optionHeight = 30
                local paddingBetween = 4
                local paddingTop = 5
                local maxHeight = 160
                local numOptions = #Options
                local calculatedHeight = numOptions * optionHeight + (numOptions - 1) * paddingBetween + paddingTop
                local finalHeight = math.min(calculatedHeight, maxHeight)
                if finalHeight < 0 then finalHeight = 0 end

                local tween = TweenInfo.new(0.3, Enum.EasingStyle.Quint)
                if IsOpen then
                    TweenService:Create(DropFrame, tween, {Size = UDim2.new(1, -10, 0, finalHeight)}):Play()
                    TweenService:Create(Arrow, tween, {Rotation = 180}):Play()
                else
                    TweenService:Create(DropFrame, tween, {Size = UDim2.new(1, -10, 0, 0)}):Play()
                    TweenService:Create(Arrow, tween, {Rotation = 0}):Play()
                end
                task.wait(0.3)
                TabContent.CanvasSize = UDim2.new(0, 0, 0, ElementContainer.AbsoluteSize.Y + ElementContainer:GetChildren()[1].AbsoluteContentSize.Y)
            end

            local function UpdateSelectedText()
                if #SelectedValues > 0 then
                    Selected.Text = table.concat(SelectedValues, ", ")
                else
                    Selected.Text = "None"
                end
            end

            local function PopulateOptions()
                for _, child in pairs(DropFrame:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                if IsOpen then
                    for _, opt in pairs(Options) do
                        local OptBtn = Linux.Instance("TextButton", {
                            Parent = DropFrame,
                            BackgroundColor3 = Linux.Theme.DropdownOption,
                            Size = UDim2.new(1, -5, 0, 30),
                            Font = Enum.Font.Gotham,
                            Text = tostring(opt),
                            TextColor3 = table.find(SelectedValues, opt) and Linux.Theme.Accent or Linux.Theme.Text,
                            TextSize = 14,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            ZIndex = 3,
                            AutoButtonColor = false
                        })

                        Linux.Instance("UICorner", {Parent = OptBtn, CornerRadius = UDim.new(0, 6)})
                        Linux.Instance("UIPadding", {Parent = OptBtn, PaddingLeft = UDim.new(0, 5)})

                        OptBtn.MouseButton1Click:Connect(function()
                            if table.find(SelectedValues, opt) then
                                for i, v in ipairs(SelectedValues) do
                                    if v == opt then
                                        table.remove(SelectedValues, i)
                                        break
                                    end
                                end
                            else
                                table.insert(SelectedValues, opt)
                            end
                            OptBtn.TextColor3 = table.find(SelectedValues, opt) and Linux.Theme.Accent or Linux.Theme.Text
                            UpdateSelectedText()
                            spawn(function() Linux:SafeCallback(config.Callback, SelectedValues) end)
                        end
                    end
                end
                UpdateDropSize()
            end

            if #Options > 0 then
                PopulateOptions()
            end

            MultiDropdown.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    IsOpen = not IsOpen
                    PopulateOptions()
                end
            end)

            local function SetOptions(newOptions)
                Options = newOptions or {}
                SelectedValues = {}
                UpdateSelectedText()
                PopulateOptions()
            end

            local function SetValues(values)
                SelectedValues = values or {}
                UpdateSelectedText()
                PopulateOptions()
                spawn(function() Linux:SafeCallback(config.Callback, SelectedValues) end)
            end

            return {
                Instance = MultiDropdown,
                SetOptions = SetOptions,
                SetValues = SetValues,
                GetValues = function() return SelectedValues end
            }
        end

        function TabElements.Slider(config)
            elementOrder = elementOrder + 1
            local Slider = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -10, 0, 45),
                ZIndex = 1,
                LayoutOrder = elementOrder,
                BorderSizePixel = 0
            })

            Linux.Instance("UICorner", {Parent = Slider, CornerRadius = UDim.new(0, 6)})
            Linux.Instance("UIStroke", {Parent = Slider, Color = Linux.Theme.Accent, Thickness = 1, Transparency = 0.9})

            Linux.Instance("TextLabel", {
                Parent = Slider,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.6, 0, 0, 20),
                Position = UDim2.new(0, 10, 0, 5),
                Font = Enum.Font.Gotham,
                Text = config.Name,
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1
            })

            local ValueLabel = Linux.Instance("TextLabel", {
                Parent = Slider,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.4, -10, 0, 20),
                Position = UDim2.new(0.6, 0, 0, 5),
                Font = Enum.Font.Gotham,
                Text = tostring(config.Default or config.Min or 0),
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 1
            })

            local SliderBar = Linux.Instance("Frame", {
                Parent = Slider,
                BackgroundColor3 = Linux.Theme.Toggle,
                Size = UDim2.new(1, -20, 0, 6),
                Position = UDim2.new(0, 10, 0, 30),
                ZIndex = 1,
                BorderSizePixel = 0
            })

            Linux.Instance("UICorner", {Parent = SliderBar, CornerRadius = UDim.new(1, 0)})

            local FillBar = Linux.Instance("Frame", {
                Parent = SliderBar,
                BackgroundColor3 = Linux.Theme.Accent,
                Size = UDim2.new(0, 0, 1, 0),
                ZIndex = 1,
                BorderSizePixel = 0
            })

            Linux.Instance("UICorner", {Parent = FillBar, CornerRadius = UDim.new(1, 0)})

            local Knob = Linux.Instance("Frame", {
                Parent = SliderBar,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new(0, 0, 0, -4),
                ZIndex = 2,
                BorderSizePixel = 0
            })

            Linux.Instance("UICorner", {Parent = Knob, CornerRadius = UDim.new(1, 0)})
            Linux.Instance("UIStroke", {Parent = Knob, Color = Linux.Theme.Accent, Thickness = 1, Transparency = 0.8})

            local Min = config.Min or 0
            local Max = config.Max or 100
            local Default = config.Default or Min
            local Value = Default

            local function UpdateSlider(pos)
                local barSize = SliderBar.AbsoluteSize.X
                local relativePos = math.clamp((pos - SliderBar.AbsolutePosition.X) / barSize, 0, 1)
                Value = Min + (Max - Min) * relativePos
                Value = math.floor(Value + 0.5)
                Knob.Position = UDim2.new(relativePos, -7, 0, -4)
                FillBar.Size = UDim2.new(relativePos, 0, 1, 0)
                ValueLabel.Text = tostring(Value)
                spawn(function() Linux:SafeCallback(config.Callback, Value) end)
            end

            local draggingSlider = false

            Slider.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = true
                    UpdateSlider(input.Position.X)
                end
            end)

            Slider.InputChanged:Connect(function(input)
                if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) and draggingSlider then
                    UpdateSlider(input.Position.X)
                end
            end)

            Slider.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = false
                end
            end)

            local function SetValue(newValue)
                newValue = math.clamp(newValue, Min, Max)
                Value = math.floor(newValue + 0.5)
                local relativePos = (Value - Min) / (Max - Min)
                Knob.Position = UDim2.new(relativePos, -7, 0, -4)
                FillBar.Size = UDim2.new(relativePos, 0, 1, 0)
                ValueLabel.Text = tostring(Value)
                spawn(function() Linux:SafeCallback(config.Callback, Value) end)
            end

            SetValue(Default)

            return {
                Instance = Slider,
                SetValue = SetValue,
                GetValue = function() return Value end
            }
        end

        function TabElements.Input(config)
            elementOrder = elementOrder + 1
            local Input = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -10, 0, 35),
                ZIndex = 1,
                LayoutOrder = elementOrder,
                BorderSizePixel = 0
            })

            Linux.Instance("UICorner", {Parent = Input, CornerRadius = UDim.new(0, 6)})
            Linux.Instance("UIStroke", {Parent = Input, Color = Linux.Theme.Accent, Thickness = 1, Transparency = 0.9})

            Linux.Instance("TextLabel", {
                Parent = Input,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.5, 0, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                Font = Enum.Font.Gotham,
                Text = config.Name,
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1
            })

            local TextBox = Linux.Instance("TextBox", {
                Parent = Input,
                BackgroundColor3 = Linux.Theme.Toggle,
                Size = UDim2.new(0.5, -15, 0, 24),
                Position = UDim2.new(0.5, 5, 0.5, -12),
                Font = Enum.Font.Gotham,
                Text = config.Default or "",
                PlaceholderText = config.Placeholder or "Enter text",
                PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false,
                ClipsDescendants = true,
                ZIndex = 2
            })

            Linux.Instance("UICorner", {Parent = TextBox, CornerRadius = UDim.new(0, 6)})
            Linux.Instance("UIPadding", {Parent = TextBox, PaddingLeft = UDim.new(0, 5)})

            local MaxLength = config.MaxLength or 50

            local function CheckTextBounds()
                if #TextBox.Text > MaxLength then
                    TextBox.Text = string.sub(TextBox.Text, 1, MaxLength)
                end
            end

            TextBox:GetPropertyChangedSignal("Text"):Connect(CheckTextBounds)

            local function UpdateInput()
                CheckTextBounds()
                spawn(function() Linux:SafeCallback(config.Callback, TextBox.Text) end)
            end

            TextBox.FocusLost:Connect(function(enterPressed)
                if enterPressed then UpdateInput() end
            end)

            TextBox.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    TextBox:CaptureFocus()
                end
            end)

            local function SetValue(newValue)
                local text = tostring(newValue)
                if #text > MaxLength then
                    text = string.sub(text, 1, MaxLength)
                end
                TextBox.Text = text
                UpdateInput()
            end

            return {
                Instance = Input,
                SetValue = SetValue,
                GetValue = function() return TextBox.Text end
            }
        end

        function TabElements.Label(config)
            elementOrder = elementOrder + 1
            local LabelFrame = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -10, 0, 35),
                ZIndex = 1,
                LayoutOrder = elementOrder,
                BorderSizePixel = 0
            })

            Linux.Instance("UICorner", {Parent = LabelFrame, CornerRadius = UDim.new(0, 6)})
            Linux.Instance("UIStroke", {Parent = LabelFrame, Color = Linux.Theme.Accent, Thickness = 1, Transparency = 0.9})

            local LabelText = Linux.Instance("TextLabel", {
                Parent = LabelFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                Font = Enum.Font.Gotham,
                Text = config.Text or "Label",
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                ZIndex = 1
            })

            local function SetText(newText)
                LabelText.Text = tostring(newText)
            end

            return {
                Instance = LabelFrame,
                SetText = SetText,
                GetText = function() return LabelText.Text end
            }
        end

        function TabElements.Section(config)
            elementOrder = elementOrder + 1
            local Section = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 0, 30),
                ZIndex = 1,
                LayoutOrder = elementOrder,
                BorderSizePixel = 0
            })

            Linux.Instance("TextLabel", {
                Parent = Section,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 1, 0),
                Position = UDim2.new(0, 5, 0, 0),
                Font = Enum.Font.GothamBold,
                Text = config.Name,
                TextColor3 = Linux.Theme.Accent,
                TextSize = 18,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1
            })

            return Section
        end

        function TabElements.Keybind(config)
            elementOrder = elementOrder + 1
            local Keybind = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -10, 0, 35),
                ZIndex = 1,
                LayoutOrder = elementOrder,
                BorderSizePixel = 0
            })

            Linux.Instance("UICorner", {Parent = Keybind, CornerRadius = UDim.new(0, 6)})
            Linux.Instance("UIStroke", {Parent = Keybind, Color = Linux.Theme.Accent, Thickness = 1, Transparency = 0.9})

            Linux.Instance("TextLabel", {
                Parent = Keybind,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.5, 0, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                Font = Enum.Font.Gotham,
                Text = config.Name,
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1
            })

            local KeyBox = Linux.Instance("TextButton", {
                Parent = Keybind,
                BackgroundColor3 = Linux.Theme.Toggle,
                Size = UDim2.new(0, 60, 0, 24),
                Position = UDim2.new(1, -70, 0.5, -12),
                Font = Enum.Font.Gotham,
                Text = config.Default and tostring(config.Default) or "None",
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Center,
                ZIndex = 2,
                AutoButtonColor = false
            })

            Linux.Instance("UICorner", {Parent = KeyBox, CornerRadius = UDim.new(0, 6)})
            Linux.Instance("UIStroke", {Parent = KeyBox, Color = Linux.Theme.Accent, Thickness = 1, Transparency = 0.9})

            local Mode = config.Mode or "Hold"
            local CurrentKey = config.Default or nil
            local IsBinding = false
            local ToggleState = false
            local IsHolding = false

            local function UpdateKeyText()
                KeyBox.Text = CurrentKey and tostring(CurrentKey) or "None"
            end

            local function ExecuteCallback(state)
                if Mode == "Hold" then
                    spawn(function() Linux:SafeCallback(config.Callback, state) end)
                elseif Mode == "Toggle" then
                    if state then
                        ToggleState = not ToggleState
                        spawn(function() Linux:SafeCallback(config.Callback, ToggleState) end)
                    end
                elseif Mode == "Always" then
                    if ToggleState then
                        spawn(function() Linux:SafeCallback(config.Callback, true) end)
                    end
                end
            end

            KeyBox.MouseButton1Click:Connect(function()
                if not IsBinding then
                    IsBinding = true
                    KeyBox.Text = "..."
                end
            end)

            KeyBox.MouseButton2Click:Connect(function()
                CurrentKey = nil
                IsBinding = false
                UpdateKeyText()
            end)

            InputService.InputBegan:Connect(function(input, gameProcessedEvent)
                if gameProcessedEvent then return end

                if IsBinding then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        CurrentKey = input.KeyCode
                        IsBinding = false
                        UpdateKeyText()
                    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                        CurrentKey = Enum.UserInputType.MouseButton1
                        IsBinding = false
                        UpdateKeyText()
                    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                        CurrentKey = Enum.UserInputType.MouseButton2
                        IsBinding = false
                        UpdateKeyText()
                    elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
                        CurrentKey = Enum.UserInputType.MouseButton3
                        IsBinding = false
                        UpdateKeyText()
                    end
                elseif CurrentKey then
                    if (CurrentKey == input.KeyCode or CurrentKey == input.UserInputType) then
                        IsHolding = true
                        ExecuteCallback(true)
                    end
                end
            end)

            InputService.InputEnded:Connect(function(input, gameProcessedEvent)
                if gameProcessedEvent then return end

                if CurrentKey and (CurrentKey == input.KeyCode or CurrentKey == input.UserInputType) then
                    IsHolding = false
                    if Mode == "Hold" then
                        ExecuteCallback(false)
                    end
                end
            end)

            if Mode == "Always" then
                spawn(function()
                    while true do
                        if ToggleState then
                            ExecuteCallback(true)
                        end
                        wait()
                    end
                end)
            end

            local function SetKey(newKey)
                CurrentKey = newKey
                UpdateKeyText()
            end

            local function SetMode(newMode)
                Mode = newMode
                ToggleState = false
                IsHolding = false
            end

            UpdateKeyText()

            return {
                Instance = Keybind,
                SetKey = SetKey,
                GetKey = function() return CurrentKey end,
                SetMode = SetMode
            }
        end

        function TabElements.Paragraph(config)
            elementOrder = elementOrder + 1
            local ParagraphFrame = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -10, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                ZIndex = 1,
                LayoutOrder = elementOrder,
                BorderSizePixel = 0
            })

            Linux.Instance("UICorner", {Parent = ParagraphFrame, CornerRadius = UDim.new(0, 6)})
            Linux.Instance("UIStroke", {Parent = ParagraphFrame, Color = Linux.Theme.Accent, Thickness = 1, Transparency = 0.9})

            Linux.Instance("TextLabel", {
                Parent = ParagraphFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 0, 20),
                Position = UDim2.new(0, 10, 0, 5),
                Font = Enum.Font.GothamBold,
                Text = config.Title or "Paragraph",
                TextColor3 = Linux.Theme.Text,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1
            })

            local Content = Linux.Instance("TextLabel", {
                Parent = ParagraphFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 0, 0),
                Position = UDim2.new(0, 10, 0, 25),
                Font = Enum.Font.Gotham,
                Text = config.Content or "Content",
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                AutomaticSize = Enum.AutomaticSize.Y,
                ZIndex = 1
            })

            Linux.Instance("UIPadding", {Parent = ParagraphFrame, PaddingBottom = UDim.new(0, 5)})

            local function SetTitle(newTitle)
                ParagraphFrame:GetChildren()[1].Text = tostring(newTitle)
            end

            local function SetContent(newContent)
                Content.Text = tostring(newContent)
            end

            return {
                Instance = ParagraphFrame,
                SetTitle = SetTitle,
                SetContent = SetContent
            }
        end

        function TabElements.Notification(config)
            elementOrder = elementOrder + 1
            local NotificationFrame = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -10, 0, 35),
                ZIndex = 1,
                LayoutOrder = elementOrder,
                BorderSizePixel = 0
            })

            Linux.Instance("UICorner", {Parent = NotificationFrame, CornerRadius = UDim.new(0, 6)})
            Linux.Instance("UIStroke", {Parent = NotificationFrame, Color = Linux.Theme.Accent, Thickness = 1, Transparency = 0.9})

            Linux.Instance("TextLabel", {
                Parent = NotificationFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.5, 0, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                Font = Enum.Font.Gotham,
                Text = config.Name,
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1
            })

            local NotificationText = Linux.Instance("TextLabel", {
                Parent = NotificationFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.5, -15, 1, 0),
                Position = UDim2.new(0.5, 5, 0, 0),
                Font = Enum.Font.Gotham,
                Text = config.Default or "No interaction yet",
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                TextTruncate = Enum.TextTruncate.AtEnd,
                ZIndex = 1
            })

            local function SetText(newText)
                NotificationText.Text = tostring(newText)
            end

            return {
                Instance = NotificationFrame,
                SetText = SetText,
                GetText = function() return NotificationText.Text end
            }
        end

        return TabElements
    end

    return LinuxLib
end

return Linux
