-- ChairWare Hub by !Milan#4563 
-- Some code on here is shitty but it works so IDGAF
repeat wait() until game:IsLoaded()
game:GetService("Players").LocalPlayer.Idled:connect(function() -- copy pasted anti afk
	game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
	wait(1)
	game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)
local queue_on_teleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport or function() end
queue_on_teleport(game:HttpGet("https://raw.githubusercontent.com/Milan08Studio/ChairWare/main/main.lua"))
local win = loadstring(game:HttpGet("https://raw.githubusercontent.com/Milan08Studio/ChairWare/main/kavo.lua"))().CreateLib("ChairWare Hub | discord.gg/WNeMvS5GB4","Sentinel")
local config = {fov=70}
local crawlHandler = require(game.ReplicatedStorage.Modules.Game.ClientCrawlHandler)
local network = require(game.ReplicatedStorage.Modules.Utilities.Network)
local consts = require(game.ReplicatedStorage.Modules.Constants)
local notificationHandler = require(game.ReplicatedStorage.Modules.NotificationHandler)
function getCurrentMap() return workspace:FindFirstChild(workspace:GetAttribute("Map")) end
function getKiller() return game.Teams.Killer:GetPlayers()[1] end
local mainTab = win:NewTab("Main")
local survivorSec = mainTab:NewSection("Survivors")
survivorSec:NewToggle("Loot Autofarm","teleports u to loot", function(val)
    config.lootFarm = val
    if val then collectLoot() end
end)
survivorSec:NewToggle("Revive Farm","teleports u to downed ppl", function(val)
    config.reviveFarm = val
end)
survivorSec:NewToggle("Killer Safety","teleports u away from killer", function(val)
    config.killerSafety = val
end)
survivorSec:NewToggle("Auto Escape","teleports u to door when it opens", function(val)
    config.autoEscape = val
end)
survivorSec:NewToggle("No Rat Traps","removes traps", function(val)
    config.removeTraps = val
end)
function collectLoot()
    local collected = 0
    for i,v in pairs(getCurrentMap().LootSpawns:GetChildren()) do
        if collected == consts.MAX_ITEMS[game.Players.LocalPlayer:GetAttribute("Membership")].MAX_BACKPACK then break end
        if v.ProximityPrompt.Enabled then
            game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(v.Model.Border.CFrame + Vector3.new(0,5,0))
            wait(0.2)
            fireproximityprompt(v.ProximityPrompt)
            wait(0.2)
            collected += 1
        end
    end
end
workspace:GetAttributeChangedSignal("Timer"):Connect(function()
    if workspace:GetAttribute("Timer") == 300 and config.lootFarm and game.Players.LocalPlayer.Team == game.Teams.Survivor then collectLoot() end
end)
workspace:GetAttributeChangedSignal("ExitsOpen"):Connect(function()
    if workspace:GetAttribute("ExitsOpen") and config.autoEscape and game.Players.LocalPlayer.Team == game.Teams.Survivor  then
        game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(getCurrentMap().Exits.ExitGateway.PrimaryPart.CFrame)
        nameTagGui:ClearAllChildren()
    end
end)
local killerSec = mainTab:NewSection("Killer")
workspace.ChildAdded:Connect(function(child) if config.soulTeleport and child.Name == "Soul" and game.Players.LocalPlayer.Team == game.Teams.Killer then child.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position end end)
killerSec:NewToggle("Auto Kill All","kills everyone when you are the killer", function(val)
    config.killAll = val
    if config.killAll then
        coroutine.resume(coroutine.create(function()
            while wait() do
                if not config.killAll then coroutine.yield() end
                local char = game.Players.LocalPlayer.Character
                if char and game.Players.LocalPlayer.Team == game.Teams.Killer and char:FindFirstChild("Knife") then
                    require(game.ReplicatedStorage.Modules.Game.KnifeInput).SlashInput("KnifeSlash",Enum.UserInputState.Begin)
                    for i,v in pairs(game.Players:GetPlayers()) do
                        if v.Team == game.Teams.Survivor and v.Character and not v:GetAttribute("Downed") then
                            repeat
                                char:SetPrimaryPartCFrame(v.Character.HumanoidRootPart.CFrame)
                                wait(0.1)
                            until v:GetAttribute("Downed") or v.Team ~= game.Teams.Survivor or not workspace:FindFirstChild(v.Name)
                        end
                    end
                    require(game.ReplicatedStorage.Modules.Game.KnifeInput).SlashInput("KnifeSlash",Enum.UserInputState.End)
                end
            end
        end))
    end
end)
killerSec:NewToggle("Soul Teleport","teleports souls to you when people die",function(val) config.soulTeleport = val end)
local visualsTab = win:NewTab("Visuals")
local playerEspSec = visualsTab:NewSection("Player ESP")
local worldSec = visualsTab:NewSection("World")
worldSec:NewSlider("FOV","changes ur field of view",120,70,function(val)
    config.fov = val
end)
playerEspSec:NewToggle("Nametag ESP","Shows cool ass nametags",function(val)
    config.nametags = val
end)
playerEspSec:NewToggle("Box ESP","Shows box esp",function(val)
    config.boxEsp = val
end)
local nametags = {}
local nameTagGui = Instance.new("ScreenGui")
if syn then
    nameTagGui.Name = syn.crypt.random(20)
    syn.protect_gui(nameTagGui)
end
nameTagGui.Parent = game.CoreGui
function makeNametag(plr) 
    local Nametag = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local TextLabel = Instance.new("TextLabel")
    local UIStroke = Instance.new("UIStroke",Nametag)
    UIStroke.Transparency = 0.5
    UIStroke.Thickness = 2
    Nametag.Name = plr.Name
    Nametag.Parent = nameTagGui
    Nametag.BackgroundColor3 = Color3.fromRGB(111, 111, 111)
    Nametag.BackgroundTransparency = 0.500
    Nametag.Position = UDim2.new(0.279894412, 0, 0.369717419, 0)
    Nametag.Size = UDim2.new(0, 145, 0, 13)
    Nametag.Visible = false
    UICorner.CornerRadius = UDim.new(0, 5)
    UICorner.Parent = Nametag
    TextLabel.Parent = Nametag
    TextLabel.RichText = true
    TextLabel.BackgroundColor3 = Color3.fromRGB(111, 111, 111)
    TextLabel.BackgroundTransparency = 1.000
    TextLabel.Position = UDim2.new(0.00332302507, 0, -0.0333827101, 0)
    TextLabel.Size = UDim2.new(0, 145, 0, 13)
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextSize = 10.000
    nametags[plr.Name] = Nametag
    return nametags[plr.Name]
end
game:GetService("RunService").RenderStepped:Connect(function()
    local killer = getKiller()
    nameTagGui.Enabled = config.nametags
    for i,v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Team ~= game.Teams.Lobby then
            local char = v.Character
            if char then -- Box ESP rendering
                if not char.HumanoidRootPart:FindFirstChild("BoxEssPee") and config.boxEsp then
                    local billboard = Instance.new("BillboardGui",char.HumanoidRootPart)
                    billboard.Name = "BoxEssPee"
                    billboard.Size = UDim2.new(3,0,5,0)
                    billboard.AlwaysOnTop = true
                    local frame = Instance.new("Frame",billboard)
                    frame.Size = UDim2.new(1,0,1,0)
                    frame.BackgroundColor3 = v.Team.TeamColor.Color
                    frame.BackgroundTransparency = 0.5
                    frame.BorderSizePixel = 0
                elseif char.HumanoidRootPart:FindFirstChild("BoxEssPee") and not config.boxEsp then char.HumanoidRootPart.BoxEssPee:Destroy()
                end
                -- Nametags rendering
                local nametag = nametags[v.Name]
                if not nametag then nametag = makeNametag(v) end
                if not nametag:FindFirstChild("TextLabel") then nametag:Destroy() nametag = makeNametag(v) end
                local pos, isVis = workspace.CurrentCamera:WorldToScreenPoint(char.Head.Position)
                nametag.Visible = isVis
                if v.Team == game.Teams.Survivor then
                    local lives = v:GetAttribute("Lives")
                    local hpColor = "rgb(0, 255, 0)"
                    if lives == 2 then hpColor = "rgb(255, 166, 0)" end
                    if lives == 1 then hpColor = "rgb(255, 0, 0)" end
                    nametag.TextLabel.Text = v.DisplayName .. "<font color=\""..hpColor .. "\"> [" .. lives .."]</font>"
                else
                    nametag.TextLabel.Text = v.DisplayName
                end               
                nametag.Position = UDim2.new(0,pos.X - 70,0,pos.Y - 22)
                nametag.UIStroke.Color = v.Team.TeamColor.Color
                for i,v in pairs(nametags) do if not game.Players:FindFirstChild(i) or game.Players[i].Team == game.Teams.Lobby then nametags[i]:Destroy() end end
            end
            if char and game.Players.LocalPlayer.Team == game.Teams.Survivor and v.Team == game.Teams.Survivor and config.reviveFarm and v:GetAttribute("Downed") and not game.Players.LocalPlayer:GetAttribute("Downed") and (v.Character.HumanoidRootPart.Position - killer.Character.HumanoidRootPart.Position).Magnitude > 30 then
                game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(char.HumanoidRootPart.CFrame + Vector3.new(0,2,0))
                wait(0.5)
            end
        end
    end
    if config.killerSafety and game.Players.LocalPlayer.Team == game.Teams.Survivor then -- Killer safety
        local loots = getCurrentMap().LootSpawns:GetChildren()
        if killer and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - killer.Character.HumanoidRootPart.Position).Magnitude < 20 then
            game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(loots[math.random(1,#loots)].Model.Border.CFrame + Vector3.new(0,5,0))
        end
    end
    workspace.CurrentCamera.FieldOfView = config.fov 
    pcall(function() if config.removeTraps then getCurrentMap().RatTraps:Destroy() end end)
end)
local miscTab = win:NewTab("Misc")
local commsSec = miscTab:NewSection("Communications")
commsSec:NewToggle("Chat Spammer","spams in chat",function(val)
    config.spammer = val
    coroutine.resume(coroutine.create(function()
        while wait(2) do
            if not config.spammer then coroutine.yield() end 
            game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("dissord.gg/WNeMvS5GB4 - join ChairWare Hub","All")
        end
    end))
end)
miscTab:NewSection("User Interface"):NewKeybind("Toggle UI", "toggles gui", Enum.KeyCode.RightControl, function()
	win:ToggleUI()
end)
notificationHandler.BannerAlert("ChairWare Hub loaded successfully!",Color3.new(255,0,0))
