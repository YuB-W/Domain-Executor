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
local CurrentCamera = workspace.CurrentCamera
local Camera = workspace.Camera
local Mouse = LocalPlayer:GetMouse()
local PlayerGui = LocalPlayer.PlayerGui
local Animation = Character.Animate
local Collectibles = workspace.Collectibles

local entity = Mana.Entity
local GuiLibrary = Mana.GuiLibrary
local Tabs = Mana.Tabs
local Functions = Mana.Functions

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

local BeeSwarm = {
    DispenserRemote = ReplicatedStorage.Events.ToyEvent
}

runFunction(function()
	AutoDig = Tabs.Utility:CreateToggle({
        Name = "AutoDig",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                RunLoops:BindToRenderStep("AutoDig", function()
                    for i, v in pairs(LocalPlayer.Character:GetChildren()) do 
						if v:IsA("Tool") then 
							v.ClickEvent:FireServer()
						end
					end
                end)
            else
                RunLoops:UnbindFromRenderStep("AutoDig")
            end
        end
    })
end)

runFunction(function()
	local FarmLeavesSpeed = {Value = 0.1}
	local FarmLeavesEnabled = false
	local Info = TweenInfo.new(FarmLeavesSpeed.Value or 0.1)
    local Item = {}
	FarmLeaves = Tabs.Utility:CreateToggle({
        Name = "FarmLeaves",
        Keybind = nil,
        Callback = function(callback)
            if callback then
				FarmLeavesEnabled = true
                RunLoops:BindToRenderStep("FarmLeaves", function()
                    wait(1)    
					for i, v in pairs(workspace:GetDescendants()) do
						if FarmLeavesEnabled then
							if string.find(v.Name, "LeafBurst") then
							LocalPlayer.Character.HumanoidRootPart.CFrame = v.Parent.CFrame * CFrame.new(0,0,0)
							end
						end
					end

					for i,v in pairs(Collectibles:GetChildren()) do
						if FarmLeavesEnabled then
							if tostring(v) == tostring(game.Players.LocalPlayer.Name) or tostring(v) == test then
								if (v.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 60 then
									Item.CFrame = CFrame.new(v.Position.x, plr.Character.HumanoidRootPart.Position.y, v.Position.z)
									local Tween = TweenService:Create(LocalPlayer.Character.HumanoidRootPart, Info, Item)
									Tween:Play()
								end
							end
						end
					end
                end)
            else
                RunLoops:UnbindFromRenderStep("FarmLeaves")
            end
        end
    })

	FarmLeavesSpeed = FarmLeaves:CreateSlider({
        Name = "FarmSpeed",
        Function = function(v)
			FarmLeavesSpeed = v or 0.1
		end,
        Min = 0,
        Max = 1,
        Default = 0.1,
        Round = 1
    })
end)

runFunction(function()
	local FarmTokensSpeed = {Value = 0.1}
	local FarmTokensEnabled = false
	local Info = TweenInfo.new(FarmTokensSpeed.Value or 0.1)
    local Item = {}
	FarmTokens = Tabs.Utility:CreateToggle({
        Name = "FarmTokens and Bubbels",
        Keybind = nil,
        Callback = function(callback)
            if callback then
				FarmLeavesEnabled = true
                RunLoops:BindToRenderStep("FarmTokens", function()
					for i,v in pairs(Collectibles:GetChildren()) do
						if FarmLeavesEnabled then
							wait(1)
							if v.Name == "C" then
								if v.Transparency ~= 0.699999988079071 then -- check if that coin is already collected 
									LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
								end
							end
						end
					end
                end)
            else
                RunLoops:UnbindFromRenderStep("FarmTokens")
            end
        end
    })

	FarmTokensSpeed = FarmTokens:CreateSlider({
        Name = "FarmSpeed",
        Function = function(v)
			FarmTokensSpeed = v or 0.1
		end,
        Min = 0,
        Max = 1,
        Default = 0.1,
        Round = 1
    })
end)

runFunction(function()
	MemoryMatchHack = Tabs.Utility:CreateToggle({
        Name = "MemoryMatchHack",
        Keybind = nil,
        Callback = function(callback)
            if callback then
				 RunLoops:BindToRenderStep("MemoryMatchHack", function()
					for i,v in pairs(PlayerGui.ScreenGui:WaitForChild("MinigameLayer"):GetChildren()) do
						for o, b in pairs(v:WaitForChild("GuiGrid"):GetDescendants()) do
							if b.Name == "ObjContent" or q.Name == "ObjImage" then
								b.Visible = true
							end
						end
					end
				end)
            else
				RunLoops:UnbindFromRenderStep("MemoryMatchHack")
            end
        end
    })
end)

print("[ManaV2ForRoblox/Scripts/1537690962.lua]: Loaded in " .. tostring(tick() - startTick) .. ".")
