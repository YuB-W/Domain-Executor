--[[
    Credits to anyones code i used or looked at
]]

local startTick = tick()

local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character
local HumanoidRootPart = Character.HumanoidRootPart
local Humanoid = Character.Humanoid
local Camera = workspace.CurrentCamera
local RealCamera = workspace.Camera
local Mouse = LocalPlayer:GetMouse()
local PlayerGui = LocalPlayer.PlayerGui

local GuiLibrary = Mana.GuiLibrary
local Tabs = Mana.Tabs
local Functions = Mana.funcs

local function runFunction(func) func() end

local CFrames = {
    FarmJumps = CFrame.new(-500.47287, 5.51772547, 10915.1553, -0.999997258, -1.50035824e-08, 0.00233520381, -1.49010466e-08, 1, 4.39257235e-08, -0.00233520381, 4.38908074e-08, -0.999997258),
    FarmSpeed = CFrame.new(-2496.354, 57.8458519, 38671.9609, -0.99582231, 8.23530932e-09, -0.0913119763, 1.93580751e-09, 1, 6.90773447e-08, 0.0913119763, 6.86119961e-08, -0.99582231),
    FarmHealth = CFrame.new(-4500.24902, 6.88842297, 10845.2812, -0.999975204, -1.24351951e-08, 0.00704113534, -1.26406974e-08, 1, -2.91414697e-08, -0.00704113534, -2.92297528e-08, -0.999975204),
    FarmDamage = CFrame.new(-6500.04785, 0.198037609, 10220.5449, -0.998949587, -3.03456531e-08, 0.0458233096, -3.43861615e-08, 1, -8.73875337e-08, -0.0458233096, -8.8871424e-08, -0.998949587)
}

runFunction(function()
    FarmJumpsEnabled = false
    Tabs.Utility:CreateToggle({
        Name = "FarmJumps",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                FarmJumpsEnabled = true
                while FarmJumpsEnabled and task.wait() do
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrames.FarmJumps
                    wait(0.1)
                end
            else
                FarmJumpsEnabled = false
            end
        end
    })
end)

runFunction(function()
    FarmSpeedEnabled = false
    Tabs.Utility:CreateToggle({
        Name = "FarmSpeed",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                FarmSpeedEnabled = true
                while FarmSpeedEnabled and task.wait() do
                    LocalPlayer.CharacterHumanoidRootPart.CFrame = CFrames.FarmSpeed
                    wait(0.1)
                end
            else
                FarmSpeedEnabled = false
            end
        end
    })
end)

runFunction(function()
    FarmHealtEnabled = false
    Tabs.Utility:CreateToggle({
        Name = "FarmHealth",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                FarmHealtEnabled = true
                while FarmHealtEnabled and task.wait() do
                    LocalPlayer.CharacterHumanoidRootPart.CFrame = CFrames.FarmHealth
                    wait(0.1)
                end
            else
                FarmHealtEnabled = false
            end
        end
    })
end)

runFunction(function()
    FarmDamageEnabled = false
    Tabs.Utility:CreateToggle({
        Name = "FarmDamage",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                FarmDamageEnabled = true
                while FarmDamageEnabled and task.wait() do
                    LocalPlayer.CharacterHumanoidRootPart.CFrame = CFrames.FarmDamage
                end
            else
                FarmDamageEnabled = false
            end
        end
    })
end)

print("[ManaV2ForRoblox/Scripts/11912525919.lua]: Loaded in " .. tostring(tick() - startTick) .. ".")