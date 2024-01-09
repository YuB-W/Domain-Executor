--[[
    Credits to anyones code i used or looked at
]]

local startTick = tick()

local request = (syn and syn.request) or request or http_request or (http and http.request)
local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport
local setthreadidentityfunc = syn and syn.set_thread_identity or set_thread_identity or setidentity or setthreadidentity
local getthreadidentityfunc = syn and syn.get_thread_identity or get_thread_identity or getidentity or getthreadidentity

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

local GuiLibrary = Mana.GuiLibrary
local Tabs = Mana.Tabs
local Functions = Mana.funcs

local function runFunction(func) func() end

local Remotes = {
    GenRemote = ReplicatedStorage.Remotes.generateBoost,
    SellRemote = ReplicatedStorage.Remotes.sellBricks,
    RankRemote = ReplicatedStorage.Remotes.rankUp
}

runFunction(function()
	AutoSell = Tabs.Utility:CreateToggle({
        Name = "AutoSell",
        Keybind = nil,
        Callback = function(callback)
            if callback then
				while callback == true do
                    Remotes.SellRemote:FireServer()
                end
            else
                
            end
        end
    })
end)

runFunction(function()
    CoinsAmount = {Value = 100000}
	AutoCoins = Tabs.Utility:CreateToggle({
        Name = "AutoCoins",
        Keybind = nil,
        Callback = function(callback)
            if callback then
				while callback == true do
                    Remotes.GenRemote:FireServer("Coins", 0, CoinsAmount.Value)
                end
            else
                
            end
        end
    })
    CoinsAmount = AutoCoins:CreateSlider({
        Name = "Levels",
        Function = function(v)
            CoinsAmount = v
        end,
        Min = 1,
        Max = 10000000,
        Default = 1000000,
        Round = 0
    })
end)

runFunction(function()
    LevelAmount = {Value = 1}
	AutoLevels = Tabs.Utility:CreateToggle({
        Name = "AutoLevels",
        Keybind = nil,
        Callback = function(callback)
            if callback then
				while callback == true do
                    GenRemote:FireServer("Levels", 0, LevelAmount.Value)
                end
            else
                
            end
        end
    })
    LevelAmount = AutoLevels:CreateSlider({
        Name = "Levels",
        Function = function(v)
            LevelAmount = v
        end,
        Min = 1,
        Max = 15,
        Default = 1,
        Round = 0
    })
end)

runFunction(function()
	AutoSell = Tabs.Utility:CreateToggle({
        Name = "AutoRank",
        Keybind = nil,
        Callback = function(callback)
            if callback then
				while callback == true do
                    RankRemote:FireServer()
                end
            else
                
            end
        end
    })
end)