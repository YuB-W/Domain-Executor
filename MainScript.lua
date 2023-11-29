--[[
    Credits to anyones code i used or looked at
]]

repeat task.wait() until game:IsLoaded()

local startTick = tick()

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

--Variables
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character
local HumanoidRootPart = Character.HumanoidRootPart
local Humanoid = Character.Humanoid
local Camera = workspace.CurrentCamera
local RealCamera = workspace.Camera
local Mouse = LocalPlayer:GetMouse()
local PlayerGui = LocalPlayer.PlayerGui
local PlaceId = game.PlaceId

--what do i write here
local request = (syn and syn.request) or request or http_request or (http and http.request)
local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport
local setthreadidentityfunc = syn and syn.set_thread_identity or set_thread_identity or setidentity or setthreadidentity
local getthreadidentityfunc = syn and syn.get_thread_identity or get_thread_identity or getidentity or getthreadidentity
local function runFunction(func) func() end

local Functions = {}

do
    --[[
    function Functions:GithubRequest(filepath)
        if not isfile("Mana/"..scripturl) then
            local suc, res = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/MankaUser/ManaV2ForReblox/"..scripturl, true) end)
            assert(suc, res)
            assert(res ~= "404: Not Found", res)
            --if scripturl:find(".lua") then res = "--This watermark is used to delete the file if its cached, remove it to make the file persist after commits.\n"..res end
            writefile("Mana/"..scripturl, res)
        end
        return readfile("Mana/"..scripturl)
    end
    ]]

    function Functions:RunFile(filepath)
        if isfile("Mana/".. filepath) then
            return loadstring(readfile("Mana/".. filepath))()
        elseif game:HttpGet("https://raw.githubusercontent.com/Maanaaaa/ManaV2ForRoblox/main/".. filepath) then
            return loadstring(game:HttpGet("https://raw.githubusercontent.com/Maanaaaa/ManaV2ForRoblox/main/".. filepath))()
        else
            return print("[ManaV2ForReblox]: Can't find file:", filepath ,".")
        end
    end

    function Functions:RunGameScript(path)
        if isfile("Mana/Scripts/".. path) then
            loadstring(readfile("Mana/Scripts/".. path))()
        elseif game:HttpGet("https://raw.githubusercontent.com/Maanaaaa/ManaV2ForRoblox/main/Scripts/".. path) then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Maanaaaa/ManaV2ForRoblox/main/Scripts/".. path))()
        end
    end
end

if not getgenv or (identifyexecutor and identifyexecutor():find("Arceus")) then
    return warn("[ManaV2ForReblox]: Unsupported executor.")
end

if Mana and Mana.Activated == true then 
    warn("[ManaV2ForReblox]: Already loaded.")
    return
end


local GuiLibrary = Functions:RunFile("UILibrary.lua")

getgenv().Mana = {}
Mana.Entity = loadstring(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/Libraries/entityHandler.lua", true))()
Mana.GuiLibrary = GuiLibrary
Mana.Functions = Functions
Mana.Activated = true

GuiLibrary:CreateWindow()

local Tabs = {
    Combat = GuiLibrary:CreateTab("Combat",Color3.fromRGB(252, 60, 68)),
    Movement = GuiLibrary:CreateTab("Movement",Color3.fromRGB(255, 148, 36)),
    Render = GuiLibrary:CreateTab("Render",Color3.fromRGB(59, 170, 222)),
    Utility = GuiLibrary:CreateTab("Utility",Color3.fromRGB(83, 214, 110)),
    World = GuiLibrary:CreateTab("World",Color3.fromRGB(52,28,228)),
    Misc = GuiLibrary:CreateTab("Other",Color3.fromRGB(240, 157, 62))
}

Mana.Tabs = Tabs

--[[
runFunction(function()
    Discord = Tabs.Misc:CreateToggle({
        Name = "CopyDiscordInvite",
        Keybind = nil,
        Callback = function(v)
        if v then
            toclipboard("https://discord.gg/gPkD8BdbMA")
        else

        end
        end
    })
end)
]]

runFunction(function()
    local LibNotification = {Value = true}
    local LibSounds = {Value = true}
    local LibrarrySize = {Value = 1.1}
    local UICornerSlider = {Value = 2}
    local LibrarySettings = Tabs.Misc:CreateToggle({
        Name = "LibrarySettings",
        Keybind = nil,
        Callback = function(v)
            if v then
            
            else
            
            end
        end
    })

    LibNotification = LibrarySettings:CreateOptionTog({
        Name = "Notifications",
        Default = true,
        Func = function(v)
        GuiLibrary.Notifications = v
        end
        
    })

    LibSounds = LibrarySettings:CreateOptionTog({
        Name = "Sounds",
        Default = true,
        Func = function(v)
        GuiLibrary.Sounds = v
        end 
    })
end)

runFunction(function()
    Uninject = Tabs.Misc:CreateToggle({
        Name = "Uninject",
        Keybind = nil,
        Callback = function(v)
            if v then
                Mana.Activated = false
                Uninject:silentToggle()
                wait(0.1)
                -- Cringe code but idc
                if CoreGui:FindFirstChild("ManaV2") then CoreGui:FindFirstChild("ManaV2"):Destroy() end
                if CoreGui:FindFirstChild("ManaNotificationGui") then CoreGui:FindFirstChild("ManaNotificationGui"):Destroy() end
                if CoreGui:FindFirstChild("54687") then CoreGui:FindFirstChild("54687"):Destroy() end
                if CoreGui:FindFirstChild("54687") then CoreGui:FindFirstChild("54687"):Destroy() end
                if CoreGui:FindFirstChild("54687") then CoreGui:FindFirstChild("54687"):Destroy() end
                if CoreGui:FindFirstChild("54687") then CoreGui:FindFirstChild("54687"):Destroy() end
                if CoreGui:FindFirstChild("54674679857") then CoreGui:FindFirstChild("54674679857"):Destroy() end
            else

            end
        end
    })

    ReInject = Tabs.Misc:CreateToggle({
        Name = "ReInject",
        Keybind = nil,
        Callback = function(v)
        if v then
            Mana.Activated = false
            ReInject:silentToggle()
            wait(0.1)
            -- Cringe code but idc
            if CoreGui:FindFirstChild("ManaV2") then CoreGui:FindFirstChild("ManaV2"):Destroy() end
            if CoreGui:FindFirstChild("ManaNotificationGui") then CoreGui:FindFirstChild("ManaNotificationGui"):Destroy() end
            if CoreGui:FindFirstChild("54687") then CoreGui:FindFirstChild("54687"):Destroy() end
            if CoreGui:FindFirstChild("54687") then CoreGui:FindFirstChild("54687"):Destroy() end
            if CoreGui:FindFirstChild("54687") then CoreGui:FindFirstChild("54687"):Destroy() end
            if CoreGui:FindFirstChild("54687") then CoreGui:FindFirstChild("54687"):Destroy() end
            if CoreGui:FindFirstChild("54674679857") then CoreGui:FindFirstChild("54674679857"):Destroy() end
            wait(1)
            Functions:RunFile("MainScript.lua")
        else
            
        end
        end
    })
end)

print("[ManaV2ForReblox/MainScript.lua]: Loaded in " .. tostring(tick() - startTick) .. ".")

UniversalScript = Functions:RunFile("Scripts/Universal.lua")
GameScript = Functions:RunGameScript("".. PlaceId ..".lua")
