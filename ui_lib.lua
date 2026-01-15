-- UILibrary.lua (Представь, что это лежит на GitHub)
local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

function Library:CreateWindow(cfg)
    local UI = {}
    
    -- 1. Создаем ScreenGui (Защита от повтора)
    if CoreGui:FindFirstChild(cfg.Name) then CoreGui[cfg.Name]:Destroy() end
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = cfg.Name
    ScreenGui.Parent = CoreGui
    
    -- 2. Основной фрейм
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "Main"
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.Parent = ScreenGui
    
    -- Делаем красиво (Закругления)
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = MainFrame

    -- Заголовок
    local Title = Instance.new("TextLabel")
    Title.Text = cfg.Title or "Menu"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Size = UDim2.new(1, -20, 0, 40)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = MainFrame

    -- Контейнер для кнопок
    local Container = Instance.new("ScrollingFrame")
    Container.Position = UDim2.new(0, 10, 0, 50)
    Container.Size = UDim2.new(1, -20, 1, -60)
    Container.BackgroundTransparency = 1
    Container.BorderSizePixel = 0
    Container.Parent = MainFrame
    
    local UIList = Instance.new("UIListLayout")
    UIList.Parent = Container
    UIList.Padding = UDim.new(0, 5)

    -- Перетаскивание (Drag Function)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = MainFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)

    -- === МЕТОДЫ ОКНА === --
    
    -- Функция добавления кнопки
    function UI:Button(text, callback)
        local Btn = Instance.new("TextButton")
        Btn.Parent = Container
        Btn.Size = UDim2.new(1, 0, 0, 35)
        Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Btn.Text = text
        Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        Btn.Font = Enum.Font.GothamSemibold
        Btn.TextSize = 14
        
        local BtnCorner = Instance.new("UICorner"); BtnCorner.Parent = Btn
        
        Btn.MouseButton1Click:Connect(function()
            pcall(callback)
            TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
            wait(0.1)
            TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
        end)
    end

    return UI
end

return Library -- Самое важное! Мы возвращаем таблицу.
