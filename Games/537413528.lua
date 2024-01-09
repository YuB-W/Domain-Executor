--[[
    Credits to anyones code i used or looked at
]]

local startTick = tick()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character
local HumanoidRootPart = Character.HumanoidRootPart
local Humanoid = Character.Humanoid
local Camera = workspace.CurrentCamera
local RealCamera = workspace.Camera
local Mouse = LocalPlayer:GetMouse()
local PlayerGui = LocalPlayer.PlayerGui

local GuiLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/Maanaaaa/ManaV2ForRoblox/main/GuiLibrary.lua"))()

GuiLibrary:CreateWindow()

local Tabs = {
    Combat = GuiLibrary:CreateTab("Combat",Color3.fromRGB(252, 60, 68)),
    Movement = GuiLibrary:CreateTab("Movement",Color3.fromRGB(255, 148, 36)),
    Render = GuiLibrary:CreateTab("Render",Color3.fromRGB(59, 170, 222)),
    Utility = GuiLibrary:CreateTab("Utility",Color3.fromRGB(83, 214, 110)),
    World = GuiLibrary:CreateTab("World",Color3.fromRGB(52,28,228)),
    Misc = GuiLibrary:CreateTab("Other",Color3.fromRGB(240, 157, 62))
}

local function runFunction(func) func() end

runFunction(function()
	InfBlocks = {Value = false}
	InfBlocks = Tabs.Utility:CreateToggle({
        Name = "InfinityBlocks",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                for i,v in pairs(PlayerGui.BuildGui.InventoryFrame.ScrollingFrame.BlocksFrame:GetChildren()) do
                    if v:FindFirstChild("AmountText") then
                        v.AmountText.Text = 'INF'
                        v.AmountText.Changed:Connect(function()
                            if callback then
                                v.AmountText.Text = 9999999
                            end
                        end)
                    end
                end
            else
				
            end
        end
    })
end)