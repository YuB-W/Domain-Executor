--[[
    Credits to anyones code i used or looked at
]]

repeat task.wait() until game:IsLoaded()

local startTick = tick()

local request = (syn and syn.request) or request or http_request or (http and http.request)
local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport
local setthreadidentityfunc = syn and syn.set_thread_identity or set_thread_identity or setidentity or setthreadidentity
local getthreadidentityfunc = syn and syn.get_thread_identity or get_thread_identity or getidentity or getthreadidentity

--Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

--Instances
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character
local HumanoidRootPart = Character.HumanoidRootPart
local Humanoid = Character.Humanoid
local GameCamera = workspace.CurrentCamera
local RealCamera = workspace.Camera
local Mouse = LocalPlayer:GetMouse()
local PlayerGui = LocalPlayer.PlayerGui
local PlayerScripts = LocalPlayer.PlayerScripts
local Leaderstats = LocalPlayer.leaderstats
local LightingTime = Lighting.TimeOfDay 

--Mana instances
local GuiLibrary = Mana.GuiLibrary
local Tabs = Mana.Tabs
local Functions = Mana.funcs

-- Loadstrings
entity = loadstring(game:HttpGet("https://raw.githubusercontent.com/Maanaaaa/ManaV2ForRoblox/main/Modules/EntityHandler.lua", true))()

--What do i write here
local function runFunction(func) func() end
local getasset = getsynasset or getcustomasset

do
    local oldcharacteradded = entity.characterAdded
    entity.characterAdded = function(plr, char, localcheck)
        return oldcharacteradded(plr, char, localcheck, function() end)
    end
    entity.fullEntityRefresh()
end

local function isAlive(plr)
	if plr then
		return plr and plr.Character and plr.Character.Parent ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid")
	end
	return LocalPlayer and LocalPlayer.Character and LocalPlayer.Character.Parent ~= nil and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Head") and LocalPlayer.Character:FindFirstChild("Humanoid")
end

local function targetCheck(plr, check)
	return (check and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("ForceField") == nil or check == false)
end

local function isPlayerTargetable(plr, target)
    return plr ~= LocalPlayer and plr and isAlive(plr) and targetCheck(plr, target)
end

local function GetAllNearestHumanoidToPosition(distance, amount)
    local returnedplayer = {}
    local currentamount = 0
    if entity.isAlive then -- alive check
        for i, v in pairs(game.Players:GetChildren()) do -- loop through players
            if isPlayerTargetable((v), true, true, v.Character ~= nil) and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") and currentamount < amount then -- checks
                local mag = (LocalPlayer.Character.HumanoidRootPart.Position - v.Character:FindFirstChild("HumanoidRootPart").Position).magnitude
                if mag <= distance then -- mag check
                    table.insert(returnedplayer, v)
                    currentamount = currentamount + 1
                end
            end
        end
        for i2,v2 in pairs(game:GetService("CollectionService"):GetTagged("Monster")) do -- monsters
            if v2:FindFirstChild("HumanoidRootPart") and currentamount < amount and v2.Name ~= "Duck" then -- no duck
                local mag = (LocalPlayer.Character.HumanoidRootPart.Position - v2.HumanoidRootPart.Position).magnitude
                if mag <= distance then -- magcheck
                    table.insert(returnedplayer, {Name = (v2 and v2.Name or "Monster"), UserId = 1443379645, Character = v2}) -- monsters are npcs so I have to create a fake player for target info
                    currentamount = currentamount + 1
                end
            end
        end
    end
    return returnedplayer -- table of attackable entities
end

local spawn = function(func) 
    return coroutine.wrap(func)()
end

local function GetRemote(tab)
    for i,v in pairs(tab) do
        if v == "Client" then
            return tab[i + 1]
        end
    end
    return ""
end

local function GetValue(thingg)
    return {thinggg = thingg}
end

local function playsound(id, volume) 
    local sound = Instance.new("Sound")
    sound.Parent = workspace
    sound.SoundId = id
    sound.PlayOnRemove = true 
    if volume then 
        sound.Volume = volume
    end
    sound:Destroy()
end


local function playanimation(id) 
    if isAlive() then 
        local animation = Instance.new("Animation")
        animation.AnimationId = id
        local animatior = LocalPlayer.Character.Humanoid.Animator
        animatior:LoadAnimation(animation):Play()
    end
end

-- Bedwars remotes, functions and tables
local Client = require(game:GetService("ReplicatedStorage").TS.remotes).default.Client
local Flamework = require(ReplicatedStoragerbxts_includenode_modules@flamework.core.out).Flamework
local RemoteFolder = ReplicatedStoragerbxts_includenode_modules@rbxtsnetout_NetManaged
local KnitClient = debug.getupvalue(require(PlayerScripts.TS.knit).setup, 6)

local Bedwars = {
    --AttackEntityController = Client:Get(getremote(debug.getconstants(getmetatable(KnitClient.Controllers.SwordController)attackEntity))),
    AttackRemote = GetRemote(debug.getconstants(KnitClient.Controllers.SwordController.sendServerRequest)),
    BalloonController = KnitClient.Controllers.BalloonController,
    BlockEngine = require(ReplicatedStoragerbxts_includenode_modules@easy-gamesblock-engine.out).BlockEngine,
    BlockPlacer = require(ReplicatedStoragerbxts_includenode_modules@easy-gamesblock-engine.out.client.placementblock-placer).BlockPlacer,
    ClientBlockEngine = require(PlayerScripts.TS.libblock-engineclient-block-engine).ClientBlockEngine,
    ClientHandler = Client,
    CombatConstant = require(ReplicatedStorage.TS.combatcombat-constant).CombatConstant,
    FallRemote = ReplicatedStoragerbxts_includenode_modules@rbxts.net.out_NetManaged.GroundHit,
    GuitarController = ReplicatedStorage.rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.PlayGlitchGuitar,
    InventoryUtil = require(ReplicatedStorage.TS.inventoryinventory-util).InventoryUtil,
    ItemTableFunction = require(ReplicatedStorage.TS.itemitem-meta).getItemMeta,
    ItemMeta = require(ReplicatedStorage.TS.itemitem-meta), 
    MatchEnd = require(PlayerScripts.TS.controllers.game.matchmatch-end-controller).MatchEndController,
    MatchState = require(ReplicatedStorage.TS.matchmatch-state).MatchState,
    QueueMeta = require(ReplicatedStorage.TS.gamequeue-meta).QueueMeta,
    QueryUtil = require(ReplicatedStoragerbxts_includenode_modules@easy-gamesgame-core.out).GameQueryUtil,
    SprintController = require(PlayerScripts.TS.controllers.global.sprintsprint-controller).SprintController,
    SwordController = require(PlayerScripts.TS.controllers.global.combat.swordsword-controller).SwordController,
    ScytheDash = ReplicatedStorage.rbxts_include.node_modules@rbxts.net.out._NetManaged.ScytheDash,
    SwitchToolController = ReplicatedStoragerbxts_includenode_modules@rbxts.net.out._NetManaged.SetInvItem,
    ShopItems = debug.getupvalue(debug.getupvalue(require(ReplicatedStorage.TS.games.bedwars.shopbedwars-shop).BedwarsShop.getShopItem, 1), 2),

	PingController = require(PlayerScripts.TS.controllers.game.pingping-controller).PingController,

}
KnockbackTable = debug.getupvalue(require(ReplicatedStorage.TS.damageknockback-util).KnockbackUtil.calculateKnockbackVelocity, 1)
--KnockbackUtil = require(ReplicatedStorage.TS.damageknockback-util).KnockbackUtil
ClientStore = require(PlayerScripts.TS.ui.store).ClientStore
--ItemStuff = debug.getupvalue(ReplicatedStorage.TS.itemitem-meta.getItemMeta, 1)
ItemTable = debug.getupvalue(Bedwars.ItemTableFunction, 1)
MacthTime = ClientStore:getState().Game.matchState

local function getqueuetype()
    local queuetype = "bedwars_test"
    pcall(function()
        queuetype = ClientStore:getState().Game.queueType
    end)
    return queuetype
end

local function getItem(itemName)
    for i5, v5 in pairs(getinv(LocalPlayer)items) do
        if v5itemType == itemName then
            return v5, i5
        end
    end
    return nil
end

function getwool()
    for i5, v5 in pairs(getinv(LocalPlayer).items) do
        if v5.itemType:match("wool") or v5.itemType:match("grass") then
            return v5.itemType, v5.amount
        end
    end	
    return nil
end

local function getEquipped()
    local typetext = ""
    local obj = (entity.isAlive and LocalPlayer.Character:FindFirstChild("HandInvItem") and LocalPlayer.Character.HandInvItem.Value or nil)
    if obj then
        if obj.Name:find("sword") or obj.Name:find("blade") or obj.Name:find("baguette") or obj.Name:find("scythe") or obj.Name:find("dao") then
            typetext = "sword"
        end
        if obj.Name:find("wool") or ItemTable[obj.Name]block then
            typetext = "block"
        end
        if obj.Name:find("bow") then
            typetext = "bow"
        end
    end
    return {Object = obj, Type = typetext}
end

function SwitchTool(tool)
    Character = LocalPlayer.Character
    Bedwars.SwitchToolController:InvokeServer({
    hand = tool,
  })
  repeat task.wait() until Character.HandInvItem == tool
end

function hash(p1)
    local hashmod = require(ReplicatedStorage.TSremote-hashremote-hash-util)
    local toret = hashmod.RemoteHashUtil:prepareHashVector3(p1)
    return toret
end

function getinv(plr)
    local plr = plr or LocalPlayer
    local thingy, thingytwo = pcall(function() return Bedwars.InventoryUtil.getInventory(plr) end)
    return (thingy and thingytwo or {
        items = {},
        armor = {},
        hand = nil
    })
end

function GetSword()
    local sd
    local higherdamage
    local swordslots
    local swords = getinv().items
    for i, v in pairs(swords) do
        if v.itemType:lower():find("sword") or v.itemType:lower():find("blade") then
            if higherdamage == nil or itemstuff[v.itemType].sword.damage > higherdamage then
                sd = v
                higherdamage = itemstuff[v.itemType].sword.damage
                swordslots = i
            end
        end
    end
    return sd, swordslots
end

local blocktable = Bedwars.ClientBlockEngine.new(Bedwars.BlockEngine, getwool())
function placeblockthing(newpos, customblock)
    local placeblocktype = (customblock or getwool())
    blocktable.blockType = placeblocktype
    if Bedwars.BlockEngine:isAllowedPlacement(LocalPlayer, placeblocktype, Vector3.new(newpos.X / 3, newpos.Y / 3, newpos.Z / 3)) and getItem(placeblocktype) then
        return blocktable:placeBlock(Vector3.new(newpos.X / 3, newpos.Y / 3, newpos.Z / 3))
    end
end

local oldpos = Vector3.new(0, 0, 0)
function getScaffold(vec, diagonaltoggle)
    local realvec = Vector3.new(math.floor((vec.X / 3) + 0.5) * 3, math.floor((vec.Y / 3) + 0.5) * 3, math.floor((vec.Z / 3) + 0.5) * 3) 
    local newpos = (oldpos - realvec)
    local returedpos = realvec
        if entity.isAlive then
            local angle = math.deg(math.atan2(-LocalPlayer.Character.Humanoid.MoveDirection.X, -LocalPlayer.Character.Humanoid.MoveDirection.Z))
            local goingdiagonal = (angle >= 130 and angle <= 150) or (angle <= -35 and angle >= -50) or (angle >= 35 and angle <= 50) or (angle <= -130 and angle >= -150)
            if goingdiagonal and ((newpos.X == 0 and newpos.Z ~= 0) or (newpos.X ~= 0 and newpos.Z == 0)) and diagonaltoggle then
                return oldpos
            end
        end
    return realvec
end

--Clone system

local IsClone = false

local RealCharacter
local Clone
function MakeClone()
    RealCharacter = LocalPlayer.Character
    RealCharacter.Archivable = true
    Clone = RealCharacter:Clone()
    Clone.Parent = workspace
    LocalPlayer.Character = Clone
end

local SecondClone
function MakeSecondClone()
    SecondClone = realchar:Clone()
    SecondClone.Parent = workspace
end

function GetMapName()
    for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
        if v.Name == "Map" then
            if v:FindFirstChild("Worlds") then
                for g, c in pairs(v.Worlds:GetChildren()) do
                    if c.Name ~= "Void_World" then
                        return c.Name
                    end
		        end
		    end
		end
	end
end

-- Combat
runFunction(function()
    local oldbs
    local conectionkillaura
    local animspeed = {Value = 0.3}
    local AttackSpeed = {Value = 15}
    local AutoRotate = {Value = true}
    local DistVal = {Value = 10}
    local origC0 = game.ReplicatedStorage.Assets.Viewmodel.RightHand.RightWrist.C0
    local KillAura = Tabs.Combat:CreateToggle({
        Name = "KillAura",
        Keybind = nil,
        Callback = function(v)
            if v then
                spawn(function()
                    repeat
                        for i,v in pairs(game.Players:GetChildren()) do
                            wait(0.01)
                            if v.Character and v.Name ~= game.Players.LocalPlayer.Name and v.Character:FindFirstChild("HumanoidRootPart") then
                                local mag = (v.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                                if mag <= DistVal.Value and v.Team ~= game.Players.LocalPlayer.Team and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                                    task.wait(1/AttackSpeedValue)
                                    local PlayerSword = getEquipped()Type
                                    if getEquipped()Type == "sword" then 
                                        if AutoRotate.Value == true then
                                            local targetPosition = v.Character.Head.Position
                                            local localPosition = LocalPlayer.Character.HumanoidRootPart.Position
                                            local lookVector = (targetPosition - localPosition).Unit
                                            local newYaw = math.atan2(-lookVector.X, -lookVector.Z)
                                            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(localPosition) * CFrame.Angles(0, newYaw, 0)
                                        end
                                        BedwarsRemotes.SwordController:swingSwordAtMouse()
                                    end
                                end
                            end
                        end                    
                    until (not v)
                end)
            end
        end
    })

    AutoRotate = KillAura:CreateOptionTog({
        Name = "AutoRotate",
        Default = true,
        Func = function()
        end
        
    })
    AttackSpeed = KillAura:CreateSlider({
        Name = "AttackSpeed",
        Function = function() end,
        Min = 0,
        Max = 20,
        Default = 15,
        Round = 1
    })
    DistVal = KillAura:CreateSlider({
        Name = "AttackDistance",
        Function = function() end,
        Min = 1,
        Max = 15,
        Default = 10,
        Round = 0
    })
end)

runFunction(function()
    local velohorizontal = {Value = 0}
    local velovertical = {Value = 0}
    local velocitytog = Tabs.Combat:CreateToggle({
        Name = "Velocity",
        Keybind = nil,
        Callback = function(v)
            getgenv().veloval = v
            spawn(function()
                if getgenv().veloval then
                    if not Humanoid then return end
                    if Humanoid then
                        KnockbackTablekbDirectionStrength = 0
                        KnockbackTablekbUpwardStrength = 0
                    end
                else
                    KnockbackTablekbDirectionStrength = 100
                    KnockbackTablekbUpwardStrength = 100
                    return
                end
            end)
        end
    })
    velohorizontal = velocitytog:CreateSlider({
        Name = "Horizontal",
        Function = function() 
            if Humanoid then
                KnockbackTablekbDirectionStrength = velohorizontalValue
            end
        end,
        Min = 0,
        Max = 100,
        Default = 0,
        Round = 0
    })
    velovertical = velocitytog:CreateSlider({
        Name = "Vertical",
        Function = function() 
            if Humanoid then
                KnockbackTablekbUpwardStrength = veloverticalValue
            end
        end,
        Min = 0,
        Max = 100,
        Default = 0,
        Round = 0
    })
end)

runFunction(function()
    local ACC1
    local ACC2
    local testtogttt = {Value = 2}
    local autoclickertog = Tabs.Combat:CreateToggle({
        Name = "AutoClicker",
        Keybind = nil,
        Callback = function(v)
            if v then
                local holding = false
                ACC1 = UserInputService.InputBegan:connect(function(input, gameProcessed)
                    if gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 then
                        holding = true
                    end
                end)
                ACC2 = UserInputService.InputEnded:connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        holding = false
                    end
                end)
                spawn(function()
                    repeat
                        task.wait(1/testtogtttValue)
                        if holding then
                            if holding == false then return end
                            if getEquipped()Type == "sword" then 
                                if holding == false then return end
                                BedwarsRemotes.SwordController:swingSwordAtMouse()
                            end
                        end
                    until (not v)
                end)
            else
                ACC1:Disconnect()
                ACC2:Disconnect()
                return
            end
        end
    })
    testtogttt = autoclickertog:CreateSlider({
        Name = "CPS",
        Function = function() end,
        Min = 1,
        Max = 20,
        Default = 20,
        Round = 0
    })
end)

runFunction(function()
	Tabs.Combat:CreateToggle({
		Name = "NoClickDelay",
		Keybind = nil,
		Callback = function(v)
			getgenv().funisus = v
			spawn(function()
				if getgenv().funisus and entity.isAlive then
					for i2,v2 in pairs(ItemTable) do
						if type(v2) == "table" and rawget(v2, "sword") then
							v2.sword.attackSpeed = 0.0000000001
						end
						BedwarsRemotes.SwordController.isClickingTooFast = function() return false end
					end
				else
				end
			end)
		end
	})
end)

runFunction(function()
    local reachvalue = {Value = 18}
    local reachtog = Tabs.Combat:CreateToggle({
        Name = "Reach",
        Keybind = nil,
        Callback = function(v)
            getgenv().reachval = v
            if getgenv().reachval then
                BedwarsRemotes.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE = reachvalueValue
            else
                BedwarsRemotes.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE = 14.4
            end
        end
    })
    reachvalue = reachtog:CreateSlider({
        Name = "Reach",
        Function = function() 
            BedwarsRemotes.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE = reachvalueValue
        end,
        Min = 1,
        Max = 18,
        Default = 18,
        Round = 1
    })
end)

-- Movement
runFunction(function()
	local sprint = false
	Tabs.Movement:CreateToggle({
		Name = "Sprint",
		Keybind = nil,
		Callback = function(v)
			sprint = v
			if sprint then
				spawn(function()
					repeat
						wait()
						if (not sprint) then return end
						if BedwarsRemotes.SprintController.sprinting == false then
							BedwarsRemotes.SprintController:startSprinting()
						end
					until (not sprint)
				end)
			else
				BedwarsRemotes.SprintController:stopSprinting()
			end
		end
	})
end)

do
	spawn(function()
		while wait(1) do
			matchState =ClientStore:getState().Game.matchState
		end
	end)
end

runFunction(function() 
	--why no
	local cloneval = false
	local CloneGodmodeFullDisabler
	CloneGodmodeFullDisabler = Tabs.Movement:CreateToggle({
		Name = "CloneGodmodeFullDisabler",
		Keybind = nil,
		Callback = function(v)
			cloneval = v
			if cloneval then
				spawn(function()
					IsClone = true
					clonemake()
					speedd = 200
					connectionnnn = game:GetService("RunService").Heartbeat:connect(function()
						local velo = clone.Humanoid.MoveDirection * speedd
						Clone.HumanoidRootPart.Velocity = Vector3.new(velo.x, LocalPlayer.Character.HumanoidRootPart.Velocity.y, velo.z)
					end)
				end)
				repeat task.wait() until (matchState == 2)
				CloneGodmodeFullDisabler:Toggle()
			else
				Clone:remove()
				LocalPlayer.Character = RealCharacter
				RealCharacter.Humanoid:ChangeState("Dead")
				IsClone = false
				connectionnnn:Disconnect()
				return
			end
		end
	})
end)

--Render

runFunction(function()
	local SpawnParts = {}
	TabsRender:CreateToggle({
		Name = "SpawnESP",
		Keybind = nil,
		Callback = function(v)
			if v then 
				for i,v2 in pairs(workspace.MapCFrames:GetChildren()) do 
					if v2.Name:find("spawn") and v2.Name ~= "spawn" and v2.Name:find("respawn") == nil then
						local part = Instance.new("Part")
						part.Size = Vector3.new(1, 1000, 1)
						part.Position = v2.Value.p
						part.Anchored = true
						part.Parent = workspace
						part.CanCollide = false
						part.Transparency = 0.5
						part.Material = Enum.Material.Neon
						part.Color = Color3.new(1, 0, 0)
						BedwarsRemotes.QueryUtil:setQueryIgnored(part, true)
						table.insert(SpawnParts, part)
					end
				end
			else
				for i,v in pairs(SpawnParts) do v:Destroy() end
				table.clear(SpawnParts)
			end
		end
	})
end)

--Utility
local lcmapname = GetMapName()

runFunction(function()
	Tabs.Utility:CreateToggle({
		Name = "NoFall",
		Keybind = nil,
		Callback = function(v)
			if entity.isAlive then
				spawn(function()
					repeat
						if v == false then return end
						wait(0.5)
						BedwarsRemotes.FallRemote:FireServer(workspace.Map.Worlds[lcmapname].Blocks,1645488277.345853)
					until v == false
				end)
			end
		end
	})
end)


runFunction(function()
	local connections = {}
	local suffix
	local BedPrint 
	local KillPrint
	local BedDestroyedPrint

	local BedBreakAuto = {Value = false}
	local BedDestroyedAuto = {Value = false}
	local FinalkillAuto = {Value = false}
	local SuffixDrop = {Value = ""}

	AutoToxic = Tabs.Utility:CreateToggle({
		Name = "AutoToxic",
		Keybind = nil,
		Callback = function(v)
			spawn(function()  
				Client:WaitFor("EntityDeathEvent"):andThen(function(p6)
					p6:Connect(function(p7)
						if p7.fromEntity == LocalPlayer.Character then
							if FinalkillAuto.Value == true then
								local Playerr = game.Players:GetPlayerFromCharacter(p7.entityInstance)
								local toxicmessage = KillPrint .. " " .. teamname .. " " .. SuffixDrop.Value
								if v == true then
								TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(toxicmessage)
								end
							end
						end
					end)        
				end)
			end)
			spawn(function()
				getgenv().valspeed = v
				if getgenv().valspeed then
					spawn(function()
						Client:WaitFor("BedwarsBedBreak"):andThen(function(p13)
							p13:Connect(function(p14)
								if p14.player.UserId == LocalPlayer.UserId then
									if BedBreakAuto.Value == true then
										local team = queuemeta[clntstorehandlr:getState().Game.queueType or "bedwars_test.teams[tonumber(p14.brokenBedTeam.id)]
										local teamname = team and team.displayName:lower() or "white"
										local toxicmessage = BedPrint .. " " .. teamname .. " " .. SuffixDrop.Value
										if v == true then
										TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(toxicmessage)
										end
									end
								end
							end)
						end)
					end)
				end
			end)
			spawn(function()
				if LocalPlayer.leaderstats.Bed.Value ~= "✅" then
					if BedDestroyedAuto.Value == true then
						TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(BedDestroyedPrint)
					end
				end
			end)
		end
	})

	BedBreakAuto = AutoToxic:CreateOptionTog({
		Name = "BedB",
		Default = false,
		Func = function()
		end 
	})
	BedDestroyedAuto = AutoToxic:CreateOptionTog({
		Name = "BedD",
		Default = false,
		Func = function()
		end 
	})
	FinalkillAuto = AutoToxic:CreateOptionTog({
		Name = "Kill",
		Default = false,
		Func = function()
		end 
	})

	--[[ soon
	DeathAuto = AutoToxic:CreateOptionTog({
		Name = "Death"
		Function = function() end,
		Default = false
	})]]

	BedBreakDrop = AutoToxic:CreateDropDown({
		Name = "Bed break",
		Function = function(val)
			BedPrint = val   
		end,
		Text = "BedB",
		List = {"Nice bed", "Easy bed", "Go to lobby"},
		Default = "Easy bed"
	})
	BedDeatroyedDrop = AutoToxic:CreateDropDown({
		Name = "Bed destroyed",
		Function = function(val)
			BedDestroyedPrint = val   
		end,
		Text = "BedD",
		List = {"Who broke my bed :(", "Who ever broke my bed, i have your IP adress."},
		Default = "Who broke my bed :("
	})

	--[[ soon
	DeathDrop = AutoToxic:CreateDropDown({
		Name = "Death",
		Function = function(val)
			DeathPrint = val
		end,
		Text = "Value",
		List = {"You killed me, that's why you won", "My gaming chair expired, that's why you won"},
		Default = "You killed me, that's why you won"
	})]]

	FinalKillDrop = AutoToxic:CreateDropDown({
		Name = "kill",
		Function = function(val)
			KillPrint = val
		end,
		Text = "Kill",
		List = {"Killed", "L"},
		Default = "Killed"
	})
	SuffixDrop = AutoToxic:CreateDropDown({
		Name = "Suffix",
		Function = function(val)
			suffix = val
		end,
		Text = "Suffix",
		List = {"| Mana", "| ManaV2", ""},
		Default = "| Mana"
	})
end)

runFunction(function()
	local tiered = {}
	local nexttier = {}

	for i,v in pairs(BedwarsRemotes.ShopItems) do
		if type(v) == "table" then 
			if v.tiered then
				tiered[v.itemType] = v.tiered
			end
			if v.nextTier then
				nexttier[v.itemType] = v.nextTier
			end
		end
	end

	Tabs.Utility:CreateToggle({
		Name = "ShopTierSkip",
		Keybind = nil,
		Callback = function(v)
			if v then
				for i,v in pairs(BedwarsRemotes.ShopItems) do
					if type(v) == "table" then 
						v.tiered = nil
						v.nextTier = nil
					end
				end
			else
				for i,v in pairs(BedwarsRemotes.ShopItems) do
					if type(v) == "table" then 
						if tiered[v.itemType] then
							v.tiered = tiered[v.itemType]
						end
						if nexttier[v.itemType] then
							v.nextTier = nexttier[v.itemType]
						end
					end
				end
			end
		end
	})
end)

runFunction(function()
	--idk if someone will still use it
	Tabs.Utility:CreateToggle({
		Name = "ScytheDisabler",
		Keybind = nil,
		Callback = function(v)
			if v then
				RunService.RenderStepped:Connect(function()

					local args = {
						[1] = {
							direction = HumanoidRootPart.CFrame.LookVector
						}
					}
				
					if v == true then
						ScytheDash:FireServer(unpack(args))
					end

				end)
			end
		end
	})
end)

runFunction(function()
	Tabs.Utility:CreateToggle({
		Name = "AfkFarm",
		Keybind = nil,
		Callback = function(v)
			if v then
				local char = game:GetService("Players").LocalPlayer.Character
				char:FindFirstChild("HumanoidRootPart").CFrame = char:FindFirstChild("HumanoidRootPart").CFrame + Vector3.new(0,99,0)
				char:FindFirstChild("Head").Anchored = true
				char:FindFirstChild("UpperTorso").Anchored = true
				char:FindFirstChild("UpperTorso").Anchored = true
			else
				local char = game:GetService("Players").LocalPlayer.Character
				char:FindFirstChild("HumanoidRootPart").CFrame = char:FindFirstChild("HumanoidRootPart").CFrame + Vector3.new(0,99,0)
				char:FindFirstChild("Head").Anchored = false
				char:FindFirstChild("UpperTorso").Anchored = false
				char:FindFirstChild("UpperTorso").Anchored = false
			end
		end
	})
end)

runFunction(function()
	Tabs.Utility:CreateToggle({
		Name = "AutoGuitar",
		Keybind = nil,
		Callback = function(v)
			if v then
				AutoGuitarVal = true
				while AutoGuitarVal and task.wait() do
					BedwarsRemotes.GuitarController:FireServer({targets = {}})
				end
			else
				AutoGuitarVal = false
			end
		end
	})
end)

--World
runFunction(function()
	local yes
	local yestwo
	local sussyfunnything
	local sussything = false
	Tabs.World:CreateToggle({
		Name = "Scaffold",
		Keybind = nil,
		Callback = function(o)
			local v = o
			if (v) and entity.isAlive then
				spawn(function()
					yestwo = RunService.Heartbeat:Connect(function(step)
						if (v) then return end
						local y = LocalPlayer.Character.HumanoidRootPart.Position.y
						local x = LocalPlayer.Character.HumanoidRootPart.Position.x
						local z = LocalPlayer.Character.HumanoidRootPart.Position.z
						if (v) then return end
						local blockpos = getScaffold((LocalPlayer.Character.Head.Position) + Vector3.new(1, -math.floor(LocalPlayer.Character.Humanoid.HipHeight * 3), 0) + LocalPlayer.Character.Humanoid.MoveDirection)
						if (v) then return end
						placeblockthing(blockpos, getwool())
					end)
				end)
			else
				yestwo:Disconnect()
			end
		end
	})
end)

--Other
runFunction(function()
	local StatsUpdateDelay = {Value = 0.5}
	local statem = Tabs.Misc:CreateToggle({
		Name = "MatchState",
		Keybind = nil,
		Callback = function(v)
			if v == true then
				a = game:GetService("CoreGui"):FindFirstChild("MatchA_StateB")
				if a then
					a.Enabled = true
				else
					local MatchState = Instance.new("ScreenGui")
					MainBackground = Instance.new("Frame")
					local Frame_Corner = Instance.new("UICorner")
					local Terrible_Tittle = Instance.new("TextLabel")
					local Tittle_Corner = Instance.new("UICorner")
					local UIGradient = Instance.new("UIGradient")
					local Kills_label = Instance.new("TextLabel")
					local Bed_label = Instance.new("TextLabel")
					local Skulls_label = Instance.new("TextLabel")
					--local Map_label = Instance.new("TextLabel")
					local UIListLayout = Instance.new("UIListLayout")
					
					local stats = game.Players.LocalPlayer.leaderstats
					
					MatchState.Name = "MatchA_StateB"
					MatchState.Parent = game:GetService("CoreGui")
					MatchState.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
					
					MainBackground.Name = "MainBackground"
					MainBackground.Parent = MatchState
					MainBackground.BackgroundColor3 = Color3.fromRGB(81, 81, 81)
					MainBackground.BorderColor3 = Color3.fromRGB(0, 0, 0)
					MainBackground.BorderSizePixel = 0
					MainBackground.BackgroundTransparency = 1
					MainBackground.Position = UDim2.new(0, 0, 0.316799998, 0)
					MainBackground.Size = UDim2.new(0, 150, 0, 130)
					MainBackground.Active = true
					MainBackground.Draggable = true
					
					Frame_Corner.CornerRadius = UDim.new(0, 4)
					Frame_Corner.Name = "Frame_Corner"
					Frame_Corner.Parent = MainBackground
					
					Terrible_Tittle.Name = "Tittle"
					Terrible_Tittle.Parent = MainBackground
					Terrible_Tittle.Active = true
					Terrible_Tittle.BackgroundColor3 = Color3.fromRGB(141, 255, 121)
					Terrible_Tittle.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Terrible_Tittle.BorderSizePixel = 0
					Terrible_Tittle.ClipsDescendants = true
					Terrible_Tittle.Size = UDim2.new(0, 150, 0, 25)
					Terrible_Tittle.Font = Enum.Font.Gotham
					Terrible_Tittle.Text = ""
					Terrible_Tittle.TextColor3 = Color3.fromRGB(255, 255, 255)
					Terrible_Tittle.TextSize = 20.000
					Terrible_Tittle.BackgroundTransparency = 0.7
					
					Tittle_Corner.CornerRadius = UDim.new(0, 4)
					Tittle_Corner.Name = "Tittle_Corner"
					Tittle_Corner.Parent = Terrible_Tittle
					
					UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(213, 213, 213)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(213, 213, 213))}
					UIGradient.Parent = MainBackground
					
					Bed_label.Name = "Bedededed_label"
					Bed_label.Parent = MainBackground
					Bed_label.BackgroundColor3 = Color3.fromRGB(81, 81, 81)
					--Bed_label.BackgroundTransparency = 0.500
					Bed_label.BorderColor3 = Color3.fromRGB(134, 134, 134)
					Bed_label.Position = UDim2.new(0, 0, 0.265000015, 0)
					Bed_label.Size = UDim2.new(0, 150, 0, 25)
					Bed_label.Font = Enum.Font.Gotham
					Bed_label.Text = "Bed: nil"
					Bed_label.TextColor3 = Color3.fromRGB(255, 255, 255)
					Bed_label.TextSize = 18.000
					Bed_label.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
					
					Skulls_label.Name = "Skulls_label"
					Skulls_label.Parent = MainBackground
					Skulls_label.BackgroundColor3 = Color3.fromRGB(81, 81, 81)
					--Skulls_label.BackgroundTransparency = 0.500
					Skulls_label.BorderColor3 = Color3.fromRGB(134, 134, 134)
					Skulls_label.Position = UDim2.new(0, 0, 0.400000006, 0)
					Skulls_label.Size = UDim2.new(0, 150, 0, 25)
					Skulls_label.Font = Enum.Font.Gotham
					Skulls_label.Text = "Skulls: nil"
					Skulls_label.TextColor3 = Color3.fromRGB(255, 255, 255)
					Skulls_label.TextSize = 18.000
					Skulls_label.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
					
					--[[
					Map_label.Name = "Mapep_label"
					Map_label.Parent = MainBackground
					Map_label.BackgroundColor3 = Color3.fromRGB(81, 81, 81)
					Map_label.BackgroundTransparency = 0.500
					Map_label.BorderColor3 = Color3.fromRGB(134, 134, 134)
					Map_label.Position = UDim2.new(0, 0, 0.524999976, 0)
					Map_label.Size = UDim2.new(0, 150, 0, 25)
					Map_label.Font = Enum.Font.Gotham
					Map_label.Text = "Map: nil"
					Map_label.TextColor3 = Color3.fromRGB(255, 255, 255)
					Map_label.TextSize = 18.000
					Map_label.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
					--]]
					
					UIListLayout.Parent = MainBackground
					UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
					UIListLayout.Padding = UDim.new(0, 0)
					
					while wait(StatsUpdateDelayValue) do
						Kills_label.Text = "Kills: ".. stats.Kills.Value
						Bed_label.Text = "Bed: ".. stats.Bed.Value
						Skulls_label.Text = "Skulls: ".. stats.Skulls.Value
					end

				end
			else
			game:GetService("CoreGui"):FindFirstChild("MatchA_StateB").Enabled = false
			end
		end
	})

    StatsUpdateDelay = statem:CreateSlider({
        Name = "UpdateDelay",
        Function = function() end,
        Min = 0.1,
        Max = 10,
        Default = 1,
        Round = 1
    })
end)

print("[ManaV2ForRoblox/Scripts/6872274481.lua]: Loaded in " .. tostring(tick() - startTick) .. ".")