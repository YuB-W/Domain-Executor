--[[
    Credits to anyones code I used or looked at
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
local LocalPlayerEvents = {}

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

if getgenv then
    getgenv().Mana = {Developer = false}
elseif not getgenv then
    _G.Mana = {Developer = false}
    warn("[ManaV2ForRoblox]: Using _G function.")
elseif not (_G and getgenv) then
    return warn("[ManaV2ForRoblox]: Unsupported executor.")
end

do
    function Functions:WriteFile(path, filepath) -- path - executor's in workspace path, filepath - github path
        local CurrentFile
        if isfile(path) then CurrentFile = readfile(path) end
        local res = httprequest({Url = 'https://raw.githubusercontent.com/Maanaaaa/ManaV2ForRoblox/main/' .. filepath, Method = 'GET'}).Body
        if res ~= '404: Not Found' and res ~= CurrentFile then
            writefile("Mana/" .. path, res)
        else
            warn("[ManaV2ForRoblox]: Can't write requested file. \nWorkspacePath: " .. path .. " \nGithubFilePath: " .. filepath .. ". \nError: " .. res)
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
            return loadstring(readfile("NewMana/" .. filepath))()
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

local Whitelist = HttpService:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/Maanaaaa/Whitelist/main/Whitelist.json"))
local GuiLibrary = Functions:RunFile("GuiLibrary.lua")
local EntityLibrary = Functions:RunFile("Libraries/EntityLibrary.lua")

Mana.GuiLibrary = GuiLibrary
Mana.Functions = Functions
Mana.RunLoops = RunLoops
Mana.EntityLibrary = EntityLibrary
Mana.Activated = true
Mana.Whitelisted = false

GuiLibrary:CreateWindow()

local Tabs = {
    Combat = GuiLibrary:CreateTab({
        Name = "Combat",
        Color = Color3.fromRGB(252, 60, 68),
        Visible = true,
        Callback = function() end
    }),
    Movement = GuiLibrary:CreateTab({
        Name = "Movement",
        Color = Color3.fromRGB(255, 148, 36),
        Visible = true,
        Callback = function() end
    }),
    Render = GuiLibrary:CreateTab({
        Name = "Render",
        Color = Color3.fromRGB(59, 170, 222),
        Visible = true,
        Callback = function() end
    }),
    Utility = GuiLibrary:CreateTab({
        Name = "Utility",
        Color = Color3.fromRGB(83, 214, 110),
        Visible = true,
        Callback = function() end
    }),
    World = GuiLibrary:CreateTab({
        Name = "World",
        Color = Color3.fromRGB(52,28,228),
        Visible = true,
        Callback = function() end
    }),
    Misc = GuiLibrary:CreateTab({
        Name = "Other",
        Color = Color3.fromRGB(240, 157, 62),
        Visible = true,
        Callback = function() end
    }),
}

Mana.Tabs = Tabs

if GuiLibrary.Device == "Mobile" then
    SliderScaleValue = 0.5
end

-- Chattags and commands system
task.spawn(function() -- so it doesn't stop script loading
    for PlayerName, Tag in pairs(Whitelist) do
        if LocalPlayer.UserId == tonumber(Tag.UserId) then
            if Tag.Whitelisted or Tag.Whitelisted == "true" then
                Mana.Whitelisted = true

                Tabs.Private = GuiLibrary:CreateTab({
                    Name = "Private",
                    Color = Color3.fromRGB(243, 247, 5),
                    Visible = true,
                    Callback = function() end
                })

                GuiLibrary:CreateNotification("Whitelist", "Successfully whitelisted as whitelisted!", 10, true, "warn") -- warn bc it has bigger chance that you will notice this
            elseif Tag.Developer or Tag.Developer == "true" then
                Mana.Whitelisted = true
                Mana.Developer = true

                Tabs.Private = GuiLibrary:CreateTab({
                    Name = "Private",
                    Color = Color3.fromRGB(243, 247, 5),
                    Visible = true,
                    Callback = function() end
                })

                GuiLibrary:CreateNotification("Whitelist", "Successfully whitelisted as whitelisted and developer!", 10, true, "warn")
            end
            if Mana.Whitelisted or Mana.Developer then
                TextChatService.OnIncomingMessage = function(Message, ChatStyle)
                    local MessageProperties = Instance.new("TextChatMessageProperties")
                    local Player = Players:GetPlayerByUserId(Message.TextSource.UserId)
                    if Player.Name == PlayerName then
                        MessageProperties.PrefixText = '<font color="' .. Tag.Color .. '">' .. Tag.Chattag .. '</font> ' .. Message.PrefixText
                    end
                    return MessageProperties
                end
            end
        end
    end
end)

-- Misc tab

runFunction(function()
    local AutoSaveDelay = {Value = 5}
    local AutoSaveOnRejoin = {Value = true}
    local LeavingEvent
    AutoSaveConfig = Tabs.Misc:CreateToggle({
        Name = "AutoSaveConfig",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                while callback and task.wait(AutoSaveDelay.Value) do
                    GuiLibrary.ConfigSystem.functions:WriteConfigs(GuiLibrary.ConfigTable)
                end

                LeavingEvent = Players.PlayerRemoving:Connect(function(Player)
                    if Player == LocalPlayer and AutoSaveOnRejoin.Value then
                        GuiLibrary.ConfigSystem.functions:WriteConfigs(GuiLibrary.ConfigTable)
                    end
                end)
            else
                if LeavingEvent then
                    LeavingEvent:Disconnect()
                end
            end
        end
    })

    AutoSaveOnRejoin = AutoSaveConfig:CreateToggle({
        Name = "On rejoin or leave",
        Default = true,
        Function = function(v)
        end 
    })

    AutoSaveDelay = AutoSaveConfig:CreateSlider({
        Name = "Delay",
        Function = function(v)
		end,
        Min = 1,
        Max = 60,
        Default = 15,
        Round = 0
    })
end)

runFunction(function()
    local ClickGuiEnabled = false
    local LibrarySettings = Tabs.Misc:CreateToggle({
        Name = "ClickGui",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                ClickGuiEnabled = callback
            end
        end
    })

    LibSounds = LibrarySettings:CreateToggle({
        Name = "Sounds",
        Default = true,
        Function = function(v)
            if ClickGuiEnabled then
                GuiLibrary.Sounds = v
            end
        end 
    })

    Notifications = LibrarySettings:CreateToggle({
        Name = "Notifications",
        Default = true,
        Function = function(v)
            if ClickGuiEnabled then
                GuiLibrary.Notifications = v
            end
        end 
    })

    ChatNotifications = LibrarySettings:CreateToggle({
        Name = "ChatNotifications",
        Default = true,
        Function = function(v)
            if ClickGuiEnabled then
                GuiLibrary.ChatNotifications = v
            end
        end 
    })

    LibrarySize = LibrarySettings:CreateSlider({
        Name = "Size",
        Function = function(v)
            if ClickGuiEnabled then
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
    Discord = Tabs.Misc:CreateToggle({
        Name = "CopyDiscordInvite",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                toclipboard("https://discord.gg/gPkD8BdbMA")
                Discord:Toggle(true)
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

runFunction(function()
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
    ToggleGui = Tabs.Misc:CreateToggle({
        Name = "ToggleGui",
        Keybind = nil,
        Callback = function(callback)
            GuiLibrary:ToggleLibrary()
        end
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
end)

local Button = Instance.new("TextButton")
local Corner = Instance.new("UICorner")
Button.Name = "GuiButton"
Button.Position = UDim2.new(1, -700, 0, -32)
Button.Text = "Mana"
Button.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
Button.TextColor3 = Color3.new(1, 1, 1)
Button.Size = UDim2.new(0, 32, 0, 32)
Button.BorderSizePixel = 0
Button.BackgroundTransparency = 0.5
Button.Parent = GuiLibrary.ScreenGui
Corner.Parent = Button
Corner.CornerRadius = UDim.new(0, 8)

Button.MouseButton1Click:Connect(function()
    GuiLibrary:ToggleLibrary()
end)

UserInputService.InputBegan:Connect(function(Input)
    if Input.KeyCode == Enum.KeyCode.RightShift or Input.KeyCode == Enum.KeyCode.N then
        GuiLibrary:ToggleLibrary()
    end
end)

print("[ManaV2ForRoblox/MainScript.lua]: Loaded in " .. tostring(tick() - startTick) .. ".")

UniversalScript = Functions:RunFile("Scripts/Universal.lua")
GameScript = Functions:RunFile("Scripts/" .. PlaceId .. ".lua")