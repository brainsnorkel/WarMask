-- =============================================================================
-- Warmask Line Rendering
-- =============================================================================
-- Adapted from BetterGuard by TheMrPancake
-- Original line rendering logic from CrutchAlerts by Kyzeragon
-- and OdySupportIcons by Lamierina7
-- =============================================================================

WarMask = WarMask or {}
local WM = WarMask

local line = nil
local backdrop = nil
local renderCtrl = nil
local lineWindow = nil

-- =============================================================================
-- COORDINATE CONVERSION
-- =============================================================================
-- Convert in-world coordinates to view via linear algebra
-- Credit: OdySupportIcons, CrutchAlerts
local function GetViewCoordinates(wX, wY, wZ)
    if not renderCtrl then return 0, 0, false end
    
    -- Prepare render space
    Set3DRenderSpaceToCurrentCamera(renderCtrl:GetName())
    
    -- Retrieve camera world position and orientation vectors
    local cX, cY, cZ = GuiRender3DPositionToWorldPosition(renderCtrl:Get3DRenderSpaceOrigin())
    local fX, fY, fZ = renderCtrl:Get3DRenderSpaceForward()
    local rX, rY, rZ = renderCtrl:Get3DRenderSpaceRight()
    local uX, uY, uZ = renderCtrl:Get3DRenderSpaceUp()
    
    -- Calculate inverse camera matrix
    local i11 = -(uY * fZ - uZ * fY)
    local i12 = -(rZ * fY - rY * fZ)
    local i13 = -(rY * uZ - rZ * uY)
    local i21 = -(uZ * fX - uX * fZ)
    local i22 = -(rX * fZ - rZ * fX)
    local i23 = -(rZ * uX - rX * uZ)
    local i31 = -(uX * fY - uY * fX)
    local i32 = -(rY * fX - rX * fY)
    local i33 = -(rX * uY - rY * uX)
    local i41 = -(uZ * fY * cX + uY * fX * cZ + uX * fZ * cY - uX * fY * cZ - uY * fZ * cX - uZ * fX * cY)
    local i42 = -(rX * fY * cZ + rY * fZ * cX + rZ * fX * cY - rZ * fY * cX - rY * fX * cZ - rX * fZ * cY)
    local i43 = -(rZ * uY * cX + rY * uX * cZ + rX * uZ * cY - rX * uY * cZ - rY * uZ * cX - rZ * uX * cY)
    
    -- Screen dimensions
    local uiW, uiH = GuiRoot:GetDimensions()
    
    -- Calculate unit view position
    local pX = wX * i11 + wY * i21 + wZ * i31 + i41
    local pY = wX * i12 + wY * i22 + wZ * i32 + i42
    local pZ = wX * i13 + wY * i23 + wZ * i33 + i43
    
    -- Calculate unit screen position
    local w, h = GetWorldDimensionsOfViewFrustumAtDepth(math.abs(pZ))
    
    return pX * uiW / w, -pY * uiH / h, pZ > 0
end

-- =============================================================================
-- LINE DRAWING
-- =============================================================================
local function DrawLineBetweenPoints(x1, y1, x2, y2)
    if not line then return end
    
    -- Get color based on countdown state
    local color = {0, 1, 0, 1}  -- Default green
    if WM.savedVars then
        local isCountdownActive = WM.isCountdownActive and WM.isCountdownActive() or false
        if isCountdownActive then
            local countdownEndTime = WM.countdownEndTime and WM.countdownEndTime() or nil
            if countdownEndTime then
                local remaining = countdownEndTime - GetGameTimeSeconds()
                if remaining > 50 then
                    -- Cooldown period (60s to 50s)
                    color = WM.savedVars.cooldownColor or {1, 0.3, 0.3, 1}
                else
                    -- Ready period (49s and lower)
                    color = WM.savedVars.readyColor or {0, 1, 0, 1}
                end
            else
                color = WM.savedVars.readyColor or {0, 1, 0, 1}
            end
        else
            color = WM.savedVars.readyColor or {0, 1, 0, 1}
        end
    end
    
    backdrop:SetCenterColor(unpack(color))
    backdrop:SetEdgeColor(unpack(color))
    
    -- Calculate midpoint
    local centerX = (x1 + x2) / 2
    local centerY = (y1 + y2) / 2
    line:ClearAnchors()
    line:SetAnchor(CENTER, GuiRoot, CENTER, centerX, centerY)
    
    -- Set length and rotation
    local dx = x2 - x1
    local dy = y2 - y1
    local length = math.sqrt(dx * dx + dy * dy)
    line:SetDimensions(length, 4)
    local angle = math.atan(dy / dx)
    line:SetTransformRotationZ(-angle)
end

-- =============================================================================
-- PUBLIC FUNCTIONS
-- =============================================================================
function WM.CreateLineUI()
    -- Create render space control
    renderCtrl = WINDOW_MANAGER:CreateControl(WM.name .. "RenderCtrl", GuiRoot, CT_CONTROL)
    renderCtrl:SetAnchorFill(GuiRoot)
    renderCtrl:Create3DRenderSpace()
    renderCtrl:SetHidden(true)
    
    -- Create parent window for line
    lineWindow = WINDOW_MANAGER:CreateTopLevelWindow(WM.name .. "LineWin")
    lineWindow:SetClampedToScreen(true)
    lineWindow:SetMouseEnabled(false)
    lineWindow:SetMovable(false)
    lineWindow:SetAnchorFill(GuiRoot)
    lineWindow:SetDrawLayer(DL_BACKGROUND)
    lineWindow:SetDrawTier(DT_LOW)
    lineWindow:SetDrawLevel(0)
    
    -- Create line control
    line = WINDOW_MANAGER:CreateControl(WM.name .. "Line", lineWindow, CT_CONTROL)
    backdrop = WINDOW_MANAGER:CreateControl(WM.name .. "LineBackdrop", line, CT_BACKDROP)
    backdrop:SetAnchorFill()
    backdrop:SetCenterColor(0, 1, 0, 1)
    backdrop:SetEdgeColor(0, 1, 0, 1)
    
    line:SetHidden(true)
    
    -- Add to HUD fragments
    local frag = ZO_HUDFadeSceneFragment:New(lineWindow)
    HUD_UI_SCENE:AddFragment(frag)
    HUD_SCENE:AddFragment(frag)
end

function WM.DrawLineToTarget()
    if not WM.savedVars.enableLine then
        WM.RemoveLine()
        return
    end
    
    if not DoesUnitExist("reticleover") then
        WM.RemoveLine()
        return
    end
    
    if not line then return end
    
    line:SetHidden(false)
    
    -- Get player position (at chest height)
    local _, pX, pY, pZ = GetUnitRawWorldPosition("player")
    local playerX, playerY, playerInFront = GetViewCoordinates(pX, pY + 100, pZ)
    
    -- Get target position (at chest height)
    local _, tX, tY, tZ = GetUnitRawWorldPosition("reticleover")
    local targetX, targetY, targetInFront = GetViewCoordinates(tX, tY + 100, tZ)
    
    -- Only draw if at least one point is in front of camera
    if not playerInFront and not targetInFront then
        line:SetHidden(true)
        return
    end
    
    DrawLineBetweenPoints(playerX, playerY, targetX, targetY)
end

function WM.RemoveLine()
    if line then
        line:SetHidden(true)
    end
end




