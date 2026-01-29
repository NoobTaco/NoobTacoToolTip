local addonName, ns = ...
local NT = {}
_G[addonName] = NT
ns.NT = NT

local L = ns.L
NT.Version = C_AddOns and C_AddOns.GetAddOnMetadata(addonName, "Version") or GetAddOnMetadata(addonName, "Version")

function NT:GetItemLevel(data)
  if not data or not data.lines then return end

  -- Try to find item level in tooltip lines first (modern WoW way)
  for _, line in ipairs(data.lines) do
    if line.type == 41 then -- Enum.TooltipDataLineType.ItemLevel
      return line.leftText and tonumber(line.leftText:match("%d+"))
    end
  end

  -- Fallback: Use C_Item.GetDetailedItemLevelInfo if we can get a link
  local hyperlink
  if data.guid then
    hyperlink = C_Item.GetItemLinkByGUID(data.guid)
  elseif data.hyperlink then
    hyperlink = data.hyperlink
  end

  if hyperlink then
    local actualLevel = C_Item.GetDetailedItemLevelInfo(hyperlink)
    return actualLevel
  end
end

function NT:OnTooltipSetData(tooltip, data)
  if not tooltip or tooltip:IsForbidden() then return end

  -- Apply styling
  self:UpdateTooltipStyle(tooltip)

  -- Feature Logic
  local db = NoobTacoToolTipDB

  if data.type == Enum.TooltipDataType.Item then
    if db.showItemLevel then
      local level = self:GetItemLevel(data)
      if level then
        local levelColor = { r = 1, g = 0.82, b = 0 } -- Yellow
        tooltip:AddLine(L["ITEM_LEVEL"]:format(level), levelColor.r, levelColor.g, levelColor.b)
      end
    end

    if db.showIconId and data.id then
      local icon = select(5, C_Item.GetItemInfoInstant(data.id))
      if icon then
        tooltip:AddLine(L["ICON_ID"]:format(icon), 1, 1, 1)
      end
    end
  elseif data.type == Enum.TooltipDataType.Unit then
    local unit = "mouseover"
    if not UnitExists(unit) then return end

    local name = UnitName(unit)
    if db.showTitle and UnitIsPlayer(unit) then
      name = UnitPVPName(unit) or name
    end

    local level = UnitLevel(unit)
    local race = UnitRace(unit)
    local class, classFile = UnitClass(unit)
    local specName = ""

    if UnitIsPlayer(unit) then
      -- Attempt to find spec in the tooltip data lines (more reliable than GetInspectSpecialization)
      if data and data.lines then
        for i = 2, #data.lines do
          local lineData = data.lines[i]
          if lineData and lineData.leftText then
            -- Usually, Blizzard puts "Spec Class" on line 2 or 3
            if lineData.leftText:find(class) then
              specName = lineData.leftText:gsub(class, ""):trim()
              break
            end
          end
        end
      end

      -- Fallback to inspect if data lines didn't help (though rarely needed for mouseover)
      if specName == "" then
        local specID = GetInspectSpecialization(unit)
        if specID and specID > 0 then
          specName = select(2, GetSpecializationInfoByID(specID))
        end
      end
    end

    local classColor = RAID_CLASS_COLORS[classFile] or { r = 1, g = 1, b = 1 }
    local levelColor = { r = 1, g = 0.82, b = 0 } -- Yellow
    local tooltipName = tooltip:GetName()
    if not tooltipName then return end

    -- Line 1: Name (Class colored)
    local line1 = _G[tooltipName .. "TextLeft1"]
    if line1 then
      line1:SetText(name)
      line1:SetTextColor(classColor.r, classColor.g, classColor.b)
    end

    -- Line 2: Level (Yellow) Race (White)
    local line2 = _G[tooltipName .. "TextLeft2"]
    if line2 then
      local levelText = level == -1 and "??" or tostring(level)
      local line2Text = levelText
      if race then
        line2Text = line2Text .. " " .. race
      end
      line2:SetText(line2Text)
      line2:SetTextColor(levelColor.r, levelColor.g, levelColor.b)
    end

    -- Line 3: Spec Class (Class colored)
    local line3 = _G[tooltipName .. "TextLeft3"]
    if line3 then
      local classText = (specName ~= "" and specName .. " " or "") .. class
      line3:SetText(classText)
      line3:SetTextColor(classColor.r, classColor.g, classColor.b)
      line3:Show()
    end

    -- Item Level (White)
    local nextLineIndex = 4
    if db.showItemLevel and UnitIsPlayer(unit) then
      local iLevel
      if UnitIsUnit(unit, "player") then
        iLevel = select(2, GetAverageItemLevel())
      else
        local guid = UnitGUID(unit)
        if guid then
          iLevel = self.lastItemLevel and self.lastItemLevel[guid]
          if not iLevel then
            -- Fallback to search tooltip lines (some addons/Blizzard might put it there)
            if data and data.lines then
              for i = 2, #data.lines do
                local lineData = data.lines[i]
                if lineData and lineData.leftText and lineData.leftText:find(L["ITEM_LEVEL"]:gsub("%%d", "")) then
                  iLevel = tonumber(lineData.leftText:match("%d+"))
                  break
                end
              end
            end
          end

          if not iLevel then
            -- Request inspect if we haven't checked this unit recently
            if not self.lastInspectRequest or (GetTime() - self.lastInspectRequest > 2) then
              if not (InCombatLockdown() or (InspectFrame and InspectFrame:IsShown())) then
                NotifyInspect(unit)
                self.lastInspectRequest = GetTime()
                self.pendingInspectUnit = guid
              end
            end
          end
        end
      end

      if iLevel then
        local line4 = _G[tooltipName .. "TextLeft4"]
        if line4 then
          line4:SetText(L["ITEM_LEVEL"]:format(iLevel))
          line4:SetTextColor(levelColor.r, levelColor.g, levelColor.b)
          line4:Show()
        else
          tooltip:AddLine(L["ITEM_LEVEL"]:format(iLevel), levelColor.r, levelColor.g, levelColor.b)
        end
        nextLineIndex = 5
      end
    end

    -- Target (Yellow)
    local targetLineIndex = nextLineIndex
    if db.showTarget then
      local target = UnitName(unit .. "target")
      if target then
        local line4 = _G[tooltipName .. "TextLeft" .. targetLineIndex]
        if line4 then
          line4:SetText((L["TARGET_LABEL"] or "Target:") .. " " .. target)
          line4:SetTextColor(levelColor.r, levelColor.g, levelColor.b)
          line4:Show()
          targetLineIndex = targetLineIndex + 1
        else
          tooltip:AddLine((L["TARGET_LABEL"] or "Target:") .. " " .. target, levelColor.r, levelColor.g, levelColor.b)
          targetLineIndex = targetLineIndex + 1
        end
      end
    end

    -- Hide everything else (Guild, Alliance, Hints)
    if tooltip.GetNumLines then
      for i = targetLineIndex, tooltip:GetNumLines() do
        local line = _G[tooltipName .. "TextLeft" .. i]
        if line then line:SetText("") end
        local lineR = _G[tooltipName .. "TextRight" .. i]
        if lineR then lineR:SetText("") end
      end
    end

    -- NPC ID
    if db.showNpcId and not UnitIsPlayer(unit) then
      local guid = UnitGUID(unit) or data.guid
      if guid then
        local npcId = select(6, strsplit("-", guid))
        if npcId then
          tooltip:AddLine(L["NPC_ID"]:format(tonumber(npcId)), 1, 1, 1)
        end
      end
    end
  elseif data.type == Enum.TooltipDataType.Spell then
    if db.showSpellId and data.id then
      tooltip:AddLine(L["SPELL_ID"]:format(data.id), 1, 1, 1)
    end
    if db.showIconId and data.id then
      local spellInfo = C_Spell.GetSpellInfo(data.id)
      if spellInfo and spellInfo.iconID then
        tooltip:AddLine(L["ICON_ID"]:format(spellInfo.iconID), 1, 1, 1)
      end
    end
  end
end

function NT:Initialize()
  -- Initialize DB
  if not NoobTacoToolTipDB then
    NoobTacoToolTipDB = {}
  end

  -- Merge defaults and register options
  NT:InitializeOptions()

  -- Hook tooltips
  local types = {
    Enum.TooltipDataType.Item,
    Enum.TooltipDataType.Unit,
    Enum.TooltipDataType.Spell,
    Enum.TooltipDataType.Currency,
    Enum.TooltipDataType.Achievement,
    Enum.TooltipDataType.Quest,
  }

  for _, typeID in ipairs(types) do
    TooltipDataProcessor.AddTooltipPostCall(typeID, function(tooltip, data)
      self:OnTooltipSetData(tooltip, data)
    end)
  end

  -- Hook specialized frames that might not use the standard post-calls consistently
  local frames = {
    GameTooltip,
    ItemRefTooltip,
    ReputationParagonTooltip,
    ShoppingTooltip1,
    ShoppingTooltip2,
  }

  for _, frame in ipairs(frames) do
    if frame then
      frame:HookScript("OnShow", function(tooltip)
        self:UpdateTooltipStyle(tooltip)
      end)
    end
  end

  -- Mouse Anchoring
  hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
    if NoobTacoToolTipDB.showMouse then
      tooltip:SetOwner(parent, "ANCHOR_CURSOR")
    end
  end)

  -- Scale logic
  hooksecurefunc(GameTooltip, "Show", function(tooltip)
    if NoobTacoToolTipDB.scale then
      tooltip:SetScale(NoobTacoToolTipDB.scale)
    end
  end)

  print("|cffD78144NoobTaco|r|cffF8F9FAToolTip|r loaded. Version: " .. (NT.Version or "dev"))
end

local function OnEvent(self, event, ...)
  if event == "ADDON_LOADED" and ... == addonName then
    self:UnregisterEvent("ADDON_LOADED")
    NT:Initialize()
  elseif event == "INSPECT_READY" then
    local guid = ...
    if guid and NT.pendingInspectUnit == guid then
      if not NT.lastItemLevel then NT.lastItemLevel = {} end

      -- Get accurate "stated" iLevel from inspection
      local iLevel = C_PaperDollInfo.GetInspectItemLevel("mouseover")

      if iLevel and iLevel > 0 then
        NT.lastItemLevel[guid] = iLevel
        NT.pendingInspectUnit = nil

        -- Refresh tooltip if mouse is still over the same unit
        if UnitExists("mouseover") and UnitGUID("mouseover") == guid then
          GameTooltip:SetUnit("mouseover")
        end
      end
    end
  end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("INSPECT_READY")
frame:SetScript("OnEvent", OnEvent)

ns.NT = NT
