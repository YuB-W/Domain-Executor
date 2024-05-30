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
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character
local HumanoidRootPart = Character.HumanoidRootPart
local Humanoid = Character.Humanoid
local CurrentCamera = workspace.CurrentCamera
local Camera = workspace.Camera
local Mouse = LocalPlayer:GetMouse()
local PlayerGui = LocalPlayer.PlayerGui
local Backpack = LocalPlayer.Backpack
local Animation = Character.Animate
local LightingTime = Lighting.TimeOfDay

local entity = Mana.Entity
local GuiLibrary = Mana.GuiLibrary
local Tabs = Mana.Tabs
local Functions = Mana.Functions

local Place = Functions:CheckPlace("Bedwars")

local getasset = getsynasset or getcustomasset
local function runFunction(func) func() end

do
    local oldcharacteradded = entity.characterAdded
        entity.characterAdded = function(Player, Character, LocalCheck)
            return oldcharacteradded(Player, Character, LocalCheck, function() end)
        end
    entity.fullEntityRefresh()
end

local spawn = function(func) 
    return coroutine.wrap(func)()
end

local function isAlive(Player, headCheck)
    local Player = Player or LocalPlayer
    if Player and Player.Character and ((Player.Character:FindFirstChildOfClass("Humanoid")) and (Player.Character:FindFirstChild("HumanoidRootPart")) and (headCheck and Player.Character:FindFirstChild("Head") or not headCheck)) then
        return true
    else
        return false
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

-- Combat tab

runFunction(function()
    AutoClickerCPS = {Value = 15}
    AutoClickerEnabled = false
    AutoClicker = Tabs.Combat:CreateToggle({
        Name = "UniversalAutoClicker",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                AutoClickerEnabled = true
                while AutoClickerEnabled do
                    if mouse1click and (isrbxactive and isrbxactive() or iswindowactive and iswindowactive()) then
                        local clickfunc = (mouse1click)
                        clickfunc()
                        task.wait(1 / AutoClickerCPS.Value)
                    end
                end
            else
                AutoClickerEnabled = false
            end
        end
    })

    AutoClickerCPS = AutoClicker:CreateSlider({
        Name = "CPS",
        Function = function() end,
        Min = 0,
        Max = 20,
        Default = 13,
        Round = 0
    })
end)

-- Movement tab

runFunction(function()
    AutoClicker = Tabs.Movement:CreateToggle({
        Name = "AutoWalk",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                RunLoops:BindToRenderStep("AutoWalk", function()
                    if isAlive() then
                        LocalPlayer.Character.Humanoid:Move(Vector3.new(0, 0, -1), true)
                    end
                end)
            else
                RunLoops:UnbindFromRenderStep("AutoWalk")
            end
        end
    })
end)


runFunction(function()
    local Flight = Tabs.Movement:CreateToggle({
        Name = "Flight",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                workspace.Gravity = 0
            else
                workspace.Gravity = 196
            end
        end
    })
end)


runFunction(function()
    local TPValue = {Value = 5}
    local isTeleporting = false
    local ForwardTP = Tabs.Movement:CreateToggle({
        Name = "ForwardTP",
        Keybind = nil,
        Callback = function(callback)
            if callback and not isTeleporting then
                isTeleporting = true
                if LocalPlayer.Character then
                    local humanoid = LocalPlayer.Character.Humanoid
                    if humanoid.MoveDirection.Magnitude > 0 or humanoid:GetState() == Enum.HumanoidStateType.Running then
                        local forwardVector = LocalPlayer.Character.HumanoidRootPart.CFrame.lookVector
                        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + forwardVector * TPValue.Value
                    end
                end
                isTeleporting = false
                ForwardTP:silentToggle()
                else
                
            end
        end
    })
    
    TPValue = ForwardTP:CreateSlider({
        Name = "Studs",
        Function = function(v)
            TPValue.Value = v
        end,
        Min = 0,
        Max = 50,
        Default = 5,
        Round = 0
    })
end)

runFunction(function()
    --[[
        Note:
        3 - Jumping
        5 - Freefall
    ]]
    local HighJump
    local HighJumpPower = {Value = 20}
    HighJump = Tabs.Movement:CreateToggle({
        Name = "HighJump",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                LocalPlayer.Character.Humanoid:ChangeState(3)
                task.wait()
                spawn(function()
                    for i = 1, HighJumpPower.Value do
                        wait()
                        if (not callback) then return end
                        LocalPlayer.Character.Humanoid:ChangeState(3)
                    end
                end)
                spawn(function()
                    for i = 1, HighJumpPower.Value / 28 do
                        task.wait(0.1)
                        LocalPlayer.Character.Humanoid:ChangeState(5)
                        task.wait(0.1)
                        LocalPlayer.Character.Humanoid:ChangeState(3)
                    end
                end)
                HighJump:silentToggle()
            else
                return
            end
        end
    })
    HighJumpPower = HighJump:CreateSlider({
        Name = "Force",
        Function = function() end,
        Min = 0,
        Max = 50,
        Default = 25,
        Round = 0
    })
end)

runFunction(function()
    local SpeedValue = {Value = 23}
    Speed = Tabs.Movement:CreateToggle({
        Name = "Speed",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                LocalPlayer.Character.Humanoid.WalkSpeed = SpeedValue.Value
            else
                Humanoid.WalkSpeed = 16
            end
        end
    })

    Speed = Speed:CreateSlider({
    Name = "Speed",
    Function = function(v)
        LocalPlayer.Character.Humanoid.WalkSpeed = SpeedValue.Value or v
    end,
    Min = 0,
    Max = 200,
    Default = 16,
    Round = 0
})
end)

--Render

runFunction(function()
    local chinahattrail
    local ChinaHatEnabled = false
    Tabs.Render:CreateToggle({
        Name = "ChinaHat",
        Keybind = nil,
        Callback = function(callback)
            ChinaHatEnabled = callback
            if ChinaHatEnabled then
                spawn(function()
                    repeat
                        task.wait(0.3)
                        if (not ChinaHatEnabled) then return end
                        if entity.isAlive then
                            if chinahattrail == nil or chinahattrail.Parent == nil then
                                chinahattrail = Instance.new("Part")
                                chinahattrail.CFrame = LocalPlayer.Character.Head.CFrame * CFrame.new(0, 1.1, 0)
                                chinahattrail.Size = Vector3.new(3, 0.7, 3)
                                chinahattrail.Name = "ChinaHat"
                                chinahattrail.Material = Enum.Material.Neon
                                chinahattrail.CanCollide = false
                                chinahattrail.Transparency = 0.3
                                local chinahatmesh = Instance.new("SpecialMesh")
                                chinahatmesh.Parent = chinahattrail
                                chinahatmesh.MeshType = "FileMesh"
                                chinahatmesh.MeshId = "http://www.roblox.com/asset/?id=1778999"
                                chinahatmesh.Scale = Vector3.new(3, 0.6, 3)
                                local chinahatweld = Instance.new("WeldConstraint")
                                chinahatweld.Name = "WeldConstraint"
                                chinahatweld.Parent = chinahattrail
                                chinahatweld.Part0 = LocalPlayer.Character.Head
                                chinahatweld.Part1 = chinahattrail
                                chinahattrail.Parent = RealCamera
                            else
                                chinahattrail.Parent = RealCamera
                                chinahattrail.CFrame = LocalPlayer.Character.Head.CFrame * CFrame.new(0, 1.1, 0)
                                chinahattrail.LocalTransparencyModifier = ((Camera.CFrame.Position - Camera.Focus.Position).Magnitude <= 0.6 and 1 or 0)
                                if chinahattrail:FindFirstChild("WeldConstraint") then
                                    chinahattrail.WeldConstraint.Part0 = LocalPlayer.Character.Head
                                end
                            end
                        else
                            if chinahattrail then 
                                chinahattrail:remove()
                                chinahattrail = nil
                            end
                        end
                    until (not ChinaHatEnabled)
                end)
            else
                if chinahattrail then
                    chinahattrail:Remove()
                    chinahattrail = nil
                end
            end
        end
    })
end)

runFunction(function()
    Tabs.Render:CreateToggle({
        Name = "CustomCrossHair",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                Mouse.Icon = "rbxassetid://9943168532"
            else
                Mouse.Icon = ""
            end
        end
    })
end)

runFunction(function()
    local OldFov = game.Workspace.Camera.FieldOfView
    local NewFov = {Value = 80}
    local FovChanger = Tabs.Render:CreateToggle({
        Name = "FovChanger",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                CurrentCamera.FieldOfView = NewFov.Value
            else
                CurrentCamera.FieldOfView = OldFov
            end
        end
    })
    
    NewFov = FovChanger:CreateSlider({
        Name = "Field Of View",
        Function = function(v)
            CurrentCamera.FieldOfView = v or NewFov.Value
        end,
        Min = 1,
        Max = 150,
        Default = 80,
        Round = 0
    })
end)

runFunction(function()
    Tabs.Render:CreateToggle({
        Name = "Night",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                Lighting.TimeOfDay = "1:00:00"
            else
                Lighting.TimeOfDay = LightingTime
            end
        end
    })
end)

runFunction(function()
    Tabs.Render:CreateToggle({
        Name = "NoAnimation",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                Animation.Disabled = true          
            else
                Animation.Disabled = false            
            end
        end
    })
end)

runFunction(function()
    local Hours = {Value = 13}
    local Minutes = {Value = 0}
    local Seconds = {Value = 0}
    
    TimeOfDay = Tabs.Render:CreateToggle({
        Name = "TimeOfDay",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                Lighting.TimeOfDay = Hours.Value..":"..Minutes.Value..":"..Seconds.Value
            else
                Lighting.TimeOfDay = "13:00:00"
            end
        end
    })
        
    Hours = TimeOfDay:CreateSlider({
        Name = "Hours",
        Function = function()
            Lighting.TimeOfDay = Hours.Value..":"..Minutes.Value..":"..Seconds.Value
        end,
        Min = 0,
        Max = 24,
        Default = 13,
        Round = 0
    })
    
    Minutes = TimeOfDay:CreateSlider({
        Name = "Minutes",
        Function = function()
            Lighting.TimeOfDay = Hours.Value..":"..Minutes.Value..":"..Seconds.Value
        end,
        Min = 0,
        Max = 64,
        Default = 0,
        Round = 0
    })
    
    Seconds = TimeOfDay:CreateSlider({
        Name = "Seconds",
        Function = function()
            Lighting.TimeOfDay = Hours.Value..":"..Minutes.Value..":"..Seconds.Value
        end,
        Min = 0,
        Max = 64,
        Default = 0,
        Round = 0
    })
end)

--Utility

runFunction(function()
    local CameraUnlock = Tabs.Utility:CreateToggle({
        Name = "CameraUnlock",
        Keybind = nil,
        Callback = function(callback) 
            if callback then 
                LocalPlayer.CameraMaxZoomDistance = 99999999
            else
                print("[ManaV2ForRoblox]: no way to make it back.")
            end
        end
    })
end)

runFunction(function()
    local MouseConnection
    local ClickTP = Tabs.Utility:CreateToggle({
        Name = "ClickTP",
        Keybind = nil,
        Callback = function(callback) 
            if callback then 
                MouseConnection = Mouse.Button1Down:Connect(function()
                    if isAlive() and Mouse.Target then 
                        LocalPlayer.Character.HumanoidRootPart.CFrame = Mouse.Hit + Vector3.new(0, 3, 0)
                    end
                end)
            else
                if MouseConnection then 
                    MouseConnection:Disconnect()
                    MouseConnection = nil
                end
            end
        end
    })
end)

runFunction(function()
    local InfinityJump = Tabs.Utility:CreateToggle({
        Name = "InfinityJump",
        Keybind = nil,
        Callback = function(callback) 
            if callback then 
                UserInputService.JumpRequest:Connect(function()
                    if callback then
                        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(3)
                    end
                end)
            else
                
            end
        end
    })
end)

runFunction(function()
    local Noclip = Tabs.Utility:CreateToggle({
        Name = "Noclip",
        Keybind = nil,
        Callback = function(callback) 
            if callback then 
                LocalPlayer.Character.Humanoid:ChangeState(11)
            else
                LocalPlayer.Character.Humanoid:ChangeState(5)
            end
        end
    })
end)

--World

runFunction(function()
    local GravityValue = {Value = 18}
    local GravityEnabled = false
    local Gravity = Tabs.World:CreateToggle({
        Name = "Gravity",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                GravityEnabled = true
                workspace.Gravity = GravityValue.Value
            else
                GravityEnabled = false
                workspace.Gravity = 196.19999694824
            end
        end
    })
    
    GravityValue = Gravity:CreateSlider({
        Name = "Gravity",
        Function = function(v)
            if GravityEnabled then
                workspace.Gravity = v
            end
        end,
        Min = 1,
        Max = 200,
        Default = 196,
        Round = 0
    })
end)

print("[ManaV2ForRoblox/Universal.lua]: Loaded in " .. tostring(tick() - startTick) .. ".")
