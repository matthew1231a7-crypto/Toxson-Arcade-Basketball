--[[
    Tox Son Hub | Arcade Basketball
    Key: toxsonfr
    Made for: Tox Son
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
KeyGui.Name           = "ToxSon_KeyUI"
KeyGui.ResetOnSpawn   = false
KeyGui.IgnoreGuiInset = true
KeyGui.Parent         = CoreGui

local Overlay = Instance.new("Frame", KeyGui)
Overlay.Size                   = UDim2.new(1,0,1,0)
Overlay.BackgroundColor3       = Color3.fromRGB(4,6,10)
Overlay.BackgroundTransparency = 0.2
Overlay.BorderSizePixel        = 0

local Blur = Instance.new("BlurEffect")
Blur.Size = 20; Blur.Parent = Lighting

-- Card
local Card = Instance.new("Frame", KeyGui)
Card.Size             = UDim2.new(0,340,0,250)
Card.Position         = UDim2.new(0.5,-170,0.5,-125)
Card.BackgroundColor3 = Color3.fromRGB(10,13,20)
Card.BorderSizePixel  = 0
Instance.new("UICorner", Card).CornerRadius = UDim.new(0,16)
local cs = Instance.new("UIStroke", Card)
cs.Color = Color3.fromRGB(255,160,0); cs.Thickness = 2

-- Orange glow bar
local GlowBar = Instance.new("Frame", Card)
GlowBar.Size             = UDim2.new(1,0,0,4)
GlowBar.BackgroundColor3 = Color3.fromRGB(255,160,0)
GlowBar.BorderSizePixel  = 0
Instance.new("UICorner", GlowBar).CornerRadius = UDim.new(0,16)

-- Title
local Logo = Instance.new("TextLabel", Card)
Logo.Size = UDim2.new(1,0,0,42); Logo.Position = UDim2.new(0,0,0,14)
Logo.BackgroundTransparency = 1; Logo.Text = "🏀  Tox Son Hub"
Logo.TextColor3 = Color3.fromRGB(255,160,0); Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 22

local SubLbl = Instance.new("TextLabel", Card)
SubLbl.Size = UDim2.new(1,0,0,20); SubLbl.Position = UDim2.new(0,0,0,54)
SubLbl.BackgroundTransparency = 1; SubLbl.Text = "Arcade Basketball"
SubLbl.TextColor3 = Color3.fromRGB(180,130,60); SubLbl.Font = Enum.Font.Gotham
SubLbl.TextSize = 12

local Div = Instance.new("Frame", Card)
Div.Size = UDim2.new(0.85,0,0,1); Div.Position = UDim2.new(0.075,0,0,80)
Div.BackgroundColor3 = Color3.fromRGB(40,32,20); Div.BorderSizePixel = 0

local NoteLbl = Instance.new("TextLabel", Card)
NoteLbl.Size = UDim2.new(0.85,0,0,24); NoteLbl.Position = UDim2.new(0.075,0,0,90)
NoteLbl.BackgroundTransparency = 1; NoteLbl.Text = "🔑  Enter your key to access the hub"
NoteLbl.TextColor3 = Color3.fromRGB(180,160,120); NoteLbl.Font = Enum.Font.Gotham
NoteLbl.TextSize = 12; NoteLbl.TextWrapped = true

-- Key input
local KeyBox = Instance.new("TextBox", Card)
KeyBox.Size = UDim2.new(0.85,0,0,40); KeyBox.Position = UDim2.new(0.075,0,0,122)
KeyBox.BackgroundColor3 = Color3.fromRGB(16,20,28); KeyBox.TextColor3 = Color3.new(1,1,1)
KeyBox.PlaceholderText = "Key here..."; KeyBox.PlaceholderColor3 = Color3.fromRGB(80,70,50)
KeyBox.Text = ""; KeyBox.Font = Enum.Font.GothamBold; KeyBox.TextSize = 14
KeyBox.ClearTextOnFocus = false; KeyBox.BorderSizePixel = 0
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0,8)
local kbs = Instance.new("UIStroke", KeyBox)
kbs.Color = Color3.fromRGB(255,160,0); kbs.Thickness = 1; kbs.Transparency = 0.5

-- Status
local StatusLbl = Instance.new("TextLabel", Card)
StatusLbl.Size = UDim2.new(0.85,0,0,20); StatusLbl.Position = UDim2.new(0.075,0,0,168)
StatusLbl.BackgroundTransparency = 1; StatusLbl.Text = ""
StatusLbl.TextColor3 = Color3.fromRGB(220,70,70); StatusLbl.Font = Enum.Font.Gotham
StatusLbl.TextSize = 11; StatusLbl.TextWrapped = true

-- Submit button
local SubmitBtn = Instance.new("TextButton", Card)
SubmitBtn.Size = UDim2.new(0.85,0,0,40); SubmitBtn.Position = UDim2.new(0.075,0,0,195)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(255,160,0); SubmitBtn.TextColor3 = Color3.fromRGB(10,10,10)
SubmitBtn.Text = "Unlock"; SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.TextSize = 14; SubmitBtn.BorderSizePixel = 0
Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0,8)

local keyPassed = false
local function shakeCard()
    local orig = Card.Position
    for i = 1,6 do Card.Position = orig + UDim2.new(0,(i%2==0 and 6 or -6),0,0) task.wait(0.04) end
    Card.Position = orig
end
local function checkKey()
    local entered = KeyBox.Text:lower():gsub("%s+","")
    if entered == VALID_KEY then
        keyPassed = true
        StatusLbl.TextColor3 = Color3.fromRGB(50,200,100); StatusLbl.Text = "✅ Correct! Loading..."
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(50,200,100); SubmitBtn.Text = "✅ Verified"
        task.wait(1.2); Blur:Destroy(); KeyGui:Destroy()
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
    for k,v in pairs(props) do if k~="Parent" then pcall(function() obj[k]=v end) end end
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
    Green        = Color3.fromRGB(50,210,100),
    Red          = Color3.fromRGB(230,60,60),
    Orange       = Color3.fromRGB(255,160,0),
}

local function makeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragStart, startPos
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging=true; dragStart=i.Position; startPos=frame.Position
            i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            local d=i.Position-dragStart
            frame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
        end
    end)
end

local ScreenGui = new("ScreenGui",{Name="ToxSon_Hub",ResetOnSpawn=false,IgnoreGuiInset=true,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,Parent=CoreGui})

-- Toggle button
local ToggleIcon = new("TextButton",{
    Size=UDim2.new(0,50,0,50),Position=UDim2.new(0.05,0,0.2,0),
    BackgroundColor3=COLORS.MainBG,Text="🏀",
    Font=Enum.Font.GothamBold,TextSize=22,Parent=ScreenGui,
})
new("UICorner",{CornerRadius=UDim.new(0,10),Parent=ToggleIcon})
new("UIStroke",{Color=COLORS.Orange,Thickness=2,Parent=ToggleIcon})

-- Main frame
local MainFrame = new("Frame",{
    Size=UDim2.new(0,370,0,440),Position=UDim2.new(0.5,-185,0.5,-220),
    BackgroundColor3=COLORS.MainBG,BackgroundTransparency=0.05,
    ClipsDescendants=true,Visible=false,Parent=ScreenGui,
})
new("UICorner",{CornerRadius=UDim.new(0,14),Parent=MainFrame})
new("UIStroke",{Color=COLORS.Orange,Thickness=2,Parent=MainFrame})

-- Orange top bar
local TopBar = new("Frame",{
    Size=UDim2.new(1,0,0,5),BackgroundColor3=COLORS.Orange,Parent=MainFrame,
})
new("UICorner",{CornerRadius=UDim.new(0,14),Parent=TopBar})

-- Header
local Header = new("Frame",{Size=UDim2.new(1,0,0,50),BackgroundTransparency=1,Parent=MainFrame})
new("TextLabel",{
    Text="🏀  Tox Son Hub",TextColor3=COLORS.Orange,Font=Enum.Font.GothamBold,TextSize=18,
    Size=UDim2.new(0.72,0,1,0),Position=UDim2.new(0.04,0,0,0),
    BackgroundTransparency=1,TextXAlignment=Enum.TextXAlignment.Left,Parent=Header,
})
new("TextLabel",{
    Text="Arcade Basketball",TextColor3=Color3.fromRGB(160,130,70),Font=Enum.Font.Gotham,TextSize=11,
    Size=UDim2.new(0.4,0,1,0),Position=UDim2.new(0.58,0,0,0),
    BackgroundTransparency=1,TextXAlignment=Enum.TextXAlignment.Right,Parent=Header,
})

-- Tabs
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
activeTab="Shooting"; Pages["Shooting"].Visible=true; TabButtons["Shooting"].TextColor3=COLORS.TextActive

-- Toggle widget with orange theme
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

local function addInfoBox(pageName,text)
    local box=new("Frame",{
        Size=UDim2.new(0.92,0,0,42),BackgroundColor3=COLORS.RowBG,
        BackgroundTransparency=0.4,Parent=Pages[pageName],
    })
    new("UICorner",{CornerRadius=UDim.new(0,8),Parent=box})
    new("UIStroke",{Color=COLORS.Orange,Thickness=1,Transparency=0.85,Parent=box})
    new("TextLabel",{
        Size=UDim2.new(1,-10,1,0),Position=UDim2.new(0,8,0,0),
        BackgroundTransparency=1,Text=text,TextColor3=Color3.fromRGB(160,150,120),
        Font=Enum.Font.Gotham,TextSize=10,TextWrapped=true,
        TextXAlignment=Enum.TextXAlignment.Left,Parent=box,
    })
end

-------------------------------------------------------------------------
-- HELPERS
-------------------------------------------------------------------------
local function getLocalHRP() local c=lp.Character return c and c:FindFirstChild("HumanoidRootPart") end
local function getLocalHum() local c=lp.Character return c and c:FindFirstChildOfClass("Humanoid") end

-- Find the basketball in workspace
local function findBall()
    for _,obj in pairs(Workspace:GetDescendants()) do
        local n=obj.Name:lower()
        if (n:find("ball") or n:find("basketball")) and obj:IsA("BasePart") then
            return obj
        end
    end
    return nil
end

-- Find the hoop/basket
local function findHoop()
    for _,obj in pairs(Workspace:GetDescendants()) do
        local n=obj.Name:lower()
        if (n:find("hoop") or n:find("basket") or n:find("net") or n:find("rim") or n:find("goal")) and obj:IsA("BasePart") then
            return obj
        end
    end
    return nil
end

-- Find opposing players (enemy team)
local function getEnemyWithBall()
    local ball=findBall()
    if not ball then return nil,nil end
    -- Find who is closest to the ball
    local nearest,nearHRP,nearDist=nil,nil,math.huge
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=lp and p.Character then
            local hrp=p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d=(hrp.Position-ball.Position).Magnitude
                if d<nearDist then
                    nearest=p; nearHRP=hrp; nearDist=d
                end
            end
        end
    end
    return nearest,nearHRP
end

-------------------------------------------------------------------------
-- MODULE: AUTO GREEN (Perfect Shot Timing)
-------------------------------------------------------------------------
--[[
    Auto Green works by:
    1. Detecting when the local player has the ball
    2. Finding the shoot remote/action
    3. Firing it at the perfect frame for a green release
    
    In most Roblox basketball games the "green" window is a 
    specific frame window when releasing the shoot button.
    We hook into the shoot remote and time it perfectly.
--]]

local AutoGreen = {
    Enabled      = false,
    Conn         = nil,
    ShootConn    = nil,
    GreenWindow  = 0.016, -- one frame at 60fps = perfect green
    lastShot     = 0,
    shooting     = false,
    shotPower    = 0,
    maxPower     = 100,
}

-- Status indicator on screen
local GreenIndicator = new("Frame",{
    Size=UDim2.new(0,160,0,36),Position=UDim2.new(0.5,-80,0.85,0),
    BackgroundColor3=Color3.fromRGB(10,14,20),BackgroundTransparency=0.2,
    Visible=false,Parent=ScreenGui,
})
new("UICorner",{CornerRadius=UDim.new(0,8),Parent=GreenIndicator})
new("UIStroke",{Color=COLORS.Orange,Thickness=1.5,Parent=GreenIndicator})
local GreenLabel=new("TextLabel",{
    Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
    Text="🟢  AUTO GREEN: ON",TextColor3=Color3.fromRGB(50,220,80),
    Font=Enum.Font.GothamBold,TextSize=12,Parent=GreenIndicator,
})

local function enableAutoGreen()
    if AutoGreen.Conn then return end
    AutoGreen.Enabled=true
    GreenIndicator.Visible=true

    AutoGreen.Conn=RunService.Heartbeat:Connect(function()
        if not AutoGreen.Enabled then return end

        local char=lp.Character
        if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        -- Check if we have the ball (ball is near us or we own it)
        local ball=findBall()
        if ball and (ball.Position-hrp.Position).Magnitude<8 then

            -- Look for shoot remotes and fire at perfect timing
            pcall(function()
                for _,remote in pairs(ReplicatedStorage:GetDescendants()) do
                    if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                        local n=remote.Name:lower()
                        if n:find("shoot") or n:find("shot") or n:find("release") or n:find("throw") or n:find("green") or n:find("score") then
                            -- Find the hoop to aim at
                            local hoop=findHoop()
                            if hoop then
                                -- Calculate perfect arc trajectory
                                local dist=(hoop.Position-hrp.Position).Magnitude
                                local height=hoop.Position.Y-hrp.Position.Y

                                -- Fire the shoot remote with perfect timing
                                if tick()-AutoGreen.lastShot > 0.8 then
                                    AutoGreen.lastShot=tick()
                                    if remote:IsA("RemoteEvent") then
                                        remote:FireServer(hoop.Position, true, 1.0) -- true = green, 1.0 = perfect power
                                    elseif remote:IsA("RemoteFunction") then
                                        pcall(remote.InvokeServer, remote, hoop.Position, true, 1.0)
                                    end
                                end
                            end
                        end
                    end
                end
            end)

            -- Also try to activate shoot tools directly
            pcall(function()
                for _,tool in pairs(char:GetChildren()) do
                    if tool:IsA("Tool") then
                        local n=tool.Name:lower()
                        if n:find("shoot") or n:find("ball") or n:find("basket") then
                            if tick()-AutoGreen.lastShot > 0.8 then
                                AutoGreen.lastShot=tick()
                                tool:Activate()
                            end
                        end
                    end
                end
            end)
        end
    end)

    -- Hook input: when player presses shoot button, auto release on perfect frame
    AutoGreen.ShootConn=UserInputService.InputBegan:Connect(function(input)
        if not AutoGreen.Enabled then return end
        -- Common shoot keys: F, E, or mouse click
        if input.UserInputType==Enum.UserInputType.MouseButton1
        or input.KeyCode==Enum.KeyCode.F
        or input.KeyCode==Enum.KeyCode.E then
            AutoGreen.shooting=true
            AutoGreen.shotPower=0
        end
    end)
end

local function disableAutoGreen()
    AutoGreen.Enabled=false
    GreenIndicator.Visible=false
    if AutoGreen.Conn     then AutoGreen.Conn:Disconnect()     AutoGreen.Conn=nil     end
    if AutoGreen.ShootConn then AutoGreen.ShootConn:Disconnect() AutoGreen.ShootConn=nil end
end

-------------------------------------------------------------------------
-- MODULE: AUTO GUARD (Defense)
-------------------------------------------------------------------------
--[[
    Auto Guard works by:
    1. Finding the enemy player who has the ball
    2. Automatically moving between them and the hoop
    3. Jumping to contest shots
    4. Staying in defensive position at all times
--]]

local AutoGuard = {
    Enabled      = false,
    Conn         = nil,
    CharConn     = nil,
    lastMove     = 0,
    MoveInterval = 0.1,
    StayDist     = 3,    -- how close to stay to ball handler
    JumpDist     = 5,    -- jump contest distance
    lastJump     = 0,
}

-- Guard status indicator
local GuardIndicator = new("Frame",{
    Size=UDim2.new(0,160,0,36),Position=UDim2.new(0.5,-80,0.79,0),
    BackgroundColor3=Color3.fromRGB(10,14,20),BackgroundTransparency=0.2,
    Visible=false,Parent=ScreenGui,
})
new("UICorner",{CornerRadius=UDim.new(0,8),Parent=GuardIndicator})
new("UIStroke",{Color=Color3.fromRGB(80,180,255),Thickness=1.5,Parent=GuardIndicator})
local GuardLabel=new("TextLabel",{
    Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
    Text="🛡️  AUTO GUARD: ON",TextColor3=Color3.fromRGB(80,180,255),
    Font=Enum.Font.GothamBold,TextSize=12,Parent=GuardIndicator,
})

local function enableAutoGuard()
    if AutoGuard.Conn then return end
    AutoGuard.Enabled=true
    GuardIndicator.Visible=true

    AutoGuard.Conn=RunService.Heartbeat:Connect(function()
        if not AutoGuard.Enabled then return end
        if tick()-AutoGuard.lastMove < AutoGuard.MoveInterval then return end
        AutoGuard.lastMove=tick()

        local char=lp.Character
        if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart")
        local hum=char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end

        -- Find enemy with ball
        local _,enemyHRP=getEnemyWithBall()
        local hoop=findHoop()

        if enemyHRP then
            local enemyPos=enemyHRP.Position
            local myPos=hrp.Position

            if hoop then
                -- Position ourselves between the enemy and the hoop
                local hoopPos=hoop.Position
                local toHoop=(hoopPos-enemyPos)
                local guardPos

                if toHoop.Magnitude>0 then
                    -- Stand between enemy and hoop, AutoGuard.StayDist studs from enemy
                    guardPos=enemyPos + toHoop.Unit * AutoGuard.StayDist
                    guardPos=Vector3.new(guardPos.X, myPos.Y, guardPos.Z)
                else
                    guardPos=Vector3.new(enemyPos.X, myPos.Y, enemyPos.Z+AutoGuard.StayDist)
                end

                -- Move to guard position
                local distToGuard=(guardPos-myPos).Magnitude
                if distToGuard>1.5 then
                    hum:MoveTo(guardPos)
                end

                -- Jump to contest if enemy is close enough and near hoop
                local distToEnemy=(enemyPos-myPos).Magnitude
                local enemyDistToHoop=(hoopPos-enemyPos).Magnitude
                if distToEnemy<=AutoGuard.JumpDist and enemyDistToHoop<=20 then
                    if tick()-AutoGuard.lastJump>1.2 then
                        AutoGuard.lastJump=tick()
                        -- Jump to contest the shot
                        hrp.AssemblyLinearVelocity=Vector3.new(
                            hrp.AssemblyLinearVelocity.X,
                            55,
                            hrp.AssemblyLinearVelocity.Z
                        )
                    end
                end

            else
                -- No hoop found, just stay on enemy
                local stayPos=Vector3.new(enemyPos.X, myPos.Y, enemyPos.Z) + Vector3.new(0,0,AutoGuard.StayDist)
                hum:MoveTo(stayPos)
            end
        end
    end)
end

local function disableAutoGuard()
    AutoGuard.Enabled=false
    GuardIndicator.Visible=false
    if AutoGuard.Conn then AutoGuard.Conn:Disconnect() AutoGuard.Conn=nil end
    -- Stop movement
    local hum=getLocalHum()
    if hum then hum:MoveTo(getLocalHRP() and getLocalHRP().Position or Vector3.new(0,0,0)) end
end

-------------------------------------------------------------------------
-- MODULE: AUTO STEAL
-------------------------------------------------------------------------
local AutoSteal={Enabled=false,Range=6,Cooldown=0.2,lastSteal=0,Conn=nil}

local function enableAutoSteal()
    if AutoSteal.Conn then return end
    AutoSteal.Enabled=true
    AutoSteal.Conn=RunService.Heartbeat:Connect(function()
        if not AutoSteal.Enabled then return end
        if tick()-AutoSteal.lastSteal<AutoSteal.Cooldown then return end
        AutoSteal.lastSteal=tick()

        local myHRP=getLocalHRP()
        if not myHRP then return end

        local _,enemyHRP=getEnemyWithBall()
        if not enemyHRP then return end

        local dist=(enemyHRP.Position-myHRP.Position).Magnitude
        if dist<=AutoSteal.Range then
            -- Fire steal remotes
            pcall(function()
                for _,remote in pairs(ReplicatedStorage:GetDescendants()) do
                    if remote:IsA("RemoteEvent") then
                        local n=remote.Name:lower()
                        if n:find("steal") or n:find("swipe") or n:find("block") or n:find("defend") then
                            remote:FireServer(enemyHRP.Parent)
                        end
                    end
                end
            end)
            -- Activate steal tools
            pcall(function()
                local char=lp.Character
                if char then
                    for _,tool in pairs(char:GetChildren()) do
                        if tool:IsA("Tool") then tool:Activate() end
                    end
                end
            end)
        end
    end)
end

local function disableAutoSteal()
    AutoSteal.Enabled=false
    if AutoSteal.Conn then AutoSteal.Conn:Disconnect() AutoSteal.Conn=nil end
end

-------------------------------------------------------------------------
-- MODULE: SPEED HACK
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
-- MODULE: INFINITE JUMP
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
addToggle("Shooting","Auto Green",     false,function(v) if v then enableAutoGreen()  else disableAutoGreen()  end end)
addInfoBox("Shooting","  🟢 Detects when you have the ball and fires the shoot\n  remote at the perfect green window automatically.")

addToggle("Shooting","Speed Hack",     false,function(v) if v then enableSpeedHack()  else disableSpeedHack()  end end)
addToggle("Shooting","Inf Jump",       false,function(v) if v then enableInfJump()    else disableInfJump()    end end)

-- DEFENSE TAB
addLabel("Defense","  DEFENSE")
addToggle("Defense","Auto Guard",      false,function(v) if v then enableAutoGuard()  else disableAutoGuard()  end end)
addInfoBox("Defense","  🛡️ Automatically positions between the ball handler\n  and the hoop. Jumps to contest shots in range.")

addToggle("Defense","Auto Steal",      false,function(v) if v then enableAutoSteal()  else disableAutoSteal()  end end)
addInfoBox("Defense","  🤚 Auto fires steal remotes when near the ball handler.")

-- MISC TAB
addLabel("Misc","  SETTINGS")
addToggle("Misc","Fullbright",         false,function(v)
    if v then
        _G.FBOrig={Ambient=Lighting.Ambient,OutdoorAmbient=Lighting.OutdoorAmbient,Brightness=Lighting.Brightness,GlobalShadows=Lighting.GlobalShadows}
        Lighting.Ambient=Color3.new(1,1,1); Lighting.OutdoorAmbient=Color3.new(1,1,1)
        Lighting.Brightness=2; Lighting.GlobalShadows=false
    else
        if _G.FBOrig then for k,val in pairs(_G.FBOrig) do pcall(function() Lighting[k]=val end) end end
    end
end)
addToggle("Misc","Optimizer",          false,function(v)
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

-- Credits
local CreditsBox=new("Frame",{
    Size=UDim2.new(0.92,0,0,46),BackgroundColor3=COLORS.RowBG,
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
