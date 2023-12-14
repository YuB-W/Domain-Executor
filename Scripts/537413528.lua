--[[
    Credits to anyones code i used or looked at
]]

local startTick = tick()

--Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

--Variables
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character
local HumanoidRootPart = Character.HumanoidRootPart
local Humanoid = Character.Humanoid
local Camera = workspace.CurrentCamera
local RealCamera = workspace.Camera
local Mouse = LocalPlayer:GetMouse()
local PlayerGui = LocalPlayer.PlayerGui

-- Mana Variables
local GuiLibrary = Mana.GuiLibrary
local Tabs = Mana.Tabs
local Functions = Mana.funcs

--What do i write here
local request = (syn and syn.request) or request or http_request or (http and http.request)
local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport
local setthreadidentityfunc = syn and syn.set_thread_identity or set_thread_identity or setidentity or setthreadidentity
local getthreadidentityfunc = syn and syn.get_thread_identity or get_thread_identity or getidentity or getthreadidentity
local getasset = getsynasset or getcustomasset
local function runFunction(func) func() end
local Entity = loadstring(game:HttpGet("https://raw.githubusercontent.com/Maanaaaa/ManaV2ForRoblox/main/Modules/EntityHandler.lua", true))()

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