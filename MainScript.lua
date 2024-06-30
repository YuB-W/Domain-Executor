--[[
    Credits to anyones code i used or looked at
]]

repeat task.wait() until game:IsLoaded()

local startTick = tick()

local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character
local HumanoidRootPart = Character.HumanoidRootPart
local Humanoid = Character.Humanoid
local Camera = workspace.CurrentCamera
local RealCamera = workspace.Camera
local Mouse = LocalPlayer:GetMouse()
local PlayerGui = LocalPlayer.PlayerGui
local PlaceId = game.PlaceId
local SliderScaleValue = 1
local Functions = {}
local SessionTime = {
    Hours = 0,
    Minutes = 0,
    Seconds = 0,
    TotalTime = "00:00:00"
}

local httprequest = (request and http and http.request or http_request or fluxus and fluxus.request)
local function runFunction(func) func() end

if Mana and Mana.Activated == true then 
    warn("[ManaV2ForRoblox]: Already loaded.")
    Mana.GuiLibrary:playsound("rbxassetid://421058925", 1)
    if Mana.GuiLibrary.ChatNotifications then
        Mana.GuiLibrary:CreateChatNotification("Warn", "Already loaded.")
    end
    return
end

if not getgenv then
    warn("[ManaV2ForRoblox]: Using _G function.")
elseif not (_G and getgenv) then --idk if its possible to dont have _G thing
    return warn("[ManaV2ForRoblox]: Unsupported executor.")
end

if getgenv then
    getgenv().Mana = {Developer = false}
else
    _G.Mana = {Developer = false}
end

do
    function Functions:WriteFile(path, filepath) -- path - executor's in workspace path, filepath - github path
        local CurrentFile
        if isfile(path) then CurrentFile = readfile(path) end
        local res = httprequest({Url = 'https://raw.githubusercontent.com/Maanaaaa/ManaV2ForRoblox/main/' .. filepath, Method = 'GET'}).Body
        if res ~= '404: Not Found' and res ~= CurrentFile then --  and Mana.Developer
            writefile("Mana/" .. path, res)
        else
            warn("[ManaV2ForRoblox]: Can't write requested file. \nWorspacePath: " .. path .. " \nGithubFilePath: " .. filepath .. ". \nError: " .. res)
        end
    end

    function Functions:CheckFile(filepath)
        local ToReturn
        local Success, Error = pcall(function() 
            ToReturn = loadstring(game:HttpGet("https://raw.githubusercontent.com/Maanaaaa/ManaV2ForRoblox/main/" .. filepath))()
        end) 
        if not Success then 
            warn(Error)
        else
            return ToReturn
        end
    end

    function Functions:RunFile(filepath)
        if filepath == "Scripts/6872274481.lua" or filepath == "Scripts/8560631822.lua" or filepath == "Scripts/8444591321.lua" then
            Functions:WriteFile(filepath, filepath)
            return Functions:CheckFile("Scripts/6872274481.lua")
        elseif Mana.Developer then
            return loadstring(readfile("Mana/" .. filepath))()
        else
            Functions:WriteFile(filepath, filepath)
            return Functions:CheckFile(filepath)
        end
    end
end

local RunLoops = {RenderStepTable = {}, StepTable = {}, HeartTable = {}}

do
	function RunLoops:BindToRenderStep(name, func)
		if RunLoops.RenderStepTable[name] == nil then
			RunLoops.RenderStepTable[name] = RunService.RenderStepped:Connect(func)
		end
	end

	function RunLoops:UnbindFromRenderStep(name)
		if RunLoops.RenderStepTable[name] then
			RunLoops.RenderStepTable[name]:Disconnect()
			RunLoops.RenderStepTable[name] = nil
		end
	end

	function RunLoops:BindToStepped(name, func)
		if RunLoops.StepTable[name] == nil then
			RunLoops.StepTable[name] = RunService.Stepped:Connect(func)
		end
	end

	function RunLoops:UnbindFromStepped(name)
		if RunLoops.StepTable[name] then
			RunLoops.StepTable[name]:Disconnect()
			RunLoops.StepTable[name] = nil
		end
	end

	function RunLoops:BindToHeartbeat(name, func) 
		if RunLoops.HeartTable[name] == nil then
			RunLoops.HeartTable[name] = RunService.Heartbeat:Connect(func)
		end
	end

	function RunLoops:UnbindFromHeartbeat(name)
		if RunLoops.HeartTable[name] then
			RunLoops.HeartTable[name]:Disconnect()
			RunLoops.HeartTable[name] = nil
		end
	end
end

local Commands = {}

do
    function Commands:CreateCommand(Name, Function) 
        Commands[Name] = Function
    end

    function Commands:RemoveCommand(Name)
        if Commands[Name] then
            Commands[Name] = nil
        end
    end
end

local Whitelist = HttpService:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/Maanaaaa/Whitelist/main/Whitelist.json"))
local GuiLibrary = Functions:RunFile("GuiLibrary.lua")
local EntityLibrary = Functions:RunFile("Libraries/EntityLibrary.lua")

Mana.GuiLibrary = GuiLibrary
Mana.Functions = Functions
Mana.RunLoops = RunLoops
Mana.EntityLibrary = EntityLibrary
--Mana.GetCustomAssetFunction
Mana.Activated = true
Mana.Whitelisted = false
Mana.SessionTime = SessionTime

GuiLibrary:CreateWindow()

local Tabs = {
    Combat = GuiLibrary:CreateTab("Combat", Color3.fromRGB(252, 60, 68)),
    Movement = GuiLibrary:CreateTab("Movement", Color3.fromRGB(255, 148, 36)),
    Render = GuiLibrary:CreateTab("Render", Color3.fromRGB(59, 170, 222)),
    Utility = GuiLibrary:CreateTab("Utility", Color3.fromRGB(83, 214, 110)),
    World = GuiLibrary:CreateTab("World", Color3.fromRGB(52,28,228)),
    Misc = GuiLibrary:CreateTab("Other", Color3.fromRGB(240, 157, 62)),
}

Mana.Tabs = Tabs

--[[
local SessionInfo = GuiLibrary:CreateSessionInfo()

local SessionInfoLabels = {
    Time = SessionInfo:CreateInfoLabel("Time: 00:00:00")
}

while wait(1) do
    SessionInfoLabels.Time.TextLabel.Text = SessionTime.TotalTime
end
]]

if GuiLibrary.Device == "Mobile" then
    SliderScaleValue = 0.5
end

if LocalPlayer.UserId == 5366854020 then
    Mana.Developer = true
end

task.spawn(function() -- task.spawn bc it will run and while it's loading other things will load too
    for PlayerName, Tag in pairs(Whitelist) do
        local Player = Players:FindFirstChild(PlayerName)
        if Tag.Whitelisted or Tag.Whitelisted == "true" then
            Mana.Whitelisted = true
            Tabs.Private = GuiLibrary:CreateTab("Private", Color3.fromRGB(243, 247, 5))
        end
        if Player then
            TextChatService.OnIncomingMessage = function(Message, ChatStyle)
                local MessageProperties = Instance.new("TextChatMessageProperties")
                local Player = Players:GetPlayerByUserId(Message.TextSource.UserId)
                if Player then
                    for PlayerName, Tag in pairs(Whitelist) do
                        if Player.Name == PlayerName then
                            MessageProperties.PrefixText = '<font color="' .. Tag.Color .. '">' .. Tag.Chattag .. '</font> ' .. Message.PrefixText
                        end
                    end
                end
                return MessageProperties
            end
        end
    end
end)

runFunction(function()
    Discord = Tabs.Misc:CreateToggle({
        Name = "CopyDiscordInvite",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                toclipboard("https://discord.gg/gPkD8BdbMA")
            else

            end
        end
    })
end)

runFunction(function()
    ToggleGui = Tabs.Misc:CreateToggle({
        Name = "ToggleGui",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                GuiLibrary.Functions:ToggleLibrary()
            else
                GuiLibrary.Functions:ToggleLibrary()
            end
        end
    })
end)


runFunction(function()
    local LibrarySettings = Tabs.Misc:CreateToggle({
        Name = "ClickGui",
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
        Function = function(v)
            if en then
                GuiLibrary.Sounds = v
            end
        end 
    })

    Notifications = LibrarySettings:CreateOptionTog({
        Name = "Notifications",
        Default = true,
        Function = function(v)
            if en then
                GuiLibrary.Notifications = v
            end
        end 
    })

    ChatNotifications = LibrarySettings:CreateOptionTog({
        Name = "ChatNotifications",
        Default = true,
        Function = function(v)
            if en then
                GuiLibrary.ChatNotifications = v
            end
        end 
    })

    LibrarySize = LibrarySettings:CreateSlider({
        Name = "Size",
        Function = function(v)
            if en then
                GuiLibrary.UIScale.Scale = v
            end
		end,
        Min = 1,
        Max = 10,
        Default = SliderScaleValue,
        Round = 1
    })
end)

runFunction(function()
    Uninject = Tabs.Misc:CreateToggle({
        Name = "Uninject",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                Mana.Activated = false
                Uninject:Toggle(false)
                wait(0.1)
                GuiLibrary.ScreenGui:Destroy()
            end
        end
    })

    Reinject = Tabs.Misc:CreateToggle({
        Name = "ReInject",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                Mana.Activated = false
                Reinject:Toggle(false)
                GuiLibrary.ScreenGui:Destroy()
                wait(1)
                Functions:RunFile("MainScript.lua")
            end
        end
    })
end)

runFunction(function()
    DeleteConfig = Tabs.Misc:CreateToggle({
        Name = "DeleteConfig",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                Mana.Activated = false
                DeleteConfig:Toggle(false)
                GuiLibrary.ScreenGui:Destroy()
                if isfile("Mana/Config/" .. game.PlaceId .. ".json") then delfile("Mana/Config/" .. game.PlaceId .. ".json") end
                wait(1)
                Functions:RunFile("MainScript.lua")
            end
        end
    })
end)

local Button = Instance.new("TextButton")
local Corner = Instance.new("UICorner")
Button.Name = "GuiButton"
Button.Position = UDim2.new(1, -700, 0, -32)
Button.Text = "Mana"
--Button.Active = true
--Button.Draggable = true
Button.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
Button.TextColor3 = Color3.new(1, 1, 1)
Button.Size = UDim2.new(0, 32, 0, 32)
Button.BorderSizePixel = 0
Button.BackgroundTransparency = 0.5
Button.Parent = GuiLibrary.ScreenGui
Corner.Parent = Button
Corner.CornerRadius = UDim.new(0, 8)

Button.MouseButton1Click:Connect(function()
    GuiLibrary.Functions:ToggleLibrary()
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.N then
        GuiLibrary.Functions:ToggleLibrary()
    end
end)

--[[
repeat
    local Seconds = SessionTime.Seconds
    local Minutes = SessionTime.Minutes
    local Hours = SessionTime.Hours

    SessionTime.Seconds = Seconds + 1

    if Seconds == 60 then
        SessionTime.Seconds = 0
        SessionTime.Minutes = Minutes + 1
    end

    if Minutes == 60 then
        SessionTime.Minutes = 0
        SessionTime.Hours = Hours + 1
    end

    SessionTime.TotalTime = Hours .. ":" .. Minutes .. ":" .. Seconds

    task.wait(1)
until (false == true)
]]

print("[ManaV2ForRoblox/MainScript.lua]: Loaded in " .. tostring(tick() - startTick) .. ".")

-- it's here to prevent not printing thing above this
UniversalScript = Functions:RunFile("Scripts/Universal.lua")
GameScript = Functions:RunFile("Scripts/" .. PlaceId .. ".lua") 