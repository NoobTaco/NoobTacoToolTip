local addonName, ns = ...
local L = setmetatable({}, {
  __index = function(t, k)
    local v = tostring(k)
    rawset(t, k, v)
    return v
  end
})

ns.L = L

-- Default Locale (English)
if GetLocale() == "enUS" or GetLocale() == "enGB" then
  L["SHOW_MOUSE_NAME"] = "Show at Mouse"
  L["SHOW_MOUSE_DESC"] = "Show tooltip at mouse cursor."
  L["SCALE_NAME"] = "Tooltip Scale"
  L["SCALE_DESC"] = "Adjust the scale of the tooltip."
  L["ITEM_LEVEL"] = "Item Level: |cffffffff%d|r"
  L["GUILD"] = "Guild: %s"
  L["TARGET"] = "Target: %s"
  L["TARGET_LABEL"] = "Target:"
  L["NPC_ID"] = "NPC ID: %d"
  L["ICON_ID"] = "Icon ID: %d"
  L["SPELL_ID"] = "Spell ID: %d"
  L["FONT_NAME"] = "Font"
  L["FONT_DESC"] = "Choose the font for the tooltip."
  L["BORDER_SIZE_NAME"] = "Border Size"
  L["BORDER_SIZE_DESC"] = "Set the border size (1 for single pixel)."
  L["SHOW_TITLE_NAME"] = "Show Player Title"
  L["SHOW_TITLE_DESC"] = "Toggle the display of player titles in tooltips."
  L["BORDER_COLOR_NAME"] = "Border Color"
  L["BORDER_COLOR_DESC"] = "Set the color of the tooltip border."
  L["BG_TEXTURE_NAME"] = "Background Texture"
  L["BG_TEXTURE_DESC"] = "Select the background texture for the tooltip."
end

-- Add more locales here as needed (deDE, frFR, etc.)
