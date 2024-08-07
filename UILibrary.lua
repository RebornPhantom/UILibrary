local UILibrary = {}

local UIS = game:GetService("UserInputService")

function UILibrary:CreateScreenGui(name)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = name or "ScreenGui"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    return screenGui
end

function UILibrary:CreateFrame(parent, size, position, backgroundColor)
    local frame = Instance.new("Frame")
    frame.Size = size or UDim2.new(0, 300, 0, 250)
    frame.Position = position or UDim2.new(0.5, -150, 0.5, -125)
    frame.BackgroundColor3 = backgroundColor or Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    local shadow = Instance.new("ImageLabel")
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 6)
    shadow.Size = UDim2.new(1, 18, 1, 18)
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.BackgroundTransparency = 1
    shadow.ZIndex = 0
    shadow.Parent = frame

    return frame
end

function UILibrary:CreateTextLabel(parent, size, position, text, backgroundColor)
    local label = Instance.new("TextLabel")
    label.Size = size or UDim2.new(1, 0, 0, 50)
    label.Position = position or UDim2.new(0, 0, 0, 0)
    label.BackgroundColor3 = backgroundColor or Color3.fromRGB(30, 30, 30)
    label.BorderSizePixel = 0
    label.Text = text or "Label"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 24
    label.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = label
    
    return label
end

function UILibrary:CreateTextButton(parent, size, position, text, backgroundColor)
    local button = Instance.new("TextButton")
    button.Size = size or UDim2.new(0.8, 0, 0, 40)
    button.Position = position or UDim2.new(0.1, 0, 0.5, 0)
    button.BackgroundColor3 = backgroundColor or Color3.fromRGB(60, 60, 60)
    button.BorderSizePixel = 0
    button.Text = text or "Button"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 18
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = button
    
    return button
end

function UILibrary:CreateBody(name)
    local screenGui = self:CreateScreenGui(name or "ControlGui")
    local frame = self:CreateFrame(screenGui, UDim2.new(0, 300, 0, 250), UDim2.new(1, -320, 0, 10), Color3.fromRGB(40, 40, 40))
    frame.AnchorPoint = Vector2.new(1, 0)
    frame.Active = true
    frame.Draggable = true

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 45)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 25))
    }
    gradient.Rotation = 90
    gradient.Parent = frame

    local title = self:CreateTextLabel(frame, UDim2.new(1, 0, 0, 50), UDim2.new(0, 0, 0, 0), "Control Panel", Color3.fromRGB(30, 30, 30))
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24

    local collapseButton = self:CreateTextButton(frame, UDim2.new(0, 50, 0, 50), UDim2.new(1, -50, 0, 0), "-", Color3.fromRGB(30, 30, 30))
    collapseButton.Font = Enum.Font.GothamBold
    collapseButton.TextSize = 24

    collapseButton.MouseButton1Click:Connect(function()
        frame.Visible = not frame.Visible
        collapseButton.Text = frame.Visible and "-" or "+"
    end)

    return screenGui, frame
end

function UILibrary:CreateSector(parent, name)
    local sector = self:CreateFrame(parent, UDim2.new(1, -20, 0, 50), UDim2.new(0.5, 0, 0.5, 0), Color3.fromRGB(50, 50, 50))
    sector.Name = name or "Sector"
    sector.Visible = false

    local sectorTitle = self:CreateTextLabel(sector, UDim2.new(1, 0, 0, 50), UDim2.new(0, 0, 0, 0), name, Color3.fromRGB(40, 40, 40))
    sectorTitle.Font = Enum.Font.GothamBold
    sectorTitle.TextSize = 20

    return sector
end

function UILibrary:CreateButton(sector, name, text, callback)
    local button = self:CreateTextButton(sector, UDim2.new(0.8, 0, 0, 40), UDim2.new(0.1, 0, 0.5, 0), text or "Button", Color3.fromRGB(60, 60, 60))
    button.Name = name
    button.MouseButton1Click:Connect(callback)
    return button
end

function UILibrary:CreateKeybindButton(sector, name, text, initialKey, callback)
    local button = self:CreateTextButton(sector, UDim2.new(0.8, 0, 0, 40), UDim2.new(0.1, 0, 0.5, 0), text or "Set Keybind", Color3.fromRGB(60, 60, 60))
    button.Name = name

    local keybind = initialKey or Enum.KeyCode.Unknown
    local listening = false

    local function updateButtonText()
        button.Text = keybind ~= Enum.KeyCode.Unknown and "Keybind: " .. keybind.Name or "Set Keybind"
    end

    updateButtonText()

    button.MouseButton1Click:Connect(function()
        button.Text = "Press any key..."
        listening = true
    end)

    UIS.InputBegan:Connect(function(input)
        if listening and input.UserInputType == Enum.UserInputType.Keyboard then
            keybind = input.KeyCode
            listening = false
            updateButtonText()
            callback(keybind)
        end
    end)

    UIS.InputBegan:Connect(function(input)
        if input.KeyCode == keybind then
            callback(keybind)
        end
    end)

    return button
end

return UILibrary
