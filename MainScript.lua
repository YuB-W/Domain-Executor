--[[
    Credits to anyones code i used or looked at
]]

repeat task.wait() until game:IsLoaded()

local startTick = tick()

local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
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
local Whitelist = HttpService:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/Maanaaaa/Whitelist/main/Whitelist.json"))

--what do i write here
local request = (syn and syn.request) or request or http_request or (http and http.request)
local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport
local setthreadidentityfunc = syn and syn.set_thread_identity or set_thread_identity or setidentity or setthreadidentity
local getthreadidentityfunc = syn and syn.get_thread_identity or get_thread_identity or getidentity or getthreadidentity
local function runFunction(func) func() end

local Functions = {}

do
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

    function Functions:CheckPlace(placename)
        if placename == "Bedwars" then
            if PlaceId == 8560631822 or PlaceId == 8444591321 or PlaceId == 6872274481 then
                return true
            else
                return false
            end
        end
    end
end

if not getgenv then
    return warn("[ManaV2ForRoblox]: Unsupported executor.")
end

if Mana and Mana.Activated == true then 
    warn("[ManaV2ForRoblox]: Already loaded.")
    return
end


local GuiLibrary = Functions:RunFile("GuiLibrary.lua")

getgenv().Mana = {}
Mana.Entity = loadstring(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/Libraries/entityHandler.lua", true))()
Mana.GuiLibrary = GuiLibrary
Mana.Functions = Functions
Mana.Activated = true
Mana.Whitelisted = false

GuiLibrary:CreateWindow()

local Tabs = {
    Combat = GuiLibrary:CreateTab("Combat", Color3.fromRGB(252, 60, 68)),
    Movement = GuiLibrary:CreateTab("Movement", Color3.fromRGB(255, 148, 36)),
    Render = GuiLibrary:CreateTab("Render", Color3.fromRGB(59, 170, 222)),
    Utility = GuiLibrary:CreateTab("Utility", Color3.fromRGB(83, 214, 110)),
    World = GuiLibrary:CreateTab("World", Color3.fromRGB(52,28,228)),
    Misc = GuiLibrary:CreateTab("Other", Color3.fromRGB(240, 157, 62))
}

Mana.Tabs = Tabs

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


runFunction(function()
    local LibSounds = {Value = true}
    local LibrarySettings = Tabs.Misc:CreateToggle({
        Name = "LibrarySettings",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                en = callback
            end
        end
    })

    LibSounds = LibrarySettings:CreateOptionTog({
        Name = "Sounds",
        Default = true,
        Func = function(v)
            if en then
                GuiLibrary.Sounds = v
            end
        end 
    })

    LibrarrySize = LibrarySettings:CreateSlider({
        Name = "Size",
        Function = function(v)
            if en then
                UISizee = CoreGui.ManaV2.Tabs.UIScale
                if UISizee then UISizee.Scale = v end
            end
		end,
        Min = 1,
        Max = 10,
        Default = 4,
        Round = 1
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
                if CoreGui:FindFirstChild("Mana") then CoreGui:FindFirstChild("Mana"):Destroy() end
            else

            end
        end
    })

    Reinject = Tabs.Misc:CreateToggle({
        Name = "ReInject",
        Keybind = nil,
        Callback = function(v)
            if v then
                Mana.Activated = false
                Reinject:silentToggle()
                if CoreGui:FindFirstChild("Mana") then CoreGui:FindFirstChild("Mana"):Destroy() end
                wait(1)
                Functions:RunFile("MainScript.lua")
            else
                
            end
        end
    })
end)

--some mobile support, and yea it's only smaller gui
if UserInputService.TouchEnabled then
    warn("[ManaV2ForRoblox]: mobile user.")
    CoreGui.Mana.Tabs:FindFirstChild("scalee").Scale = 0.7
else
    warn("[ManaV2ForRoblox]: not mobile user.")
end

print("[ManaV2ForRoblox/MainScript.lua]: Loaded in " .. tostring(tick() - startTick) .. ".")

UniversalScript = Functions:RunFile("Scripts/Universal.lua")
local Success, Error = pcall(function() 
    Functions:RunGameScript("".. PlaceId ..".lua") 
end) 
if not Success then warn(Error) end