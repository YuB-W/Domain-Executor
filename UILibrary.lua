--[[
    Credits to anyones code i used or looked at
]]

repeat task.wait() until game:IsLoaded()

-- Instances
local Players = game.Players
local LocalPlayer = Players.LocalPlayer
local Mouse = game.Players.LocalPlayer:GetMouse()
local PlayerGui = LocalPlayer.PlayerGui
local configsaving = true

-- Services
local UserInputService = game:GetService("UserInputService")
local InputService = game:GetService("UserInputService")
local input = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")


-- I don't know what do i write here 
local getasset = getsynasset or getcustomasset

local tweens = {Notification = function(base)
    TweenService:Create(base, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {Position = UDim2.new(0.438, 0,0.053, 0)}):Play()
end}

local optionframe
local TabsFrame

-- Main thing
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Name = "Mana"
local ClickGui = Instance.new("Frame", ScreenGui)
ClickGui.Name = "ClickGui"
local NotificationGui = Instance.new("Frame", ScreenGui)
NotificationGui.Name = "NotificationGui"
NotificationGui.Size = UDim2.new(0, 100, 0, 10)
NotificationGui.Position = UDim2.new(0, 1817, 0, 955)
NotificationGui.Active = true
NotificationGui.Draggable = true

local keybinds = {}
local Library = {
    ["Sounds"] = true,
    ["GuiKeybind"] = "N",
    ["IsDraggable"] = true,
    ["Font"] = Enum.Font.Gotham,
    ["TextSize"] = 20,
    ["Objects"] = {}
}

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

local sliderapi = {}

-- Config system
local foldername = "Mana/Config"
local conf = {
	["file"] = foldername.."/"..game.PlaceId..".json",
	["functions"] = {}
}

function conf.functions:MakeFile()
	if isfile("Mana/Config/"..game.PlaceId..".json") then return end
        if not isfolder(foldername)  then
            makefolder(foldername)
        end
	writefile("Mana/Config/"..game.PlaceId..".json", "{}")
end

function conf.functions:LoadConfigs()
	if not isfile("Mana/Config/"..game.PlaceId..".json") then
		conf.functions:MakeFile()
	end
    wait(0.5)
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile("Mana/Config/"..game.PlaceId..".json"))
    end)
    if success then
        warn("[ManaV2ForRoblox]: success!")
        return data
    else
        warn("[ManaV2ForRoblox]: error in decoding JSON:", data, ".")
        return {}
    end
end

function conf.functions:WriteConfigs(tab)
	conf.functions:MakeFile()
	writefile("Mana/Config/"..game.PlaceId..".json", HttpService:JSONEncode((tab or {})))
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
local function getcustomassetfunc(path)
    if not betterisfile(path) then
        spawn(function()
            local textlabel = Instance.new("TextLabel")
            textlabel.Size = UDim2.new(1, 0, 0, 36)
            textlabel.Text = "Downloading "..path
            textlabel.BackgroundTransparency = 1
            textlabel.TextStrokeTransparency = 0
            textlabel.TextSize = 30
            textlabel.Font = Enum.Font.SourceSans
            textlabel.TextColor3 = Color3.new(1, 1, 1)
            textlabel.Position = UDim2.new(0, 0, 0, -36)
            textlabel.Parent = ScreenGuitwo
            repeat wait() until betterisfile(path)
            textlabel:Remove()
        end)
        local req = requestfunc({
            Url = "https://raw.githubusercontent.com/Maanaaaa/ManaV2ForRoblox/main/"..path:gsub("Mana/Assets", "Assets"),
            Method = "GET"
        })
        writefile(path, req.Body)
    end
    if cachedassets[path] == nil then
        cachedassets[path] = getasset(path) 
    end
    return cachedassets[path]
end

function Library:ToggleLibrary()
    if not NotificationGui.Visible and UserInputService:GetFocusedTextBox() == nil then
        NotificationGui.Visible = true
    else
        if UserInputService:GetFocusedTextBox() == nil then
            NotificationGui.Visible = false
        end
    end
end

--notification (from Future)
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

--[[
local NotificationSize = UDim2.new(0, 300, 0, 100)
function GuiLibrary:CreateNotification(tittle, text, Time)
    spawn(function()
        local Time = Time or 2
        local title = title or "Notification"
        local text = text or "No text"

        local offset = #NotificationGui:GetChildren()
        local ToastNotification = Instance.new("Frame")
        local Topbar = Instance.new("Frame")
        local Bottombar = Instance.new("Frame")
        local Title = Instance.new("TextLabel")
        local Text = Instance.new("TextLabel")
        ToastNotification.Name = "ToastNotification"
        ToastNotification.Parent = NotificationGui
        ToastNotification.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        ToastNotification.BackgroundTransparency = 0.250
        ToastNotification.BorderSizePixel = 0
        ToastNotification.Position = UDim2.new(1, 0, 1, -((5 + NotificationSize.Y.Offset) * (offset + 1)))
        ToastNotification.Size = NotificationSize
        Topbar.Name = "Topbar"
        Topbar.Parent = ToastNotification
        Topbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Topbar.BackgroundTransparency = 0.6
        Topbar.BorderSizePixel = 0
        Topbar.Size = UDim2.new(0, NotificationSize.X.Offset, 0, NotificationSize.Y.Offset/3.16)
        Bottombar.Name = "Bottombar"
        Bottombar.Parent = ToastNotification
        Bottombar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Bottombar.BackgroundTransparency = 0.6
        Bottombar.BorderSizePixel = 0
        Bottombar.Size = UDim2.new(0, NotificationSize.X.Offset, 0, 5)
        Bottombar.Position = UDim2.new(0.5,0, 1, -5)
        Bottombar.AnchorPoint = Vector2.new(0.5, 0)
        Title.Name = "Title"
        Title.Parent = Topbar
        Title.BackgroundTransparency = 1.000
        Title.Position = UDim2.new(0.0260000005, 0, 0, 0)
        Title.Size = UDim2.new(0, NotificationSize.X.Offset/1.16326531, 0, NotificationSize.Y.Offset/3.16)
        Title.Font = GuiLibrary.Font
        Title.Text = title
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 20
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Text.Name = "Text"
        Text.Parent = ToastNotification
        Text.BackgroundTransparency = 1.000
        Text.Position = UDim2.new(0.0260000005, 0, 0, Topbar.Size.Y.Offset + 5)
        Text.Size = UDim2.new(0, NotificationSize.X.Offset/1.14, 0, NotificationSize.Y.Offset/1.05333333)
        Text.Font = GuiLibrary.Font
        Text.Text = text
        Text.TextColor3 = Color3.fromRGB(255, 255, 255)
        Text.TextSize = 20
        Text.TextWrapped = true
        Text.TextXAlignment = Enum.TextXAlignment.Left
        Text.TextYAlignment = Enum.TextYAlignment.Top

        bettertween2(ToastNotification, UDim2.new(1, -(NotificationSize.X.Offset + 10), 1, -((5 + NotificationSize.Y.Offset) * (offset + 1))), Enum.EasingDirection.In, Enum.EasingStyle.Sine, 0.15, true)
        task.wait(0.15)
        pcall(function()
            Bottombar:TweenSize(UDim2.new(0, 0, 0, 5), Enum.EasingDirection.In, Enum.EasingStyle.Linear, Time, true)
        end)
        task.wait(Time)
        bettertween2(ToastNotification, UDim2.new(1, 0, 1, ToastNotification.Position.Y.Offset), Enum.EasingDirection.In, Enum.EasingStyle.Sine, 0.15, true)
        task.wait(0.15)
        ToastNotification:Destroy()
    end)
end
]]

function Library:CreateNotification(title, text, delay2, toggled)
    spawn(function()
        if ScreenGuitwo:FindFirstChild("Background") then ScreenGuitwo:FindFirstChild("Background"):Destroy() end
		if Library["Notifications"] == true then
	        local frame = Instance.new("Frame")
	        frame.Size = UDim2.new(0, 100, 0, 115)
	        frame.Position = UDim2.new(0.5, 0, 0, -115)
	        frame.BorderSizePixel = 0
	        frame.AnchorPoint = Vector2.new(0.5, 0)
	        frame.BackgroundTransparency = 0.5
	        frame.BackgroundColor3 = Color3.new(0, 0, 0)
	        frame.Name = "Background"
	        frame.Parent = ScreenGuitwo
	        local frameborder = Instance.new("Frame")
	        frameborder.Size = UDim2.new(1, 0, 0, 8)
	        frameborder.BorderSizePixel = 0
	        frameborder.BackgroundColor3 = (toggled and Color3.fromRGB(102, 205, 67) or Color3.fromRGB(205, 64, 78))
	        frameborder.Parent = frame
	        local frametitle = Instance.new("TextLabel")
	        frametitle.Font = Enum.Font.SourceSansLight
	        frametitle.BackgroundTransparency = 1
	        frametitle.Position = UDim2.new(0, 0, 0, 30)
	        frametitle.TextColor3 = (toggled and Color3.fromRGB(102, 205, 67) or Color3.fromRGB(205, 64, 78))
	        frametitle.Size = UDim2.new(1, 0, 0, 28)
	        frametitle.Text = "          "..title
	        frametitle.TextSize = 24
	        frametitle.TextXAlignment = Enum.TextXAlignment.Left
	        frametitle.TextYAlignment = Enum.TextYAlignment.Top
	        frametitle.Parent = frame
	        local frametext = Instance.new("TextLabel")
	        frametext.Font = Enum.Font.SourceSansLight
	        frametext.BackgroundTransparency = 1
	        frametext.Position = UDim2.new(0, 0, 0, 68)
	        frametext.TextColor3 = Color3.new(1, 1, 1)
	        frametext.Size = UDim2.new(1, 0, 0, 28)
	        frametext.Text = "          "..text
	        frametext.TextSize = 24
	        frametext.TextXAlignment = Enum.TextXAlignment.Left
	        frametext.TextYAlignment = Enum.TextYAlignment.Top
	        frametext.Parent = frame
	        local textsize = game:GetService("TextService"):GetTextSize(frametitle.Text, frametitle.TextSize, frametitle.Font, Vector2.new(100000, 100000))
	        local textsize2 = game:GetService("TextService"):GetTextSize(frametext.Text, frametext.TextSize, frametext.Font, Vector2.new(100000, 100000))
	        if textsize2.X > textsize.X then textsize = textsize2 end
	        frame.Size = UDim2.new(0, textsize.X + 38, 0, 115)
	        pcall(function()
	            frame:TweenPosition(UDim2.new(0.5, 0, 0, 20), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.15)
	            game:GetService("Debris"):AddItem(frame, delay2 + 0.15)
	        end)
	end
    end)
end

function Library:CreateWarning(title, text, delay2)
    spawn(function()
        if ScreenGuitwo:FindFirstChild("Background") then ScreenGuitwo:FindFirstChild("Background"):Destroy() end
	        local frame = Instance.new("Frame")
	        frame.Size = UDim2.new(0, 100, 0, 115)
	        frame.Position = UDim2.new(0.5, 0, 0, -115)
	        frame.BorderSizePixel = 0
	        frame.AnchorPoint = Vector2.new(0.5, 0)
	        frame.BackgroundTransparency = 0.5
	        frame.BackgroundColor3 = Color3.new(0, 0, 0)
	        frame.Name = "Background"
	        frame.Parent = ScreenGuitwo
	        local frameborder = Instance.new("Frame")
	        frameborder.Size = UDim2.new(1, 0, 0, 8)
	        frameborder.BorderSizePixel = 0
	        frameborder.BackgroundColor3 = Color3.fromRGB(205, 64, 78)
	        frameborder.Parent = frame
	        local frametitle = Instance.new("TextLabel")
	        frametitle.Font = Enum.Font.SourceSansLight
	        frametitle.BackgroundTransparency = 1
	        frametitle.Position = UDim2.new(0, 0, 0, 30)
	        frametitle.TextColor3 = Color3.fromRGB(205, 64, 78)
	        frametitle.Size = UDim2.new(1, 0, 0, 28)
	        frametitle.Text = "          "..title
	        frametitle.TextSize = 24
	        frametitle.TextXAlignment = Enum.TextXAlignment.Left
	        frametitle.TextYAlignment = Enum.TextYAlignment.Top
	        frametitle.Parent = frame
	        local frametext = Instance.new("TextLabel")
	        frametext.Font = Enum.Font.SourceSansLight
	        frametext.BackgroundTransparency = 1
	        frametext.Position = UDim2.new(0, 0, 0, 68)
	        frametext.TextColor3 = Color3.new(1, 1, 1)
	        frametext.Size = UDim2.new(1, 0, 0, 28)
	        frametext.Text = "          "..text
	        frametext.TextSize = 24
	        frametext.TextXAlignment = Enum.TextXAlignment.Left
	        frametext.TextYAlignment = Enum.TextYAlignment.Top
	        frametext.Parent = frame
	        local textsize = game:GetService("TextService"):GetTextSize(frametitle.Text, frametitle.TextSize, frametitle.Font, Vector2.new(100000, 100000))
	        local textsize2 = game:GetService("TextService"):GetTextSize(frametext.Text, frametext.TextSize, frametext.Font, Vector2.new(100000, 100000))
	        if textsize2.X > textsize.X then textsize = textsize2 end
	        frame.Size = UDim2.new(0, textsize.X + 38, 0, 115)
	        pcall(function()
	            frame:TweenPosition(UDim2.new(0.5, 0, 0, 20), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.15)
	            game:GetService("Debris"):AddItem(frame, delay2 + 0.15)
	        end)
    end)
end

--Library:CreateNotification("Loaded", "Press N to toggle GUI", 3, true)
--Library:CreateWarning("Loaded", "Press N to toggle GUI", 3)

-- GUI Button
local button = Instance.new("TextButton")
button.Position = UDim2.new(1, -1816, 0, -32)
button.Text = "Mana"
button.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
button.TextColor3 = Color3.new(1, 1, 1)
button.Size = UDim2.new(0, 32, 0, 32)
button.BorderSizePixel = 0
button.BackgroundTransparency = 0.5
button.Parent = ScreenGui
--[[
button.Active = true
button.Draggable = true
]]
local UICorner = Instance.new("UICorner")
UICorner.Parent = button

local function dragGUI(gui, dragpart)
    spawn(function()
        local dragging
        local dragInput
        local dragStart = Vector3.new(0,0,0)
        local startPos
        local function update(input)
            local delta = input.Position - dragStart
            local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (delta.X), startPos.Y.Scale, startPos.Y.Offset + (delta.Y))
            TweenService:Create(gui, TweenInfo.new(.20), {Position = Position}):Play()
        end
        dragpart.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch and dragging == false then
                    dragStart = input.Position
                    local delta = (input.Position - dragStart)
                    if delta.Y <= 30 then
                        dragging = dragpart.Visible
                        startPos = gui.Position
                        
                        input.Changed:Connect(function()
                            if input.UserInputState == Enum.UserInputState.End then
                                dragging = false
                            end
                        end)
                    end
                end
        end)
        dragpart.InputChanged:Connect(function(input)
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

local function playsound(id, volume) 
      if Library.Sounds == true then
	    local sound = Instance.new("Sound")
	    sound.Parent = workspace
	    sound.SoundId = id
	    if volume then 
	        sound.Volume = volume
	    end
	    sound:Play()
	    wait(2)
	    sound:Destroy()
      end
end

local a
local tabs = {}
function Library:CreateWindow()
    TabsFrame = Instance.new("Frame")
    local uilistthingy = Instance.new("UIListLayout")
    local UIScale = Instance.new("UIScale")
    TabsFrame.Name = "Tabs"
    TabsFrame.Parent = ScreenGui
    TabsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabsFrame.BackgroundTransparency = 1.000
    TabsFrame.BorderSizePixel = 0
    TabsFrame.Position = UDim2.new(0.010, 0,0.010, 0)
    TabsFrame.Size = UDim2.new(0, 207, 0, 40)
    TabsFrame.AutomaticSize = "X"
    uilistthingy.Parent = TabsFrame
    uilistthingy.FillDirection = Enum.FillDirection.Horizontal
    uilistthingy.SortOrder = Enum.SortOrder.LayoutOrder
    uilistthingy.Padding = UDim.new(0, 40)
    UIScale.Parent = TabsFrame
    UIScale.Scale = 4
    function Library:CreateTab(title, color)
        table.insert(tabs, #tabs)
        local tab = Instance.new("TextButton")
        local tabname = Instance.new("TextLabel")
        local assetthing = Instance.new("ImageLabel")
        local uilistlay = Instance.new("UIListLayout")
        tab.Modal = true
        uilistlay.Parent = tab
        uilistlay.SortOrder = Enum.SortOrder.LayoutOrder
        tab.Name = title
	tab.Draggable = true
	tab.Active = true
        tab.ZIndex = 1
        tab.Parent = TabsFrame
        tab.BackgroundColor3 = Color3.fromRGB(14, 14, 23)
        tab.BorderSizePixel = 0
        tab.Position = UDim2.new(0,40,0.858895704, 0)
        tab.Size = UDim2.new(0, 207, 0, 40)
        tab.Active=true
        tab.LayoutOrder = 1 + #tabs
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
        tabname.Text = " "..title
        tabname.TextColor3 = color
        tabname.TextSize = 22.000
        tabname.TextWrapped = true
        tabname.TextXAlignment = Enum.TextXAlignment.Left
    
        assetthing.Parent = tabname
        assetthing.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        assetthing.BackgroundTransparency = 1
        assetthing.Position = UDim2.new(0.86, 0,0.154, 0)
        assetthing.Size = UDim2.new(0, 30, 0, 30)

        if tittle == "Other" then
        assetthing.Image = getcustomassetfunc("Mana/Assets/settings.png") or getasset("Mana/Assets/settings.png")
        end

        local tabtable = {
            ["Toggles"]={}
        }
        function tabtable:CreateToggle(data)
            local info = {
            ["Name"] = data["Name"],  
            ["Keybind"] = (configtable[data["Name"]["Keybind"]] or data["Keybind"]), 
            ["Callback"] = (data["Callback"] or function() end)
            }
            -- adding module name to configtable
            configtable[info["Name"]]={
                ["Keybind"]=((configtable[info["Name"]] and configtable[info["Name"]]["Keybind"]) or "none"), 
                ["IsToggled"]=((configtable[info["Name"]] and configtable[info["Name"]]["IsToggled"]) or false)
            }
            -- code
            local title,keybind,callback=info["Name"],info["Keybind"],info["Callback"]
            keybind = (keybind or {["Name"] = nil})
            keybinds[(keybind.Name or "%*")] = (keybind.Name == nil and false or true)
            local focus = {
                ["Elements"]={}
            }
            
            local sussyamog = {["Enabled"] = false, ["Name"] = (data["Name"] or "")}
            table.insert(tabtable["Toggles"],#tabtable["Toggles"])
            sussyamog["Enabled"] = false
            sussyamog["Name"] = (data["Name"] or "")
            callback = callback or function() end
            local oldkey = keybind.Name
            local toggle = Instance.new("TextButton")
            local togname = Instance.new("TextLabel")
            local toggledtog = Instance.new("TextButton")
            local togname_2 = Instance.new("TextLabel")
            local uicorner = Instance.new("UICorner")
            toggle.Name = "toggle_" .. title
            toggle.Parent = tab
            toggle.BackgroundColor3 = Color3.fromRGB(14, 20, 14)
            toggle.BorderSizePixel = 0
            toggle.Position = UDim2.new(0.0827946085, -17, 0.133742347, 33)
            toggle.Size = UDim2.new(0, 207, 0, 40)
            toggle.Text = ""
            togname.Name = "toggle_" .. title .. "234"
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
			
            local optionselement = {
                ["Stuff"] = {}
            }
            local BindText
                table.insert(optionselement["Stuff"],#optionselement["Stuff"])
                local optionframe = Instance.new("Frame")
                optionframe.Name = "optionframe"
                optionframe.Parent = tab
                optionframe.BackgroundColor3 = Color3.fromRGB(47, 48, 64)
                optionframe.Position = UDim2.new(0.102424242, 0, 0.237059206, 0)
                optionframe.Size = UDim2.new(0, 207, 0, 0)
                optionframe.AutomaticSize = "Y"
                optionframe.Visible = false
                local UIListLayout = Instance.new("UIListLayout")
                UIListLayout.Parent = optionframe
                UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout.Padding = UDim.new(0, 8)
                BindText = Instance.new("TextButton")
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
                    focus["Elements"]["toggle_"..title]=true 
                end)
                BindText.MouseLeave:Connect(function()
                    focus["Elements"]["toggle_"..title]=false
                end)
                conf["functions"]:WriteConfigs(configtable)
                local x = (game:GetService("HttpService"):JSONDecode(readfile(conf["file"])))
                if isfile(conf["file"]) and x[title]["Keybind"] ~= "none" and x[title]["Keybind"] ~= nil then
                    x = x[title]["Keybind"]
                    --[title]["Keybind"] or "none")
                    if keybinds[x] == true then
                        BindText.Text = "Bind: "..x
                        isclicked = false
                        return
                    end
                    if oldkey ~= nil then 
                        keybinds[oldkey] = nil
                    end
                    oldkey=x
                    BindText.Text = "Bind: "..x
                    configtable[title]["Keybind"] = x
                    isclicked = false
                    cooldown = true
                    wait(0.5)
                    cooldown = false
                end
                BindText.MouseButton1Click:Connect(function()
                    if not focus["Elements"]["toggle_"..title]  then return end
                    if isclicked == true then return end
                    isclicked = true
                    BindText.Text = "Bind: ..."
                    
                    UserInputService.InputBegan:Connect(function(input)
                        if input.KeyCode.Name ~= "Unknown" and input.KeyCode.Name ~= oldkey then
                            if isclicked  == false  then return end
                            if keybinds[input.KeyCode.Name] == true then
                                BindText.Text = "Bind: "..oldkey
                                isclicked = false
                                return
                            end
                            if oldkey ~= nil then 
                                keybinds[oldkey] = nil
                            end
                            oldkey=input.KeyCode.Name
                            BindText.Text = "Bind: "..oldkey
                            configtable[title]["Keybind"] = oldkey
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
    
            if isfile(conf["file"]) then
               
            else
               configtable[title]["IsToggled"]=false
            end
    
            function sussyamog:Toggle(bool)
                bool = bool or (not sussyamog["Enabled"])
                sussyamog["Enabled"] = bool
                if not bool then
                    spawn(function()
                        callback(false)
                    end)
                    spawn(function()
                        Library:CreateNotification(title, "Disabled "..title, 4, false)
                        configtable[title]["IsToggled"] = false
                    end)
                    toggle.BackgroundColor3 = Color3.fromRGB(14, 20, 14)
                    playsound("rbxassetid://421058925", 1)
                else
                    spawn(function()
                        callback(true)
                    end)
                    spawn(function()
                        Library:CreateNotification(title, "Enabled "..title, 4, true)
                        configtable[title]["IsToggled"] = true
                    end)
                    toggle.BackgroundColor3 = tabname.TextColor3
                   playsound("rbxassetid://421058925", 1)
                end
            end
    
            function sussyamog:silentToggle(bool)
                bool = bool or (not sussyamog["Enabled"])
                if type(bool) == "boolean" then
                    bool = bool
                else
                    if type(bool) == "string" then
                        if bool == "true" then
                            bool = true
                        else
                            if bool == "false" then
                                bool = false
                            end
                        end
                    end
                end
                sussyamog["Enabled"] = bool
                if bool == false or bool == "false" then
                    spawn(function()
                        callback(false)
                    end)
                    configtable[title]["IsToggled"] = false
                    toggle.BackgroundColor3 = Color3.fromRGB(14, 20, 14)
                else
                    if bool == true or bool == "true" then
                        spawn(function()
                            callback(true)
                        end)
                        configtable[title]["IsToggled"] = true
                        toggle.BackgroundColor3 = tabname.TextColor3
                    end
                end
            end
            
            toggle.MouseButton1Click:Connect(function()
                sussyamog:Toggle()
            end)
            UserInputService.InputBegan:Connect(function(input)
                if oldkey == nil then return end
                if cooldown == true then
                    cooldown = false
                    return
                end
                if isclicked == true then return end
                if input.KeyCode.Name == oldkey and UserInputService:GetFocusedTextBox() == nil then
                    sussyamog:Toggle()
                end	
            end) 
            if configtable[title]["IsToggled"]==true then
                sussyamog:silentToggle(true)
            end
            function sussyamog:CreateSlider(argstable)
                local sliderapi = {["Value"] = (configtable[argstable["Name"]..sussyamog["Name"].."_SR"] and configtable[argstable["Name"]..sussyamog["Name"].."_SR"]["Value"] or argstable.Default or argstable.Min)}
                local min, max, roundval = argstable.Min, argstable.Max, (argstable.Round or 2)
                local slider = Instance.new("TextButton")
                local slidertext = Instance.new("TextLabel")
                local slider_2 = Instance.new("Frame")
                slider.Name = "slider"
                slider.Parent = optionframe
                slider.BackgroundColor3 = Color3.fromRGB(47, 48, 64)
                slider.BorderSizePixel = 0
                slider.Position = UDim2.new(0.0833333358, 0, 0.109391868, 0)
                slider.Size = UDim2.new(0, 180, 0, 34)
                slider.Text = ""
                slider.AutoButtonColor = false
                slidertext.Name = "slidertext"
                slidertext.Parent = slider
                slidertext.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                slidertext.BackgroundTransparency = 1.000
                slidertext.BorderSizePixel = 0
                slidertext.Position = UDim2.new(0.0188679248, 0, 0, 0)
                slidertext.Size = UDim2.new(0, 180, 0, 33)
                slidertext.ZIndex = 3
                slidertext.Font = Enum.Font.SourceSansLight
                slidertext.Text = "yes"
                slidertext.TextColor3 = Color3.fromRGB(255, 255, 255)
                slidertext.TextSize = 22.000
                slidertext.TextXAlignment = Enum.TextXAlignment.Left
                slider_2.Name = "slider"
                slider_2.Parent = slider
                slider_2.BackgroundColor3 = color
                slider_2.BorderSizePixel = 0
                slider_2.Position = UDim2.new(0.00786163565, 0, -0.00825500488, 0)
                slider_2.Size = UDim2.new(0, 0, 0, 34)
                slider_2.ZIndex = 2
                local mouse = game.Players.LocalPlayer:GetMouse()
                if configtable[argstable["Name"]..sussyamog["Name"].."_SR"] == nil then
                    configtable[argstable["Name"]..sussyamog["Name"].."_SR"] = {["Value"] = sliderapi["Value"]}
                end
                local function slide(input)
                    local sizeX = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                    slider_2.Size = UDim2.new(sizeX, 0, 1, 0)
                    local value = math.floor(((((max - min) * sizeX) + min) * (10 ^ roundval)) +0.5)/(10 ^ roundval)
                    sliderapi["Value"] = value
                    slidertext.Text = argstable.Name..": "..tostring(value)
                    configtable[argstable["Name"]..sussyamog["Name"].."_SR"]["Value"]=sliderapi["Value"]
                    if not argstable["OnInputEnded"] then
                        argstable.Function(value)
                    end
                end
                local sliding
                slider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = true
                        slide(input)
                    end
                end)

                slider.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if argstable["OnInputEnded"] then
                            argstable.Function(sliderapi.Value)
                            configtable[argstable["Name"]..sussyamog["Name"].."_SR"]["Value"]=sliderapi["Value"] 
                        end
                        sliding = false
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        if sliding then
                            slide(input)
                        end
                    end
                end)

                sliderapi["Set"] = function(value)
                    local value = math.floor((math.clamp(value, min, max) * (10^roundval))+0.5)/(10^roundval)
                    sliderapi["Value"] = value
                    slider_2.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                    slidertext.Text = argstable.Name..": "..tostring(value)
                    argstable.Function(value)
                end
                sliderapi.Set(sliderapi["Value"])

                Library["Objects"][argstable.Name.."Slider"] = {["API"] = sliderapi, ["Instance"] = Slider, ["Type"] = "Slider", ["OptionsButton"] = argstable.Name, ["Window"] = TabsFrame.Name}
                return sliderapi
            end
            function sussyamog:CreateDropDown(argstable)
                local ddname = argstable.Name
                local dropdownapi = {["Value"] = nil, ["List"] = {}}
                for i,v in next, argstable.List do 
                    table.insert(dropdownapi.List, v)
                end
                if configtable[ddname] == nil then
                    configtable[ddname] = {["Value"] = dropdownapi["Value"]}
                end
                dropdownapi["Value"] = (configtable[ddname] and configtable[ddname]["Value"]) or argstable.Default or dropdownapi.List[1]
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
                Dropdown.Text = "Value: " --[[.. argstable.Text .. ": "]] ..argstable.Default
                Dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
                Dropdown.TextSize = 22.000
                --Dropdown.TextWrapped = true
                Dropdown.TextXAlignment = Enum.TextXAlignment.Left
                Dropdown.TextYAlignment = Enum.TextYAlignment.Bottom
                dropdownapi["Select"] = function(_select) 
                    if dropdownapi.List[_select] or stringtablefind(dropdownapi.List, _select) then
                        dropdownapi["Value"] = dropdownapi.List[_select] or dropdownapi.List[stringtablefind(dropdownapi.List, _select)]
                        Dropdown.Text = "".. argstable.Text .. ": " ..tostring(dropdownapi.Value)
                        configtable[ddname]["Value"]=dropdownapi["Value"]
                        argstable.Function(dropdownapi["Value"])
                    end
                end
                dropdownapi["SelectNext"] = function() 
                    local newindex = table.find(dropdownapi.List, dropdownapi.Value) 
                    if newindex then 
                        newindex = getvalue(newindex + 1)
                        dropdownapi.Select(newindex)
                    else
                        Library:CreateNotification("NewIndex in selector ("..argstable.Name..") in function `SelectNext` was not found!", "If this keeps happening, go to you exploit's folder\nthen go to workspace/Mana/Config\nand delete everything inside of that folder", 10)
                    end
                end

                dropdownapi["SelectPrevious"] = function() 
                    local newindex = table.find(dropdownapi.List, dropdownapi.Value) 
                    if newindex then 
                        newindex = getvalue(newindex - 1)
                        dropdownapi.Select(newindex)
                    else
                        Library:CreateWarning("NewIndex in selector ("..argstable.Name..") in function `SelectPrevious` was not found!", "If this keeps happening, go to you exploit's folder\nthen go to workspace/Mana/Config\nand delete everything inside of that folder", 10)
                    end
                end
    			if configtable[ddname] and configtable[ddname]["Value"] then
    				dropdownapi.Select(stringtablefind(dropdownapi.List,configtable[ddname]["Value"]))
    			end
                Dropdown.MouseButton1Click:Connect(dropdownapi.SelectNext)
                Dropdown.MouseButton2Click:Connect(dropdownapi.SelectPrevious)
    
                Library["Objects"][argstable.Name.."Selector"] = {["API"] = dropdownapi, ["Instance"] = Selector, ["Type"] = "Selector", ["OptionsButton"] = argstable.Name, ["Window"] = TabsFrame.Name}
                return dropdownapi
            end
            function sussyamog:CreateOptionTog(argstable)
                if configtable[argstable["Name"]..sussyamog["Name"].."_OT"] == nil then
                    configtable[argstable["Name"]..sussyamog["Name"].."_OT"] = {["IsToggled"] = configtable[argstable["Name"]..sussyamog["Name"].."_OT"] and configtable[argstable["Name"]..sussyamog["Name"].."_OT"]["IsToggled"] or argstable.Default}
                end
                local optiontogval = {["Value"] = configtable[argstable["Name"]..sussyamog["Name"].."_OT"] and configtable[argstable["Name"]..sussyamog["Name"].."_OT"]["IsToggled"] or argstable.Default}
                local thing = {
                    ["Name"] = argstable["Name"],
                    ["Func"] = argstable["Func"]
                }
                argstable["Func"] = argstable["Func"] or function() end
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
                tognametwo.Text = argstable["Name"]
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
                if configtable[argstable["Name"]..sussyamog["Name"].."_OT"] == nil then
                    configtable[argstable["Name"]..sussyamog["Name"].."_OT"] = {["IsToggled"] = optiontogval["Value"]}
                end
                function optiontogval:Toggle(bool)
                    bool = bool or not (optiontogval["Value"])
                    optiontogval["Value"] = bool
                    configtable[argstable["Name"]..sussyamog["Name"].."_OT"]["IsToggled"]=bool
                    if not bool then
                        spawn(function()
                            argstable["Func"](false)
                        end)
                        toggleactived.BackgroundColor3 = Color3.fromRGB(68, 68, 60)
                    else
                        spawn(function()
                            argstable["Func"](true)
                        end)
                        toggleactived.BackgroundColor3 = tabname.TextColor3
                    end
                end
                if configtable[argstable["Name"]..sussyamog["Name"].."_OT"] then
                	optiontogval:Toggle(configtable[argstable["Name"]..sussyamog["Name"].."_OT"]["IsToggled"])
                end
                untoggled.MouseButton1Click:Connect(function()
                    optiontogval:Toggle()
                end)
                return optiontogval
            end
            
            --idk if it work
            function sussyamog:CreateTextBox(argstable)
                local textboxapi = {["Value"] = (configtable[argstable["Name"]..sussyamog["Name"].."_MN"] and configtable[argstable["Name"]..sussyamog["Name"].."_MN"]["Value"] or argstable.Value)}
                local slider = Instance.new("TextBox")
                local slider_2 = Instance.new("Frame")
                slider.Name = "slider"
                slider.Parent = optionframe
                slider.BackgroundColor3 = Color3.fromRGB(47, 48, 64)
                slider.BorderSizePixel = 0
                slider.Position = UDim2.new(0.0833333358, 0, 0.109391868, 0)
                slider.Size = UDim2.new(0, 180, 0, 34)
                slider.Text = ""
                slider_2.Name = "slider"
                slider_2.Parent = slider
                slider_2.BackgroundColor3 = color
                slider_2.BorderSizePixel = 0
                slider_2.Position = UDim2.new(0.00786163565, 0, -0.00825500488, 0)
                slider_2.Size = UDim2.new(0, 0, 0, 34)
                slider_2.ZIndex = 2

                if configtable[argstable["Name"]..sussyamog["Name"].."_MN"] == nil then
                    configtable[argstable["Name"]..sussyamog["Name"].."_MN"] = {["Value"] = textboxapi["Value"]}
                end

                Library["Objects"][argstable.Name.."TextBox"] = {
                    ["API"] = textboxapi, 
                    ["Instance"] = TextBox, 
                    ["Type"] = "TextBox", 
                    ["OptionsButton"] = argstable.Name, 
                    ["Window"] = TabsFrame.Name
                }
                return textboxapi
            end
            local thngylol = Instance.new("Frame")
            thngylol.Parent = optionframe
            thngylol.Transparency = 1
            thngylol.Size = UDim2.new(0, 0, 0, 0.7)
            thngylol.LayoutOrder = 99999
            local thngyloltwo = Instance.new("Frame")
            thngyloltwo.Parent = optionframe
            thngyloltwo.Transparency = 1
            thngyloltwo.Size = UDim2.new(0, 0, 0, 0.7)
            thngyloltwo.LayoutOrder = -9999
            return sussyamog
        end
        
        return tabtable
    end
end
Library:ToggleLibrary()
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.N then
        Library:ToggleLibrary()
    end
end) 
return Library
