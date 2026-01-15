--[[ 
    PREMIUM SIDEBAR UI LIBRARY v3
    Style: Sidebar Navigation + Glassmorphism
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Library = {}

function Library:CreateWindow(config)
    local Window = {}
    local SelectedTab = nil
    
    -- 1. CLEANUP
    if CoreGui:FindFirstChild(config.Name) then
        CoreGui[config.Name]:Destroy()
    end

    -- 2. MAIN GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = config.Name
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- MAIN FRAME
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 600, 0, 400) -- Чуть шире для сайдбара
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Parent = MainFrame
    MainStroke.Color = Color3.fromRGB(50, 50, 50)
    MainStroke.Thickness = 1

    -- 3. HEADER (Верхняя полоска)
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Parent = MainFrame
    Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BorderSizePixel = 0

    local Title = Instance.new("TextLabel")
    Title.Parent = Header
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = config.Title or "Menu"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Separator = Instance.new("Frame") -- Линия под шапкой
    Separator.Parent = Header
    Separator.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Separator.BorderSizePixel = 0
    Separator.Position = UDim2.new(0, 0, 1, -1)
    Separator.Size = UDim2.new(1, 0, 0, 1)

    -- 4. SIDEBAR (Левая панель)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.Size = UDim2.new(0, 150, 1, -40)
    Sidebar.BorderSizePixel = 0

    local SidebarLine = Instance.new("Frame") -- Линия справа от сайдбара
    SidebarLine.Parent = Sidebar
    SidebarLine.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SidebarLine.BorderSizePixel = 0
    SidebarLine.Position = UDim2.new(1, -1, 0, 0)
    SidebarLine.Size = UDim2.new(0, 1, 1, 0)

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Parent = Sidebar
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding = UDim.new(0, 5)

    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.Parent = Sidebar
    SidebarPadding.PaddingTop = UDim.new(0, 10)

    -- 5. CONTENT AREA (Место для кнопок справа)
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Parent = MainFrame
    ContentArea.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Position = UDim2.new(0, 160, 0, 50) -- Отступ от сайдбара
    ContentArea.Size = UDim2.new(1, -170, 1, -60)

    -- 6. WINDOW CONTROLS (Свернуть/Закрыть)
    local BtnsFrame = Instance.new("Frame")
    BtnsFrame.Parent = Header
    BtnsFrame.Size = UDim2.new(0, 70, 1, 0)
    BtnsFrame.Position = UDim2.new(1, -70, 0, 0)
    BtnsFrame.BackgroundTransparency = 1

    local function CreateCtrlBtn(txt, col, func)
        local b = Instance.new("TextButton")
        b.Parent = BtnsFrame
        b.Size = UDim2.new(0, 35, 1, 0)
        b.BackgroundTransparency = 1
        b.Text = txt
        b.TextColor3 = Color3.fromRGB(150, 150, 150)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 16
        local list = Instance.new("UIListLayout")
        list.Parent = BtnsFrame
        list.FillDirection = Enum.FillDirection.Horizontal
        
        b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.2), {TextColor3 = col}):Play() end)
        b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play() end)
        b.MouseButton1Click:Connect(func)
    end

    local minimized = false
    CreateCtrlBtn("-", Color3.fromRGB(100, 150, 255), function()
        minimized = not minimized
        if minimized then
            TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 600, 0, 40)}):Play()
            Sidebar.Visible = false
            ContentArea.Visible = false
        else
            Sidebar.Visible = true
            ContentArea.Visible = true
            TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 600, 0, 400)}):Play()
        end
    end)
    CreateCtrlBtn("X", Color3.fromRGB(255, 80, 80), function() ScreenGui:Destroy() end)

    -- 7. DRAGGING
    local dragging, dragStart, startPos
    Header.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true; dragStart=i.Position; startPos=MainFrame.Position end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then local delta=i.Position-dragStart; MainFrame.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y) end end)
    Header.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)

    -- == TAB SYSTEM LOGIC ==
    function Window:Tab(name, iconId)
        local TabObj = {}
        
        -- Кнопка в сайдбаре
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = name
        TabBtn.Parent = Sidebar
        TabBtn.Size = UDim2.new(1, -10, 0, 35) -- Ширина минус отступ
        TabBtn.Position = UDim2.new(0, 5, 0, 0)
        TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = ""
        TabBtn.AutoButtonColor = false

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabBtn

        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Parent = TabBtn
        TabIcon.Position = UDim2.new(0, 10, 0.5, -10)
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = iconId or "rbxassetid://6034509993" -- Дефолт иконка
        TabIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)

        local TabLabel = Instance.new("TextLabel")
        TabLabel.Parent = TabBtn
        TabLabel.Position = UDim2.new(0, 40, 0, 0)
        TabLabel.Size = UDim2.new(1, -40, 1, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = name
        TabLabel.Font = Enum.Font.GothamSemibold
        TabLabel.TextSize = 13
        TabLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left

        -- Страница с контентом (Скролл)
        local Page = Instance.new("ScrollingFrame")
        Page.Name = name.."_Page"
        Page.Parent = ContentArea
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255)
        Page.Visible = false -- Скрыто по умолчанию

        local PageList = Instance.new("UIListLayout")
        PageList.Parent = Page
        PageList.SortOrder = Enum.SortOrder.LayoutOrder
        PageList.Padding = UDim.new(0, 6)

        -- Логика переключения
        TabBtn.MouseButton1Click:Connect(function()
            -- Сброс стилей у всех вкладок
            for _, child in pairs(Sidebar:GetChildren()) do
                if child:IsA("TextButton") then
                    TweenService:Create(child.TextLabel, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                    TweenService:Create(child.ImageLabel, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                    TweenService:Create(child, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                end
            end
            for _, child in pairs(ContentArea:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end

            -- Активация текущей
            TweenService:Create(TabLabel, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(TabIcon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
            Page.Visible = true
        end)

        -- Если это первая вкладка - активируем её сразу
        if SelectedTab == nil then
            SelectedTab = TabBtn
            -- Имитируем клик
            TabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            TabBtn.BackgroundTransparency = 0
            TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Page.Visible = true
        end

        -- == ФУНКЦИИ ВНУТРИ ВКЛАДКИ ==
        function TabObj:Button(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Parent = Page
            Btn.Size = UDim2.new(1, -5, 0, 38)
            Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Btn.AutoButtonColor = false
            Btn.Text = ""
            
            local BtnC = Instance.new("UICorner"); BtnC.CornerRadius = UDim.new(0, 6); BtnC.Parent = Btn
            local BtnS = Instance.new("UIStroke"); BtnS.Parent = Btn; BtnS.Color = Color3.fromRGB(45, 45, 45); BtnS.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            local Lbl = Instance.new("TextLabel")
            Lbl.Parent = Btn
            Lbl.BackgroundTransparency = 1
            Lbl.Position = UDim2.new(0, 15, 0, 0)
            Lbl.Size = UDim2.new(1, -15, 1, 0)
            Lbl.Text = text
            Lbl.Font = Enum.Font.GothamSemibold
            Lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
            Lbl.TextSize = 13
            Lbl.TextXAlignment = Enum.TextXAlignment.Left

            Btn.MouseEnter:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
                TweenService:Create(BtnS, TweenInfo.new(0.2), {Color = Color3.fromRGB(100, 100, 255)}):Play()
            end)
            Btn.MouseLeave:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
                TweenService:Create(BtnS, TweenInfo.new(0.2), {Color = Color3.fromRGB(45, 45, 45)}):Play()
            end)
            Btn.MouseButton1Click:Connect(function() pcall(callback) end)
        end

        function TabObj:Label(text)
            local L = Instance.new("TextLabel")
            L.Parent = Page
            L.Size = UDim2.new(1, 0, 0, 25)
            L.BackgroundTransparency = 1
            L.Text = text
            L.TextColor3 = Color3.fromRGB(100, 100, 100)
            L.Font = Enum.Font.GothamBold
            L.TextSize = 11
            L.TextXAlignment = Enum.TextXAlignment.Left
            L.Position = UDim2.new(0, 5, 0, 0)
        end

        return TabObj
    end

    return Window
end

return Library
