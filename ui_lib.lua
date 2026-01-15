--[[ 
    PREMIUM UI LIBRARY v2
    Design: Dark Modern + Animations
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Library = {}

function Library:CreateWindow(config)
    local UI = {}
    local TitleText = config.Title or "Menu"
    
    -- Удаляем старое
    if CoreGui:FindFirstChild(config.Name) then
        CoreGui[config.Name]:Destroy()
    end

    -- 1. SCREEN GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = config.Name
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- 2. MAIN FRAME (Основа)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 550, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true -- Важно для сворачивания!
    MainFrame.Parent = ScreenGui

    -- Обводка (Stroke)
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Parent = MainFrame
    MainStroke.Color = Color3.fromRGB(60, 60, 60)
    MainStroke.Thickness = 1

    -- Закругление
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame

    -- 3. HEADER (Шапка)
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Parent = MainFrame
    Header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Header.BorderSizePixel = 0
    Header.Size = UDim2.new(1, 0, 0, 45)

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 8)
    HeaderCorner.Parent = Header
    
    -- Исправление углов шапки снизу (чтобы не было круглых дырок при стыке)
    local HeaderCover = Instance.new("Frame")
    HeaderCover.Parent = Header
    HeaderCover.BorderSizePixel = 0
    HeaderCover.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    HeaderCover.Size = UDim2.new(1, 0, 0, 10)
    HeaderCover.Position = UDim2.new(0, 0, 1, -10)

    -- Заголовок
    local Title = Instance.new("TextLabel")
    Title.Parent = Header
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = TitleText
    Title.TextColor3 = Color3.fromRGB(240, 240, 240)
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Градиент для текста заголовка (Красота)
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 255))
    }
    UIGradient.Parent = Title

    -- 4. CONTAINER (Контент)
    local Container = Instance.new("ScrollingFrame")
    Container.Name = "Container"
    Container.Parent = MainFrame
    Container.Active = true
    Container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Container.BackgroundTransparency = 1
    Container.BorderSizePixel = 0
    Container.Position = UDim2.new(0, 15, 0, 60)
    Container.Size = UDim2.new(1, -30, 1, -75)
    Container.ScrollBarThickness = 2
    Container.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255)

    local UIList = Instance.new("UIListLayout")
    UIList.Parent = Container
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0, 8)

    -- 5. HEADER BUTTONS (Кнопки управления)
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Parent = Header
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Size = UDim2.new(0, 80, 1, 0)
    ButtonContainer.Position = UDim2.new(1, -85, 0, 0)

    local function CreateHeaderBtn(symbol, color, callback)
        local btn = Instance.new("TextButton")
        btn.Parent = ButtonContainer
        btn.BackgroundTransparency = 1
        btn.Size = UDim2.new(0, 40, 1, 0)
        btn.Font = Enum.Font.GothamBold
        btn.Text = symbol
        btn.TextColor3 = Color3.fromRGB(150, 150, 150)
        btn.TextSize = 18

        local btnLayout = Instance.new("UIListLayout")
        btnLayout.Parent = ButtonContainer
        btnLayout.FillDirection = Enum.FillDirection.Horizontal
        btnLayout.SortOrder = Enum.SortOrder.LayoutOrder

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.3), {TextColor3 = color}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
        end)
        btn.MouseButton1Click:Connect(callback)
    end

    -- Логика Сворачивания
    local minimized = false
    local openSize = UDim2.new(0, 550, 0, 400)
    local miniSize = UDim2.new(0, 550, 0, 45)

    CreateHeaderBtn("-", Color3.fromRGB(100, 150, 255), function()
        minimized = not minimized
        if minimized then
            TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = miniSize}):Play()
            Container.Visible = false
        else
            Container.Visible = true
            TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = openSize}):Play()
        end
    end)

    -- Логика Закрытия
    CreateHeaderBtn("X", Color3.fromRGB(255, 80, 80), function()
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 550, 0, 0)}):Play()
        wait(0.25)
        ScreenGui:Destroy()
    end)

    -- 6. DRAG SCRIPT
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = MainFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    Header.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)


    -- 7. FUNCTION FOR BUTTONS (Функции меню)
    function UI:Button(text, callback)
        local BtnFrame = Instance.new("TextButton")
        BtnFrame.Parent = Container
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

        -- Иконка стрелочки
        local Arrow = Instance.new("ImageLabel")
        Arrow.Parent = BtnFrame
        Arrow.BackgroundTransparency = 1
        Arrow.Position = UDim2.new(1, -30, 0.5, -10)
        Arrow.Size = UDim2.new(0, 20, 0, 20)
        Arrow.Image = "rbxassetid://6034818372" -- Стрелочка
        Arrow.ImageColor3 = Color3.fromRGB(100, 100, 100)

        -- Анимации наведения
        BtnFrame.MouseEnter:Connect(function()
            TweenService:Create(BtnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
            TweenService:Create(BtnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(100, 100, 255)}):Play() -- Подсветка границы
            TweenService:Create(Arrow, TweenInfo.new(0.2), {Position = UDim2.new(1, -25, 0.5, -10), ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)

        BtnFrame.MouseLeave:Connect(function()
            TweenService:Create(BtnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
            TweenService:Create(BtnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(50, 50, 50)}):Play()
            TweenService:Create(Arrow, TweenInfo.new(0.2), {Position = UDim2.new(1, -30, 0.5, -10), ImageColor3 = Color3.fromRGB(100, 100, 100)}):Play()
        end)

        BtnFrame.MouseButton1Click:Connect(function()
            -- Эффект клика (Bounce)
            TweenService:Create(BtnFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, -4, 0, 36)}):Play()
            wait(0.1)
            TweenService:Create(BtnFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 40)}):Play()
            pcall(callback)
        end)
    end

    function UI:Label(text)
        local Lab = Instance.new("TextLabel")
        Lab.Parent = Container
        Lab.Size = UDim2.new(1, 0, 0, 25)
        Lab.BackgroundTransparency = 1
        Lab.Text = text
        Lab.TextColor3 = Color3.fromRGB(150, 150, 150)
        Lab.Font = Enum.Font.GothamBold
        Lab.TextSize = 12
        Lab.TextXAlignment = Enum.TextXAlignment.Left
        Lab.Position = UDim2.new(0, 5, 0, 0)
    end

    return UI
end

return Library
