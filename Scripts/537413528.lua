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
local Functions = Mana.Functions

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