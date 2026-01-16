--[[ 
    PREMIUM UI LIBRARY v5 (RESIZE & FIXES)
    Features: Resizable Window, Working Minimize, Fixed Sidebar Layout
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Mouse = game.Players.LocalPlayer:GetMouse()

local Library = {}

-- Настройки цветов
local Colors = {
    Main = Color3.fromRGB(20, 20, 20),
    Sidebar = Color3.fromRGB(25, 25, 25),
    Content = Color3.fromRGB(22, 22, 22),
    Accent = Color3.fromRGB(99, 102, 241), -- Indigo
    Text = Color3.fromRGB(240, 240, 240),
    TextDark = Color3.fromRGB(120, 120, 120),
    Border = Color3.fromRGB(45, 45, 45),
    Card = Color3.fromRGB(32, 32, 32),
    CardHover = Color3.fromRGB(40, 40, 40)
}

function Library:CreateWindow(config)
    local UI = {}
    local TitleText = config.Title or "Menu"

    if CoreGui:FindFirstChild(config.Name) then
        CoreGui[config.Name]:Destroy()
    end

    -- 1. SCREEN GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = config.Name
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- 2. MAIN FRAME
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 650, 0, 450) -- Начальный размер
    MainFrame.Position = UDim2.new(0.5, -325, 0.5, -225)
    MainFrame.BackgroundColor3 = Colors.Main
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    -- Минимальный размер окна, чтобы не сломать верстку
    local minSize = Vector2.new(500, 350)

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Parent = MainFrame
    MainStroke.Color = Color3.fromRGB(60, 60, 60)
    MainStroke.Thickness = 1

    -- Тень
    local Shadow = Instance.new("ImageLabel")
    Shadow.Parent = ScreenGui
    Shadow.Image = "rbxassetid://6015897843"
    Shadow.ImageColor3 = Color3.new(0, 0, 0)
    Shadow.ImageTransparency = 0.4
    Shadow.Position = MainFrame.Position + UDim2.new(0, 15, 0, 15)
    Shadow.Size = MainFrame.Size
    Shadow.ZIndex = -1
    Shadow.BackgroundTransparency = 1

    -- Синхронизация тени с размером окна
    MainFrame:GetPropertyChangedSignal("Size"):Connect(function()
        Shadow.Size = MainFrame.Size
    end)
    MainFrame:GetPropertyChangedSignal("Position"):Connect(function()
        Shadow.Position = MainFrame.Position + UDim2.new(0, 15, 0, 15)
    end)

    -- 3. HEADER
    local Header = Instance.new("Frame")
    Header.Parent = MainFrame
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Header.BorderSizePixel = 0
    
    -- Градиент шапки
    local HeaderGrad = Instance.new("UIGradient")
    HeaderGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 40))
    }
    HeaderGrad.Rotation = 90
    HeaderGrad.Parent = Header

    -- Pulse Dot (Кружок слева)
    local Dot = Instance.new("Frame")
    Dot.Parent = Header
    Dot.Size = UDim2.new(0, 8, 0, 8)
    Dot.BackgroundColor3 = Colors.Accent
    Dot.Position = UDim2.new(0, 15, 0.5, -4)
    local DotCorner = Instance.new("UICorner"); DotCorner.CornerRadius = UDim.new(1, 0); DotCorner.Parent = Dot

    -- Title
    local AppName = Instance.new("TextLabel")
    AppName.Parent = Header
    AppName.Text = TitleText
    AppName.Font = Enum.Font.GothamBold
    AppName.TextSize = 16
    AppName.TextColor3 = Color3.fromRGB(255, 255, 255)
    AppName.Size = UDim2.new(0, 200, 1, 0)
    AppName.Position = UDim2.new(0, 35, 0, 0)
    AppName.BackgroundTransparency = 1
    AppName.TextXAlignment = Enum.TextXAlignment.Left

    -- 4. SIDEBAR & CONTENT CONTAINERS
    local Sidebar = Instance.new("Frame")
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Colors.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Size = UDim2.new(0, 75, 1, -50) -- Ширина 75px
    Sidebar.Position = UDim2.new(0, 0, 0, 50)
    
    local SidebarBorder = Instance.new("Frame")
    SidebarBorder.Parent = Sidebar
    SidebarBorder.Size = UDim2.new(0, 1, 1, 0)
    SidebarBorder.Position = UDim2.new(1, -1, 0, 0)
    SidebarBorder.BackgroundColor3 = Colors.Border
    SidebarBorder.BorderSizePixel = 0

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Parent = Sidebar
    TabContainer.BackgroundTransparency = 1
    TabContainer.Size = UDim2.new(1, 0, 1, -10)
    TabContainer.Position = UDim2.new(0, 0, 0, 10)
    TabContainer.ScrollBarThickness = 0
    
    local TabList = Instance.new("UIListLayout")
    TabList.Parent = TabContainer
    TabList.Padding = UDim.new(0, 5)
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local PagesFolder = Instance.new("Frame")
    PagesFolder.Parent = MainFrame
    PagesFolder.BackgroundColor3 = Colors.Content
    PagesFolder.BorderSizePixel = 0
    PagesFolder.Position = UDim2.new(0, 76, 0, 50)
    PagesFolder.Size = UDim2.new(1, -76, 1, -50)

    -- 5. RESIZE HANDLER (Растягивание)
    local ResizeBtn = Instance.new("ImageButton")
    ResizeBtn.Name = "ResizeHandle"
    ResizeBtn.Parent = MainFrame
    ResizeBtn.BackgroundTransparency = 1
    ResizeBtn.Size = UDim2.new(0, 20, 0, 20)
    ResizeBtn.Position = UDim2.new(1, -20, 1, -20)
    ResizeBtn.Image = "rbxassetid://13462153833" -- Иконка уголка (можно заменить)
    ResizeBtn.ImageColor3 = Color3.fromRGB(100, 100, 100)
    ResizeBtn.ImageTransparency = 0.5
    ResizeBtn.ZIndex = 10

    local resizing = false
    local resizeStart, startSize

    ResizeBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            resizeStart = input.Position
            startSize = MainFrame.AbsoluteSize
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - resizeStart
            local newX = math.max(minSize.X, startSize.X + delta.X)
            local newY = math.max(minSize.Y, startSize.Y + delta.Y)
            MainFrame.Size = UDim2.new(0, newX, 0, newY)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)

    -- 6. HEADER BUTTONS & MINIMIZE LOGIC
    local minimized = false
    local restoreSize = MainFrame.Size -- Запоминаем размер

    local function CreateControl(text, color, action)
        local btn = Instance.new("TextButton")
        btn.Parent = Header
        btn.Text = text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 20
        btn.TextColor3 = Color3.fromRGB(150, 150, 150)
        btn.BackgroundTransparency = 1
        btn.Size = UDim2.new(0, 40, 1, 0)
        btn.Position = UDim2.new(1, (text == "X" and -40 or -80), 0, 0)
        
        btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = color}):Play() end)
        btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play() end)
        btn.MouseButton1Click:Connect(action)
    end

    -- Close (X)
    CreateControl("X", Color3.fromRGB(255, 80, 80), function() ScreenGui:Destroy() end)

    -- Minimize (-)
    CreateControl("-", Colors.Accent, function() 
        minimized = not minimized
        if minimized then
            restoreSize = MainFrame.Size -- Сохраняем текущий размер перед сворачиванием
            ResizeBtn.Visible = false -- Скрываем уголок ресайза
            Sidebar.Visible = false
            PagesFolder.Visible = false
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, restoreSize.X.Offset, 0, 50)}):Play()
        else
            ResizeBtn.Visible = true
            Sidebar.Visible = true
            PagesFolder.Visible = true
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = restoreSize}):Play()
        end
    end)

    -- 7. DRAG LOGIC (Перетаскивание)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = MainFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    Header.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)


    -- === TAB SYSTEM ===
    local tabs = {}
    local firstTab = true

    function UI:Tab(name, iconId)
        local TabObj = {}
        
        -- КНОПКА ВКЛАДКИ (Исправленный дизайн)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = TabContainer
        TabBtn.Size = UDim2.new(0, 65, 0, 60) -- Квадратная форма, чуть больше
        TabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = ""
        
        -- Индикатор слева (Полоска)
        local Indicator = Instance.new("Frame")
        Indicator.Parent = TabBtn
        Indicator.BackgroundColor3 = Colors.Accent
        Indicator.Size = UDim2.new(0, 3, 0, 0)
        Indicator.Position = UDim2.new(0, 0, 0.5, 0) -- Центр по вертикали
        Indicator.AnchorPoint = Vector2.new(0, 0.5)
        Indicator.BorderSizePixel = 0
        
        -- Иконка
        local Icon = Instance.new("ImageLabel")
        Icon.Parent = TabBtn
        Icon.BackgroundTransparency = 1
        Icon.Size = UDim2.new(0, 24, 0, 24)
        Icon.Position = UDim2.new(0.5, -12, 0.4, -12) -- Чуть выше центра
        Icon.Image = iconId
        Icon.ImageColor3 = Colors.TextDark

        -- Текст под иконкой
        local Lab = Instance.new("TextLabel")
        Lab.Parent = TabBtn
        Lab.BackgroundTransparency = 1
        Lab.Text = name
        Lab.TextSize = 10
        Lab.TextColor3 = Colors.TextDark
        Lab.Font = Enum.Font.GothamBold
        Lab.Size = UDim2.new(1, 0, 0, 15)
        Lab.Position = UDim2.new(0, 0, 0.75, 0) -- Внизу кнопки
        Lab.TextXAlignment = Enum.TextXAlignment.Center -- ПО ЦЕНТРУ!

        -- Страница
        local Page = Instance.new("ScrollingFrame")
        Page.Name = name .. "Page"
        Page.Parent = PagesFolder
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, -20, 1, -20)
        Page.Position = UDim2.new(0, 20, 0, 20)
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = Colors.Accent
        Page.Visible = false
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = Page
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder

        -- Анимация переключения
        local function Activate()
            for _, t in pairs(tabs) do
                TweenService:Create(t.Icon, TweenInfo.new(0.3), {ImageColor3 = Colors.TextDark}):Play()
                TweenService:Create(t.Lab, TweenInfo.new(0.3), {TextColor3 = Colors.TextDark}):Play()
                TweenService:Create(t.Ind, TweenInfo.new(0.3), {Size = UDim2.new(0, 3, 0, 0)}):Play()
                t.Page.Visible = false
            end
            
            TweenService:Create(Icon, TweenInfo.new(0.3), {ImageColor3 = Colors.Accent}):Play()
            TweenService:Create(Lab, TweenInfo.new(0.3), {TextColor3 = Colors.Accent}):Play()
            TweenService:Create(Indicator, TweenInfo.new(0.3), {Size = UDim2.new(0, 3, 0, 40)}):Play() -- Высокая полоска
            Page.Visible = true
        end

        TabBtn.MouseButton1Click:Connect(Activate)
        table.insert(tabs, {Btn = TabBtn, Page = Page, Icon = Icon, Lab = Lab, Ind = Indicator})

        if firstTab then Activate(); firstTab = false end

        -- === ЭЛЕМЕНТЫ ===
        
        -- 1. BUTTON
        function TabObj:Button(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Parent = Page
            Btn.Size = UDim2.new(1, -10, 0, 45)
            Btn.BackgroundColor3 = Colors.Card
            Btn.AutoButtonColor = false
            Btn.Text = ""
            
            local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 6); Corner.Parent = Btn
            local Stroke = Instance.new("UIStroke"); Stroke.Parent = Btn; Stroke.Color = Colors.Border; Stroke.Thickness = 1
            
            local Txt = Instance.new("TextLabel")
            Txt.Parent = Btn
            Txt.Text = text
            Txt.Font = Enum.Font.GothamSemibold
            Txt.TextSize = 14
            Txt.TextColor3 = Colors.Text
            Txt.BackgroundTransparency = 1
            Txt.Size = UDim2.new(1, -20, 1, 0)
            Txt.Position = UDim2.new(0, 15, 0, 0)
            Txt.TextXAlignment = Enum.TextXAlignment.Left

            Btn.MouseEnter:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.CardHover}):Play()
                TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = Colors.Accent}):Play()
            end)
            Btn.MouseLeave:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Card}):Play()
                TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = Colors.Border}):Play()
            end)
            Btn.MouseButton1Click:Connect(function() pcall(callback) end)
        end

        -- 2. TOGGLE
        function TabObj:Toggle(text, default, callback)
            local toggled = default or false
            local Frame = Instance.new("TextButton")
            Frame.Parent = Page
            Frame.Size = UDim2.new(1, -10, 0, 45)
            Frame.BackgroundColor3 = Colors.Card
            Frame.AutoButtonColor = false
            Frame.Text = ""
            
            local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 6); Corner.Parent = Frame
            local Stroke = Instance.new("UIStroke"); Stroke.Parent = Frame; Stroke.Color = Colors.Border; Stroke.Thickness = 1

            local Txt = Instance.new("TextLabel")
            Txt.Parent = Frame
            Txt.Text = text
            Txt.Font = Enum.Font.GothamSemibold
            Txt.TextSize = 14
            Txt.TextColor3 = Colors.Text
            Txt.BackgroundTransparency = 1
            Txt.Size = UDim2.new(1, -60, 1, 0)
            Txt.Position = UDim2.new(0, 15, 0, 0)
            Txt.TextXAlignment = Enum.TextXAlignment.Left

            local SwitchBg = Instance.new("Frame")
            SwitchBg.Parent = Frame
            SwitchBg.Size = UDim2.new(0, 44, 0, 24)
            SwitchBg.Position = UDim2.new(1, -55, 0.5, -12)
            SwitchBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            local SwitchCorner = Instance.new("UICorner"); SwitchCorner.CornerRadius = UDim.new(1, 0); SwitchCorner.Parent = SwitchBg
            
            local Circle = Instance.new("Frame")
            Circle.Parent = SwitchBg
            Circle.Size = UDim2.new(0, 20, 0, 20)
            Circle.Position = UDim2.new(0, 2, 0.5, -10)
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            local CircleCorner = Instance.new("UICorner"); CircleCorner.CornerRadius = UDim.new(1, 0); CircleCorner.Parent = Circle

            local function UpdateToggle()
                if toggled then
                    TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Accent}):Play()
                    TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -22, 0.5, -10)}):Play()
                else
                    TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
                    TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
                end
                pcall(callback, toggled)
            end
            if toggled then UpdateToggle() end
            Frame.MouseButton1Click:Connect(function() toggled = not toggled; UpdateToggle() end)
        end
        
        -- 3. LABEL
        function TabObj:Label(text)
            local Lab = Instance.new("TextLabel")
            Lab.Parent = Page
            Lab.Text = string.upper(text)
            Lab.Font = Enum.Font.GothamBold
            Lab.TextSize = 11
            Lab.TextColor3 = Colors.TextDark
            Lab.BackgroundTransparency = 1
            Lab.Size = UDim2.new(1, 0, 0, 25)
            Lab.TextXAlignment = Enum.TextXAlignment.Left
            Lab.Position = UDim2.new(0, 5, 0, 0)
        end

        return TabObj
    end
    return UI
end
return Library
