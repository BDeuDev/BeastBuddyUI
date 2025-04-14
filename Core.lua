-- Frame principal
local CUSTOM_FONT_PATH = "Interface\\AddOns\\BeastBuddyUI\\Fonts\\Myriad-Pro"

local PetStatusFrame = CreateFrame("Frame", "PetStatusFrame", UIParent)
PetStatusFrame:SetWidth(175)
PetStatusFrame:SetHeight(45)
PetStatusFrame:SetPoint("TOP", UIParent, "TOP", 0, -50)
PetStatusFrame:SetBackdrop({
    bgFile = nil,
    edgeFile = nil,
    tile = true, tileSize = 16, edgeSize = 12,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
PetStatusFrame:SetBackdropColor(0, 0, 0, 0.8)
PetStatusFrame:SetMovable(true)
PetStatusFrame:EnableMouse(true)
PetStatusFrame:RegisterForDrag("LeftButton")
PetStatusFrame:SetScript("OnMouseDown", function()
    PetStatusFrame:StartMoving()
end)
PetStatusFrame:SetScript("OnMouseUp", function()
    PetStatusFrame:StopMovingOrSizing()
end)
PetStatusFrame:Show()
PetStatusFrame.isUnlocked = false

-- Textura personalizada
local customTexture = PetStatusFrame:CreateTexture(nil, "BACKGROUND")
customTexture:SetTexture("Interface\\AddOns\\BeastBuddyUI\\textures\\bg")
customTexture:SetAllPoints(PetStatusFrame)

-- Crear icono de la mascota
local PetIcon = PetStatusFrame:CreateTexture(nil, "ARTWORK")
PetIcon:SetWidth(32)
PetIcon:SetHeight(32)
PetIcon:SetPoint("LEFT", PetStatusFrame, "LEFT", 4, 0)

-- Función para actualizar el icono de la mascota
local function UpdatePetIcon()
    local iconPath = GetPetIcon()
    if iconPath then
        PetIcon:SetTexture(iconPath)
        PetIcon:Show()
    else
        PetIcon:Hide()
    end
end

-- Crear icono de estado
local HappinessFrame = CreateFrame("Frame", "HappinessFrame", PetStatusFrame)
HappinessFrame:SetWidth(18)
HappinessFrame:SetHeight(18)
HappinessFrame:SetPoint("TOPLEFT", PetStatusFrame, "TOPLEFT", 0, 18)
HappinessFrame:SetBackdrop({
    bgFile = nil,
    edgeFile = nil,
    tile = true, tileSize = 16, edgeSize = 12,
    insets = { left = 0, right = 0, top = 0, bottom = 0 }
})
HappinessFrame:SetBackdropColor(0, 0, 0, 0.8)
HappinessFrame:SetMovable(true)
HappinessFrame:EnableMouse(true)
HappinessFrame:RegisterForDrag("LeftButton")
HappinessFrame:SetScript("OnMouseDown", function()
    HappinessFrame:StartMoving()
end)
HappinessFrame:SetScript("OnMouseUp", function()
    HappinessFrame:StopMovingOrSizing()
end)
HappinessFrame:Show()

local customTexture = HappinessFrame:CreateTexture(nil, "BACKGROUND")
customTexture:SetTexture("Interface\\AddOns\\BeastBuddyUI\\textures\\bg")
customTexture:SetAllPoints(HappinessFrame)
-- Tooltip de felicidad
HappinessFrame:SetScript("OnEnter", function()
    GameTooltip:SetOwner(HappinessFrame, "ANCHOR_RIGHT")
    
    local happiness = GetPetHappiness()
    if happiness == 1 then
        GameTooltip:SetText("😢 Triste", 1, 0, 0)
        GameTooltip:AddLine("Tu mascota está muy hambrienta o infeliz.", 1, 1, 1, true)
    elseif happiness == 2 then
        GameTooltip:SetText("😐 Neutral", 1, 1, 0)
        GameTooltip:AddLine("Tu mascota está bien, pero podría estar más feliz.", 1, 1, 1, true)
    elseif happiness == 3 then
        GameTooltip:SetText("😊 Feliz", 0, 1, 0)
        GameTooltip:AddLine("Tu mascota está contenta y rinde al máximo.", 1, 1, 1, true)
    else
        GameTooltip:SetText("Estado desconocido", 1, 1, 1)
    end

    GameTooltip:Show()
end)

HappinessFrame:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
-- Textura dinámica según felicidad
local HappinessIcon = HappinessFrame:CreateTexture(nil, "ARTWORK")
HappinessIcon:SetAllPoints(HappinessFrame)
HappinessIcon:SetTexture("")

-- Función para crear una barra
local function CreateStatusBar(parent, yOffset, labelText, height)
    local bar = CreateFrame("StatusBar", nil, parent)
    bar:SetWidth(130)
    bar:SetHeight(height)
    bar:SetPoint("TOP", 18, yOffset)
    bar:SetStatusBarTexture("Interface\\AddOns\\BeastBuddyUI\\textures\\bar_gradient")
    bar:SetMinMaxValues(0, 100)
    bar:SetValue(0)

    local bg = bar:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(true)
    bg:SetTexture(0.2, 0.2, 0.2, 0.5)

    local label = bar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetFont(CUSTOM_FONT_PATH, 24, "OUTLINE")
    label:SetPoint("CENTER", bar, "CENTER", 0, 0)
    label:SetText(labelText)

    bar.label = label
    return bar
end

-- Crear barras de estado
local HungerBar = CreateStatusBar(PetStatusFrame, -5, "Hambre", 15)
local ExperienceBar = CreateStatusBar(PetStatusFrame, -25, "Experiencia", 15)

local function SetBarColor(bar, value)
    if value >= 33 and value < 66 then
        bar:SetStatusBarColor(0.7, 0.2, 0.2)
        bar.label:SetTextColor(1, 1, 1)
    elseif value >= 66 and value <= 99 then
        bar:SetStatusBarColor(0.7, 0.6, 0.1)
        bar.label:SetTextColor(1, 1, 1)
    elseif value >= 100 then
        bar:SetStatusBarColor(0.4, 0.6, 0.4)
        bar.label:SetTextColor(1, 1, 1)
    end
end

-- Estado para saber si el mouse está sobre el HungerBar
local isHoveringHunger = false
local isHoveringExperience = false

-- Solo se asigna una vez
HungerBar:EnableMouse(true)
HungerBar:SetScript("OnEnter", function()
    isHoveringHunger = true
end)
HungerBar:SetScript("OnLeave", function()
    isHoveringHunger = false
end)

ExperienceBar:EnableMouse(true)
ExperienceBar:SetScript("OnEnter", function()
    isHoveringExperience = true
end)
ExperienceBar:SetScript("OnLeave", function()
    isHoveringExperience = false
end)

-- Estado previo para evitar actualizaciones redundantes
local hungerAlertPlayed = false
local prevHappiness = nil
local prevXP = 0
local prevNextXP = 0
local prevHungerPercent = -1
local prevXPPercent = -1

local function ShowPetHungerAlert()
    if not hungerAlertPlayed then
        UIErrorsFrame:AddMessage("|cffff0000¡TU MASCOTA TIENE HAMBRE!|r", 1.0, 0.1, 0.1, 53, 5)
        PlaySoundFile("Interface\\AddOns\\BeastBuddyUI\\sound\\hunger_alert.wav", "Master")
        hungerAlertPlayed = true
    end
end

local function UpdatePetStatus()
    if not UnitExists("pet") then
        HungerBar:Hide()
        ExperienceBar:Hide()
        PetStatusFrame:Hide()
        prevHappiness = nil
        return
    end

    PetStatusFrame:Show()

    local happiness, damagePercentage = GetPetHappiness()
    local currXP, nextXP = GetPetExperience()
    UpdatePetIcon()

    if not happiness or not currXP or not nextXP then
        HungerBar:Hide()
        ExperienceBar:Hide()
        return
    end

    HungerBar:Show()
    ExperienceBar:Show()

    -- Hambre
    local hungerPercent = (happiness / 3) * 100
    if hungerPercent ~= prevHungerPercent then
        HungerBar:SetValue(hungerPercent)
        prevHungerPercent = hungerPercent
    end
    if isHoveringHunger then
        HungerBar.label:SetText("Hambre: " .. math.floor(hungerPercent) .. "% (" .. math.floor(damagePercentage) .. "% ATQ)")
    else
        HungerBar.label:SetText("Hambre: " .. math.floor(hungerPercent) .. "%")
    end
    SetBarColor(HungerBar, hungerPercent)

    -- XP
    local xpPercent = (currXP / nextXP) * 100
    if xpPercent ~= prevXPPercent then
        ExperienceBar:SetValue(xpPercent)
        prevXPPercent = xpPercent
    end
    if isHoveringExperience then
        ExperienceBar.label:SetText("XP: " .. math.floor(xpPercent) .. "% (" .. math.floor(currXP) .. " / " .. math.floor(nextXP) .. ")")
    else
        ExperienceBar.label:SetText("XP: " .. math.floor(xpPercent) .. "%")
    end
    ExperienceBar:SetStatusBarColor(0.18, 0.18, 0.36)
    ExperienceBar.label:SetTextColor(0.37, 0.37, 0.87)

    -- Estado emocional
    if happiness ~= prevHappiness then
        if happiness == 1 then
            HappinessIcon:SetTexture("Interface\\AddOns\\BeastBuddyUI\\textures\\sad")
            ShowPetHungerAlert()
        elseif happiness == 2 then
            HappinessIcon:SetTexture("Interface\\AddOns\\BeastBuddyUI\\textures\\neutral")
        elseif happiness == 3 then
            HappinessIcon:SetTexture("Interface\\AddOns\\BeastBuddyUI\\textures\\happy")
            hungerAlertPlayed = false
        else
            HappinessIcon:SetTexture("")
            hungerAlertPlayed = false
        end
        prevHappiness = happiness
    end
end

-- Temporizador eficiente
local updateFrame = CreateFrame("Frame")
local lastUpdate = 0
updateFrame:SetScript("OnUpdate", function()
    local now = GetTime()
    if now - lastUpdate >= 1 then
        UpdatePetStatus()
        lastUpdate = now
    end
end)


-- Comando para mostrar/ocultar el frame

SlashCmdList["PETSTATUS"] = function()
    if PetStatusFrame:IsShown() then
        PetStatusFrame:Hide()
    else
        PetStatusFrame:Show()
    end
end
SLASH_PETSTATUS1 = "/petstatus"
SlashCmdList["PETSTATUS"] = function()
    if UnitExists("pet") then
        PetStatusFrame:Show()
    else
        UIErrorsFrame:AddMessage("|cffff6600No tienes mascota activa.|r", 1, 0.6, 0)
        PetStatusFrame:Hide()
    end
end
-- Ocultar barras al inicio si no hay pet
HungerBar:Hide()
ExperienceBar:Hide()

