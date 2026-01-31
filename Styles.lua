local addonName, ns = ...
local NT = ns.NT
local LSM = LibStub("LibSharedMedia-3.0")

-- Register Fonts
LSM:Register("font", "Poppins Regular", [[Interface\AddOns\NoobTacoToolTip\Media\Fonts\Poppins-Regular.ttf]])
LSM:Register("font", "Poppins Bold", [[Interface\AddOns\NoobTacoToolTip\Media\Fonts\Poppins-Bold.ttf]])
LSM:Register("font", "Roboto Regular", [[Interface\AddOns\NoobTacoToolTip\Media\Fonts\Roboto-Regular.ttf]])
LSM:Register("font", "Roboto Bold", [[Interface\AddOns\NoobTacoToolTip\Media\Fonts\Roboto-Bold.ttf]])

-- Register Backgrounds
LSM:Register("background", "Solid", [[Interface\Buttons\WHITE8X8]])
LSM:Register("background", "Blizzard Tooltip", [[Interface\Tooltips\UI-Tooltip-Background]])
LSM:Register("background", "Blizzard Chat", [[Interface\ChatFrame\ChatFrameBackground]])
LSM:Register("background", "Blizzard Dialog", [[Interface\DialogFrame\UI-DialogBox-Background]])
LSM:Register("background", "Blizzard Character", [[Interface\CharacterFrame\UI-CharacterFrame-Background]])
LSM:Register("background", "Blizzard Marble", [[Interface\FrameGeneral\UI-Background-Marble]])
LSM:Register("background", "Blizzard Rock", [[Interface\FrameGeneral\UI-Background-Rock]])
LSM:Register("background", "Blizzard Parchment", [[Interface\AchievementFrame\UI-Achievement-Parchment-Horizontal]])
LSM:Register("background", "Blizzard Parchment 2",
  [[Interface\AchievementFrame\UI-GuildAchievement-Parchment-Horizontal]])

-- Styles Configuration
NT.Styles = {
  Backdrop = {
    bgFile = [[Interface\Buttons\WHITE8X8]],
    edgeFile = [[Interface\Buttons\WHITE8X8]],
    tile = false,
    tileSize = 0,
    edgeSize = 1,
    insets = { left = 1, right = 1, top = 1, bottom = 1 }
  },
  Colors = {
    Border = { r = 0.06, g = 0.06, b = 0.06, a = 1 },
    Background = { r = 0.14, g = 0.15, b = 0.2, a = 0.95 },
  }
}

function NT:StyleHealthBar(tooltip)
  local statusBar = _G[tooltip:GetName() .. "StatusBar"]
  if not statusBar then return end

  if not statusBar.ntStyled then
    statusBar:SetHeight(4)
    statusBar:ClearAllPoints()
    statusBar:SetPoint("BOTTOMLEFT", tooltip, "BOTTOMLEFT", 1, 1)
    statusBar:SetPoint("BOTTOMRIGHT", tooltip, "BOTTOMRIGHT", -1, 1)
    statusBar:SetStatusBarTexture([[Interface\Buttons\WHITE8X8]])

    -- Background for the status bar
    statusBar.ntBg = statusBar:CreateTexture(nil, "BACKGROUND")
    statusBar.ntBg:SetAllPoints()
    statusBar.ntBg:SetTexture([[Interface\Buttons\WHITE8X8]])
    statusBar.ntBg:SetVertexColor(0.05, 0.05, 0.05, 1)

    statusBar.ntStyled = true
  end

  -- Color it green as per template
  statusBar:SetStatusBarColor(0.5, 0.8, 0.4)
end

function NT:UpdateTooltipStyle(tooltip)
  if not tooltip or tooltip:IsForbidden() then return end

  -- Hide default border elements
  if tooltip.SetBackdrop then
    tooltip:SetBackdrop(nil)
  end
  if tooltip.NineSlice then
    tooltip.NineSlice:Hide()
  end
  if tooltip.Background then
    tooltip.Background:Hide()
  end

  -- Apply custom backdrop (manual texture implementation to avoid Backdrop.lua "secret value" bug)
  if not tooltip.ntBackdrop then
    tooltip.ntBackdrop = CreateFrame("Frame", nil, tooltip)
    tooltip.ntBackdrop:SetAllPoints()
    tooltip.ntBackdrop:SetFrameLevel(tooltip:GetFrameLevel() > 0 and tooltip:GetFrameLevel() - 1 or 0)

    -- Background
    tooltip.ntBg = tooltip.ntBackdrop:CreateTexture(nil, "BACKGROUND")
    tooltip.ntBg:SetAllPoints()
    tooltip.ntBg:SetTexture([[Interface\Buttons\WHITE8X8]])

    -- Borders
    tooltip.ntBorderTop = tooltip.ntBackdrop:CreateTexture(nil, "OVERLAY")
    tooltip.ntBorderBottom = tooltip.ntBackdrop:CreateTexture(nil, "OVERLAY")
    tooltip.ntBorderLeft = tooltip.ntBackdrop:CreateTexture(nil, "OVERLAY")
    tooltip.ntBorderRight = tooltip.ntBackdrop:CreateTexture(nil, "OVERLAY")

    local borderTex = [[Interface\Buttons\WHITE8X8]]
    tooltip.ntBorderTop:SetTexture(borderTex)
    tooltip.ntBorderBottom:SetTexture(borderTex)
    tooltip.ntBorderLeft:SetTexture(borderTex)
    tooltip.ntBorderRight:SetTexture(borderTex)
  end

  local db = NoobTacoToolTipDB
  local edgeSize = db.borderSize or 1

  -- Update Border Positions and Sizes
  tooltip.ntBorderTop:SetHeight(edgeSize)
  tooltip.ntBorderTop:SetPoint("TOPLEFT", tooltip, "TOPLEFT")
  tooltip.ntBorderTop:SetPoint("TOPRIGHT", tooltip, "TOPRIGHT")

  tooltip.ntBorderBottom:SetHeight(edgeSize)
  tooltip.ntBorderBottom:SetPoint("BOTTOMLEFT", tooltip, "BOTTOMLEFT")
  tooltip.ntBorderBottom:SetPoint("BOTTOMRIGHT", tooltip, "BOTTOMRIGHT")

  tooltip.ntBorderLeft:SetWidth(edgeSize)
  tooltip.ntBorderLeft:SetPoint("TOPLEFT", tooltip, "TOPLEFT")
  tooltip.ntBorderLeft:SetPoint("BOTTOMLEFT", tooltip, "BOTTOMLEFT")

  tooltip.ntBorderRight:SetWidth(edgeSize)
  tooltip.ntBorderRight:SetPoint("TOPRIGHT", tooltip, "TOPRIGHT")
  tooltip.ntBorderRight:SetPoint("BOTTOMRIGHT", tooltip, "BOTTOMRIGHT")

  -- Update Colors
  local bg = NT.Styles.Colors.Background
  local borderCol = NT.Styles.Colors.Border
  if db.borderColor then
    if type(db.borderColor) == "string" then
      local color = CreateColorFromHexString(db.borderColor)
      borderCol = { r = color.r, g = color.g, b = color.b, a = color.a }
    elseif type(db.borderColor) == "table" and db.borderColor.r then
      borderCol = db.borderColor
    end
  end

  -- Update Background Texture
  local bgTextureName = db.bgTexture or "Solid"
  local bgTex = LSM:Fetch("background", bgTextureName, true) or LSM:Fetch("statusbar", bgTextureName, true) or
  [[Interface\Buttons\WHITE8X8]]
  tooltip.ntBg:SetTexture(bgTex)
  tooltip.ntBg:SetVertexColor(bg.r, bg.g, bg.b, bg.a)

  tooltip.ntBorderTop:SetVertexColor(borderCol.r, borderCol.g, borderCol.b, borderCol.a)
  tooltip.ntBorderBottom:SetVertexColor(borderCol.r, borderCol.g, borderCol.b, borderCol.a)
  tooltip.ntBorderLeft:SetVertexColor(borderCol.r, borderCol.g, borderCol.b, borderCol.a)
  tooltip.ntBorderRight:SetVertexColor(borderCol.r, borderCol.g, borderCol.b, borderCol.a)

  -- Style Health Bar
  self:StyleHealthBar(tooltip)

  -- Crisp Text: Apply Font
  local headerFontName = db.headerFont or "Poppins Bold"
  local bodyFontName = db.bodyFont or "Poppins Regular"

  -- Fallback for migration if user hasn't opened options yet but had old setting
  if not db.headerFont and db.fontName then
    headerFontName = db.fontName
  end
  if not db.bodyFont and db.fontName then
    bodyFontName = db.fontName
  end

  local headerFont = LSM:Fetch("font", headerFontName)
  local bodyFont = LSM:Fetch("font", bodyFontName)

  local fontSize = db.fontSize or 12
  local tooltipName = tooltip:GetName()

  -- Header
  if tooltipName then
    local headerLine = _G[tooltipName .. "TextLeft1"]
    if headerLine then
      headerLine:SetFont(headerFont, fontSize + 2, "OUTLINE")
    end
  end

  -- Body
  if tooltip.GetNumLines and tooltipName then
    for i = 2, tooltip:GetNumLines() do
      local line = _G[tooltipName .. "TextLeft" .. i]
      if line then
        line:SetFont(bodyFont, fontSize, "OUTLINE")
      end
      local lineRight = _G[tooltipName .. "TextRight" .. i]
      if lineRight then
        lineRight:SetFont(bodyFont, fontSize, "OUTLINE")
      end
    end
  end
end
