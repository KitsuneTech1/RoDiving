local player = game.Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GachaRollRemote = ReplicatedStorage:WaitForChild("GachaRollRequest")

-- Hook into existing ScreenGui
local screenGui = PlayerGui:WaitForChild("DiveHUD")

-- Create Shop Panel
local shopFrame = Instance.new("Frame")
shopFrame.Size = UDim2.new(0, 300, 0, 400)
shopFrame.Position = UDim2.new(1, -320, 0.5, -200)
shopFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
shopFrame.BorderSizePixel = 0
shopFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Text = "Deep Sea Gacha"
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.Font = Enum.Font.GothamBlack
title.TextSize = 24
title.Parent = shopFrame

-- Gacha Button
local rollButton = Instance.new("TextButton")
rollButton.Size = UDim2.new(0.8, 0, 0, 60)
rollButton.Position = UDim2.new(0.1, 0, 0.8, 0)
rollButton.Text = "Roll Gear (500 Coins)"
rollButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
rollButton.TextColor3 = Color3.fromRGB(255, 255, 255)
rollButton.Font = Enum.Font.GothamBold
rollButton.TextSize = 20
rollButton.Parent = shopFrame

-- Notification Label
local notifLabel = Instance.new("TextLabel")
notifLabel.Size = UDim2.new(0.9, 0, 0.4, 0)
notifLabel.Position = UDim2.new(0.05, 0, 0.2, 0)
notifLabel.TextWrapped = true
notifLabel.Text = "Roll for a chance to win better Oxygen Tanks and Flippers!"
notifLabel.BackgroundTransparency = 1
notifLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
notifLabel.Font = Enum.Font.Gotham
notifLabel.TextSize = 18
notifLabel.Parent = shopFrame

local isRolling = false

rollButton.MouseButton1Click:Connect(function()
    if isRolling then return end
    isRolling = true
    
    rollButton.Text = "Rolling..."
    rollButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    notifLabel.Text = "..."
    
    -- Request Roll from Server
    local success, result = GachaRollRemote:InvokeServer()
    
    if success then
        -- result is the wonItem table
        local rarityColors = {
            Common = Color3.fromRGB(200, 200, 200),
            Rare = Color3.fromRGB(0, 150, 250),
            Legendary = Color3.fromRGB(255, 200, 0)
        }
        
        notifLabel.TextColor3 = rarityColors[result.Rarity] or Color3.fromRGB(255, 255, 255)
        notifLabel.Text = "You won a " .. result.Rarity .. " " .. result.Name .. "!"
    else
        -- result is the error message
        notifLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        notifLabel.Text = result
    end
    
    task.wait(2)
    
    rollButton.Text = "Roll Gear (500 Coins)"
    rollButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    notifLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    if not success then
        notifLabel.Text = "Roll for a chance to win better Oxygen Tanks and Flippers!"
    end
    
    isRolling = false
end)
