local addonName, ns = ...
local NT = ns.NT
local L = ns.L
local LSM = LibStub("LibSharedMedia-3.0")

local defaults = {
  showMouse = false,
  scale = 1.0,
  showItemLevel = false,
  showSpellId = false,
  showNpcId = false,
  showIconId = false,
  showTarget = true,
  borderSize = 1,
  headerFont = "Poppins Bold",
  bodyFont = "Poppins Regular",
  fontSize = 12,
  showTitle = true,
  borderColor = "FF0F0F0F",
}

local function GetFontOptions()
  local container = Settings.CreateControlTextContainer()
  for _, fontName in ipairs(LSM:List("font")) do
    container:Add(fontName, fontName)
  end
  return container:GetData()
end

local function GetColorOptions()
  local container = Settings.CreateControlTextContainer()
  container:Add("FF000000", "Black")
  container:Add("FFFFFFFF", "White")
  container:Add("FFFF0000", "Red")
  container:Add("FF00FF00", "Green")
  container:Add("FF0000FF", "Blue")
  container:Add("FFFFFF00", "Yellow")
  container:Add("FF00FFFF", "Cyan")
  container:Add("FFFF00FF", "Magenta")
  container:Add("FF0F0F0F", "Dark Gray (Default)")
  return container:GetData()
end

function NT:InitializeOptions()
  -- Simple defaults merging
  for k, v in pairs(defaults) do
    if NoobTacoToolTipDB[k] == nil then
      NoobTacoToolTipDB[k] = v
    end
  end

  -- Context: Fix for "CreateColorFromHexString" error
  -- Migration: Convert old table 'borderColor' to hex string
  if type(NoobTacoToolTipDB.borderColor) == "table" then
    local c = NoobTacoToolTipDB.borderColor
    -- Ensure we have valid numbers
    if c.r and c.g and c.b then
      local color = CreateColor(c.r, c.g, c.b, c.a or 1)
      NoobTacoToolTipDB.borderColor = color:GenerateHexColor()
    else
      -- Fallback if table is malformed
      NoobTacoToolTipDB.borderColor = defaults.borderColor
    end
  end

  -- Register Settings in the modern system
  local category, layout = Settings.RegisterVerticalLayoutCategory("|cffD78144NoobTaco|r|cffF8F9FAToolTip|r")

  -- Appearance Section
  layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Appearance"))

  -- Scale
  local setting = Settings.RegisterAddOnSetting(category, "NT_TOOLTIP_SCALE", "scale", NoobTacoToolTipDB,
    type(defaults.scale), L["SCALE_NAME"], defaults.scale)
  local options = Settings.CreateSliderOptions(0.5, 2.0, 0.05)
  Settings.CreateSlider(category, setting, options, L["SCALE_DESC"])

  -- Border Size
  setting = Settings.RegisterAddOnSetting(category, "NT_BORDER_SIZE", "borderSize", NoobTacoToolTipDB,
    type(defaults.borderSize), L["BORDER_SIZE_NAME"], defaults.borderSize)
  options = Settings.CreateSliderOptions(1, 5, 1)
  Settings.CreateSlider(category, setting, options, L["BORDER_SIZE_DESC"])

  -- Border Color
  setting = Settings.RegisterAddOnSetting(category, "NT_BORDER_COLOR", "borderColor", NoobTacoToolTipDB,
    type(defaults.borderColor), L["BORDER_COLOR_NAME"], defaults.borderColor)

  Settings.CreateDropdown(category, setting, GetColorOptions, L["BORDER_COLOR_DESC"])

  -- Header Font
  setting = Settings.RegisterAddOnSetting(category, "NT_HEADER_FONT", "headerFont", NoobTacoToolTipDB,
    type(defaults.headerFont), "Header Font", defaults.headerFont)
  Settings.CreateDropdown(category, setting, GetFontOptions, "Select the font for the tooltip header.")

  -- Body Font
  setting = Settings.RegisterAddOnSetting(category, "NT_BODY_FONT", "bodyFont", NoobTacoToolTipDB,
    type(defaults.bodyFont), "Body Font", defaults.bodyFont)
  Settings.CreateDropdown(category, setting, GetFontOptions, "Select the font for the tooltip body text.")

  -- Features Section
  layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Features"))

  -- Show at Mouse
  setting = Settings.RegisterAddOnSetting(category, "NT_SHOW_MOUSE", "showMouse", NoobTacoToolTipDB,
    type(defaults.showMouse), L["SHOW_MOUSE_NAME"], defaults.showMouse)
  Settings.CreateCheckbox(category, setting, L["SHOW_MOUSE_DESC"])

  -- Item Level
  setting = Settings.RegisterAddOnSetting(category, "NT_SHOW_ITEM_LEVEL", "showItemLevel", NoobTacoToolTipDB,
    type(defaults.showItemLevel), "Show Item Level", defaults.showItemLevel)
  Settings.CreateCheckbox(category, setting, "Displays the item level on item and player tooltips.")

  -- Spell ID
  setting = Settings.RegisterAddOnSetting(category, "NT_SHOW_SPELL_ID", "showSpellId", NoobTacoToolTipDB,
    type(defaults.showSpellId), "Show Spell ID", defaults.showSpellId)
  Settings.CreateCheckbox(category, setting, "Displays the spell ID on spell tooltips.")

  -- NPC ID
  setting = Settings.RegisterAddOnSetting(category, "NT_SHOW_NPC_ID", "showNpcId", NoobTacoToolTipDB,
    type(defaults.showNpcId), "Show NPC ID", defaults.showNpcId)
  Settings.CreateCheckbox(category, setting, "Displays the NPC ID on unit tooltips.")

  -- Icon ID
  setting = Settings.RegisterAddOnSetting(category, "NT_SHOW_ICON_ID", "showIconId", NoobTacoToolTipDB,
    type(defaults.showIconId), "Show Icon ID", defaults.showIconId)
  Settings.CreateCheckbox(category, setting, "Displays the Icon ID on tooltips.")

  -- Target
  setting = Settings.RegisterAddOnSetting(category, "NT_SHOW_TARGET", "showTarget", NoobTacoToolTipDB,
    type(defaults.showTarget), "Show Target", defaults.showTarget)
  Settings.CreateCheckbox(category, setting, "Displays the unit's target.")

  -- Show Title
  setting = Settings.RegisterAddOnSetting(category, "NT_SHOW_TITLE", "showTitle", NoobTacoToolTipDB,
    type(defaults.showTitle), L["SHOW_TITLE_NAME"], defaults.showTitle)
  Settings.CreateCheckbox(category, setting, L["SHOW_TITLE_DESC"])

  Settings.RegisterAddOnCategory(category)
end
