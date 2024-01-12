--[[
    Credits to anyones code i used or looked at
]]

local startTick = tick()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
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

local Services = ReplicatedStorage.Packages.Knit.Services
local Remotes = {
    ClickRemote = Services.ClickService.RF.Click,
    RebithRemote = Services.RebirthService.RF.Rebirth,
    EquipBestPetsRemote = Services.PetsService.RF.EquipBest,
    OpenEggRemote = Services.EggService.RF.Open,
    CraftAllPetsRemote = Services.PetsService.RF.CraftAll,
    ReedemCodeRemote = Services.CodesService.RF.Redeem,
    SeasonRemote = Services.SeasonPassService.RF.ClaimTier
}

runFunction(function()
    AutoFarmEnabled = false
    Tabs.Utility:CreateToggle({
        Name = "AutoFarm",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                AutoFarmEnabled = true
                while AutoFarmEnabled and task.wait() do
                    LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(-100000, 0, 0)
                end
            else
                AutoFarmEnabled = false
            end
        end
    })
end)

runFunction(function()
    AutoClickEnabled = false
    Tabs.Utility:CreateToggle({
        Name = "AutoClick",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                AutoClickEnabled = true
                while AutoClickEnabled and task.wait() do
                    Remotes.ClickRemote:InvokeServer()
                end
            else
                AutoClickEnabled = false
            end
        end
    })
end)

runFunction(function()
    AutoEquipBestPetsEnabled = false
    Tabs.Utility:CreateToggle({
        Name = "AutoEquipBestPets",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                AutoEquipBestPetsEnabled = true
                while AutoEquipBestPetsEnabled and task.wait() do
                    Remotes.EquipBestPetsRemote:InvokeServer()
                end
            else
                AutoEquipBestPetsEnabled = false
            end
        end
    })
end)

runFunction(function()
    AutoCraftPetsEnabled = false
    Tabs.Utility:CreateToggle({
        Name = "AutoCraftPets",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                AutoCraftPetsEnabled = true
                while AutoCraftPetsEnabled and task.wait() do
                    Remotes.CraftAllPetsRemote:InvokeServer()
                end
            else
                AutoCraftPetsEnabled = false
            end
        end
    })
end)

runFunction(function()
    AutoSeasonEnabled = false
    Tabs.Utility:CreateToggle({
        Name = "AutoSeason",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                AutoSeasonEnabled = true
                while AutoSeasonEnabled and task.wait() do
                    Remotes.SeasonRemote:InvokeServer()
                end
            else
                AutoSeasonEnabled = false
            end
        end
    })
end)

runFunction(function()
    AutoRebirthEnabled = false
    Tabs.Utility:CreateToggle({
        Name = "AutoRebith",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                AutoRebirthEnabled = true
                while AutoRebirthEnabled and task.wait() do
                    Remotes.RebithRemote:InvokeServer()
                end
            else
                AutoRebirthEnabled = false
            end
        end
    })
end)
print("[ManaV2ForRoblox/Scripts/9285238704.lua]: Loaded in " .. tostring(tick() - startTick) .. ". ")