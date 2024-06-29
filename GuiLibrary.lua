--[[
    Credits to anyones code i used or looked at
]]

repeat task.wait() until game:IsLoaded()

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

local getasset = getsynasset or getcustomasset
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local configsaving = true
local LastPress = 0
local OnMobile
local TabsFrame
local Tabs = {}
local Fonts = {}
local Keybinds = {}
local Library = {
    Device = "None",
    Scale = 1,
    MobileScale = 0.45,
    Sounds = true,
    GuiKeybind = "N",
    Font = Enum.Font.Arial,
    Notifications = true,
    ChatNotifications = true,
    ArrayListObject = {},
    Objects = {},
    UpdateHud = {},
    Functions = {},
    ColorSystem = { -- idk how i will do it
        Type = "Normal", -- Normal or Custom
        ColorR = 20,
        ColorG = 20,
        ColorB = 20
    }
}

-- Main thing
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "Mana"
ScreenGui.DisplayOrder = 999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.OnTopOfCoreBlur = true
local ClickGui = Instance.new("Frame", ScreenGui)
ClickGui.Name = "ClickGui"
local NotificationGui = Instance.new("Frame", ScreenGui)
NotificationGui.Name = "NotificationGui"
NotificationGui.BackgroundTransparency = 1
NotificationGui.Size = UDim2.new(0, 100, 0, 10)
NotificationGui.Position = UDim2.new(0, 1735, 0, 820)
--NotificationGui.Active = true
--NotificationGui.Draggable = true

Library.ScreenGui = ScreenGui
Library.ClickGui = ClickGui
Library.NotificationGui = NotificationGui

if UserInputService.TouchEnabled then
    Library.Device = "Mobile"
end

for i,v in pairs(Enum.Font:GetEnumItems()) do 
	if v.Name ~= "Arial" then
		table.insert(Fonts, v.Name)
	end
end

Library.FontsList = Fonts

-- Config System
if isfolder("Mana") == false then
    makefolder("Mana")
end

if isfolder("Mana/Assets") == false then
    makefolder("Mana/Assets")
end

if isfolder("Mana/Config") == false then
    makefolder("Mana/Config")
end

if isfolder("Mana/Scripts") == false then
    makefolder("Mana/Scripts")
end

if isfolder("Mana/Modules") == false then
    makefolder("Mana/Modules")
end

if isfolder("Mana/Libraries") == false then
    makefolder("Mana/Libraries")
end

local foldername = "Mana/Config"
local conf = {
	file = foldername .. "/" .. game.PlaceId .. ".json",
	functions = {}
}

function conf.functions:MakeFile()
	if isfile("Mana/Config/" .. game.PlaceId .. ".json") then return end
        if not isfolder(foldername) then
            makefolder(foldername)
        end
	writefile("Mana/Config/ ".. game.PlaceId .. ".json", "{}")
end

function conf.functions:LoadConfigs()
	if not isfile("Mana/Config/" .. game.PlaceId .. ".json") then
		conf.functions:MakeFile()
	end
    wait(0.5)
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile("Mana/Config/" .. game.PlaceId .. ".json"))
    end)
    if success then
        warn("[NewManaV2ForRoblox]: successfully decoded JSON.")
        return data
    else
        warn("[NewManaV2ForRoblox]: error in decoding JSON:", data, ".")
        return {}
    end
end

function conf.functions:WriteConfigs(tab)
	conf.functions:MakeFile()
	writefile("Mana/Config/" .. game.PlaceId .. ".json", HttpService:JSONEncode((tab or {})))
end
local configtable = (conf.functions:LoadConfigs() or {})

spawn(function()
    repeat
        conf.functions:WriteConfigs(configtable)
        task.wait(30)
    until (not configsaving)
end)

local requestfunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or request or function(tab)
    if tab.Method == "GET" then
        return {
            Body = game:HttpGet(tab.Url, true),
            Headers = {},
            StatusCode = 200
        }
    else
        return {
            Body = "bad exploit",
            Headers = {},
            StatusCode = 404
        }
    end
end 

local betterisfile = function(file)
    local suc, res = pcall(function() return readfile(file) end)
    return suc and res ~= nil
end

local cachedassets = {}
local function GetCustomAsset(path)
    if not betterisfile(path) then
        spawn(function()
            local textlabel = Instance.new("TextLabel")
            textlabel.Size = UDim2.new(1, 0, 0, 36)
            textlabel.Text = "Downloading "..path
            textlabel.BackgroundTransparency = 1
            textlabel.TextStrokeTransparency = 0
            textlabel.TextSize = 30
            textlabel.Font = Library.Font
            textlabel.TextColor3 = Color3.new(1, 1, 1)
            textlabel.Position = UDim2.new(0, 0, 0, -36)
            textlabel.Parent = ScreenGui
            repeat wait() until betterisfile(path)
            textlabel:Remove()
        end)
        local req = requestfunc({
            Url = "https://raw.githubusercontent.com/Maan04ka/NewManaV2ForRoblox/main/" .. path:gsub("Mana/Assets", "Assets"),
            Method = "GET"
        })
        writefile(path, req.Body)
    end
    if cachedassets[path] == nil then
        cachedassets[path] = getasset(path) 
    end
    return cachedassets[path]
end

function dragGUI(gui)
	task.spawn(function()
		local dragging
		local dragInput
		local dragStart = Vector3.new(0,0,0)
		local startPos
		local function update(input)
			local delta = input.Position - dragStart
			local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			TweenService:Create(gui, TweenInfo.new(.20), {Position = Position}):Play()
		end
		gui.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = gui.Position

				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)
		gui.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				update(input)
			end
		end)
	end)
end

local ColorBox
function Library.Functions:MakeRainbowText(Text, Bool)
    local Text = Text or Instance.new("TextLabel")
    spawn(function()
        ColorBox = Color3.fromRGB(170, 0, 170)
        local x = 0
        while wait() do
            ColorBox = Color3.fromHSV(x, 1, 1)
            x = x + 4.5 / 255
            if x >= 1 then
                x = 0
            end
        end
    end)
    spawn(function()
        repeat
            wait()
            if Bool then
                Text.TextColor3 = ColorBox
            end
        until true == false
    end)
end

function Library.Functions:MakeRainbowObjectBackground(Object, Bool)
    spawn(function()
        repeat
            wait()
            if Bool then
                Object.BackgroundColor3 = ColorBox
            end
        until true == false
    end)
end

local function bettertween(obj, newpos, dir, style, tim, override)
    spawn(function()
        local frame = Instance.new("Frame")
        frame.Visible = false
        frame.Position = obj.Position
        frame.Parent = ScreenGui
        frame:GetPropertyChangedSignal("Position"):Connect(function()
            obj.Position = UDim2.new(obj.Position.X.Scale, obj.Position.X.Offset, frame.Position.Y.Scale, frame.Position.Y.Offset)
        end)
        pcall(function()
            frame:TweenPosition(newpos, dir, style, tim, override)
        end)
        frame.Parent = nil
        task.wait(tim)
        frame:Remove()
    end)
end

local function bettertween2(obj, newpos, dir, style, tim, override)
    spawn(function()
        local frame = Instance.new("Frame")
        frame.Visible = false
        frame.Position = obj.Position
        frame.Parent = ScreenGui
        frame:GetPropertyChangedSignal("Position"):Connect(function()
            obj.Position = UDim2.new(frame.Position.X.Scale, frame.Position.X.Offset, obj.Position.Y.Scale, obj.Position.Y.Offset)
        end)
        pcall(function()
            frame:TweenPosition(newpos, dir, style, tim, override)
        end)
        frame.Parent = nil
        task.wait(tim)
        frame:Remove()
    end)
end

function Library:CreateGuiNotification(title, text, delay2, toggled)
    spawn(function()
        if NotificationGui:FindFirstChild("Background") then NotificationGui:FindFirstChild("Background"):Destroy() end
		if Library.Notifications == true then
	        local frame = Instance.new("Frame")
            local frameborder = Instance.new("Frame")
            local frametitle = Instance.new("TextLabel")
            local frametext = Instance.new("TextLabel")

	        frame.Size = UDim2.new(0, 100, 0, 115)
	        frame.Position = UDim2.new(0.5, 0, 0, -115)
	        frame.BorderSizePixel = 0
	        frame.AnchorPoint = Vector2.new(0.5, 0)
	        frame.BackgroundTransparency = 0.5
	        frame.BackgroundColor3 = Color3.new(0, 0, 0)
	        frame.Name = "Background"
	        frame.Parent = NotificationGui

	        frameborder.Size = UDim2.new(1, 0, 0, 8)
	        frameborder.BorderSizePixel = 0
	        frameborder.BackgroundColor3 = (toggled and Color3.fromRGB(102, 205, 67) or Color3.fromRGB(205, 64, 78))
	        frameborder.Parent = frame

	        frametitle.Font = Enum.Font.SourceSansLight
	        frametitle.BackgroundTransparency = 1
	        frametitle.Position = UDim2.new(0, 0, 0, 30)
	        frametitle.TextColor3 = (toggled and Color3.fromRGB(102, 205, 67) or Color3.fromRGB(205, 64, 78))
	        frametitle.Size = UDim2.new(1, 0, 0, 28)
	        frametitle.Text = "          " .. title
	        frametitle.TextSize = 24
	        frametitle.TextXAlignment = Enum.TextXAlignment.Left
	        frametitle.TextYAlignment = Enum.TextYAlignment.Top
	        frametitle.Parent = frame

	        frametext.Font = Enum.Font.SourceSansLight
	        frametext.BackgroundTransparency = 1
	        frametext.Position = UDim2.new(0, 0, 0, 68)
	        frametext.TextColor3 = Color3.new(1, 1, 1)
	        frametext.Size = UDim2.new(1, 0, 0, 28)
	        frametext.Text = "          " .. text
	        frametext.TextSize = 24
	        frametext.TextXAlignment = Enum.TextXAlignment.Left
	        frametext.TextYAlignment = Enum.TextYAlignment.Top
	        frametext.Parent = frame

	        local textsize = TextService:GetTextSize(frametitle.Text, frametitle.TextSize, frametitle.Font, Vector2.new(100000, 100000))
	        local textsize2 = TextService:GetTextSize(frametext.Text, frametext.TextSize, frametext.Font, Vector2.new(100000, 100000))

	        if textsize2.X > textsize.X then textsize = textsize2 end

	        frame.Size = UDim2.new(0, textsize.X + 38, 0, 115)

	        pcall(function()
	            frame:TweenPosition(UDim2.new(0.5, 0, 0, 20), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.15)

	            DebrisService:AddItem(frame, delay2 + 0.15)
	        end)
	    end
    end)
end

function Library:CreateChatNotification(NotificationText, NotificationType) -- type: warning, error, print
    local Text = NotificationText or "nil"
    local NotificationType = NotificationType or "print"
    local NewText

    if NotificationType == "print" then
        NewText = Text
    else
        NewText = "[" .. NotificationType .. "]: " .. Text
    end
    
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Font = Library.Font,
        Text = NewText,
    })
end

function Library:CreateNotification(NotificationTitle, NotificationText, Delay, Toggled, NotificationType)
    if Library.Notifications then
        Library:CreateGuiNotification(NotificationTitle, NotificationText, Delay, Toggled)
    end

    if Library.ChatNotifications then
        Library:CreateChatNotification(NotificationText, NotificationType)
    end
end

function Library:CreateSessionInfo()
    local SessionInfoTable = {
        Rainbow = false,
        Objects = {}
    }

    local SessionInfo = Instance.new("Frame")
    local UIListLayout = Instance.new("UIListLayout")
    local RainbowTop = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local RainbowTopFix = Instance.new("Frame")
    local UICorner_2 = Instance.new("UICorner")
    local SessionInfoTitle = Instance.new("TextLabel")
    
    SessionInfo.Name = "SessionInfo"
    SessionInfo.Parent = ScreenGui
    SessionInfo.BackgroundColor3 = Color3.fromRGB(14, 14, 23)
    SessionInfo.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SessionInfo.BorderSizePixel = 0
    SessionInfo.Position = UDim2.new(0, 0, 0.318777293, 0)
    SessionInfo.Size = UDim2.new(0, 150, 0, 25)

    dragGUI(SessionInfo)
    
    UIListLayout.Parent = SessionInfo
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    RainbowTop.Name = "RainbowTop"
    RainbowTop.Parent = SessionInfo
    RainbowTop.BackgroundColor3 = Color3.fromRGB(215, 255, 140)
    RainbowTop.BorderColor3 = Color3.fromRGB(0, 0, 0)
    RainbowTop.BorderSizePixel = 0
    RainbowTop.Size = UDim2.new(0, 150, 0, 10)
    
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = RainbowTop
    
    RainbowTopFix.Name = "RainbowTopFix"
    RainbowTopFix.Parent = RainbowTop
    RainbowTopFix.BackgroundColor3 = Color3.fromRGB(215, 255, 140)
    RainbowTopFix.BorderColor3 = Color3.fromRGB(0, 0, 0)
    RainbowTopFix.BorderSizePixel = 0
    RainbowTopFix.Position = UDim2.new(0, 0, 0.670000017, 0)
    RainbowTopFix.Size = UDim2.new(0, 150, 0, 4)
    
    UICorner_2.CornerRadius = UDim.new(0, 4)
    UICorner_2.Parent = SessionInfo
    
    SessionInfoTitle.Name = "SessionInfoLabel"
    SessionInfoTitle.Parent = SessionInfo
    SessionInfoTitle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    SessionInfoTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SessionInfoTitle.BorderSizePixel = 0
    SessionInfoTitle.LayoutOrder = 1
    SessionInfoTitle.Position = UDim2.new(0, 0, 0.200000003, 0)
    SessionInfoTitle.Size = UDim2.new(0, 150, 0, 15)
    SessionInfoTitle.Font = Enum.Font.Arial
    SessionInfoTitle.Text = "   SessionInfo"
    SessionInfoTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SessionInfoTitle.TextSize = 14.000
    SessionInfoTitle.TextXAlignment = Enum.TextXAlignment.Left

    function SessionInfoTable:CreateInfoLabel(Name)
        local Name = Name or "Hello"
        local LabelTable = {
            Name = Name
        }

        local Label = Instance.new("TextLabel")

        Label.Name = Name
        Label.Parent = SessionInfo
        Label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Label.BorderSizePixel = 0
        Label.LayoutOrder = 1
        Label.Position = UDim2.new(0, 0, 0.200000003, 0)
        Label.Size = UDim2.new(0, 150, 0, 15)
        Label.Font = Enum.Font.Arial
        Label.Text = "   " .. Name .. ": "
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        Label.TextSize = 14.000
        Label.TextXAlignment = Enum.TextXAlignment.Left

        LabelTable.TextLabel = Label

        table.insert(SessionInfoTable, Label)

        return LabelTable
    end

    function SessionInfoTable:RemoveLabel(Name)
        if SessionInfo:FindFirstChild(Name) then
            SessionInfo:FindFirstChild(Name):Destroy()
        end
    end

    function SessionInfoTable:Rainbow(Bool)
        Library.Functions:MakeRainbowObjectBackground(RainbowTop, Bool)
        Library.Functions:MakeRainbowObjectBackground(RainbowTopFix, Bool)
    end

    function SessionInfoTable:RemoveSessionInfo()
        if SessionInfo then
            SessionInfo:Destroy()
        end
    end

    return SessionInfoTable
end

-- Hud functions
function Library.UpdateHud:UpdateFont(NewFont)
    local font = "Enum.Font." .. NewFont
    for i, v in pairs(ScreenGui:GetChildren()) do
        if v:IsA("TextButton") or v:IsA("TextLabel") then
            v.Font = font
        end
    end
end

-- Functions functions
function Library.Functions:RandomString() -- from vape
    local randomlength = math.random(10,100)
    local array = {}

    for i = 1, randomlength do
        array[i] = string.char(math.random(32, 126))
    end

    return table.concat(array)
end

function Library:ToggleLibrary()
    if ClickGui.Visible == false then
        if UserInputService:GetFocusedTextBox() == nil then
            ClickGui.Visible = true
        end
    else
        if UserInputService:GetFocusedTextBox() == nil then
            ClickGui.Visible = false
        end
    end
end

function Library:RemoveObject(ObjectName) 
    pcall(function()
        if Library.Objects[ObjectName] and Library.Objects[ObjectName].Type == "Toggle" then 
            Library.Objects[ObjectName].Instance:Destroy()
            Library.Objects[ObjectName].OptionFrame:Destroy()
            Library.Objects[ObjectName] = nil
        end
    end)
end

function Library:playsound(id, volume) 
    if Library.Sounds == true then
        local sound = Instance.new("Sound")
        sound.Parent = workspace
        sound.SoundId = id
        if volume then 
            sound.Volume = volume
        end
        sound:Play()
        wait(sound.TimeLength + 2)
        sound:Destroy()
    end
end

--[[
    ToDo:
    Make tabs scrollable
]]

function Library:CreateWindow()
    ScreenGui.Name = Library.Functions:RandomString()
    
    local TabsFrame = Instance.new("Frame")
    local uilistthingy = Instance.new("UIListLayout")
    local UIScale = Instance.new("UIScale")
    local HoverText = Instance.new("TextLabel")

    TabsFrame.Name = "Tabs"
    TabsFrame.Parent = ScreenGui
    TabsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabsFrame.BackgroundTransparency = 1.000
    TabsFrame.BorderSizePixel = 0
    TabsFrame.Position = UDim2.new(0.010, 0, 0.010, 0)
    TabsFrame.Size = UDim2.new(0, 207, 0, 40)
    TabsFrame.AutomaticSize = "X"

    uilistthingy.Parent = TabsFrame
    uilistthingy.FillDirection = Enum.FillDirection.Horizontal
    uilistthingy.SortOrder = Enum.SortOrder.LayoutOrder
    uilistthingy.Padding = UDim.new(0, 40)

    UIScale.Parent = TabsFrame
    UIScale.Scale = Library.Scale

    HoverText.Text = "  "
    HoverText.ZIndex = 1
    HoverText.TextColor3 = Color3.fromRGB(160, 160, 160)
    HoverText.TextXAlignment = Enum.TextXAlignment.Left
    HoverText.TextSize = 14
    HoverText.Visible = false
    HoverText.Parent = TabsFrame
    HoverText.AnchorPoint = Vector2.new(0.5, 0.5)

    Library.TabsFrame = TabsFrame
    Library.UIScale = UIScale

    if Library.Device == "Mobile" then
        UIScale.Scale = Library.MobileScale
        Library.Scale = 0.45
    end

    function Library:CreateTab(title, color)
        table.insert(Tabs, #Tabs)
        local tab = Instance.new("TextButton")
        local tabname = Instance.new("TextLabel")
        local assetthing = Instance.new("ImageLabel")
        local uilistlayout = Instance.new("UIListLayout")

        local tabtable = {
            Toggles = {}
        }

        --[[
        -- W - Width, H - Height
        local TabPositionX = 0
        local TabPositionY = 247 * #Tabs
        local TabPositionW = 0
        local TabPositionH = 0

        local TabPositionTable = {
            X = TabPositionX,
            Y = TabPositionY,
            W = TabPositionW,
            H = TabPositionH,
        }
        
        if configtable[title] == nil and configtable[title.Position] == nil or configtable[title] == nil or configtable[title.Position] == nil then
            configtable[title] = title
            configtable[title.Position] = TabPositionTable
        end
        ]]

        tab.Modal = true
        tab.Name = title
        tab.Selectable = true
        tab.ZIndex = 1
        tab.Parent = TabsFrame
        tab.BackgroundColor3 = Color3.fromRGB(14, 14, 23)
        tab.BorderSizePixel = 0
        tab.Position = configtable[title.Position] or UDim2.new(TabPositionX, TabPositionY, TabPositionW, TabPositionH)
        tab.Size = UDim2.new(0, 207, 0, 40)
        tab.Active = true
        tab.LayoutOrder = 1 + #Tabs
        tab.AutoButtonColor = false
	    tab.Text = ""
    
        tabname.Name = title
        tabname.Parent = tab
        tabname.ZIndex = tab.ZIndex + 1
        tabname.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        tabname.BackgroundTransparency = 1.000
        tabname.BorderSizePixel = 0
        tabname.Position = UDim2.new(0, 199,0, 40)
        tabname.Size = UDim2.new(0, 199,0, 40)
        tabname.Font = Enum.Font.SourceSansLight
        tabname.Text = " " .. title
        tabname.TextColor3 = color
        tabname.TextSize = 22.000
        tabname.TextWrapped = true
        tabname.TextXAlignment = Enum.TextXAlignment.Left
        tabname.Selectable = true
    
        assetthing.Parent = tabname
        assetthing.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        assetthing.BackgroundTransparency = 1
        assetthing.Position = UDim2.new(0.86, 0,0.154, 0)
        assetthing.Size = UDim2.new(0, 30, 0, 30)
        
        uilistlayout.Parent = tab
        uilistlayout.SortOrder = Enum.SortOrder.LayoutOrder

        --dragGUI(tab, tabname)

        function tabtable:CreateDivider(data)
            if data.WithText then
                local Text = data.Name or "Hello world!"
                local DividerFrame = Instance.new("Frame")
                local Divider = Instance.new("TextLabel")
                local DividerFrame2 = Instance.new("Frame")
                DividerFrame.Name = title .. "_FrameDivider"
                DividerFrame.Parent = tab
                DividerFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                DividerFrame.BorderSizePixel = 0
                DividerFrame.Position = UDim2.new(0.0827946085, -17, 0.133742347, 33)
                DividerFrame.Size = UDim2.new(0, 207, 0, 2)
                Divider.Name = title .. "_TextLabelDivider"
                Divider.Parent = tab
                Divider.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                Divider.BorderSizePixel = 0
                Divider.Position = UDim2.new(0.0827946085, -17, 0.133742347, 33)
                Divider.Size = UDim2.new(0, 207, 0, 20)
                Divider.Font = Enum.Font.SourceSansLight --Library.Font
                Divider.Text = Text
                Divider.TextColor3 = Color3.fromRGB(255, 255, 255)
                Divider.TextSize = 18
                Divider.TextXAlignment = Enum.TextXAlignment.Center
                DividerFrame2.Name = title .. "_FrameDivider"
                DividerFrame2.Parent = tab
                DividerFrame2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                DividerFrame2.BorderSizePixel = 0
                DividerFrame2.Position = UDim2.new(0.0827946085, -17, 0.133742347, 33)
                DividerFrame2.Size = UDim2.new(0, 207, 0, 2)
                return Divider
            else
                local Divider = Instance.new("Frame")
                Divider.Name = title .. "_FrameDivider"
                Divider.Parent = tab
                Divider.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                Divider.BorderSizePixel = 0
                Divider.Position = UDim2.new(0.0827946085, -17, 0.133742347, 33)
                Divider.Size = UDim2.new(0, 207, 0, 20)
                return Divider
            end
        end

        function tabtable:CreateToggle(data)
            local info = {
                Name = data.Name,
                HoverText = data.HoverText,
                Keybind = (configtable[data.Name.Keybind] or data.Keybind),
                Callback = (data.Callback or function() end)
            }

            configtable[info.Name] = {
                Keybind = ((configtable[info.Name] and configtable[info.Name].Keybind) or "none"),
                IsToggled = ((configtable[info.Name] and configtable[info.Name].IsToggled) or false)
            }

            local title = info.Name
            local ToolTip = info.HoverText
            local keybind = info.Keybind
            local callback = info.Callback

            keybind = (keybind or {Name = nil})
            Keybinds[(keybind.Name or "%*")] = (keybind.Name == nil and false or true)

            local focus = {
                Elements = {}
            }

            local ToggleTable = {
                Enabled = false,
                Name = data.Name or ""
            }

            table.insert(tabtable.Toggles, #tabtable.Toggles)
            
            ToggleTable.Enabled = false
            ToggleTable.Name = data.Name or ""
            callback = callback or function() end
            oldkey = keybind.Name

            local toggle = Instance.new("TextButton")
            local BindText = Instance.new("TextButton")
            local optionsframebutton = Instance.new("TextButton")
            local togname = Instance.new("TextLabel")
            local optionframe = Instance.new("Frame")
            local UIListLayout = Instance.new("UIListLayout")

            toggle.Name = title
            toggle.Parent = tab
            toggle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            toggle.BorderSizePixel = 0
            toggle.Position = UDim2.new(0.0827946085, -17, 0.133742347, 33)
            toggle.Size = UDim2.new(0, 207, 0, 40)
            toggle.Text = ""

            togname.Parent = toggle
            togname.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            togname.BackgroundTransparency = 1.000
            togname.BorderSizePixel = 0
            togname.Position = UDim2.new(0.0338164233, 0, 0.163378686, 0)
            togname.Size = UDim2.new(0, 192, 0, 26)
            togname.Font = Enum.Font.SourceSansLight
            togname.Text = title
            togname.TextColor3 = Color3.fromRGB(255, 255, 255)
            togname.TextSize = 22.000
            togname.TextWrapped = true
            togname.TextXAlignment = Enum.TextXAlignment.Left

            optionsframebutton.Parent = toggle
            optionsframebutton.Position = UDim2.new(0, 170, 0, 0)
            optionsframebutton.Size = UDim2.new(0, 37, 0, 39)
            optionsframebutton.BackgroundTransparency = 1
            optionsframebutton.Text = "."
            optionsframebutton.TextSize = "30"

            optionframe.Name = "OptionFrame" .. info.Name
            optionframe.Parent = tab
            optionframe.BackgroundColor3 = Color3.fromRGB(47, 48, 64)
            optionframe.Position = UDim2.new(0.102424242, 0, 0.237059206, 0)
            optionframe.Size = UDim2.new(0, 207, 0, 0)
            optionframe.AutomaticSize = "Y"
            optionframe.Visible = false

            UIListLayout.Parent = optionframe
            UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Padding = UDim.new(0, 8)

            BindText.Name = "BindText"
            BindText.Parent = optionframe
            BindText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            BindText.BackgroundTransparency = 1.000
            BindText.Position = UDim2.new(0.0989583358, 0, 0, 0)
            BindText.Size = UDim2.new(0, 175, 0, 33)
            BindText.Font = Enum.Font.SourceSansLight
            BindText.Text = "Bind: none"
            BindText.TextColor3 = Color3.fromRGB(255, 255, 255)
            BindText.TextSize = 22.000
            BindText.TextXAlignment = Enum.TextXAlignment.Left
            BindText.TextYAlignment = Enum.TextYAlignment.Center

            BindText.MouseEnter:Connect(function()
                focus.Elements["toggle_" .. title] = true
            end)

            BindText.MouseLeave:Connect(function()
                focus.Elements["toggle_" .. title] = false
            end)

            conf.functions:WriteConfigs(configtable)

            local configData = HttpService:JSONDecode(readfile(conf.file))

            if isfile(conf.file) and configData[title].Keybind and configData[title].Keybind ~= "none" then
                local keybind = configData[title].Keybind

                if Keybinds[keybind] then
                    BindText.Text = "Bind: " .. keybind
                    isclicked = false
                    return
                end

                if oldkey then
                    Keybinds[oldkey] = nil
                end

                oldkey = keybind
                BindText.Text = "Bind: " .. keybind
                configtable[title].Keybind = keybind
                isclicked = false
                cooldown = true
                wait(0.5)
                cooldown = false
            end

            BindText.MouseButton1Click:Connect(function()
                if not focus.Elements["toggle_" .. title] or isclicked then return end
                isclicked = true
                BindText.Text = "Bind: ..."

                UserInputService.InputBegan:Connect(function(input)
                    local inputName = input.KeyCode.Name
                    if inputName == "Unknown" and input.UserInputType == Enum.UserInputType.MouseButton2 then
                        isclicked = true
                        BindText.Text = "Bind: " .. configtable[title].Keybind or "none"
                        print("Binding canceled.")
                    elseif inputName ~= "Unknown" and inputName ~= oldkey then
                        if not isclicked then return end
                        if Keybinds[inputName] then
                            BindText.Text = "Bind: " .. oldkey
                            isclicked = false
                            return
                        end

                        if oldkey then
                            Keybinds[oldkey] = nil
                        end

                        print("Pressed keybind: " .. inputName)

                        oldkey = inputName
                        BindText.Text = "Bind: " .. oldkey
                        configtable[title].Keybind = oldkey
                        isclicked = false
                        cooldown = true
                        wait(0.5)
                        cooldown = false
                    end
                end)
            end)

            toggle.MouseButton2Click:Connect(function()
                optionframe.Visible = not optionframe.Visible
            end)

            optionsframebutton.MouseButton1Click:Connect(function()
                optionframe.Visible = not optionframe.Visible
            end)

            toggle.MouseButton1Click:Connect(function()
                local currentTime = tick()
            
                if currentTime - LastPress < 0.5 and OnMobile then
                    optionframe.Visible = not optionframe.Visible
                end
            
                LastPress = currentTime
            end)
            
            if not isfile(conf.file) then
                configtable[title].IsToggled = false
            end
            
            function ToggleTable:Toggle(silent, bool)
                bool = bool or (not ToggleTable.Enabled)
                silent = silent or false
                ToggleTable.Enabled = bool
                if not bool then
                    spawn(function()
                        callback(false)
                    end)
                    spawn(function()
                        Library:CreateNotification(title, "Disabled " .. title, 4, false)
                        configtable[title].IsToggled = false
                    end)
                    toggle.BackgroundColor3 = Color3.fromRGB(14, 20, 14)
                    if not silent then
                        Library:playsound("rbxassetid://421058925", 1)
                    end
                else
                    spawn(function()
                        callback(true)
                    end)
                    spawn(function()
                        Library:CreateNotification(title, "Enabled " .. title, 4, true)
                        configtable[title].IsToggled = true
                    end)
                    toggle.BackgroundColor3 = tabname.TextColor3
                    if not silent then
                        Library:playsound("rbxassetid://421058925", 1)
                    end
                end
            end
            
            toggle.MouseButton1Click:Connect(function()
                ToggleTable:Toggle()
            end)
            
            UserInputService.InputBegan:Connect(function(input)
                if oldkey and not cooldown and not isclicked and input.KeyCode.Name == oldkey and not UserInputService:GetFocusedTextBox() then
                    ToggleTable:Toggle()
                end
            end)
            
            if configtable[title].IsToggled then
                ToggleTable:Toggle(true)
            end

            function ToggleTable:CreateSlider(argstable)
                local sliderapi = {Value = (configtable[argstable.Name .. ToggleTable.Name] and configtable[argstable.Name .. ToggleTable.Name].Value or argstable.Default or argstable.Min)}
                local min = argstable.Min
                local max = argstable.Max
                local round = argstable.Round or 2

                local slider = Instance.new("TextButton")
                local slidertext = Instance.new("TextLabel")
                local slider_2 = Instance.new("Frame")
            
                slider.Name = "Slider"
                slider.Parent = optionframe
                slider.BackgroundColor3 = Color3.fromRGB(47, 48, 64)
                slider.BorderSizePixel = 0
                slider.Position = UDim2.new(0.0833333358, 0, 0.109391868, 0)
                slider.Size = UDim2.new(0, 180, 0, 34)
                slider.Text = ""
                slider.AutoButtonColor = false
            
                slidertext.Name = "SliderText"
                slidertext.Parent = slider
                slidertext.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                slidertext.BackgroundTransparency = 1.000
                slidertext.BorderSizePixel = 0
                slidertext.Position = UDim2.new(0.0188679248, 0, 0, 0)
                slidertext.Size = UDim2.new(0, 180, 0, 33)
                slidertext.ZIndex = 3
                slidertext.Font = Enum.Font.SourceSansLight
                slidertext.Text = ""
                slidertext.TextColor3 = Color3.fromRGB(255, 255, 255)
                slidertext.TextSize = 22.000
                slidertext.TextXAlignment = Enum.TextXAlignment.Left
            
                slider_2.Name = "Slider_2"
                slider_2.Parent = slider
                slider_2.BackgroundColor3 = color
                slider_2.BorderSizePixel = 0
                slider_2.Position = UDim2.new(0.00786163565, 0, -0.00825500488, 0)
                slider_2.Size = UDim2.new(0, 0, 0, 34)
                slider_2.ZIndex = 2

                sliderapi.MainObject = slider
            
                if configtable[argstable.Name .. ToggleTable.Name] == nil then
                    configtable[argstable.Name .. ToggleTable.Name] = {Value = sliderapi.Value}
                end
            
                local function slide(input)
                    local sizeX = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                    local value = math.floor(((((max - min) * sizeX) + min) * (10 ^ round)) + 0.5) / (10 ^ round)

                    slider_2.Size = UDim2.new(sizeX, 0, 1, 0)
                    sliderapi.Value = value
                    slidertext.Text = argstable.Name .. ": " .. tostring(value)
                    configtable[argstable.Name .. ToggleTable.Name].Value = sliderapi.Value

                    if not argstable.OnInputEnded then
                        argstable.Function(value)
                    end
                end
            
                local sliding = false
            
                slider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = true
                        slide(input)
                    end
                end)
                
                slider.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        if argstable.OnInputEnded then
                            argstable.Function(sliderapi.Value)
                            configtable[argstable.Name .. ToggleTable.Name].Value = sliderapi.Value
                        end
                        sliding = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if (input.UserInputType == Enum.UserInputType.MouseMovement and UserInputService.MouseEnabled) or (input.UserInputType == Enum.UserInputType.Touch) then
                        if sliding then
                            slide(input)
                        end
                    end
                end)                
            
                sliderapi.Set = function(value)
                    local value = math.floor((math.clamp(value, min, max) * (10 ^ round)) + 0.5) / (10 ^ round)

                    sliderapi.Value = value
                    slider_2.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                    slidertext.Text = argstable.Name .. ": " .. tostring(value)

                    argstable.Function(value)
                end

                sliderapi.Set(sliderapi.Value)
            
                Library.Objects[argstable.Name .. "Slider"] = {
                    API = sliderapi,
                    Instance = slider,
                    Type = "Slider",
                    OptionsButton = argstable.Name,
                    Window = TabsFrame.Name
                }
                return sliderapi
            end
            function ToggleTable:CreateDropDown(argstable)
                local ddname = argstable.Name
                local dropdownapi = {
                    Value = nil,
                    List = {}
                }
            
                for i,v in next, argstable.List do 
                    table.insert(dropdownapi.List, v)
                end
            
                if configtable[ddname] == nil then
                    configtable[ddname] = {
                        Value = dropdownapi.Value
                    }
                end
            
                dropdownapi.Value = (configtable[ddname] and configtable[ddname].Value) or argstable.Default or dropdownapi.List[1]
            
                local function stringtablefind(table1, key)
                    for i,v in next, table1 do
                        if tostring(v) == tostring(key) then
                            return i
                        end
                    end
                end
            
                local function getvalue(index) 
                    local realindex
                    if index > #dropdownapi.List then
                        realindex = 1 
                    elseif index < 1 then
                        realindex = #dropdownapi.List
                    else
                        realindex = index
                    end
                    return realindex
                end
            
                local Dropdown = Instance.new("TextButton")

                Dropdown.Name = "Dropdown"
                Dropdown.Parent = optionframe
                Dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Dropdown.BackgroundTransparency = 1.000
                Dropdown.BorderSizePixel = 0
                Dropdown.Position = UDim2.new(0.0859375, 0, 0.491620123, 0)
                Dropdown.Size = UDim2.new(0, 175, 0, 25)
                Dropdown.Font = Enum.Font.SourceSansLight
                Dropdown.Text = "" .. argstable.Name .. ": " .. argstable.Default
                Dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
                Dropdown.TextSize = 22.000
                Dropdown.TextWrapped = true
                Dropdown.TextXAlignment = Enum.TextXAlignment.Left
                Dropdown.TextYAlignment = Enum.TextYAlignment.Bottom

                dropdownapi.MainObject = Dropdown
            
                dropdownapi.Select = function(_select) 
                    if dropdownapi.List[_select] or stringtablefind(dropdownapi.List, _select) then
                        dropdownapi.Value = dropdownapi.List[_select] or dropdownapi.List[stringtablefind(dropdownapi.List, _select)]
                        Dropdown.Text =  "" .. argstable.Name .. ":" .. tostring(dropdownapi.Value)
                        configtable[ddname].Value = dropdownapi.Value
                        argstable.Function(dropdownapi.Value)
                    end
                end
                
                dropdownapi.SelectNext = function()
                    local currentIndex = table.find(dropdownapi.List, dropdownapi.Value)
                    if currentIndex then
                        local newIndex = (currentIndex % #dropdownapi.List) + 1
                        dropdownapi.Select(newIndex)
                    else
                        warn("Index in selector (" .. argstable.Name .. ") in function `SelectNext` was not found!")
                        Library:CreateNotification("NewIndex in selector (" .. argstable.Name .. ") in function `SelectNext` was not found!", "If this keeps happening, go to your exploit's folder\nthen go to workspace/rektsky/config\nand delete everything inside of that folder", 10, false, "Warning")
                    end
                end
                
                dropdownapi.SelectPrevious = function()
                    local currentIndex = table.find(dropdownapi.List, dropdownapi.Value)
                    if currentIndex then
                        local newIndex = currentIndex - 1
                        if newIndex < 1 then
                            newIndex = #dropdownapi.List
                        end
                        dropdownapi.Select(newIndex)
                    else
                        warn("Index in selector (" .. argstable.Name .. ") in function `SelectPrevious` was not found!")
                        Library:CreateNotification("NewIndex in selector (" .. argstable.Name .. ") in function `SelectPrevious` was not found!", "If this keeps happening, go to your exploit's folder\nthen go to workspace/rektsky/config\nand delete everything inside of that folder", 10, false, "Warning")
                    end
                end
            
                if configtable[ddname] and configtable[ddname].Value then
                    dropdownapi.Select(stringtablefind(dropdownapi.List,configtable[ddname].Value))
                end
            
                Dropdown.MouseButton1Click:Connect(dropdownapi.SelectNext)
                Dropdown.MouseButton2Click:Connect(dropdownapi.SelectPrevious)
            
                Library.Objects[argstable.Name .. "Selector"] = {
                    API = dropdownapi,
                    Instance = Selector,
                    Type = "Selector",
                    OptionsButton = argstable.Name,
                    Window = TabsFrame.Name
                }
                
                return dropdownapi
            end               
            function ToggleTable:CreateOptionTog(argstable)
                if configtable[argstable.Name .. ToggleTable.Name] == nil then
                    configtable[argstable.Name .. ToggleTable.Name] = {IsToggled = configtable[argstable.Name .. ToggleTable.Name] and configtable[argstable.Name .. ToggleTable.Name].IsToggled or argstable.Default}
                end
                local optiontogval = {Value = configtable[argstable.Name .. ToggleTable.Name] and configtable[argstable.Name .. ToggleTable.Name].IsToggled or argstable.Default}
                local thing = {
                    Name = argstable.Name,
                    Function = argstable.Function
                }

                argstable.Function = argstable.Function or function() end

                local tognametwo = Instance.new("TextLabel")
                local toggleactived = Instance.new("Frame")
                local untoggled = Instance.new("TextButton")

                tognametwo.Name = "tognametwo"
                tognametwo.Parent = optionframe
                tognametwo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                tognametwo.BackgroundTransparency = 1.000
                tognametwo.Position = UDim2.new(0.0911458358, 0, 0.502793312, 0)
                tognametwo.Size = UDim2.new(0, 170, 0, 32)
                tognametwo.Font = Enum.Font.SourceSansLight
                tognametwo.TextColor3 = Color3.fromRGB(255, 255, 255)
                tognametwo.TextSize = 22.000
                tognametwo.TextXAlignment = Enum.TextXAlignment.Left
                tognametwo.Text = argstable.Name

                untoggled.Name = "untoggled"
                untoggled.Parent = tognametwo
                untoggled.BackgroundColor3 = Color3.fromRGB(66, 68, 66)
                untoggled.BorderSizePixel = 0
                untoggled.Position = UDim2.new(0.816739559, 0, 0.0743236542, 0)
                untoggled.Size = UDim2.new(0, 29, 0, 29)
                untoggled.ZIndex = 2
                untoggled.AutoButtonColor = false

                toggleactived.Name = "togthingylol"
                toggleactived.Parent = tognametwo
                toggleactived.BackgroundColor3 = Color3.fromRGB(66, 68, 66)
                toggleactived.BorderSizePixel = 0
                toggleactived.Position = UDim2.new(0, 141, 0, 5)
                toggleactived.Size = UDim2.new(0, 24, 0, 24)
                toggleactived.ZIndex = 3

                optiontogval.MainObject = tognametwo

                if configtable[argstable.Name .. ToggleTable.Name] == nil then
                    configtable[argstable.Name .. ToggleTable.Name] = {IsToggled = optiontogval.Value}
                end
                function optiontogval:Toggle(bool)
                    bool = bool or not (optiontogval.Value)
                    optiontogval.Value = bool
                    configtable[argstable.Name .. ToggleTable.Name].IsToggled = bool
                    if not bool then
                        if argstable.Function then
                            spawn(function()
                                argstable.Function(false)
                            end)
                        end
                        toggleactived.BackgroundColor3 = Color3.fromRGB(68, 68, 60)
                    else
                        if argstable.Function then
                            spawn(function()
                                argstable.Function(true)
                            end)
                            toggleactived.BackgroundColor3 = tabname.TextColor3
                        end
                    end
                end
                if configtable[argstable.Name .. ToggleTable.Name] then
                	optiontogval:Toggle(configtable[argstable.Name .. ToggleTable.Name].IsToggled)
                end
                untoggled.MouseButton1Click:Connect(function()
                    optiontogval:Toggle()
                end)
                return optiontogval
            end
            function ToggleTable:CreateTextBox(argstable)
                local TextBoxData = {
                    Name = argstable.Name,
                    PlaceholderText = argstable.PlaceholderText,
                    DefaultValue = argstable.DefaultValue,
                    Function = argstable.Function
                }

                local TextBoxAPI = {
                    Value = (configtable[argstable.Name .. ToggleTable.Name] and configtable[argstable.Name .. ToggleTable.Name].Value or TextBoxData.DefaultValue),
                    PlaceholderText = TextBoxData.PlaceholderText,
                    TextBoxData = TextBoxData
                }
                
                local textbox_background = Instance.new("Frame")
                local textbox = Instance.new("TextBox")

                textbox_background.Name = "textboxbackground"
                textbox_background.Parent = optionframe
                textbox_background.BackgroundColor3 = color
                textbox_background.BorderSizePixel = 0
                textbox_background.Position = UDim2.new(0.0833333358, 0, 0.109391868, 0)
                textbox_background.Size = UDim2.new(0, 180, 0, 34)

                textbox.Name = TextBoxData.Name .. "TextBox"
                textbox.Parent = textbox_background
                textbox.BackgroundColor3 = Color3.fromRGB(47, 48, 64)
                textbox.BackgroundTransparency = 1
                textbox.BorderSizePixel = 0
                textbox.Position = UDim2.new(0.00786163565, 0, -0.00825500488, 0)
                textbox.Size = UDim2.new(0, 180, 0, 34)
                textbox.Font = Enum.Font.SourceSansLight
                textbox.Text = TextBoxAPI.Value
                textbox.TextColor3 = Color3.fromRGB(0, 0, 0)
                textbox.PlaceholderColor3 = Color3.fromRGB(0, 0, 0)
                textbox.TextSize = 22.000
                textbox.PlaceholderText = TextBoxAPI.PlaceholderText or ""

                TextBoxAPI.MainObject = textbox_background
            
                textbox.Changed:Connect(function(property)
                    if property == "Text" then
                        TextBoxAPI.Value = textbox.Text
                        argstable.Function(property)
                    end
                end)
            
                if configtable[argstable.Name .. ToggleTable.Name] == nil then
                    configtable[argstable.Name .. ToggleTable.Name] = {Value = TextBoxAPI.Value}
                end
            
                Library.Objects[argstable.Name .. "TextBox"] = {
                    API = TextBoxAPI, 
                    Data = Data,
                    Instance = textbox, 
                    Type = "TextBox", 
                    OptionsButton = argstable.Name, 
                    Window = TabsFrame.Name
                }
                
                return TextBoxAPI
            end

            -- Note: this is still ToggleTable:CreateToggle function
            -- Idk what is this but if i remove it something will break 100%
            local thngylol = Instance.new("Frame")
            local thngyloltwo = Instance.new("Frame")

            thngylol.Parent = optionframe
            thngylol.Transparency = 1
            thngylol.Size = UDim2.new(0, 0, 0, 0.7)
            thngylol.LayoutOrder = 99999

            thngyloltwo.Parent = optionframe
            thngyloltwo.Transparency = 1
            thngyloltwo.Size = UDim2.new(0, 0, 0, 0.7)
            thngyloltwo.LayoutOrder = -9999

            Library.Objects[data.Name] = {
                Instance = Toggle, 
                OptionFrame = optionframe,
                Type = "Toggle", 
            }
            return ToggleTable
        end
        
        return tabtable
    end
end

return Library