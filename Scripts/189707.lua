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
local UsefulTable = {}

local GuiLibrary = Mana.GuiLibrary
local Tabs = Mana.Tabs
local Functions = Mana.funcs

local function runFunction(func) func() end

--Movement
runFunction(function()
    local WaterLevel = Workspace.WaterLevel
	WalkOnWater = Tabs.Movement:CreateToggle({
        Name = "WalkOnWater",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                WaterLevel.CanCollide = false
				WaterLevel.Size = Vector3.new(10, 1, 10)
            else
				WaterLevel.CanCollide = true
				WaterLevel.Size = Vector3.new(1000, 1, 1000)
            end
        end
    })
end)

--Utility
runFunction(function()
	NoFallDamage = Tabs.Utility:CreateToggle({
        Name = "NoFall",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                LocalPlayer.Character.FallDamageScript:Destroy()
            else

            end
        end
    })
end)

--[[
runFunction(function()
    Table = {}
    RemoveBlizzardGui = {Value = true}
    RemoveSandstormGui = {Value = true}
	RemoveGui = Tabs.Utility:CreateToggle({
        Name = "RemoveGui",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                if RemoveBlizzardGui == true then
                    table.insert(Table, PlayerGui.BlizzardGui)
                    if PlayerGui:FindFirstChild("BlizzardGui") then PlayerGui:FindFirstChild("BlizzardGui"):destroy() end
                end
                if RemoveSandstormGui == true then
                    table.insert(Table, PlayerGui.SandStormGui)
                    if PlayerGui:FindFirstChild("SandStormGui") then PlayerGui:FindFirstChild("SandStormGui"):destroy() end
                end
            else
				for i, v in pairs(Table) do
                    v.Parent = PlayerGui
                end
            end
        end
    })
end)
]]