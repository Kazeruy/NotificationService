local NotificationLibrary = {}
local TweenService = game:GetService("TweenService")
local CoreGui = cloneref(game:GetService("CoreGui"))
local Loaded = false
local NotificationService, TemplateFolder, Canvas

local LIBRARY_NAME = "NotificationService"
local TWEEN_INFO = {
    OPEN = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    CLOSE = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    FILLER = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
}

local NOTIFICATION_THEMES = {
    Warning = {
        Color = Color3.fromRGB(240, 175, 45),
        Icon = "rbxassetid://7072980286",
        DefaultText = "This action is restricted!"
    },
    Success = {
        Color = Color3.fromRGB(35, 240, 110),
        Icon = "http://www.roblox.com/asset/?id=6023426926",
        DefaultText = "Operation completed successfully!"
    },
    Info = {
        Color = Color3.fromRGB(220, 220, 220),
        Icon = "rbxassetid://113780527875977",
        DefaultText = "Information"
    },
    Error = {
        Color = Color3.fromRGB(255, 70, 73),
        Icon = "rbxassetid://7072725342",
        DefaultText = "An error occurred!"
    }
}

local function createBaseNotification()
    NotificationService = Instance.new("ScreenGui")
    NotificationService.Name = LIBRARY_NAME
    NotificationService.Parent = CoreGui
    NotificationService.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    NotificationService.ResetOnSpawn = false

    Canvas = Instance.new("Frame")
    Canvas.Name = "list"
    Canvas.Parent = NotificationService
    Canvas.AnchorPoint = Vector2.new(0.5, 0.5)
    Canvas.BackgroundTransparency = 1
    Canvas.Position = UDim2.new(0.91, 0, 0.5, 0)
    Canvas.Size = UDim2.new(0.18, 0, 0.87, 0)

    local layout = Instance.new("UIListLayout")
    layout.Parent = Canvas
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)

    TemplateFolder = Instance.new("Folder")
    TemplateFolder.Name = "Templates"
    TemplateFolder.Parent = NotificationService
end

local function createNotificationTemplate(themeName, themeData)
    local template = Instance.new("Frame")
    template.Name = themeName
    template.Parent = TemplateFolder
    template.AnchorPoint = Vector2.new(0.5, 0.5)
    template.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    template.Size = UDim2.new(1, 0, 0.086, 0)
    template.Visible = false

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(31, 31, 31)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(81, 81, 81))
    }
    gradient.Rotation = 25
    gradient.Parent = template

    local corner = Instance.new("UICorner")
    corner.Parent = template

    local header = Instance.new("TextLabel")
    header.Name = "Header"
    header.Parent = template
    header.AnchorPoint = Vector2.new(0.5, 0.5)
    header.BackgroundTransparency = 1
    header.Position = UDim2.new(0.592, 0, 0.494, 0)
    header.Size = UDim2.new(0.789, 0, 0.648, 0)
    header.ZIndex = 2
    header.Font = Enum.Font.FredokaOne
    header.Text = themeData.DefaultText
    header.TextColor3 = themeData.Color
    header.TextScaled = true
    header.TextSize = 14
    header.TextWrapped = true
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.TextYAlignment = Enum.TextYAlignment.Top

    local textConstraint = Instance.new("UITextSizeConstraint")
    textConstraint.MaxTextSize = 20
    textConstraint.Parent = header

    local decal = Instance.new("Frame")
    decal.Name = "decal"
    decal.Parent = template
    decal.BackgroundTransparency = 1
    decal.Size = UDim2.new(1, 0, 1, 0)
    decal.ZIndex = 0

    local shadow = Instance.new("ImageLabel")
    shadow.Name = "background_shadow"
    shadow.Parent = decal
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1.128, 0, 1.864, 0)
    shadow.ZIndex = 0
    shadow.Image = "rbxassetid://3523728077"
    shadow.ImageColor3 = Color3.fromRGB(24, 24, 24)
    shadow.ImageTransparency = 0.7

    local shadowAspect = Instance.new("UIAspectRatioConstraint")
    shadowAspect.AspectRatio = 2.669
    shadowAspect.Parent = shadow

    local shadowCorner = Instance.new("UICorner")
    shadowCorner.Parent = shadow

    local icon = Instance.new("ImageLabel")
    icon.Name = "icon"
    icon.Parent = decal
    icon.AnchorPoint = Vector2.new(0.5, 0.5)
    icon.BackgroundTransparency = 1
    icon.Position = UDim2.new(0.09, 0, 0.485, 0)
    icon.Size = UDim2.new(0.09, 0, 0.485, 0)
    icon.Image = themeData.Icon
    icon.ImageColor3 = themeData.Color
    icon.ScaleType = Enum.ScaleType.Fit

    local iconAspect = Instance.new("UIAspectRatioConstraint")
    iconAspect.AspectRatio = 1.008
    iconAspect.Parent = icon

    local iconCorner = Instance.new("UICorner")
    iconCorner.Parent = icon

    local decalCorner = Instance.new("UICorner")
    decalCorner.Parent = decal

    local filler = Instance.new("Frame")
    filler.Name = "Filler"
    filler.Parent = template
    filler.AnchorPoint = Vector2.new(1, 0.5)
    filler.BackgroundColor3 = themeData.Color
    filler.Position = UDim2.new(1, 0, 0.5, 0)
    filler.Size = UDim2.new(0.011, 0, 1, 0)
    filler.ZIndex = 3

    local fillerCorner = Instance.new("UICorner")
    fillerCorner.Parent = filler

    local bar = Instance.new("Frame")
    bar.Name = "bar"
    bar.Parent = template
    bar.AnchorPoint = Vector2.new(1, 0.5)
    bar.BackgroundColor3 = themeData.Color
    bar.Position = UDim2.new(1, 0, 1, 0)
    bar.Size = UDim2.new(0.01, 0, 0.05, 0)
    bar.ZIndex = 3

    local barCorner = Instance.new("UICorner")
    barCorner.Parent = bar

    return template
end

function NotificationLibrary:Load()
    if Loaded then return end
    Loaded = true

    createBaseNotification()
    
    for themeName, themeData in pairs(NOTIFICATION_THEMES) do
        createNotificationTemplate(themeName, themeData)
    end
end

function NotificationLibrary:SendNotification(mode, text, duration)
    if not Loaded then
        self:Load()
    end

    duration = duration or 3

    if not TemplateFolder:FindFirstChild(mode) then
        warn("Invalid notification theme: " .. tostring(mode))
        return
    end

    task.spawn(function()
        local success, err = pcall(function()
            local notification = TemplateFolder[mode]:Clone()
            local filler = notification.Filler
            local bar = notification.bar
            notification.Header.Text = text
            notification.Visible = true
            notification.Parent = Canvas
            notification.Size = UDim2.new(0, 0, 0.087, 0)

            TweenService:Create(notification, TWEEN_INFO.OPEN, {Size = UDim2.new(1, 0, 0.087, 0)}):Play()
            task.wait(0.2)
            
            TweenService:Create(filler, TWEEN_INFO.FILLER, {Size = UDim2.new(0.011, 0, 1, 0)}):Play()
            TweenService:Create(bar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
                Size = UDim2.new(1, 0, 0.05, 0)
            }):Play()

            task.wait(duration)

            TweenService:Create(filler, TWEEN_INFO.OPEN, {Size = UDim2.new(1, 0, 1, 0)}):Play()
            task.wait(0.25)
            TweenService:Create(notification, TWEEN_INFO.CLOSE, {Size = UDim2.new(0, 0, 0.087, 0)}):Play()
            task.wait(0.3)
            notification:Destroy()
        end)

        if not success then
            warn("Error creating notification: " .. tostring(err))
        end
    end)
end

return NotificationLibrary
