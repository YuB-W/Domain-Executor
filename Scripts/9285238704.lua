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
local entity = loadstring(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/Libraries/entityHandler.lua", true))()

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
print("[ManaV2ForRebloz/Scripts/9285238704.lua]: Loaded in " .. tostring(tick() - startTick) .. ". ")