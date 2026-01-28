-- Luacheck configuration for NoobTacoToolTip
-- This file configures luacheck to properly check World of Warcraft addon code

-- Exclude external library files from checking
exclude_files = {
  "Libraries/**",
  ".release/**",
}

-- Define global variables available in WoW addon environment
globals = {
  "LibStub",
  -- SavedVariables
  "NoobTacoToolTipDB",
  -- Addon Compartment Functions
  "NoobTacoToolTip_OnAddonCompartmentClick",
  "NoobTacoToolTip_OnAddonCompartmentEnter",
  "NoobTacoToolTip_OnAddonCompartmentLeave",
  -- Slash command globals
  "SLASH_NTTOOLTIP1", "SLASH_NTTOOLTIP2",
  "SlashCmdList", -- Slash command handler table (writable)
  -- Configuration menu globals
  "NoobTacoDB",
}

-- Allow access to WoW API globals (read-only)
read_globals = {
  -- Common WoW API functions and globals
  "CreateFrame", "UIParent", "GameFontNormal", "GameFontHighlight", "GameTooltipText",
  "GetAddOnMetadata", "Mixin", "C_AddOns",
  "Settings",                 -- New settings system
  "Interface", "AddOns",      -- Path components used in file paths
  "print", "string", "table", -- Standard Lua functions available in WoW
  "PlaySoundFile", "C_Timer",
  "ReloadUI", "GetBuildInfo", "StaticPopup_Show", "CopyToClipboard",
}

-- Ignore some patterns that are common/acceptable in WoW addons
ignore = {
  "113", -- Accessing undefined variable (handled by globals above)
  "631", -- Line is too long (we'll use max_line_length instead)
  "211", -- Unused local variable (sometimes needed for API compatibility)
  "212", -- Unused argument (common in event handlers)
  "112", -- Mutating undefined variable (handled by globals)
  "311", -- Value assigned to a local variable is unused
  "431", -- Shadowing upvalue argument (very common in WoW addon callbacks)
  "432", -- Shadowing upvalue (common in nested functions)
  "213", -- Unused loop variable (common in WoW API iteration)
  "141", -- Setting non-standard global variable (needed for WoW addon globals)
  "542", -- Empty if branch (common in WoW addon initialization)
}

-- Set standards for Lua 5.1 (used by WoW)
std = "lua51"

-- Line length limits (reasonable for addon development)
max_line_length = 120
