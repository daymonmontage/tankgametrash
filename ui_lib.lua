--[[ 
    PREMIUM UI LIBRARY v3 (Sidebar Edition)
    Design: Dashboard Style (Left Menu)
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Library = {}

function Library:CreateWindow(config)
    local UI = {}
    local TitleText = config.Title or "Menu"
    
    -- Очистка старого GUI
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
    MainFrame.Size = UDim2.new(0, 650, 0, 420) -- Чуть шире для меню слева
    MainFrame.Position = UDim2.new(0.5, -325, 0.5, -210)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Parent = MainFrame
    MainStroke.Color = Color3.fromRGB(45, 45, 45)
    MainStroke.Thickness = 1

    -- 3. SIDEBAR (Левая панель)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Sidebar.BorderSizePixel = 0
    Sidebar.Size = UDim2.new(0, 160, 1, 0)
    
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 8)
    SidebarCorner.Parent = Sidebar
    
    -- Выпрямляем правый край сайдбара
    local SidebarCover = Instance.new("Frame")
    SidebarCover.Parent = Sidebar
    SidebarCover.BorderSizePixel = 0
    SidebarCover.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SidebarCover.Size = UDim2.new(0, 10, 1, 0)
    SidebarCover.Position = UDim2.new(1, -10, 0, 0)

    -- Заголовок в Сайдбаре (Название чита)
    local AppName = Instance.new("TextLabel")
    AppName.Parent = Sidebar
    AppName.Text = TitleText
    AppName.Font = Enum.Font.GothamBold
    AppName.TextSize = 18
    AppName.TextColor3 = Color3.fromRGB(255, 255, 255)
    AppName.Size = UDim2.new(1, 0, 0, 50)
    AppName.BackgroundTransparency = 1
    
    -- Линия под названием
    local Div = Instance.new("Frame")
    Div.Parent = Sidebar
    Div.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Div.BorderSizePixel = 0
    Div.Size = UDim2.new(0.8, 0, 0, 1)
    Div.Position = UDim2.new(0.1, 0, 0, 50)

    -- Контейнер для кнопок вкладок
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Parent = Sidebar
    TabContainer.BackgroundTransparency = 1
    TabContainer.Size = UDim2.new(1, 0, 1, -60)
    TabContainer.Position = UDim2.new(0, 0, 0, 60)
    TabContainer.ScrollBarThickness = 0

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = TabContainer
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 5)

    -- 4. PAGES CONTAINER (Правая часть)
    local PagesFolder = Instance.new("Frame")
    PagesFolder.Name = "Pages"
    PagesFolder.Parent = MainFrame
    PagesFolder.BackgroundTransparency = 1
    PagesFolder.Position = UDim2.new(0, 170, 0, 40) -- Отступ слева 170
    PagesFolder.Size = UDim2.new(1, -180, 1, -50)

    -- 5. DRAG & CONTROLS (Перетаскивание за Sidebar)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    Sidebar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = MainFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    Sidebar.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)

    -- Кнопка закрытия (В правом верхнем углу MainFrame)
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = MainFrame
    CloseBtn.Text = "X"
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextColor3 = Color3.fromRGB(100, 100, 100)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Size = UDim2.new(0, 40, 0, 40)
    CloseBtn.Position = UDim2.new(1, -40, 0, 0)
    CloseBtn.TextSize = 18
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    
    -- === LOGIC ===
    local tabs = {}
    local firstTab = true

    function UI:Tab(name, iconId)
        local Tab = {}
        
        -- Кнопка вкладки
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = TabContainer
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabBtn.BorderSizePixel = 0
        TabBtn.Size = UDim2.new(1, -20, 0, 40)
        TabBtn.Position = UDim2.new(0, 10, 0, 0)
        TabBtn.AutoButtonColor = false
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.Text = "       " .. name -- Отступ для иконки
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.TextSize = 14
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabBtn

        -- Иконка
        local Icon = Instance.new("ImageLabel")
        Icon.Parent = TabBtn
        Icon.BackgroundTransparency = 1
        Icon.Position = UDim2.new(0, 10, 0.5, -10)
        Icon.Size = UDim2.new(0, 20, 0, 20)
        Icon.Image = iconId or ""
        Icon.ImageColor3 = Color3.fromRGB(150, 150, 150)

        -- Страница (Контейнер кнопок)
        local Page = Instance.new("ScrollingFrame")
        Page.Name = name .. "Page"
        Page.Parent = PagesFolder
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255)
        Page.Visible = false 
        
        local PageList = Instance.new("UIListLayout")
        PageList.Parent = Page
        PageList.SortOrder = Enum.SortOrder.LayoutOrder
        PageList.Padding = UDim.new(0, 8)

        -- Анимация выбора
        local function Activate()
            -- Деактивируем все остальные
            for _, t in pairs(tabs) do
                TweenService:Create(t.Btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 30, 30), TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                TweenService:Create(t.Icon, TweenInfo.new(0.3), {ImageColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                t.Page.Visible = false
            end
            
            -- Активируем текущую
            TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(45, 45, 45), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(Icon, TweenInfo.new(0.3), {ImageColor3 = Color3.fromRGB(100, 150, 255)}):Play()
            Page.Visible = true
        end

        TabBtn.MouseButton1Click:Connect(Activate)

        table.insert(tabs, {Btn = TabBtn, Page = Page, Icon = Icon})

        -- Если это первая вкладка, открываем её сразу
        if firstTab then
            Activate()
            firstTab = false
        end

        -- FUNCTION FOR ELEMENTS
        function Tab:Button(text, callback)
            local BtnFrame = Instance.new("TextButton")
            BtnFrame.Parent = Page
            BtnFrame.Size = UDim2.new(1, 0, 0, 40)
            BtnFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            BtnFrame.AutoButtonColor = false
            BtnFrame.Text = ""
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = BtnFrame
            
            local BtnStroke = Instance.new("UIStroke")
            BtnStroke.Parent = BtnFrame
            BtnStroke.Color = Color3.fromRGB(50, 50, 50)
            BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            local Label = Instance.new("TextLabel")
            Label.Parent = BtnFrame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.Size = UDim2.new(1, -30, 1, 0)
            Label.Font = Enum.Font.GothamSemibold
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(220, 220, 220)
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left

            BtnFrame.MouseEnter:Connect(function()
                TweenService:Create(BtnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
                TweenService:Create(BtnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(100, 150, 255)}):Play()
            end)
            BtnFrame.MouseLeave:Connect(function()
                TweenService:Create(BtnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
                TweenService:Create(BtnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(50, 50, 50)}):Play()
            end)
            BtnFrame.MouseButton1Click:Connect(function()
                TweenService:Create(BtnFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, -4, 0, 36)}):Play()
                wait(0.1)
                TweenService:Create(BtnFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                pcall(callback)
            end)
        end
        
        function Tab:Label(text)
             local Lab = Instance.new("TextLabel")
            Lab.Parent = Page
            Lab.Size = UDim2.new(1, 0, 0, 30)
            Lab.BackgroundTransparency = 1
            Lab.Text = text
            Lab.TextColor3 = Color3.fromRGB(120, 120, 120)
            Lab.Font = Enum.Font.GothamBold
            Lab.TextSize = 12
            Lab.TextXAlignment = Enum.TextXAlignment.Left
            Lab.TextYAlignment = Enum.TextYAlignment.Bottom
        end

        return Tab
    end

    return UI
end

return Library
