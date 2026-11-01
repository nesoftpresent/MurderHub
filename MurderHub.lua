-- MurderHub | Delta Executor
-- Created By @MurderHubInfo (tg)
-- Version: 1.0

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ========== НАСТРОЙКИ ==========
local KEY_CORRECT = "testrhisscriptpls"
local LOAD_TIME = 5
local LANG_WAIT = 2
local HUB_NAME = "MurderHub"

local CONFIG = {
    Key = "",
    Lang = "Russia",
    Speed = 16,
    Noclip = false,
    Fly = false,
    FlySpeed = 50,
    Esp = false,
    CandyEsp = false,
    CandyColor = "Orange",
}

-- ========== СОХРАНЕНИЕ ==========
local function SaveConfig()
    if writefile then
        pcall(function()
            writefile("MurderHub_Config.json", HttpService:JSONEncode(CONFIG))
        end)
    end
end

local function LoadConfig()
    if isfile and isfile("MurderHub_Config.json") then
        pcall(function()
            local data = HttpService:JSONDecode(readfile("MurderHub_Config.json"))
            for k, v in pairs(data) do
                CONFIG[k] = v
            end
        end)
    end
end

LoadConfig()

-- ========== УДАЛЕНИЕ СТАРОГО UI ==========
local function CleanupOldUI()
    local old = CoreGui:FindFirstChild("MurderHubUI")
    if old then old:Destroy() end
    local oldBtn = CoreGui:FindFirstChild("MurderHubToggle")
    if oldBtn then oldBtn:Destroy() end
end

CleanupOldUI()

-- ========== ПЕРЕВОДЫ ==========
local L = {
    English = {
        Loading = "MurderHub are loading...",
        WriteKey = "Write key here",
        Use = "Use",
        Wait = "Loading, please wait",
        Global = "Global",
        Murder = "Murder",
        Sheriff = "Sheriff",
        Innocent = "Innocent",
        Language = "Language",
        Credits = "Credits",
        Speed = "Speed",
        Noclip = "Noclip",
        Fly = "Fly (working)",
        FlySpeed = "Fly Speed",
        Esp = "ESP (Use in game only!)",
        CandyEsp = "Candy ESP (until update)",
        InWork = "In work",
        CreatedBy = "Created By @MurderHubInfo (tg)",
        Orange = "Orange", Cyan = "Cyan", Yellow = "Yellow",
        Lime = "Lime", Pink = "Pink", Purple = "Purple",
        CreditsText = "Vitya\nNesoftPresent\nInfo @MurderHubInfo (tg)",
    },
    Russia = {
        Loading = "MurderHub загружается...",
        WriteKey = "Введи ключ сюда",
        Use = "Использовать",
        Wait = "Загрузка, подождите",
        Global = "Общее",
        Murder = "Убийца",
        Sheriff = "Шериф",
        Innocent = "Невинный",
        Language = "Язык",
        Credits = "Создатели",
        Speed = "Скорость",
        Noclip = "Ноклип",
        Fly = "Полёт (рабочий)",
        FlySpeed = "Скорость полёта",
        Esp = "ESP (только в игре!)",
        CandyEsp = "ESP Конфеты (до обновления)",
        InWork = "В процессе",
        CreatedBy = "Создано @MurderHubInfo (tg)",
        Orange = "Оранжевый", Cyan = "Голубой", Yellow = "Жёлтый",
        Lime = "Лаймовый", Pink = "Розовый", Purple = "Фиолетовый",
        CreditsText = "Vitya\nNesoftPresent\nInfo @MurderHubInfo (tg)",
    },
    Spanish = {
        Loading = "MurderHub cargando...",
        WriteKey = "Escribe la clave aquí",
        Use = "Usar",
        Wait = "Cargando, por favor espera",
        Global = "Global",
        Murder = "Asesino",
        Sheriff = "Alguacil",
        Innocent = "Inocente",
        Language = "Idioma",
        Credits = "Créditos",
        Speed = "Velocidad",
        Noclip = "Noclip",
        Fly = "Volar (funcionando)",
        FlySpeed = "Velocidad de vuelo",
        Esp = "ESP (¡solo en el juego!)",
        CandyEsp = "ESP de caramelos (hasta actualización)",
        InWork = "En progreso",
        CreatedBy = "Creado por @MurderHubInfo (tg)",
        Orange = "Naranja", Cyan = "Cian", Yellow = "Amarillo",
        Lime = "Lima", Pink = "Rosa", Purple = "Púrpura",
        CreditsText = "Vitya\nNesoftPresent\nInfo @MurderHubInfo (tg)",
    },
    Chinese = {
        Loading = "MurderHub 正在加载...",
        WriteKey = "在此输入密钥",
        Use = "使用",
        Wait = "加载中，请稍候",
        Global = "全局",
        Murder = "凶手",
        Sheriff = "警长",
        Innocent = "无辜者",
        Language = "语言",
        Credits = "制作人员",
        Speed = "速度",
        Noclip = "穿墙",
        Fly = "飞行 (可用)",
        FlySpeed = "飞行速度",
        Esp = "ESP (仅在游戏中使用!)",
        CandyEsp = "糖果 ESP (直到更新)",
        InWork = "进行中",
        CreatedBy = "由 @MurderHubInfo (tg) 创建",
        Orange = "橙色", Cyan = "青色", Yellow = "黄色",
        Lime = "酸橙绿", Pink = "粉色", Purple = "紫色",
        CreditsText = "Vitya\nNesoftPresent\nInfo @MurderHubInfo (tg)",
    }
}

local function T(key)
    return L[CONFIG.Lang][key] or key
end

-- ========== ЦВЕТА ==========
local COLORS = {
    Orange = Color3.fromRGB(255, 140, 20),
    Cyan = Color3.fromRGB(40, 230, 255),
    Yellow = Color3.fromRGB(255, 230, 40),
    Lime = Color3.fromRGB(160, 255, 40),
    Pink = Color3.fromRGB(255, 100, 200),
    Purple = Color3.fromRGB(160, 50, 255),
}

local CANDY_COLOR_ORDER = {"Orange","Cyan","Yellow","Lime","Pink","Purple"}

-- ========== GUI ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MurderHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = CoreGui

-- ========== ЭКРАН ЗАГРУЗКИ ==========
local LoadFrame = Instance.new("Frame")
LoadFrame.Size = UDim2.new(0, 320, 0, 80)
LoadFrame.Position = UDim2.new(0.5, -160, 0.5, -40)
LoadFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 30)
LoadFrame.BackgroundTransparency = 1
LoadFrame.BorderSizePixel = 0
LoadFrame.Parent = ScreenGui

local LoadCorner = Instance.new("UICorner")
LoadCorner.CornerRadius = UDim.new(0, 12)
LoadCorner.Parent = LoadFrame

local LoadGradient = Instance.new("UIGradient")
LoadGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 80, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 30, 80)),
}
LoadGradient.Rotation = 45
LoadGradient.Parent = LoadFrame

local LoadStroke = Instance.new("UIStroke")
LoadStroke.Color = Color3.fromRGB(100, 150, 255)
LoadStroke.Thickness = 2
LoadStroke.Transparency = 1
LoadStroke.Parent = LoadFrame

local LoadLabel = Instance.new("TextLabel")
LoadLabel.Size = UDim2.new(1, 0, 1, 0)
LoadLabel.BackgroundTransparency = 1
LoadLabel.Text = T("Loading")
LoadLabel.TextColor3 = Color3.fromRGB(200, 230, 255)
LoadLabel.Font = Enum.Font.GothamBold
LoadLabel.TextSize = 20
LoadLabel.TextTransparency = 1
LoadLabel.Parent = LoadFrame

task.spawn(function()
    TweenService:Create(LoadFrame, TweenInfo.new(1), {BackgroundTransparency = 0}):Play()
    TweenService:Create(LoadStroke, TweenInfo.new(1), {Transparency = 0}):Play()
    TweenService:Create(LoadLabel, TweenInfo.new(1), {TextTransparency = 0}):Play()
    task.wait(LOAD_TIME)
    TweenService:Create(LoadFrame, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
    TweenService:Create(LoadStroke, TweenInfo.new(1), {Transparency = 1}):Play()
    TweenService:Create(LoadLabel, TweenInfo.new(1), {TextTransparency = 1}):Play()
    task.wait(1)
    LoadFrame:Destroy()
end)

-- ========== KEY-МЕНЮ ==========
local function BuildKeyMenu()
    local KeyGui = Instance.new("Frame")
    KeyGui.Size = UDim2.new(0, 380, 0, 220)
    KeyGui.Position = UDim2.new(0.5, -190, 0.5, -110)
    KeyGui.BackgroundColor3 = Color3.fromRGB(15, 20, 40)
    KeyGui.BackgroundTransparency = 1
    KeyGui.BorderSizePixel = 0
    KeyGui.Parent = ScreenGui

    local KC = Instance.new("UICorner")
    KC.CornerRadius = UDim.new(0, 14)
    KC.Parent = KeyGui

    local KS = Instance.new("UIStroke")
    KS.Color = Color3.fromRGB(80, 130, 255)
    KS.Thickness = 2
    KS.Transparency = 1
    KS.Parent = KeyGui

    local KTitle = Instance.new("TextLabel")
    KTitle.Size = UDim2.new(1, 0, 0, 50)
    KTitle.Position = UDim2.new(0, 0, 0, 15)
    KTitle.BackgroundTransparency = 1
    KTitle.Text = HUB_NAME
    KTitle.TextColor3 = Color3.fromRGB(120, 180, 255)
    KTitle.Font = Enum.Font.GothamBold
    KTitle.TextSize = 26
    KTitle.TextTransparency = 1
    KTitle.Parent = KeyGui

    local KHint = Instance.new("TextLabel")
    KHint.Size = UDim2.new(1, -40, 0, 20)
    KHint.Position = UDim2.new(0, 20, 0, 70)
    KHint.BackgroundTransparency = 1
    KHint.Text = T("WriteKey")
    KHint.TextColor3 = Color3.fromRGB(150, 180, 220)
    KHint.Font = Enum.Font.Gotham
    KHint.TextSize = 14
    KHint.TextTransparency = 1
    KHint.TextXAlignment = Enum.TextXAlignment.Left
    KHint.Parent = KeyGui

    local KBox = Instance.new("TextBox")
    KBox.Size = UDim2.new(1, -40, 0, 36)
    KBox.Position = UDim2.new(0, 20, 0, 95)
    KBox.BackgroundColor3 = Color3.fromRGB(20, 30, 60)
    KBox.BackgroundTransparency = 1
    KBox.BorderSizePixel = 0
    KBox.Text = ""
    KBox.PlaceholderText = "..."
    KBox.TextColor3 = Color3.fromRGB(200, 220, 255)
    KBox.PlaceholderColor3 = Color3.fromRGB(100, 130, 180)
    KBox.Font = Enum.Font.Gotham
    KBox.TextSize = 15
    KBox.ClearTextOnFocus = false
    KBox.TextTransparency = 1
    KBox.Parent = KeyGui

    local KBC = Instance.new("UICorner")
    KBC.CornerRadius = UDim.new(0, 8)
    KBC.Parent = KBox

    local KBStroke = Instance.new("UIStroke")
    KBStroke.Color = Color3.fromRGB(60, 100, 200)
    KBStroke.Thickness = 1.5
    KBStroke.Transparency = 1
    KBStroke.Parent = KBox

    local KUse = Instance.new("TextButton")
    KUse.Size = UDim2.new(1, -40, 0, 38)
    KUse.Position = UDim2.new(0, 20, 0, 150)
    KUse.BackgroundColor3 = Color3.fromRGB(40, 80, 180)
    KUse.BackgroundTransparency = 1
    KUse.BorderSizePixel = 0
    KUse.Text = T("Use")
    KUse.TextColor3 = Color3.fromRGB(220, 240, 255)
    KUse.Font = Enum.Font.GothamBold
    KUse.TextSize = 16
    KUse.TextTransparency = 1
    KUse.Parent = KeyGui

    local KUC = Instance.new("UICorner")
    KUC.CornerRadius = UDim.new(0, 8)
    KUC.Parent = KUse

    TweenService:Create(KeyGui, TweenInfo.new(1), {BackgroundTransparency = 0}):Play()
    TweenService:Create(KS, TweenInfo.new(1), {Transparency = 0}):Play()
    TweenService:Create(KTitle, TweenInfo.new(1), {TextTransparency = 0}):Play()
    TweenService:Create(KHint, TweenInfo.new(1), {TextTransparency = 0}):Play()
    TweenService:Create(KBox, TweenInfo.new(1), {BackgroundTransparency = 0, TextTransparency = 0}):Play()
    TweenService:Create(KBStroke, TweenInfo.new(1), {Transparency = 0}):Play()
    TweenService:Create(KUse, TweenInfo.new(1), {BackgroundTransparency = 0, TextTransparency = 0}):Play()

    KUse.MouseButton1Click:Connect(function()
        if KBox.Text == KEY_CORRECT then
            CONFIG.Key = KBox.Text
            SaveConfig()
            TweenService:Create(KeyGui, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
            TweenService:Create(KTitle, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
            TweenService:Create(KHint, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
            TweenService:Create(KBox, TweenInfo.new(0.6), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            TweenService:Create(KUse, TweenInfo.new(0.6), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            TweenService:Create(KS, TweenInfo.new(0.6), {Transparency = 1}):Play()
            task.wait(0.7)
            KeyGui:Destroy()
            -- Вторая плавная анимация загрузки
            local LoadFrame2 = LoadFrame:Clone()
            LoadFrame2.Parent = ScreenGui
            LoadFrame2.BackgroundTransparency = 1
            LoadFrame2:FindFirstChildOfClass("UIStroke").Transparency = 1
            LoadFrame2:FindFirstChildOfClass("TextLabel").TextTransparency = 1
            TweenService:Create(LoadFrame2, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
            TweenService:Create(LoadFrame2:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.5), {Transparency = 0}):Play()
            TweenService:Create(LoadFrame2:FindFirstChildOfClass("TextLabel"), TweenInfo.new(0.5), {TextTransparency = 0}):Play()
            task.wait(2)
            TweenService:Create(LoadFrame2, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
            TweenService:Create(LoadFrame2:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.5), {Transparency = 1}):Play()
            TweenService:Create(LoadFrame2:FindFirstChildOfClass("TextLabel"), TweenInfo.new(0.5), {TextTransparency = 1}):Play()
            task.wait(0.6)
            LoadFrame2:Destroy()
            BuildMainMenu()
        else
            KBStroke.Color = Color3.fromRGB(220, 30, 30)
            task.wait(0.4)
            KBStroke.Color = Color3.fromRGB(60, 100, 200)
        end
    end)
end

-- ========== ОВЕРЛЕЙ WAIT ==========
local function ShowWaitOverlay(text, duration, callback)
    local WaitGui = Instance.new("Frame")
    WaitGui.Size = UDim2.new(1, 0, 1, 0)
    WaitGui.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    WaitGui.BackgroundTransparency = 1
    WaitGui.BorderSizePixel = 0
    WaitGui.ZIndex = 100
    WaitGui.Parent = ScreenGui

    local WLabel = Instance.new("TextLabel")
    WLabel.Size = UDim2.new(1, 0, 1, 0)
    WLabel.BackgroundTransparency = 1
    WLabel.Text = text
    WLabel.TextColor3 = Color3.fromRGB(120, 180, 255)
    WLabel.Font = Enum.Font.GothamBold
    WLabel.TextSize = 28
    WLabel.TextTransparency = 1
    WLabel.ZIndex = 101
    WLabel.Parent = WaitGui

    TweenService:Create(WaitGui, TweenInfo.new(0.5), {BackgroundTransparency = 0.4}):Play()
    TweenService:Create(WLabel, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    task.wait(duration)
    TweenService:Create(WaitGui, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(WLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    task.wait(0.6)
    WaitGui:Destroy()
    if callback then callback() end
end

-- ========== NOCLIP ==========
local noclipConn
local function ToggleNoclip(state)
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    if not state then return end
    noclipConn = RunService.Stepped:Connect(function()
        local char = LocalPlayer.Character
        if char then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") and p.CanCollide then
                    p.CanCollide = false
                end
            end
        end
    end)
end

-- ========== SPEED ==========
local function ApplySpeed(val)
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").WalkSpeed = val
    end
end

-- ========== FLY (РАБОЧИЙ) ==========
local flyConn, flyBody, flyGyro
local function ToggleFly(state)
    if flyConn then flyConn:Disconnect() flyConn = nil end
    if flyBody then flyBody:Destroy() flyBody = nil end
    if flyGyro then flyGyro:Destroy() flyGyro = nil end

    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if state then
        flyBody = Instance.new("BodyVelocity")
        flyBody.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        flyBody.Velocity = Vector3.zero
        flyBody.Parent = hrp

        flyGyro = Instance.new("BodyGyro")
        flyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        flyGyro.P = 1000
        flyGyro.D = 50
        flyGyro.CFrame = hrp.CFrame
        flyGyro.Parent = hrp

        flyConn = RunService.RenderStepped:Connect(function()
            if not char.Parent then return end
            local dir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end

            if dir.Magnitude > 0 then
                flyBody.Velocity = dir.Unit * CONFIG.FlySpeed
            else
                flyBody.Velocity = Vector3.zero
            end
            flyGyro.CFrame = Camera.CFrame
        end)
    end
end

-- ========== ESP (РОЛИ И КОНФЕТЫ) ==========
local espFolder = Instance.new("Folder")
espFolder.Name = "MurderHubESP"
espFolder.Parent = CoreGui

local function GetRoleColor(plr)
    -- Логика определения роли в MM2. 
    -- Если игра использует скрытые атрибуты, пытаемся их прочитать.
    local role = plr:GetAttribute("Role") or plr.Character:GetAttribute("Role") or "Innocent"
    
    -- Проверка по оружию в бэкпаке/руках
    if plr.Character then
        local backpack = plr:FindFirstChild("Backpack")
        local hasKnife = (plr.Character:FindFirstChild("Knife")) or (backpack and backpack:FindFirstChild("Knife"))
        local hasGun = (plr.Character:FindFirstChild("Gun")) or (backpack and backpack:FindFirstChild("Gun"))
        
        if hasKnife then role = "Murder" end
        if hasGun then role = "Sheriff" end
    end

    if role == "Murder" then return Color3.fromRGB(255, 40, 40) -- Красный
    elseif role == "Sheriff" then return Color3.fromRGB(40, 120, 255) -- Синий
    else return Color3.fromRGB(40, 255, 40) end -- Зеленый (Innocent)
end

local function RefreshESP()
    espFolder:ClearAllChildren()
    if not CONFIG.Esp then return end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hl = Instance.new("Highlight")
            hl.Name = plr.Name
            hl.FillColor = GetRoleColor(plr)
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.FillTransparency = 0.5
            hl.Adornee = plr.Character
            hl.Parent = espFolder
        end
    end
end

-- Конфеты
local function RefreshCandyESP()
    for _, v in ipairs(espFolder:GetChildren()) do
        if v.Name == "Candy" then v:Destroy() end
    end
    if not CONFIG.CandyEsp then return end
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        -- Ищем по имени Candy или Candies
        if obj:IsA("BasePart") and (string.find(obj.Name:lower(), "candy") or string.find(obj.Name:lower(), "candies")) then
            local hl = Instance.new("Highlight")
            hl.Name = "Candy"
            hl.FillColor = COLORS[CONFIG.CandyColor]
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.FillTransparency = 0.5
            hl.Adornee = obj
            hl.Parent = espFolder
        end
    end
end

-- Обновление при появлении персонажа/респавне
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(1)
        RefreshESP()
        RefreshCandyESP()
    end)
end)

-- ========== ГЛАВНОЕ МЕНЮ ==========
function BuildMainMenu()
    local Main = Instance.new("Frame")
    Main.Name = "MainMenu"
    Main.Size = UDim2.new(0, 600, 0, 420)
    Main.Position = UDim2.new(0.5, -300, 0.5, -210)
    Main.BackgroundColor3 = Color3.fromRGB(10, 15, 30)
    Main.BackgroundTransparency = 1
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Main.Parent = ScreenGui

    local MC = Instance.new("UICorner")
    MC.CornerRadius = UDim.new(0, 16)
    MC.Parent = Main

    local MGradient = Instance.new("UIGradient")
    MGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 40, 80)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 20, 40)),
    }
    MGradient.Rotation = 135
    MGradient.Parent = Main

    local MS = Instance.new("UIStroke")
    MS.Color = Color3.fromRGB(80, 130, 255)
    MS.Thickness = 2
    MS.Transparency = 1
    MS.Parent = Main

    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 64)
    Header.BackgroundColor3 = Color3.fromRGB(15, 25, 50)
    Header.BackgroundTransparency = 1
    Header.BorderSizePixel = 0
    Header.Parent = Main

    local HC = Instance.new("UICorner")
    HC.CornerRadius = UDim.new(0, 16)
    HC.Parent = Header

    local HLogo = Instance.new("TextLabel")
    HLogo.Size = UDim2.new(1, -20, 0, 30)
    HLogo.Position = UDim2.new(0, 20, 0, 6)
    HLogo.BackgroundTransparency = 1
    HLogo.Text = HUB_NAME
    HLogo.TextColor3 = Color3.fromRGB(120, 180, 255)
    HLogo.Font = Enum.Font.GothamBold
    HLogo.TextSize = 24
    HLogo.TextXAlignment = Enum.TextXAlignment.Left
    HLogo.TextTransparency = 1
    HLogo.Parent = Header

    local HSub = Instance.new("TextLabel")
    HSub.Size = UDim2.new(1, -20, 0, 16)
    HSub.Position = UDim2.new(0, 20, 0, 38)
    HSub.BackgroundTransparency = 1
    HSub.Text = T("CreatedBy")
    HSub.TextColor3 = Color3.fromRGB(100, 130, 180)
    HSub.Font = Enum.Font.Gotham
    HSub.TextSize = 11
    HSub.TextXAlignment = Enum.TextXAlignment.Left
    HSub.TextTransparency = 1
    HSub.Parent = Header

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 160, 1, -84)
    Sidebar.Position = UDim2.new(0, 10, 0, 74)
    Sidebar.BackgroundColor3 = Color3.fromRGB(15, 25, 50)
    Sidebar.BackgroundTransparency = 1
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Main

    local SC = Instance.new("UICorner")
    SC.CornerRadius = UDim.new(0, 12)
    SC.Parent = Sidebar

    local SList = Instance.new("UIListLayout")
    SList.Padding = UDim.new(0, 6)
    SList.SortOrder = Enum.SortOrder.LayoutOrder
    SList.Parent = Sidebar

    local SPad = Instance.new("UIPadding")
    SPad.PaddingTop = UDim.new(0, 10)
    SPad.PaddingLeft = UDim.new(0, 8)
    SPad.PaddingRight = UDim.new(0, 8)
    SPad.Parent = Sidebar

    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -190, 1, -84)
    Content.Position = UDim2.new(0, 180, 0, 74)
    Content.BackgroundColor3 = Color3.fromRGB(15, 25, 50)
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel = 0
    Content.ClipsDescendants = true
    Content.Parent = Main

    local CC = Instance.new("UICorner")
    CC.CornerRadius = UDim.new(0, 12)
    CC.Parent = Content

    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Size = UDim2.new(1, 0, 1, 0)
    Scroll.BackgroundTransparency = 1
    Scroll.BorderSizePixel = 0
    Scroll.ScrollBarThickness = 5
    Scroll.ScrollBarImageColor3 = Color3.fromRGB(80, 130, 255)
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Scroll.Parent = Content

    local SLayout = Instance.new("UIListLayout")
    SLayout.Padding = UDim.new(0, 10)
    SLayout.Parent = Scroll

    local SPad2 = Instance.new("UIPadding")
    SPad2.PaddingTop = UDim.new(0, 14)
    SPad2.PaddingLeft = UDim.new(0, 14)
    SPad2.PaddingRight = UDim.new(0, 14)
    SPad2.PaddingBottom = UDim.new(0, 14)
    SPad2.Parent = Scroll

    TweenService:Create(Main, TweenInfo.new(0.8), {BackgroundTransparency = 0}):Play()
    TweenService:Create(MS, TweenInfo.new(0.8), {Transparency = 0}):Play()
    TweenService:Create(Header, TweenInfo.new(0.8), {BackgroundTransparency = 0}):Play()
    TweenService:Create(Sidebar, TweenInfo.new(0.8), {BackgroundTransparency = 0}):Play()
    TweenService:Create(Content, TweenInfo.new(0.8), {BackgroundTransparency = 0}):Play()
    TweenService:Create(HLogo, TweenInfo.new(0.8), {TextTransparency = 0}):Play()
    TweenService:Create(HSub, TweenInfo.new(0.8), {TextTransparency = 0}):Play()

    local tabButtons = {}

    local function ClearContent()
        for _, c in ipairs(Scroll:GetChildren()) do
            if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then
                c:Destroy()
            end
        end
    end

    local function MakeToggle(parent, labelText, state, callback)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 56)
        row.BackgroundColor3 = Color3.fromRGB(20, 35, 70)
        row.BorderSizePixel = 0
        row.Parent = parent
        local rc = Instance.new("UICorner") rc.CornerRadius = UDim.new(0, 10) rc.Parent = row

        local name = Instance.new("TextLabel")
        name.Size = UDim2.new(1, -80, 0, 22)
        name.Position = UDim2.new(0, 12, 0, 8)
        name.BackgroundTransparency = 1
        name.Text = labelText
        name.TextColor3 = Color3.fromRGB(200, 220, 255)
        name.Font = Enum.Font.GothamBold
        name.TextSize = 14
        name.TextXAlignment = Enum.TextXAlignment.Left
        name.Parent = row

        local stateLbl = Instance.new("TextLabel")
        stateLbl.Size = UDim2.new(1, -80, 0, 14)
        stateLbl.Position = UDim2.new(0, 12, 0, 32)
        stateLbl.BackgroundTransparency = 1
        stateLbl.Text = state and "ON" or "OFF"
        stateLbl.TextColor3 = state and Color3.fromRGB(150, 255, 150) or Color3.fromRGB(255, 150, 150)
        stateLbl.Font = Enum.Font.Gotham
        stateLbl.TextSize = 11
        stateLbl.TextXAlignment = Enum.TextXAlignment.Left
        stateLbl.Parent = row

        local btn = Instance.new("TextButton")
        btn.Size
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 50, 0, 26)
        btn.Position = UDim2.new(1, -62, 0.5, -13)
        btn.BackgroundColor3 = state and Color3.fromRGB(40, 80, 180) or Color3.fromRGB(25, 45, 90)
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.Parent = row
        local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 13) bc.Parent = btn

        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 20, 0, 20)
        dot.Position = state and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
        dot.BackgroundColor3 = Color3.fromRGB(230, 240, 255)
        dot.BorderSizePixel = 0
        dot.Parent = btn
        local dc = Instance.new("UICorner") dc.CornerRadius = UDim.new(1, 0) dc.Parent = dot

        btn.MouseButton1Click:Connect(function()
            state = not state
            stateLbl.Text = state and "ON" or "OFF"
            stateLbl.TextColor3 = state and Color3.fromRGB(150, 255, 150) or Color3.fromRGB(255, 150, 150)
            btn.BackgroundColor3 = state and Color3.fromRGB(40, 80, 180) or Color3.fromRGB(25, 45, 90)
            TweenService:Create(dot, TweenInfo.new(0.15), {
                Position = state and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
            }):Play()
            callback(state)
            SaveConfig()
        end)
    end

    local function MakeInput(parent, labelText, value, minV, maxV, callback)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 64)
        row.BackgroundColor3 = Color3.fromRGB(20, 35, 70)
        row.BorderSizePixel = 0
        row.Parent = parent
        local rc = Instance.new("UICorner") rc.CornerRadius = UDim.new(0, 10) rc.Parent = row

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -24, 0, 20)
        lbl.Position = UDim2.new(0, 12, 0, 6)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = Color3.fromRGB(200, 220, 255)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row

        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1, -24, 0, 28)
        box.Position = UDim2.new(0, 12, 0, 30)
        box.BackgroundColor3 = Color3.fromRGB(15, 25, 50)
        box.BorderSizePixel = 0
        box.Text = tostring(value)
        box.TextColor3 = Color3.fromRGB(200, 220, 255)
        box.Font = Enum.Font.Gotham
        box.TextSize = 14
        box.Parent = row
        local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 6) bc.Parent = box

        box.FocusLost:Connect(function()
            local n = tonumber(box.Text)
            if n then
                if minV then n = math.clamp(n, minV, maxV) end
                box.Text = tostring(n)
                callback(n)
                SaveConfig()
            else
                box.Text = tostring(value)
            end
        end)
    end

    local function MakeColorRow(parent, labelText, currentColorKey, callback)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 80)
        row.BackgroundColor3 = Color3.fromRGB(20, 35, 70)
        row.BorderSizePixel = 0
        row.Parent = parent
        local rc = Instance.new("UICorner") rc.CornerRadius = UDim.new(0, 10) rc.Parent = row

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -24, 0, 20)
        lbl.Position = UDim2.new(0, 12, 0, 6)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = Color3.fromRGB(200, 220, 255)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row

        local grid = Instance.new("Frame")
        grid.Size = UDim2.new(1, -24, 0, 44)
        grid.Position = UDim2.new(0, 12, 0, 28)
        grid.BackgroundTransparency = 1
        grid.Parent = row

        local gl = Instance.new("UIGridLayout")
        gl.CellSize = UDim2.new(0, 22, 0, 22)
        gl.CellPadding = UDim2.new(0, 4, 0, 4)
        gl.SortOrder = Enum.SortOrder.LayoutOrder
        gl.Parent = grid

        for i, cname in ipairs(CANDY_COLOR_ORDER) do
            local sq = Instance.new("TextButton")
            sq.Size = UDim2.new(0, 22, 0, 22)
            sq.BackgroundColor3 = COLORS[cname]
            sq.BorderSizePixel = 0
            sq.Text = ""
            sq.LayoutOrder = i
            sq.Parent = grid
            local sc = Instance.new("UICorner") sc.CornerRadius = UDim.new(0, 5) sc.Parent = sq

            if cname == currentColorKey then
                local sel = Instance.new("UIStroke")
                sel.Color = Color3.fromRGB(255, 255, 255)
                sel.Thickness = 2
                sel.Parent = sq
            end

            sq.MouseButton1Click:Connect(function()
                for _, other in ipairs(grid:GetChildren()) do
                    if other:IsA("TextButton") then
                        local s = other:FindFirstChildOfClass("UIStroke")
                        if s then s:Destroy() end
                    end
                end
                local sel = Instance.new("UIStroke")
                sel.Color = Color3.fromRGB(255, 255, 255)
                sel.Thickness = 2
                sel.Parent = sq
                callback(cname)
                SaveConfig()
            end)
        end
    end

    local function BuildGlobal()
        ClearContent()
        MakeInput(Scroll, T("Speed") .. " (1-100)", CONFIG.Speed, 1, 100, function(v) CONFIG.Speed = v ApplySpeed(v) end)
        MakeToggle(Scroll, T("Noclip"), CONFIG.Noclip, function(s) CONFIG.Noclip = s ToggleNoclip(s) end)
        MakeToggle(Scroll, T("Fly"), CONFIG.Fly, function(s) CONFIG.Fly = s ToggleFly(s) end)
        MakeInput(Scroll, T("FlySpeed"), CONFIG.FlySpeed, 10, 200, function(v) CONFIG.FlySpeed = v end)
        MakeToggle(Scroll, T("Esp"), CONFIG.Esp, function(s) CONFIG.Esp = s RefreshESP() end)
    end

    local function BuildMurder()
        ClearContent()
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = T("InWork")
        lbl.TextColor3 = Color3.fromRGB(100, 150, 255)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 22
        lbl.Parent = Scroll
    end

    local function BuildSheriff()
        ClearContent()
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = T("InWork")
        lbl.TextColor3 = Color3.fromRGB(100, 150, 255)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 22
        lbl.Parent = Scroll
    end

    local function BuildInnocent()
        ClearContent()
        MakeToggle(Scroll, T("CandyEsp"), CONFIG.CandyEsp, function(s) CONFIG.CandyEsp = s RefreshCandyESP() end)
        MakeColorRow(Scroll, "Candy Color", CONFIG.CandyColor, function(c) CONFIG.CandyColor = c RefreshCandyESP() end)
    end

    local function BuildLanguage()
        ClearContent()
        local function LangBtn(name, code)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, 44)
            b.BackgroundColor3 = CONFIG.Lang == code and Color3.fromRGB(40, 80, 180) or Color3.fromRGB(25, 45, 90)
            b.BorderSizePixel = 0
            b.Text = name
            b.TextColor3 = Color3.fromRGB(200, 220, 255)
            b.Font = Enum.Font.GothamBold
            b.TextSize = 15
            b.Parent = Scroll
            local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 9) bc.Parent = b
            b.MouseButton1Click:Connect(function()
                if CONFIG.Lang == code then return end
                CONFIG.Lang = code
                SaveConfig()
                ShowWaitOverlay(T("Wait") .. "...", LANG_WAIT, function()
                    Main:Destroy()
                    BuildMainMenu()
                end)
            end)
        end

        LangBtn("Русский", "Russia")
        LangBtn("English", "English")
        LangBtn("Español", "Spanish")
        LangBtn("中文", "Chinese")
    end

    local function BuildCredits()
        ClearContent()
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = T("CreditsText")
        lbl.TextColor3 = Color3.fromRGB(120, 180, 255)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 18
        lbl.Parent = Scroll
    end

    local function SwitchTab(tabName)
        for name, btn in pairs(tabButtons) do
            if name == tabName then
                btn.BackgroundColor3 = Color3.fromRGB(40, 80, 180)
            else
                btn.BackgroundColor3 = Color3.fromRGB(20, 35, 70)
            end
        end
        if tabName == "Global" then BuildGlobal()
        elseif tabName == "Murder" then BuildMurder()
        elseif tabName == "Sheriff" then BuildSheriff()
        elseif tabName == "Innocent" then BuildInnocent()
        elseif tabName == "Language" then BuildLanguage()
        elseif tabName == "Credits" then BuildCredits()
        end
        Scroll.CanvasPosition = Vector2.new(0, 0)
    end

    local function MakeTab(labelText, tabName)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 38)
        btn.BackgroundColor3 = Color3.fromRGB(20, 35, 70)
        btn.BorderSizePixel = 0
        btn.Text = labelText
        btn.TextColor3 = Color3.fromRGB(200, 220, 255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 13
        btn.Parent = Sidebar
        local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 8) bc.Parent = btn
        tabButtons[tabName] = btn
        btn.MouseButton1Click:Connect(function() SwitchTab(tabName) end)
    end

    MakeTab(T("Global"), "Global")
    MakeTab(T("Murder"), "Murder")
    MakeTab(T("Sheriff"), "Sheriff")
    MakeTab(T("Innocent"), "Innocent")
    MakeTab(T("Language"), "Language")
    MakeTab(T("Credits"), "Credits")

    SwitchTab("Global")

    -- ========== КНОПКА ЗАКРЫТИЯ (НИНДЗЯ С КРАСНЫМ КОНТУРОМ) ==========
    local toggleBtn = Instance.new("ImageButton")
    toggleBtn.Name = "MurderHubToggle"
    toggleBtn.Size = UDim2.new(0, 60, 0, 60)
    toggleBtn.Position = UDim2.new(0, 20, 0.5, -30)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(10, 15, 30)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Image = "https://i.postimg.cc/jjK8WrRv/diting-result-d5d4d45cbaa511f1b5fa420a27eb69d1-1.jpg"
    toggleBtn.Active = true
    toggleBtn.Draggable = true
    toggleBtn.Parent = ScreenGui

    local tc2 = Instance.new("UICorner") tc2.CornerRadius = UDim.new(0, 10) tc2.Parent = toggleBtn
    local ts2 = Instance.new("UIStroke") ts2.Color = Color3.fromRGB(220, 30, 40) ts2.Thickness = 2 ts2.Parent = toggleBtn

    local menuVisible = true
    toggleBtn.MouseButton1Click:Connect(function()
        menuVisible = not menuVisible
        if menuVisible then
            Main.Visible = true
            TweenService:Create(Main, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
        else
            TweenService:Create(Main, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            task.wait(0.32)
            Main.Visible = false
        end
    end)

    task.spawn(function()
        if CONFIG.Noclip then ToggleNoclip(true) end
        if CONFIG.Fly then ToggleFly(true) end
        ApplySpeed(CONFIG.Speed)
        RefreshESP()
        RefreshCandyESP()
    end)
end

-- ========== СТАРТ ==========
task.spawn(function()
    task.wait(LOAD_TIME + 2)
    if CONFIG.Key == KEY_CORRECT then
        BuildMainMenu()
    else
        BuildKeyMenu()
    end
end)
