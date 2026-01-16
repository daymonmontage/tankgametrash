--[[ 
    TITANIUM UI LIBRARY v3 (Window Controls Update)
    Features: Resize, Minimize, Close, Modern Dark Theme
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Mouse = Players.LocalPlayer:GetMouse()

local Library = {}
local Utility = {}

-- // THEME CONFIGURATION //
local Theme = {
    Background = Color3.fromRGB(18, 18, 22),
    Sidebar = Color3.fromRGB(24, 24, 30),
    Element = Color3.fromRGB(30, 30, 38),
    Hover = Color3.fromRGB(40, 40, 50),
    Text = Color3.fromRGB(240, 240, 240),
    SubText = Color3.fromRGB(160, 160, 160),
    Accent = Color3.fromRGB(114, 137, 218), -- Discord/Modern Blue
    AccentHover = Color3.fromRGB(130, 150, 240),
    Outline = Color3.fromRGB(45, 45, 55),
    Red = Color3.fromRGB(235, 60, 60)
}

-- // UTILITIES //
function Utility:Tween(instance, properties, duration, style, direction)
    local info = TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, info, properties)
    tween:Play()
    return tween
end

function Utility:Ripple(btn)
    spawn(function()
        local ripple = Instance.new("ImageLabel")
        ripple.Name = "Ripple"
        ripple.Parent = btn
        ripple.BackgroundTransparency = 1
        ripple.BorderSizePixel = 0
        ripple.Image = "rbxassetid://266543268"
        ripple.ImageColor3 = Color3.fromRGB(255, 255, 255)
        ripple.ImageTransparency = 0.8
        ripple.ScaleType = Enum.ScaleType.Stretch
        
        local x, y = Mouse.X - btn.AbsolutePosition.X, Mouse.Y - btn.AbsolutePosition.Y
        ripple.Position = UDim2.new(0, x, 0, y)
        ripple.Size = UDim2.new(0, 0, 0, 0)
        
        local size = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 1.5
        
        Utility:Tween(ripple, {Size = UDim2.new(0, size, 0, size), Position = UDim2.new(0, x - size/2, 0, y - size/2), ImageTransparency = 1}, 0.5)
        
        wait(0.5)
        ripple:Destroy()
    end)
end

-- // MAIN LIBRARY //

function Library:CreateWindow(config)
    local UI = {}
    local Title = config.Title or "Titanium UI"
    
    if CoreGui:FindFirstChild(config.Name) then CoreGui[config.Name]:Destroy() end

    -- GUI Setup
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = config.Name
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Window
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 650, 0, 420) -- Default Size
    Main.Position = UDim2.new(0.5, -325, 0.5, -210)
    Main.BackgroundColor3 = Theme.Background
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui
    
    local MinSize = Vector2.new(500, 300) -- Минимальный размер окна
    
    local MainCorner = Instance.new("UICorner", Main); MainCorner.CornerRadius = UDim.new(0, 10)
    local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = Theme.Outline; MainStroke.Thickness = 1.5
    
    -- Shadow
    local Shadow = Instance.new("ImageLabel", ScreenGui)
    Shadow.ZIndex = -1
    Shadow.Image = "rbxassetid://6015897843"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.4
    Shadow.BackgroundTransparency = 1
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.Position = UDim2.new(0, -20, 0, -20)
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    
    local function UpdateShadow()
        Shadow.Position = Main.Position + UDim2.new(0, -20, 0, -20)
        Shadow.Size = Main.Size + UDim2.new(0, 40, 0, 40)
    end
    Main:GetPropertyChangedSignal("Position"):Connect(UpdateShadow)
    Main:GetPropertyChangedSignal("Size"):Connect(UpdateShadow)
    UpdateShadow()

    -- Header (For dragging and controls)
    local Header = Instance.new("Frame", Main)
    Header.Name = "Header"
    Header.BackgroundTransparency = 1
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.ZIndex = 2

    -- Sidebar
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.Size = UDim2.new(0, 160, 1, 0)
    Sidebar.BorderSizePixel = 0
    
    -- Logo
    local Logo = Instance.new("TextLabel", Sidebar)
    Logo.Text = Title
    Logo.Font = Enum.Font.GothamBold
    Logo.TextSize = 20
    Logo.TextColor3 = Theme.Text
    Logo.Size = UDim2.new(1, -20, 0, 50)
    Logo.Position = UDim2.new(0, 20, 0, 10)
    Logo.BackgroundTransparency = 1
    Logo.TextXAlignment = Enum.TextXAlignment.Left

    local LogoGradient = Instance.new("UIGradient", Logo)
    LogoGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Theme.Accent),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 255))
    }

    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -70)
    TabContainer.Position = UDim2.new(0, 0, 0, 60)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 2
    
    local TabList = Instance.new("UIListLayout", TabContainer)
    TabList.Padding = UDim.new(0, 5)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder

    -- Content Area
    local Content = Instance.new("Frame", Main)
    Content.BackgroundColor3 = Theme.Background
    Content.BackgroundTransparency = 1
    Content.Size = UDim2.new(1, -170, 1, -20)
    Content.Position = UDim2.new(0, 170, 0, 10)
    Content.ClipsDescendants = true

    -- == WINDOW CONTROLS (Close & Minimize) ==
    local ControlsHolder = Instance.new("Frame", Main)
    ControlsHolder.BackgroundTransparency = 1
    ControlsHolder.Size = UDim2.new(0, 80, 0, 30)
    ControlsHolder.Position = UDim2.new(1, -90, 0, 10)
    ControlsHolder.ZIndex = 5

    -- Close Button
    local CloseBtn = Instance.new("TextButton", ControlsHolder)
    CloseBtn.Text = "X"
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 16
    CloseBtn.TextColor3 = Theme.SubText
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -30, 0, 0)
    
    CloseBtn.MouseEnter:Connect(function() Utility:Tween(CloseBtn, {TextColor3 = Theme.Red}, 0.2) end)
    CloseBtn.MouseLeave:Connect(function() Utility:Tween(CloseBtn, {TextColor3 = Theme.SubText}, 0.2) end)
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    -- Minimize Button
    local MinBtn = Instance.new("TextButton", ControlsHolder)
    MinBtn.Text = "_"
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 16
    MinBtn.TextColor3 = Theme.SubText
    MinBtn.BackgroundTransparency = 1
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Position = UDim2.new(1, -65, 0, -4) -- Slightly higher to align text
    
    local isMinimized = false
    local savedSize = Main.Size
    
    MinBtn.MouseEnter:Connect(function() Utility:Tween(MinBtn, {TextColor3 = Theme.Accent}, 0.2) end)
    MinBtn.MouseLeave:Connect(function() Utility:Tween(MinBtn, {TextColor3 = Theme.SubText}, 0.2) end)
    
    MinBtn.MouseButton1Click:Connect(function()
        if isMinimized then
            -- Restore
            Utility:Tween(Main, {Size = savedSize}, 0.4, Enum.EasingStyle.Quart)
            wait(0.1)
            Sidebar.Visible = true
            Content.Visible = true
            isMinimized = false
        else
            -- Minimize
            savedSize = Main.Size
            Sidebar.Visible = false
            Content.Visible = false
            isMinimized = true
            Utility:Tween(Main, {Size = UDim2.new(0, savedSize.X.Offset, 0, 50)}, 0.4, Enum.EasingStyle.Quart)
        end
    end)

    -- == RESIZE HANDLE (Right Bottom) ==
    local ResizeHandle = Instance.new("ImageButton", Main)
    ResizeHandle.Name = "Resize"
    ResizeHandle.BackgroundTransparency = 1
    ResizeHandle.Size = UDim2.new(0, 20, 0, 20)
    ResizeHandle.Position = UDim2.new(1, -20, 1, -20)
    ResizeHandle.Image = "rbxassetid://6035284528" -- Diagonal Lines
    ResizeHandle.ImageColor3 = Theme.SubText
    ResizeHandle.ZIndex = 10
    
    local isResizing = false
    
    ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isResizing = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isResizing = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isResizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local newX = input.Position.X - Main.AbsolutePosition.X
            local newY = input.Position.Y - Main.AbsolutePosition.Y
            
            -- Apply Min Size
            newX = math.max(newX, MinSize.X)
            newY = math.max(newY, MinSize.Y)
            
            if not isMinimized then
                Main.Size = UDim2.new(0, newX, 0, newY)
            end
        end
    end)
    
    -- Hide Handle when minimized
    Main:GetPropertyChangedSignal("Size"):Connect(function()
        ResizeHandle.Visible = not isMinimized
    end)


    -- Notifications System
    local NotifContainer = Instance.new("Frame", ScreenGui)
    NotifContainer.Size = UDim2.new(0, 300, 1, 0)
    NotifContainer.Position = UDim2.new(1, -320, 0, 20)
    NotifContainer.BackgroundTransparency = 1
    
    local NotifList = Instance.new("UIListLayout", NotifContainer)
    NotifList.Padding = UDim.new(0, 10)
    NotifList.VerticalAlignment = Enum.VerticalAlignment.Bottom
    NotifList.HorizontalAlignment = Enum.HorizontalAlignment.Right

    function UI:Notify(title, text, duration)
        local frame = Instance.new("Frame", NotifContainer)
        frame.Size = UDim2.new(1, 0, 0, 70)
        frame.BackgroundColor3 = Theme.Sidebar
        frame.BorderSizePixel = 0
        frame.BackgroundTransparency = 1
        
        local corner = Instance.new("UICorner", frame); corner.CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", frame); stroke.Color = Theme.Accent; stroke.Thickness = 1
        
        local tLabel = Instance.new("TextLabel", frame)
        tLabel.Text = title
        tLabel.Font = Enum.Font.GothamBold
        tLabel.TextSize = 14
        tLabel.TextColor3 = Theme.Accent
        tLabel.Position = UDim2.new(0, 10, 0, 10)
        tLabel.BackgroundTransparency = 1
        tLabel.TextXAlignment = Enum.TextXAlignment.Left

        local dLabel = Instance.new("TextLabel", frame)
        dLabel.Text = text
        dLabel.Font = Enum.Font.Gotham
        dLabel.TextSize = 13
        dLabel.TextColor3 = Theme.Text
        dLabel.Size = UDim2.new(1, -20, 0, 40)
        dLabel.Position = UDim2.new(0, 10, 0, 25)
        dLabel.BackgroundTransparency = 1
        dLabel.TextXAlignment = Enum.TextXAlignment.Left
        dLabel.TextWrapped = true

        Utility:Tween(frame, {BackgroundTransparency = 0}, 0.3)
        delay(duration or 3, function()
            Utility:Tween(frame, {BackgroundTransparency = 1}, 0.3)
            Utility:Tween(tLabel, {TextTransparency = 1}, 0.3)
            Utility:Tween(dLabel, {TextTransparency = 1}, 0.3)
            Utility:Tween(stroke, {Transparency = 1}, 0.3)
            wait(0.3)
            frame:Destroy()
        end)
    end

    -- Dragging Logic (Moved to Header)
    local dragging, dragInput, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = Main.Position
        end
    end)
    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Utility:Tween(Main, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.05)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    -- Toggle Key
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.RightControl then
            Main.Visible = not Main.Visible
            Shadow.Visible = Main.Visible
        end
    end)

    -- TABS SYSTEM
    local Tabs = {}
    local FirstTab = true

    function UI:Tab(name, icon)
        local Tab = {}
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, -20, 0, 40)
        TabBtn.Position = UDim2.new(0, 10, 0, 0)
        TabBtn.BackgroundColor3 = Theme.Background
        TabBtn.Text = ""
        TabBtn.BackgroundTransparency = 1
        TabBtn.AutoButtonColor = false

        local TabCorner = Instance.new("UICorner", TabBtn); TabCorner.CornerRadius = UDim.new(0, 8)
        
        local TabIcon = Instance.new("ImageLabel", TabBtn)
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Position = UDim2.new(0, 12, 0.5, -10)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = icon or ""
        TabIcon.ImageColor3 = Theme.SubText
        
        local TabTitle = Instance.new("TextLabel", TabBtn)
        TabTitle.Text = name
        TabTitle.Size = UDim2.new(0, 0, 1, 0)
        TabTitle.Position = UDim2.new(0, 44, 0, 0)
        TabTitle.Font = Enum.Font.GothamSemibold
        TabTitle.TextSize = 13
        TabTitle.TextColor3 = Theme.SubText
        TabTitle.BackgroundTransparency = 1
        TabTitle.TextXAlignment = Enum.TextXAlignment.Left

        local Page = Instance.new("ScrollingFrame", Content)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.Visible = false
        
        local PageList = Instance.new("UIListLayout", Page)
        PageList.Padding = UDim.new(0, 8)
        PageList.SortOrder = Enum.SortOrder.LayoutOrder

        local function Activate()
            for _, t in pairs(Tabs) do
                Utility:Tween(t.Btn, {BackgroundTransparency = 1}, 0.2)
                Utility:Tween(t.Title, {TextColor3 = Theme.SubText}, 0.2)
                Utility:Tween(t.Icon, {ImageColor3 = Theme.SubText}, 0.2)
                t.Page.Visible = false
            end
            Utility:Tween(TabBtn, {BackgroundTransparency = 0}, 0.2)
            Utility:Tween(TabTitle, {TextColor3 = Theme.Accent}, 0.2)
            Utility:Tween(TabIcon, {ImageColor3 = Theme.Accent}, 0.2)
            Page.Visible = true
        end

        TabBtn.MouseButton1Click:Connect(Activate)
        table.insert(Tabs, {Btn = TabBtn, Title = TabTitle, Icon = TabIcon, Page = Page})

        if FirstTab then Activate(); FirstTab = false end

        -- ELEMENTS
        function Tab:Label(text)
            local Lab = Instance.new("TextLabel", Page)
            Lab.Text = text
            Lab.Size = UDim2.new(1, 0, 0, 25)
            Lab.BackgroundTransparency = 1
            Lab.TextColor3 = Theme.SubText
            Lab.Font = Enum.Font.GothamBold
            Lab.TextSize = 11
            Lab.TextXAlignment = Enum.TextXAlignment.Left
            Lab.Position = UDim2.new(0, 5, 0, 0)
            return Lab
        end

        function Tab:Button(text, callback)
            local Btn = Instance.new("TextButton", Page)
            Btn.Size = UDim2.new(1, -10, 0, 40)
            Btn.BackgroundColor3 = Theme.Element
            Btn.Text = ""
            Btn.AutoButtonColor = false
            
            local BtnCorner = Instance.new("UICorner", Btn); BtnCorner.CornerRadius = UDim.new(0, 6)
            local BtnStroke = Instance.new("UIStroke", Btn); BtnStroke.Color = Theme.Outline; BtnStroke.Thickness = 1
            
            local BtnText = Instance.new("TextLabel", Btn)
            BtnText.Text = text
            BtnText.Font = Enum.Font.GothamSemibold
            BtnText.TextSize = 13
            BtnText.TextColor3 = Theme.Text
            BtnText.Size = UDim2.new(1, 0, 1, 0)
            BtnText.BackgroundTransparency = 1
            
            Btn.MouseEnter:Connect(function() 
                Utility:Tween(Btn, {BackgroundColor3 = Theme.Hover}, 0.2)
                Utility:Tween(BtnStroke, {Color = Theme.Accent}, 0.2)
            end)
            Btn.MouseLeave:Connect(function() 
                Utility:Tween(Btn, {BackgroundColor3 = Theme.Element}, 0.2)
                Utility:Tween(BtnStroke, {Color = Theme.Outline}, 0.2)
            end)
            
            Btn.MouseButton1Click:Connect(function()
                Utility:Ripple(Btn)
                pcall(callback)
            end)
        end

        function Tab:Toggle(text, default, callback)
            local toggled = default or false
            local Tgl = Instance.new("TextButton", Page)
            Tgl.Size = UDim2.new(1, -10, 0, 40)
            Tgl.BackgroundColor3 = Theme.Element
            Tgl.Text = ""
            Tgl.AutoButtonColor = false
            
            local TglCorner = Instance.new("UICorner", Tgl); TglCorner.CornerRadius = UDim.new(0, 6)
            local TglStroke = Instance.new("UIStroke", Tgl); TglStroke.Color = Theme.Outline; TglStroke.Thickness = 1
            
            local TglText = Instance.new("TextLabel", Tgl)
            TglText.Text = text
            TglText.Font = Enum.Font.GothamSemibold
            TglText.TextSize = 13
            TglText.TextColor3 = Theme.Text
            TglText.Position = UDim2.new(0, 12, 0, 0)
            TglText.Size = UDim2.new(1, -60, 1, 0)
            TglText.BackgroundTransparency = 1
            TglText.TextXAlignment = Enum.TextXAlignment.Left
            
            local Switch = Instance.new("Frame", Tgl)
            Switch.Size = UDim2.new(0, 40, 0, 20)
            Switch.Position = UDim2.new(1, -50, 0.5, -10)
            Switch.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            local SwitchCorner = Instance.new("UICorner", Switch); SwitchCorner.CornerRadius = UDim.new(1, 0)
            
            local Dot = Instance.new("Frame", Switch)
            Dot.Size = UDim2.new(0, 16, 0, 16)
            Dot.Position = UDim2.new(0, 2, 0.5, -8)
            Dot.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            local DotCorner = Instance.new("UICorner", Dot); DotCorner.CornerRadius = UDim.new(1, 0)

            local function Update()
                if toggled then
                    Utility:Tween(Switch, {BackgroundColor3 = Theme.Accent}, 0.2)
                    Utility:Tween(Dot, {Position = UDim2.new(1, -18, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
                    Utility:Tween(TglStroke, {Color = Theme.Accent}, 0.2)
                else
                    Utility:Tween(Switch, {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}, 0.2)
                    Utility:Tween(Dot, {Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Color3.fromRGB(150, 150, 150)}, 0.2)
                    Utility:Tween(TglStroke, {Color = Theme.Outline}, 0.2)
                end
                pcall(callback, toggled)
            end
            if toggled then Update() end
            Tgl.MouseButton1Click:Connect(function() toggled = not toggled; Update(); Utility:Ripple(Tgl) end)
        end

        function Tab:Slider(text, min, max, default, callback)
            local value = default or min
            local SliderFrame = Instance.new("Frame", Page)
            SliderFrame.Size = UDim2.new(1, -10, 0, 60)
            SliderFrame.BackgroundColor3 = Theme.Element
            
            local Corner = Instance.new("UICorner", SliderFrame); Corner.CornerRadius = UDim.new(0, 6)
            local Stroke = Instance.new("UIStroke", SliderFrame); Stroke.Color = Theme.Outline; Stroke.Thickness = 1
            
            local Label = Instance.new("TextLabel", SliderFrame)
            Label.Text = text
            Label.Font = Enum.Font.GothamSemibold
            Label.TextSize = 13
            Label.TextColor3 = Theme.Text
            Label.Position = UDim2.new(0, 12, 0, 10)
            Label.BackgroundTransparency = 1
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local ValLabel = Instance.new("TextLabel", SliderFrame)
            ValLabel.Text = tostring(value)
            ValLabel.Font = Enum.Font.GothamBold
            ValLabel.TextSize = 13
            ValLabel.TextColor3 = Theme.Accent
            ValLabel.Size = UDim2.new(0, 50, 0, 20)
            ValLabel.Position = UDim2.new(1, -60, 0, 10)
            ValLabel.BackgroundTransparency = 1
            ValLabel.TextXAlignment = Enum.TextXAlignment.Right
            
            local Bar = Instance.new("TextButton", SliderFrame)
            Bar.Text = ""
            Bar.AutoButtonColor = false
            Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            Bar.Size = UDim2.new(1, -24, 0, 6)
            Bar.Position = UDim2.new(0, 12, 0, 40)
            local BarCorner = Instance.new("UICorner", Bar); BarCorner.CornerRadius = UDim.new(1, 0)
            
            local Fill = Instance.new("Frame", Bar)
            Fill.BackgroundColor3 = Theme.Accent
            Fill.Size = UDim2.new((value - min)/(max - min), 0, 1, 0)
            local FillCorner = Instance.new("UICorner", Fill); FillCorner.CornerRadius = UDim.new(1, 0)
            
            local dragging = false
            local function Update(input)
                local percent = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local newVal = math.floor(min + (max - min) * percent)
                Utility:Tween(Fill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.1)
                ValLabel.Text = tostring(newVal)
                pcall(callback, newVal)
            end
            Bar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; Update(input) end end)
            UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
            SliderFrame.MouseEnter:Connect(function() Utility:Tween(Stroke, {Color = Theme.Accent}, 0.2) end)
            SliderFrame.MouseLeave:Connect(function() Utility:Tween(Stroke, {Color = Theme.Outline}, 0.2) end)
        end

        function Tab:Dropdown(text, options, callback)
            local dropped = false
            local DropFrame = Instance.new("Frame", Page)
            DropFrame.Size = UDim2.new(1, -10, 0, 40)
            DropFrame.BackgroundColor3 = Theme.Element
            DropFrame.ClipsDescendants = true
            local Corner = Instance.new("UICorner", DropFrame); Corner.CornerRadius = UDim.new(0, 6)
            local Stroke = Instance.new("UIStroke", DropFrame); Stroke.Color = Theme.Outline; Stroke.Thickness = 1
            
            local DropBtn = Instance.new("TextButton", DropFrame)
            DropBtn.Size = UDim2.new(1, 0, 0, 40)
            DropBtn.BackgroundTransparency = 1; DropBtn.Text = ""
            
            local Label = Instance.new("TextLabel", DropBtn)
            Label.Text = text .. "..."
            Label.Font = Enum.Font.GothamSemibold
            Label.TextSize = 13
            Label.TextColor3 = Theme.Text
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.Size = UDim2.new(1, -40, 1, 0)
            Label.BackgroundTransparency = 1
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            local Icon = Instance.new("ImageLabel", DropBtn)
            Icon.Image = "rbxassetid://6031091004"
            Icon.Size = UDim2.new(0, 20, 0, 20)
            Icon.Position = UDim2.new(1, -30, 0.5, -10)
            Icon.BackgroundTransparency = 1
            Icon.ImageColor3 = Theme.SubText
            
            local Container = Instance.new("Frame", DropFrame)
            Container.Size = UDim2.new(1, 0, 0, 0)
            Container.BackgroundTransparency = 1
            Container.Position = UDim2.new(0, 0, 0, 40)
            local ContainerList = Instance.new("UIListLayout", Container)
            
            for _, opt in pairs(options) do
                local OptBtn = Instance.new("TextButton", Container)
                OptBtn.Size = UDim2.new(1, 0, 0, 30)
                OptBtn.BackgroundColor3 = Theme.Element
                OptBtn.BackgroundTransparency = 0
                OptBtn.Text = opt
                OptBtn.TextColor3 = Theme.SubText
                OptBtn.Font = Enum.Font.Gotham
                OptBtn.TextSize = 12
                OptBtn.MouseButton1Click:Connect(function()
                    Label.Text = text .. ": " .. opt
                    dropped = false
                    Utility:Tween(DropFrame, {Size = UDim2.new(1, -10, 0, 40)}, 0.2)
                    Utility:Tween(Icon, {Rotation = 0}, 0.2)
                    pcall(callback, opt)
                end)
            end
            DropBtn.MouseButton1Click:Connect(function()
                dropped = not dropped
                local h = dropped and (40 + (#options * 30)) or 40
                Utility:Tween(DropFrame, {Size = UDim2.new(1, -10, 0, h)}, 0.2)
                Utility:Tween(Icon, {Rotation = dropped and 180 or 0}, 0.2)
            end)
        end

        return Tab
    end

    return UI
end

return Library
