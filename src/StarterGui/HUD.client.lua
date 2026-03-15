local player = game.Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

-- Create the UI Group
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DiveHUD"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- 1. Depth Label
local depthLabel = Instance.new("TextLabel")
depthLabel.Size = UDim2.new(0, 200, 0, 50)
depthLabel.Position = UDim2.new(0.5, -100, 0, 20)
depthLabel.BackgroundTransparency = 0.5
depthLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
depthLabel.TextColor3 = Color3.fromRGB(200, 255, 255)
depthLabel.Font = Enum.Font.GothamBold
depthLabel.TextScaled = true
depthLabel.Parent = screenGui

-- 2. Oxygen Bar Background
local oxygenBkg = Instance.new("Frame")
oxygenBkg.Size = UDim2.new(0, 300, 0, 30)
oxygenBkg.Position = UDim2.new(0.5, -150, 0, 80)
oxygenBkg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
oxygenBkg.Parent = screenGui

-- 3. Oxygen Bar Fill (The blue part)
local oxygenFill = Instance.new("Frame")
oxygenFill.Size = UDim2.new(1, 0, 1, 0)
oxygenFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
oxygenFill.BorderSizePixel = 0
oxygenFill.Parent = oxygenBkg

local oxygenText = Instance.new("TextLabel")
oxygenText.Size = UDim2.new(1, 0, 1, 0)
oxygenText.BackgroundTransparency = 1
oxygenText.TextColor3 = Color3.fromRGB(255, 255, 255)
oxygenText.Font = Enum.Font.GothamBold
oxygenText.TextScaled = true
oxygenText.Parent = oxygenBkg

-- UI Update Loop
RunService.RenderStepped:Connect(function()
    local character = player.Character
    if character then
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        -- Update Depth
        if rootPart then
            local depth = math.floor(math.max(0, -rootPart.Position.Y))
            depthLabel.Text = "Depth: " .. depth .. "m"
        end

        -- Update Oxygen Bar
        local oxygen = character:FindFirstChild("Oxygen")
        local maxOxygen = character:FindFirstChild("MaxOxygen")
        if oxygen and maxOxygen then
            local ratio = math.clamp(oxygen.Value / maxOxygen.Value, 0, 1)
            
            -- Smoothly scale the blue bar
            oxygenFill.Size = UDim2.new(ratio, 0, 1, 0)
            oxygenText.Text = "Oxygen: " .. math.floor(oxygen.Value) .. "s"
            
            -- Turn the bar red if they are drowning
            if oxygen.Value <= 0 then
                oxygenFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                oxygenFill.Size = UDim2.new(1, 0, 1, 0)
                oxygenText.Text = "DROWNING!"
            else
                oxygenFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            end
        end
    end
end)
