--[[ 
    MODERN UI LIBRARY v6 (Refined & Animated)
    Features: Sections, Dropdowns, Smooth Animations, Modern Look
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Library = {}

--// Theme Configuration
local Theme = {
    Main = Color3.fromRGB(18, 18, 18),       -- Main Background
    Sidebar = Color3.fromRGB(24, 24, 24),    -- Sidebar
    Section = Color3.fromRGB(30, 30, 30),    -- Card Background
    Text = Color3.fromRGB(240, 240, 240),    -- Main Text
    SubText = Color3.fromRGB(160, 160, 160), -- Dimmed Text
    Accent = Color3.fromRGB(114, 137, 218),  -- Accent Color (Blurple-ish)
    Border = Color3.fromRGB(50, 50, 50),     -- Borders
    Hover = Color3.fromRGB(40, 40, 40),      -- Hover State
    Success = Color3.fromRGB(100, 255, 100)
}

--// Utility Functions
local function MakeDraggable(topbar, object)
    local dragging, dragInput, dragStart, startPos
    
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local smoothCoef = 0.2 -- Smooth drag
            local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            TweenService:Create(object, TweenInfo.new(0.1), {Position = targetPos}):Play()
        end
    end)
end

local function Tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

--// Main Function
function Library:CreateWindow(config)
    local UI = {}
    config.Name = config.Name or "ModernUI"
    config.Title = config.Title or "UI Library"

    if CoreGui:FindFirstChild(config.Name) then
        CoreGui[config.Name]:Destroy()
    end

    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = config.Name
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 0, 0, 0) -- Start small for animation
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Theme.Main
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui

    -- Borders & Corners
    local MainCorner = Instance.new("UICorner", Main); MainCorner.CornerRadius = UDim.new(0, 10)
    local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = Theme.Border; MainStroke.Thickness = 1

    -- Shadow
    local Shadow = Instance.new("ImageLabel", ScreenGui)
    Shadow.ZIndex = -1
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.new(0,0,0)
    Shadow.ImageTransparency = 0.4
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.Position = UDim2.new(0, -20, 0, -20)
    Shadow.Parent = Main
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23,23,277,277)

    -- Sidebar
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.Size = UDim2.new(0, 60, 1, 0)
    Sidebar.BorderSizePixel = 0
    local SidebarCorner = Instance.new("UICorner", Sidebar); SidebarCorner.CornerRadius = UDim.new(0, 10)
    -- Fix corner overlap
    local SidebarFix = Instance.new("Frame", Sidebar)
    SidebarFix.BorderSizePixel = 0; SidebarFix.BackgroundColor3 = Theme.Sidebar; SidebarFix.Size = UDim2.new(0, 10, 1, 0); SidebarFix.Position = UDim2.new(1, -10, 0, 0)

    -- Content Area
    local Content = Instance.new("Frame", Main)
    Content.BackgroundColor3 = Theme.Main
    Content.BackgroundTransparency = 1
    Content.Size = UDim2.new(1, -60, 1, -40)
    Content.Position = UDim2.new(0, 60, 0, 40)
    Content.ClipsDescendants = true

    -- Header (Title)
    local Header = Instance.new("Frame", Main)
    Header.BackgroundTransparency = 1
    Header.Size = UDim2.new(1, -60, 0, 40)
    Header.Position = UDim2.new(0, 60, 0, 0)

    local Title = Instance.new("TextLabel", Header)
    Title.Text = config.Title
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextColor3 = Theme.Text
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Close Button
    local CloseBtn = Instance.new("TextButton", Header)
    CloseBtn.Text = "×"
    CloseBtn.Font = Enum.Font.GothamMedium
    CloseBtn.TextSize = 24
    CloseBtn.TextColor3 = Theme.SubText
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Size = UDim2.new(0, 40, 1, 0)
    CloseBtn.Position = UDim2.new(1, -40, 0, 0)
    CloseBtn.MouseButton1Click:Connect(function()
        Tween(Main, {Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1}, 0.2)
        wait(0.2)
        ScreenGui:Destroy()
    end)
    CloseBtn.MouseEnter:Connect(function() Tween(CloseBtn, {TextColor3 = Color3.fromRGB(255, 80, 80)}) end)
    CloseBtn.MouseLeave:Connect(function() Tween(CloseBtn, {TextColor3 = Theme.SubText}) end)

    -- Tab Container
    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Size = UDim2.new(1, 0, 1, -20)
    TabContainer.Position = UDim2.new(0, 0, 0, 10)
    TabContainer.ScrollBarThickness = 0
    
    local TabList = Instance.new("UIListLayout", TabContainer)
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabList.Padding = UDim.new(0, 15)

    -- Init Animation
    local targetSize = UDim2.new(0, 650, 0, 450)
    TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = targetSize}):Play()
    MakeDraggable(Header, Main)

    -- Tabs System
    local tabs = {}
    local first = true

    function UI:Tab(name, iconId)
        local Tab = {}
        
        -- Tab Button
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Text = ""
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(0, 40, 0, 40)
        
        local TabIcon = Instance.new("ImageLabel", TabBtn)
        TabIcon.Size = UDim2.new(0, 24, 0, 24)
        TabIcon.Position = UDim2.new(0.5, -12, 0.5, -12)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = iconId
        TabIcon.ImageColor3 = Theme.SubText
        
        local ActiveLine = Instance.new("Frame", TabBtn)
        ActiveLine.Size = UDim2.new(0, 3, 0, 0)
        ActiveLine.Position = UDim2.new(0, 0, 0.5, 0)
        ActiveLine.BackgroundColor3 = Theme.Accent
        ActiveLine.BorderSizePixel = 0
        ActiveLine.AnchorPoint = Vector2.new(0, 0.5)

        -- Page
        local Page = Instance.new("ScrollingFrame", Content)
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.ScrollBarThickness = 4
        Page.ScrollBarImageColor3 = Theme.Border
        Page.Visible = false
        Page.CanvasSize = UDim2.new(0, 0, 0, 0) -- Auto Resize later
        
        local PagePadding = Instance.new("UIPadding", Page)
        PagePadding.PaddingLeft = UDim.new(0, 15)
        PagePadding.PaddingRight = UDim.new(0, 15)
        PagePadding.PaddingTop = UDim.new(0, 15)
        PagePadding.PaddingBottom = UDim.new(0, 15)
        
        local PageList = Instance.new("UIListLayout", Page)
        PageList.Padding = UDim.new(0, 10)
        PageList.SortOrder = Enum.SortOrder.LayoutOrder

        PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 30)
        end)

        -- Activate Logic
        local function Activate()
            for _, t in pairs(tabs) do
                Tween(t.Icon, {ImageColor3 = Theme.SubText})
                Tween(t.Line, {Size = UDim2.new(0, 3, 0, 0)})
                t.Page.Visible = false
            end
            Tween(TabIcon, {ImageColor3 = Theme.Accent})
            Tween(ActiveLine, {Size = UDim2.new(0, 3, 0, 20)})
            Page.Visible = true
        end
        
        TabBtn.MouseButton1Click:Connect(Activate)
        table.insert(tabs, {Btn = TabBtn, Icon = TabIcon, Line = ActiveLine, Page = Page})

        if first then Activate(); first = false end

        -- SECTION (Container)
        function Tab:Section(title)
            local SectionObj = {}
            
            local SectionFrame = Instance.new("Frame", Page)
            SectionFrame.BackgroundColor3 = Theme.Section
            SectionFrame.Size = UDim2.new(1, 0, 0, 0) -- Auto resized
            local SecCorner = Instance.new("UICorner", SectionFrame); SecCorner.CornerRadius = UDim.new(0, 6)
            local SecStroke = Instance.new("UIStroke", SectionFrame); SecStroke.Color = Theme.Border; SecStroke.Thickness = 1
            
            local SecTitle = Instance.new("TextLabel", SectionFrame)
            SecTitle.Text = title:upper()
            SecTitle.Font = Enum.Font.GothamBold
            SecTitle.TextSize = 11
            SecTitle.TextColor3 = Theme.SubText
            SecTitle.BackgroundTransparency = 1
            SecTitle.Size = UDim2.new(1, -20, 0, 20)
            SecTitle.Position = UDim2.new(0, 10, 0, 5)
            SecTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local Container = Instance.new("Frame", SectionFrame)
            Container.BackgroundTransparency = 1
            Container.Size = UDim2.new(1, 0, 0, 0)
            Container.Position = UDim2.new(0, 0, 0, 25)
            
            local ContainerList = Instance.new("UIListLayout", Container)
            ContainerList.Padding = UDim.new(0, 5)
            ContainerList.HorizontalAlignment = Enum.HorizontalAlignment.Center
            ContainerList.SortOrder = Enum.SortOrder.LayoutOrder
            
            -- Auto Resize Section
            local function Resize()
                Container.Size = UDim2.new(1, 0, 0, ContainerList.AbsoluteContentSize.Y + 10)
                SectionFrame.Size = UDim2.new(1, 0, 0, ContainerList.AbsoluteContentSize.Y + 35)
            end
            ContainerList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(Resize)

            -- ELEMENTS
            
            function SectionObj:Button(text, callback)
                local Btn = Instance.new("TextButton", Container)
                Btn.Text = ""
                Btn.BackgroundColor3 = Theme.Main
                Btn.Size = UDim2.new(1, -20, 0, 35)
                Btn.AutoButtonColor = false
                local BCorner = Instance.new("UICorner", Btn); BCorner.CornerRadius = UDim.new(0, 4)
                
                local BTitle = Instance.new("TextLabel", Btn)
                BTitle.Text = text
                BTitle.Font = Enum.Font.GothamSemibold
                BTitle.TextSize = 13
                BTitle.TextColor3 = Theme.Text
                BTitle.BackgroundTransparency = 1
                BTitle.Size = UDim2.new(1, 0, 1, 0)
                
                Btn.MouseEnter:Connect(function() Tween(Btn, {BackgroundColor3 = Theme.Hover}) end)
                Btn.MouseLeave:Connect(function() Tween(Btn, {BackgroundColor3 = Theme.Main}) end)
                Btn.MouseButton1Click:Connect(function()
                    local circle = Instance.new("ImageLabel", Btn)
                    circle.Image = "rbxassetid://266543268"
                    circle.ImageColor3 = Color3.new(1,1,1)
                    circle.ImageTransparency = 0.8
                    circle.BackgroundTransparency = 1
                    circle.Size = UDim2.new(0,0,0,0)
                    circle.Position = UDim2.new(0.5,0,0.5,0)
                    circle.AnchorPoint = Vector2.new(0.5,0.5)
                    Tween(circle, {Size = UDim2.new(1.5,0,1.5,0), ImageTransparency = 1}, 0.5)
                    game:GetService("Debris"):AddItem(circle, 0.5)
                    pcall(callback)
                end)
                Resize()
            end

            function SectionObj:Toggle(text, default, callback)
                local active = default or false
                local ToggleBtn = Instance.new("TextButton", Container)
                ToggleBtn.Text = ""
                ToggleBtn.BackgroundColor3 = Theme.Main
                ToggleBtn.Size = UDim2.new(1, -20, 0, 35)
                ToggleBtn.AutoButtonColor = false
                local TCorner = Instance.new("UICorner", ToggleBtn); TCorner.CornerRadius = UDim.new(0, 4)
                
                local TText = Instance.new("TextLabel", ToggleBtn)
                TText.Text = text
                TText.Font = Enum.Font.GothamSemibold
                TText.TextSize = 13
                TText.TextColor3 = Theme.Text
                TText.BackgroundTransparency = 1
                TText.Position = UDim2.new(0, 10, 0, 0)
                TText.Size = UDim2.new(1, -50, 1, 0)
                TText.TextXAlignment = Enum.TextXAlignment.Left
                
                local Switch = Instance.new("Frame", ToggleBtn)
                Switch.Size = UDim2.new(0, 36, 0, 18)
                Switch.Position = UDim2.new(1, -46, 0.5, -9)
                Switch.BackgroundColor3 = active and Theme.Accent or Color3.fromRGB(50, 50, 50)
                local SCorner = Instance.new("UICorner", Switch); SCorner.CornerRadius = UDim.new(1, 0)
                
                local Dot = Instance.new("Frame", Switch)
                Dot.Size = UDim2.new(0, 14, 0, 14)
                Dot.Position = active and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                local DCorner = Instance.new("UICorner", Dot); DCorner.CornerRadius = UDim.new(1, 0)
                
                ToggleBtn.MouseButton1Click:Connect(function()
                    active = not active
                    Tween(Switch, {BackgroundColor3 = active and Theme.Accent or Color3.fromRGB(50, 50, 50)})
                    Tween(Dot, {Position = active and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)})
                    pcall(callback, active)
                end)
                Resize()
            end

            function SectionObj:Slider(text, min, max, default, callback)
                local val = default or min
                local SliderFrame = Instance.new("Frame", Container)
                SliderFrame.BackgroundColor3 = Theme.Main
                SliderFrame.Size = UDim2.new(1, -20, 0, 50)
                local SCorner = Instance.new("UICorner", SliderFrame); SCorner.CornerRadius = UDim.new(0, 4)
                
                local Title = Instance.new("TextLabel", SliderFrame)
                Title.Text = text
                Title.Font = Enum.Font.GothamSemibold
                Title.TextColor3 = Theme.Text
                Title.TextSize = 13
                Title.BackgroundTransparency = 1
                Title.Position = UDim2.new(0, 10, 0, 8)
                Title.TextXAlignment = Enum.TextXAlignment.Left
                
                local ValueLabel = Instance.new("TextLabel", SliderFrame)
                ValueLabel.Text = tostring(val)
                ValueLabel.Font = Enum.Font.GothamBold
                ValueLabel.TextColor3 = Theme.SubText
                ValueLabel.TextSize = 13
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Size = UDim2.new(0, 30, 0, 20)
                ValueLabel.Position = UDim2.new(1, -40, 0, 8)
                
                local Bar = Instance.new("TextButton", SliderFrame)
                Bar.Text = ""
                Bar.AutoButtonColor = false
                Bar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                Bar.Size = UDim2.new(1, -20, 0, 6)
                Bar.Position = UDim2.new(0, 10, 0, 35)
                local BCorner = Instance.new("UICorner", Bar); BCorner.CornerRadius = UDim.new(1, 0)
                
                local Fill = Instance.new("Frame", Bar)
                Fill.BackgroundColor3 = Theme.Accent
                Fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
                local FCorner = Instance.new("UICorner", Fill); FCorner.CornerRadius = UDim.new(1, 0)
                
                local dragging = false
                local function Update(input)
                    local percent = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    local value = math.floor(min + (max - min) * percent)
                    Tween(Fill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.1)
                    ValueLabel.Text = tostring(value)
                    pcall(callback, value)
                end
                
                Bar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        Update(input)
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        Update(input)
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)
                Resize()
            end

            function SectionObj:Dropdown(text, options, callback)
                local Dropdown = {}
                local expanded = false
                
                local DropFrame = Instance.new("TextButton", Container)
                DropFrame.Text = ""
                DropFrame.BackgroundColor3 = Theme.Main
                DropFrame.Size = UDim2.new(1, -20, 0, 35)
                DropFrame.AutoButtonColor = false
                local DCorner = Instance.new("UICorner", DropFrame); DCorner.CornerRadius = UDim.new(0, 4)
                
                local DText = Instance.new("TextLabel", DropFrame)
                DText.Text = text .. "..."
                DText.Font = Enum.Font.GothamSemibold
                DText.TextSize = 13
                DText.TextColor3 = Theme.Text
                DText.BackgroundTransparency = 1
                DText.Position = UDim2.new(0, 10, 0, 0)
                DText.Size = UDim2.new(1, -40, 0, 35)
                DText.TextXAlignment = Enum.TextXAlignment.Left
                
                local Arrow = Instance.new("ImageLabel", DropFrame)
                Arrow.Image = "rbxassetid://6034818372"
                Arrow.Size = UDim2.new(0, 16, 0, 16)
                Arrow.Position = UDim2.new(1, -26, 0.5, -8)
                Arrow.BackgroundTransparency = 1
                Arrow.ImageColor3 = Theme.SubText
                
                local ListFrame = Instance.new("Frame", Container)
                ListFrame.BackgroundColor3 = Theme.Main
                ListFrame.Size = UDim2.new(1, -20, 0, 0)
                ListFrame.Visible = false
                ListFrame.ClipsDescendants = true
                local LCorner = Instance.new("UICorner", ListFrame); LCorner.CornerRadius = UDim.new(0, 4)
                
                local OptionList = Instance.new("UIListLayout", ListFrame)
                OptionList.SortOrder = Enum.SortOrder.LayoutOrder
                
                for _, opt in pairs(options) do
                    local OptBtn = Instance.new("TextButton", ListFrame)
                    OptBtn.Text = opt
                    OptBtn.Font = Enum.Font.Gotham
                    OptBtn.TextSize = 12
                    OptBtn.TextColor3 = Theme.SubText
                    OptBtn.Size = UDim2.new(1, 0, 0, 30)
                    OptBtn.BackgroundColor3 = Theme.Main
                    OptBtn.AutoButtonColor = false
                    
                    OptBtn.MouseEnter:Connect(function() Tween(OptBtn, {BackgroundColor3 = Theme.Hover, TextColor3 = Theme.Text}) end)
                    OptBtn.MouseLeave:Connect(function() Tween(OptBtn, {BackgroundColor3 = Theme.Main, TextColor3 = Theme.SubText}) end)
                    
                    OptBtn.MouseButton1Click:Connect(function()
                        expanded = false
                        DText.Text = text .. ": " .. opt
                        ListFrame.Visible = false
                        Tween(Arrow, {Rotation = 0})
                        Resize()
                        pcall(callback, opt)
                    end)
                end
                
                DropFrame.MouseButton1Click:Connect(function()
                    expanded = not expanded
                    ListFrame.Visible = expanded
                    local height = expanded and (#options * 30) or 0
                    ListFrame.Size = UDim2.new(1, -20, 0, height)
                    Tween(Arrow, {Rotation = expanded and 180 or 0})
                    Resize()
                end)
                
                Resize()
            end

            return SectionObj
        end
        return Tab
    end
    return UI
end

return Library
