--[[
    Tox Son Hub | Arcade Basketball
    Key: toxsonfr
    Made for: Tox Son
    v2 - Fixed Auto Green, Auto Guard, reduced lag
--]]

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local CoreGui          = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Workspace        = game:GetService("Workspace")
local Lighting         = game:GetService("Lighting")
local ReplicatedStorage= game:GetService("ReplicatedStorage")

local lp = Players.LocalPlayer

pcall(function()
    for _, name in ipairs({"ToxSon_KeyUI", "ToxSon_Hub"}) do
        local old = CoreGui:FindFirstChild(name)
        if old then old:Destroy() end
    end
end)

-------------------------------------------------------------------------
-- KEY SYSTEM
-------------------------------------------------------------------------
local VALID_KEY = "toxsonfr"

local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "ToxSon_KeyUI"
KeyGui.ResetOnSpawn = false
KeyGui.IgnoreGuiInset = true
KeyGui.Parent = CoreGui

local Overlay = Instance.new("Frame", KeyGui)
Overlay.Size = UDim2.new(1,0,1,0)
Overlay.BackgroundColor3 = Color3.fromRGB(4,6,10)
Overlay.BackgroundTransparency = 0.2
Overlay.BorderSizePixel = 0

local Blur = Instance.new("BlurEffect")
Blur.Size = 20; Blur.Parent = Lighting

local Card = Instance.new("Frame", KeyGui)
Card.Size = UDim2.new(0,340,0,245)
Card.Position = UDim2.new(0.5,-170,0.5,-122)
Card.BackgroundColor3 = Color3.fromRGB(10,13,20)
Card.BorderSizePixel = 0
Instance.new("UICorner", Card).CornerRadius = UDim.new(0,16)
local cs = Instance.new("UIStroke", Card)
cs.Color = Color3.fromRGB(255,160,0); cs.Thickness = 2

local GlowBar = Instance.new("Frame", Card)
GlowBar.Size = UDim2.new(1,0,0,4)
GlowBar.BackgroundColor3 = Color3.fromRGB(255,160,0)
GlowBar.BorderSizePixel = 0
Instance.new("UICorner", GlowBar).CornerRadius = UDim.new(0,16)

local Logo = Instance.new("TextLabel", Card)
Logo.Size = UDim2.new(1,0,0,40); Logo.Position = UDim2.new(0,0,0,14)
Logo.BackgroundTransparency = 1; Logo.Text = "🏀  Tox Son Hub"
Logo.TextColor3 = Color3.fromRGB(255,160,0)
Logo.Font = Enum.Font.GothamBold; Logo.TextSize = 22

local SubLbl = Instance.new("TextLabel", Card)
SubLbl.Size = UDim2.new(1,0,0,18); SubLbl.Position = UDim2.new(0,0,0,52)
SubLbl.BackgroundTransparency = 1; SubLbl.Text = "Arcade Basketball"
SubLbl.TextColor3 = Color3.fromRGB(180,130,60)
SubLbl.Font = Enum.Font.Gotham; SubLbl.TextSize = 12

local NoteLbl = Instance.new("TextLabel", Card)
NoteLbl.Size = UDim2.new(0.85,0,0,22); NoteLbl.Position = UDim2.new(0.075,0,0,78)
NoteLbl.BackgroundTransparency = 1
NoteLbl.Text = "🔑  Enter your key to continue"
NoteLbl.TextColor3 = Color3.fromRGB(180,160,120)
NoteLbl.Font = Enum.Font.Gotham; NoteLbl.TextSize = 12

local KeyBox = Instance.new("TextBox", Card)
KeyBox.Size = UDim2.new(0.85,0,0,40); KeyBox.Position = UDim2.new(0.075,0,0,108)
KeyBox.BackgroundColor3 = Color3.fromRGB(16,20,28)
KeyBox.TextColor3 = Color3.new(1,1,1)
KeyBox.PlaceholderText = "Key here..."
KeyBox.PlaceholderColor3 = Color3.fromRGB(80,70,50)
KeyBox.Text = ""; KeyBox.Font = Enum.Font.GothamBold; KeyBox.TextSize = 14
KeyBox.ClearTextOnFocus = false; KeyBox.BorderSizePixel = 0
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0,8)
local kbs = Instance.new("UIStroke", KeyBox)
kbs.Color = Color3.fromRGB(255,160,0); kbs.Thickness = 1; kbs.Transparency = 0.5

local StatusLbl = Instance.new("TextLabel", Card)
StatusLbl.Size = UDim2.new(0.85,0,0,18); StatusLbl.Position = UDim2.new(0.075,0,0,155)
StatusLbl.BackgroundTransparency = 1; StatusLbl.Text = ""
StatusLbl.TextColor3 = Color3.fromRGB(220,70,70)
StatusLbl.Font = Enum.Font.Gotham; StatusLbl.TextSize = 11
StatusLbl.TextWrapped = true

local SubmitBtn = Instance.new("TextButton", Card)
SubmitBtn.Size = UDim2.new(0.85,0,0,40); SubmitBtn.Position = UDim2.new(0.075,0,0,178)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(255,160,0)
SubmitBtn.TextColor3 = Color3.fromRGB(10,10,10)
SubmitBtn.Text = "Unlock"; SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.TextSize = 14; SubmitBtn.BorderSizePixel = 0
Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0,8)

local keyPassed = false
local function shakeCard()
    local orig = Card.Position
    for i = 1,6 do
        Card.Position = orig + UDim2.new(0,(i%2==0 and 5 or -5),0,0)
        task.wait(0.04)
    end
    Card.Position = orig
end
local function checkKey()
    local entered = KeyBox.Text:lower():gsub("%s+","")
    if entered == VALID_KEY then
        keyPassed = true
        StatusLbl.TextColor3 = Color3.fromRGB(50,200,100)
        StatusLbl.Text = "✅ Loading..."
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(50,200,100)
        SubmitBtn.Text = "✅ Verified"
        task.wait(1)
        Blur:Destroy(); KeyGui:Destroy()
    else
        shakeCard()
        StatusLbl.TextColor3 = Color3.fromRGB(220,70,70)
        StatusLbl.Text = "❌ Wrong key!"
    end
end
SubmitBtn.MouseButton1Click:Connect(checkKey)
KeyBox.FocusLost:Connect(function(e) if e then checkKey() end end)
repeat task.wait(0.1) until keyPassed

-------------------------------------------------------------------------
-- MAIN HUB
-------------------------------------------------------------------------
local function new(class, props)
    local obj = Instance.new(class)
    for k,v in pairs(props) do
        if k ~= "Parent" then pcall(function() obj[k] = v end) end
    end
    if props.Parent then obj.Parent = props.Parent end
    return obj
end

local COLORS = {
    MainBG       = Color3.fromRGB(10,12,18),
    TabBG        = Color3.fromRGB(14,18,26),
    Border       = Color3.fromRGB(255,160,0),
    TextActive   = Color3.fromRGB(255,180,30),
    TextInactive = Color3.fromRGB(130,120,100),
    RowBG        = Color3.fromRGB(16,20,30),
    ToggleOff    = Color3.fromRGB(40,38,35),
    Orange       = Color3.fromRGB(255,160,0),
}

local function makeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragStart, startPos
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging=true; dragStart=i.Position; startPos=frame.Position
            i.Changed:Connect(function()
                if i.UserInputState==Enum.UserInputState.End then dragging=false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement
        or i.UserInputType==Enum.UserInputType.Touch) then
            local d=i.Position-dragStart
            frame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
        end
    end)
end

local ScreenGui = new("ScreenGui",{
    Name="ToxSon_Hub",ResetOnSpawn=false,
    IgnoreGuiInset=true,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,Parent=CoreGui,
})

local ToggleIcon = new("TextButton",{
    Size=UDim2.new(0,50,0,50),Position=UDim2.new(0.05,0,0.2,0),
    BackgroundColor3=COLORS.MainBG,Text="🏀",
    Font=Enum.Font.GothamBold,TextSize=22,Parent=ScreenGui,
})
new("UICorner",{CornerRadius=UDim.new(0,10),Parent=ToggleIcon})
new("UIStroke",{Color=COLORS.Orange,Thickness=2,Parent=ToggleIcon})

local MainFrame = new("Frame",{
    Size=UDim2.new(0,360,0,420),Position=UDim2.new(0.5,-180,0.5,-210),
    BackgroundColor3=COLORS.MainBG,BackgroundTransparency=0.05,
    ClipsDescendants=true,Visible=false,Parent=ScreenGui,
})
new("UICorner",{CornerRadius=UDim.new(0,14),Parent=MainFrame})
new("UIStroke",{Color=COLORS.Orange,Thickness=2,Parent=MainFrame})

local TopBar = new("Frame",{Size=UDim2.new(1,0,0,5),BackgroundColor3=COLORS.Orange,Parent=MainFrame})
new("UICorner",{CornerRadius=UDim.new(0,14),Parent=TopBar})

local Header = new("Frame",{Size=UDim2.new(1,0,0,50),BackgroundTransparency=1,Parent=MainFrame})
new("TextLabel",{
    Text="🏀  Tox Son Hub",TextColor3=COLORS.Orange,Font=Enum.Font.GothamBold,TextSize=18,
    Size=UDim2.new(0.7,0,1,0),Position=UDim2.new(0.04,0,0,0),
    BackgroundTransparency=1,TextXAlignment=Enum.TextXAlignment.Left,Parent=Header,
})
new("TextLabel",{
    Text="Arcade Basketball",TextColor3=Color3.fromRGB(150,120,60),Font=Enum.Font.Gotham,TextSize=11,
    Size=UDim2.new(0.38,0,1,0),Position=UDim2.new(0.6,0,0,0),
    BackgroundTransparency=1,TextXAlignment=Enum.TextXAlignment.Right,Parent=Header,
})

local TabContainer = new("Frame",{
    Size=UDim2.new(0.92,0,0,32),Position=UDim2.new(0.04,0,0.125,0),
    BackgroundColor3=COLORS.TabBG,Parent=MainFrame,
})
new("UICorner",{CornerRadius=UDim.new(0,8),Parent=TabContainer})
new("UIStroke",{Color=COLORS.Orange,Thickness=1,Transparency=0.7,Parent=TabContainer})
new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Center,Parent=TabContainer})

local PageContainer = new("Frame",{
    Size=UDim2.new(1,0,0.82,0),Position=UDim2.new(0,0,0.18,0),
    BackgroundTransparency=1,Parent=MainFrame,
})

makeDraggable(MainFrame,Header); makeDraggable(ToggleIcon)
ToggleIcon.MouseButton1Click:Connect(function() MainFrame.Visible=not MainFrame.Visible end)

local Pages,TabButtons,activeTab={},{},nil
local function createPage(name)
    local Page=new("ScrollingFrame",{
        Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Visible=false,
        ScrollBarThickness=3,ScrollBarImageColor3=COLORS.Orange,
        AutomaticCanvasSize=Enum.AutomaticSize.Y,Parent=PageContainer,
    })
    new("UIListLayout",{HorizontalAlignment=Enum.HorizontalAlignment.Center,Padding=UDim.new(0,7),Parent=Page})
    new("UIPadding",{PaddingTop=UDim.new(0,8),Parent=Page})
    Pages[name]=Page
    local TabBtn=new("TextButton",{
        Size=UDim2.new(0.32,0,1,0),BackgroundTransparency=1,
        Text=name,TextColor3=COLORS.TextInactive,Font=Enum.Font.GothamBold,TextSize=10,
        Parent=TabContainer,
    })
    TabBtn.MouseButton1Click:Connect(function()
        if activeTab==name then return end; activeTab=name
        for n,p in pairs(Pages) do p.Visible=(n==name) end
        for n,b in pairs(TabButtons) do b.TextColor3=(n==name) and COLORS.TextActive or COLORS.TextInactive end
    end)
    TabButtons[name]=TabBtn
end

for _,t in ipairs({"Shooting","Defense","Misc"}) do createPage(t) end
activeTab="Shooting"; Pages["Shooting"].Visible=true
TabButtons["Shooting"].TextColor3=COLORS.TextActive

local function addToggle(pageName,label,default,callback)
    local active=default
    local Row=new("Frame",{
        Size=UDim2.new(0.92,0,0,52),BackgroundColor3=COLORS.RowBG,
        BackgroundTransparency=0.3,Parent=Pages[pageName],
    })
    new("UICorner",{CornerRadius=UDim.new(0,10),Parent=Row})
    new("UIStroke",{Color=COLORS.Orange,Thickness=1,Transparency=0.75,Parent=Row})
    new("TextLabel",{
        Text=label,Size=UDim2.new(0.65,0,1,0),Position=UDim2.new(0.05,0,0,0),
        TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamBold,TextSize=13,
        BackgroundTransparency=1,TextXAlignment=Enum.TextXAlignment.Left,Parent=Row,
    })
    local TglBg=new("Frame",{
        Size=UDim2.new(0,44,0,22),Position=UDim2.new(1,-54,0.5,-11),
        BackgroundColor3=active and COLORS.Orange or COLORS.ToggleOff,Parent=Row,
    })
    new("UICorner",{CornerRadius=UDim.new(1,0),Parent=TglBg})
    local Circle=new("Frame",{
        Size=UDim2.new(0,18,0,18),
        Position=active and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9),
        BackgroundColor3=Color3.new(1,1,1),Parent=TglBg,
    })
    new("UICorner",{CornerRadius=UDim.new(1,0),Parent=Circle})
    local Btn=new("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",Parent=Row})
    local function setState(state)
        active=state
        local ti=TweenInfo.new(0.18,Enum.EasingStyle.Quad)
        TweenService:Create(TglBg,ti,{BackgroundColor3=active and COLORS.Orange or COLORS.ToggleOff}):Play()
        TweenService:Create(Circle,ti,{Position=active and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9)}):Play()
        pcall(callback,active)
    end
    if default then pcall(callback,true) end
    Btn.MouseButton1Click:Connect(function() setState(not active) end)
    return setState
end

local function addLabel(pageName,text)
    new("TextLabel",{
        Size=UDim2.new(0.92,0,0,22),BackgroundTransparency=1,
        Text=text,TextColor3=Color3.fromRGB(180,140,60),
        Font=Enum.Font.GothamBold,TextSize=10,
        TextXAlignment=Enum.TextXAlignment.Left,Parent=Pages[pageName],
    })
end

local function addInfo(pageName,text)
    local box=new("Frame",{
        Size=UDim2.new(0.92,0,0,36),BackgroundColor3=COLORS.RowBG,
        BackgroundTransparency=0.5,Parent=Pages[pageName],
    })
    new("UICorner",{CornerRadius=UDim.new(0,8),Parent=box})
    new("TextLabel",{
        Size=UDim2.new(1,-10,1,0),Position=UDim2.new(0,8,0,0),
        BackgroundTransparency=1,Text=text,
        TextColor3=Color3.fromRGB(150,140,110),Font=Enum.Font.Gotham,
        TextSize=10,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,Parent=box,
    })
end

-------------------------------------------------------------------------
-- CACHE SYSTEM (scan once, reuse — fixes lag)
-------------------------------------------------------------------------
local Cache = {
    ball      = nil,
    hoop      = nil,
    remotes   = {},
    lastScan  = 0,
    scanRate  = 5, -- re-scan every 5 seconds only
}

local BALL_KEYWORDS   = {"ball","basketball","bball"}
local HOOP_KEYWORDS   = {"hoop","basket","net","rim","goal","backboard"}
local SHOOT_KEYWORDS  = {"shoot","shot","release","throw","score","launch","fire"}
local GUARD_KEYWORDS  = {"steal","block","defend","guard","swipe","contest"}

local function matchesAny(name, keywords)
    name = name:lower()
    for _,k in ipairs(keywords) do
        if name:find(k) then return true end
    end
    return false
end

local function scanWorkspace()
    if tick() - Cache.lastScan < Cache.scanRate then return end
    Cache.lastScan = tick()
    Cache.ball = nil
    Cache.hoop = nil
    Cache.remotes = {shoot={}, guard={}}

    -- Scan workspace for ball and hoop
    for _,obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            if not Cache.ball and matchesAny(obj.Name, BALL_KEYWORDS) then
                Cache.ball = obj
            end
            if not Cache.hoop and matchesAny(obj.Name, HOOP_KEYWORDS) then
                Cache.hoop = obj
            end
        end
    end

    -- Scan ReplicatedStorage for remotes ONCE
    for _,obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            if matchesAny(obj.Name, SHOOT_KEYWORDS) then
                table.insert(Cache.remotes.shoot, obj)
            elseif matchesAny(obj.Name, GUARD_KEYWORDS) then
                table.insert(Cache.remotes.guard, obj)
            end
        end
    end
end

-- Initial scan
task.spawn(function()
    task.wait(2) -- wait for game to load
    Cache.lastScan = 0
    scanWorkspace()
end)

-- Re-scan when workspace changes (new ball spawns etc)
Workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("BasePart") and matchesAny(obj.Name, BALL_KEYWORDS) then
        Cache.ball = obj
    end
    if obj:IsA("BasePart") and matchesAny(obj.Name, HOOP_KEYWORDS) then
        Cache.hoop = obj
    end
end)

local function getBall() return Cache.ball end
local function getHoop() return Cache.hoop end

local function getLocalHRP()
    local c = lp.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function getLocalHum()
    local c = lp.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

-- Find enemy closest to ball
local function getEnemyWithBall()
    local ball = getBall()
    if not ball then return nil,nil end
    local nearest,nearHRP,nearDist=nil,nil,math.huge
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=lp and p.Character then
            local hrp=p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d=(hrp.Position-ball.Position).Magnitude
                if d<nearDist then nearest=p; nearHRP=hrp; nearDist=d end
            end
        end
    end
    return nearest,nearHRP
end

-------------------------------------------------------------------------
-- MODULE: AUTO GREEN
-- Uses Heartbeat at 0.3s intervals (not every frame) to avoid lag
-- Fires shoot remotes with perfect timing when you have the ball
-------------------------------------------------------------------------
local AutoGreen = {
    Enabled  = false,
    Conn     = nil,
    lastShot = 0,
    interval = 0.35, -- fire every 0.35s when u have ball (not every frame)
}

-- On-screen indicator
local GreenInd = new("Frame",{
    Size=UDim2.new(0,170,0,34),Position=UDim2.new(0.5,-85,0.87,0),
    BackgroundColor3=Color3.fromRGB(8,14,8),BackgroundTransparency=0.1,
    Visible=false,Parent=ScreenGui,
})
new("UICorner",{CornerRadius=UDim.new(0,8),Parent=GreenInd})
new("UIStroke",{Color=Color3.fromRGB(50,220,80),Thickness=1.5,Parent=GreenInd})
local GreenLbl=new("TextLabel",{
    Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
    Text="🟢  AUTO GREEN: ON",TextColor3=Color3.fromRGB(50,220,80),
    Font=Enum.Font.GothamBold,TextSize=12,Parent=GreenInd,
})

local function enableAutoGreen()
    if AutoGreen.Conn then return end
    AutoGreen.Enabled = true
    GreenInd.Visible  = true

    -- Force a cache scan first
    Cache.lastScan = 0
    scanWorkspace()

    AutoGreen.Conn = RunService.Heartbeat:Connect(function()
        if not AutoGreen.Enabled then return end
        if tick()-AutoGreen.lastShot < AutoGreen.interval then return end

        local char = lp.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local ball = getBall()
        local hoop = getHoop()

        -- Only act if ball is near us (we have it)
        if ball and (ball.Position - hrp.Position).Magnitude < 10 then
            AutoGreen.lastShot = tick()

            -- Fire all cached shoot remotes
            for _,remote in ipairs(Cache.remotes.shoot) do
                pcall(function()
                    if remote:IsA("RemoteEvent") then
                        if hoop then
                            remote:FireServer(hoop.Position, true, 1.0)
                        else
                            remote:FireServer(true, 1.0)
                        end
                    elseif remote:IsA("RemoteFunction") then
                        if hoop then
                            pcall(remote.InvokeServer, remote, hoop.Position, true, 1.0)
                        else
                            pcall(remote.InvokeServer, remote, true, 1.0)
                        end
                    end
                end)
            end

            -- Also activate any shoot tools
            pcall(function()
                for _,tool in pairs(char:GetChildren()) do
                    if tool:IsA("Tool") and matchesAny(tool.Name, SHOOT_KEYWORDS) then
                        tool:Activate()
                    end
                end
            end)

            -- If no remotes found yet, rescan
            if #Cache.remotes.shoot == 0 then
                Cache.lastScan = 0
                scanWorkspace()
            end
        end
    end)
end

local function disableAutoGreen()
    AutoGreen.Enabled = false
    GreenInd.Visible  = false
    if AutoGreen.Conn then AutoGreen.Conn:Disconnect() AutoGreen.Conn=nil end
end

-------------------------------------------------------------------------
-- MODULE: AUTO GUARD
-- Runs at 0.2s intervals (not every frame) to reduce lag
-- Positions between ball handler and hoop, jumps to contest
-------------------------------------------------------------------------
local AutoGuard = {
    Enabled  = false,
    Conn     = nil,
    lastMove = 0,
    lastJump = 0,
    interval = 0.2,  -- update position every 0.2s only
}

local GuardInd = new("Frame",{
    Size=UDim2.new(0,170,0,34),Position=UDim2.new(0.5,-85,0.81,0),
    BackgroundColor3=Color3.fromRGB(8,10,20),BackgroundTransparency=0.1,
    Visible=false,Parent=ScreenGui,
})
new("UICorner",{CornerRadius=UDim.new(0,8),Parent=GuardInd})
new("UIStroke",{Color=Color3.fromRGB(80,180,255),Thickness=1.5,Parent=GuardInd})
local GuardLbl=new("TextLabel",{
    Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
    Text="🛡️  AUTO GUARD: ON",TextColor3=Color3.fromRGB(80,180,255),
    Font=Enum.Font.GothamBold,TextSize=12,Parent=GuardInd,
})

local function enableAutoGuard()
    if AutoGuard.Conn then return end
    AutoGuard.Enabled = true
    GuardInd.Visible  = true

    Cache.lastScan = 0
    scanWorkspace()

    AutoGuard.Conn = RunService.Heartbeat:Connect(function()
        if not AutoGuard.Enabled then return end
        if tick()-AutoGuard.lastMove < AutoGuard.interval then return end
        AutoGuard.lastMove = tick()

        local char = lp.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end

        local _,enemyHRP = getEnemyWithBall()
        local hoop = getHoop()

        if enemyHRP then
            local ePos = enemyHRP.Position
            local mPos = hrp.Position

            local guardPos
            if hoop then
                -- Stand between enemy and hoop
                local toHoop = (hoop.Position - ePos)
                if toHoop.Magnitude > 0 then
                    local offset = toHoop.Unit * 3.5
                    guardPos = Vector3.new(ePos.X + offset.X, mPos.Y, ePos.Z + offset.Z)
                end
            end

            -- Fallback: stand in front of enemy
            if not guardPos then
                local myDir = (ePos - mPos)
                if myDir.Magnitude > 0 then
                    guardPos = Vector3.new(ePos.X, mPos.Y, ePos.Z) + myDir.Unit * 3
                end
            end

            if guardPos then
                local dist = (guardPos - mPos).Magnitude
                if dist > 1.5 then
                    hum:MoveTo(guardPos)
                end
            end

            -- Jump to contest shot
            local distToEnemy = (ePos - mPos).Magnitude
            local distToHoop  = hoop and (hoop.Position - ePos).Magnitude or math.huge
            if distToEnemy <= 6 and distToHoop <= 25 then
                if tick()-AutoGuard.lastJump > 1.0 then
                    AutoGuard.lastJump = tick()
                    hrp.AssemblyLinearVelocity = Vector3.new(
                        hrp.AssemblyLinearVelocity.X,
                        52,
                        hrp.AssemblyLinearVelocity.Z
                    )
                end
            end

        else
            -- No enemy with ball found — rescan if needed
            if tick()-Cache.lastScan > Cache.scanRate then
                Cache.lastScan = 0
                scanWorkspace()
            end
        end
    end)
end

local function disableAutoGuard()
    AutoGuard.Enabled = false
    GuardInd.Visible  = false
    if AutoGuard.Conn then AutoGuard.Conn:Disconnect() AutoGuard.Conn=nil end
    local hum = getLocalHum()
    local hrp = getLocalHRP()
    if hum and hrp then hum:MoveTo(hrp.Position) end
end

-------------------------------------------------------------------------
-- MODULE: AUTO STEAL (lightweight)
-------------------------------------------------------------------------
local AutoSteal={Enabled=false,lastSteal=0,Conn=nil}

local function enableAutoSteal()
    if AutoSteal.Conn then return end
    AutoSteal.Enabled=true
    AutoSteal.Conn=RunService.Heartbeat:Connect(function()
        if not AutoSteal.Enabled then return end
        if tick()-AutoSteal.lastSteal < 0.25 then return end
        AutoSteal.lastSteal=tick()
        local myHRP=getLocalHRP()
        if not myHRP then return end
        local _,enemyHRP=getEnemyWithBall()
        if not enemyHRP then return end
        if (enemyHRP.Position-myHRP.Position).Magnitude > 7 then return end
        -- Fire cached guard/steal remotes
        for _,remote in ipairs(Cache.remotes.guard) do
            pcall(function()
                if remote:IsA("RemoteEvent") then
                    remote:FireServer(enemyHRP.Parent)
                end
            end)
        end
        pcall(function()
            local char=lp.Character
            if char then
                for _,tool in pairs(char:GetChildren()) do
                    if tool:IsA("Tool") then tool:Activate() end
                end
            end
        end)
    end)
end

local function disableAutoSteal()
    AutoSteal.Enabled=false
    if AutoSteal.Conn then AutoSteal.Conn:Disconnect() AutoSteal.Conn=nil end
end

-------------------------------------------------------------------------
-- MODULE: SPEED HACK (lightweight)
-------------------------------------------------------------------------
local SpeedHack={Enabled=false,Speed=50,Conn=nil,CharConn=nil,hrp=nil,hum=nil}
local function setupSpeedChar(char)
    SpeedHack.hrp=char:WaitForChild("HumanoidRootPart")
    SpeedHack.hum=char:WaitForChild("Humanoid")
end
local function enableSpeedHack()
    if SpeedHack.Conn then return end
    SpeedHack.Enabled=true
    if lp.Character then setupSpeedChar(lp.Character) end
    if SpeedHack.CharConn then SpeedHack.CharConn:Disconnect() end
    SpeedHack.CharConn=lp.CharacterAdded:Connect(setupSpeedChar)
    SpeedHack.Conn=RunService.Heartbeat:Connect(function()
        if not SpeedHack.Enabled then return end
        local hrp=SpeedHack.hrp; local hum=SpeedHack.hum
        if not hrp or not hum then return end
        local dir=hum.MoveDirection
        if dir.Magnitude>0.1 then
            hrp.AssemblyLinearVelocity=Vector3.new(dir.X*SpeedHack.Speed,hrp.AssemblyLinearVelocity.Y,dir.Z*SpeedHack.Speed)
        end
    end)
end
local function disableSpeedHack()
    SpeedHack.Enabled=false
    if SpeedHack.Conn then SpeedHack.Conn:Disconnect() SpeedHack.Conn=nil end
    if SpeedHack.CharConn then SpeedHack.CharConn:Disconnect() SpeedHack.CharConn=nil end
end

-------------------------------------------------------------------------
-- MODULE: INF JUMP
-------------------------------------------------------------------------
local InfJump={Enabled=false,lastJump=0,Conn=nil}
local function enableInfJump()
    if InfJump.Conn then return end
    InfJump.Enabled=true
    InfJump.Conn=UserInputService.JumpRequest:Connect(function()
        local char=lp.Character
        local hrp=char and char:FindFirstChild("HumanoidRootPart")
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        if hrp and hum and hum.FloorMaterial==Enum.Material.Air then
            local now=tick()
            if now-InfJump.lastJump>=0.15 then
                InfJump.lastJump=now
                hrp.AssemblyLinearVelocity=Vector3.new(hrp.AssemblyLinearVelocity.X,55,hrp.AssemblyLinearVelocity.Z)
            end
        end
    end)
end
local function disableInfJump()
    InfJump.Enabled=false
    if InfJump.Conn then InfJump.Conn:Disconnect() InfJump.Conn=nil end
end

-------------------------------------------------------------------------
-- BUILD UI
-------------------------------------------------------------------------

-- SHOOTING TAB
addLabel("Shooting","  OFFENSE")
addToggle("Shooting","Auto Green",  false,function(v) if v then enableAutoGreen()  else disableAutoGreen()  end end)
addInfo("Shooting","  🟢 Detects ball near you → fires shoot remote at perfect green timing.")
addToggle("Shooting","Speed Hack",  false,function(v) if v then enableSpeedHack()  else disableSpeedHack()  end end)
addToggle("Shooting","Inf Jump",    false,function(v) if v then enableInfJump()    else disableInfJump()    end end)

-- DEFENSE TAB
addLabel("Defense","  DEFENSE")
addToggle("Defense","Auto Guard",   false,function(v) if v then enableAutoGuard()  else disableAutoGuard()  end end)
addInfo("Defense","  🛡️ Moves between ball handler & hoop. Jumps to contest shots.")
addToggle("Defense","Auto Steal",   false,function(v) if v then enableAutoSteal()  else disableAutoSteal()  end end)
addInfo("Defense","  🤚 Auto fires steal remotes when near the ball handler.")

-- MISC TAB
addLabel("Misc","  SETTINGS")
addToggle("Misc","Fullbright",      false,function(v)
    if v then
        _G.FBOrig={Ambient=Lighting.Ambient,OutdoorAmbient=Lighting.OutdoorAmbient,Brightness=Lighting.Brightness,GlobalShadows=Lighting.GlobalShadows}
        Lighting.Ambient=Color3.new(1,1,1); Lighting.OutdoorAmbient=Color3.new(1,1,1)
        Lighting.Brightness=2; Lighting.GlobalShadows=false
    else
        if _G.FBOrig then for k,val in pairs(_G.FBOrig) do pcall(function() Lighting[k]=val end) end end
    end
end)
addToggle("Misc","Optimizer",       false,function(v)
    if v then
        Workspace.Terrain.WaterWaveSize=0; Lighting.GlobalShadows=false
        for _,obj in pairs(game:GetDescendants()) do
            pcall(function()
                if obj:IsA("BasePart") then obj.Material=Enum.Material.Plastic
                elseif obj:IsA("Decal") then obj.Transparency=1 end
            end)
        end
    end
end)

local CreditsBox=new("Frame",{
    Size=UDim2.new(0.92,0,0,44),BackgroundColor3=COLORS.RowBG,
    BackgroundTransparency=0.3,Parent=Pages["Misc"],
})
new("UICorner",{CornerRadius=UDim.new(0,10),Parent=CreditsBox})
new("UIStroke",{Color=COLORS.Orange,Thickness=1,Transparency=0.6,Parent=CreditsBox})
new("TextLabel",{
    Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
    Text="🏀  Tox Son Hub  —  Made for Tox Son",
    TextColor3=Color3.fromRGB(200,160,60),Font=Enum.Font.GothamBold,TextSize=12,
    Parent=CreditsBox,
})
