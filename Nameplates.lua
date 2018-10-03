--- ============================ HEADER ============================
--- ======= LOCALIZE =======
  -- Addon
    local addonName, AT = ...;
    -- HeroLib
    local HL = HeroLib;
    local Cache = HeroCache;
    local Unit = HL.Unit;
    local Player = Unit.Player;
    local Target = Unit.Target;
    local Spell = HL.Spell;
    local Item = HL.Item;
    -- Lua
    local pairs = pairs;
    local stringformat = string.format;
    local tostring = tostring;
    -- File Locals
    local NameplateUnits = Unit["Nameplate"];
    AT.Nameplate = {
        TTD = {}
    };


--- ============================ CONTENT ============================
--- ======= TTD TEXT =======
    -- Add TTD Infos to Nameplates
    function AT.Nameplate.AddTTD ()
      AT.Nameplate.HideTTD();
      local useElvUINameplates = ElvUI and ElvUI[1].NamePlates; -- check if ElvUI is used and the nameplates module is enabled
      local ThisUnit, Nameplate;
      local IsInInstancedPvP = Player:IsInInstancedPvP();
      for i = 1, HL.MAXIMUM do
        ThisUnit = NameplateUnits["nameplate" .. i];
        Nameplate = C_NamePlate.GetNamePlateForUnit(ThisUnit:ID());
        if Nameplate then
          -- Update TTD
          if Nameplate.UnitFrame.unitExists or useElvUINameplates then
            local Frame = AT.Nameplate.TTD[Nameplate:GetName()];
            -- Init Frame if not already
            if not Frame then
              Frame = Nameplate:CreateFontString(string.format("%s%d", "AethysTools_TTD_NamePlate", i), UIParent, "GameFontHighlightSmallOutline");
              Frame:SetJustifyH("CENTER");
              Frame:SetJustifyV("CENTER");
              Frame:SetText("");
              AT.Nameplate.TTD[Nameplate:GetName()] = Frame;
            end

            if IsInInstancedPvP then
              Frame:SetText("");
            else
              Frame:SetText(((ThisUnit:TimeToDie() == 6666 and AT.GUISettings.Nameplates.TTD.showINF) and "INF")
                          or (ThisUnit:TimeToDie() < 6666 and stringformat("%d", ThisUnit:TimeToDie()))
                          or "");
            end
            if not Frame:IsVisible() then
              if useElvUINameplates then
                Frame:SetPoint("LEFT", Nameplate.unitFrame.HealthBar, "RIGHT", AT.GUISettings.Nameplates.TTD.XOffsetElvUI, AT.GUISettings.Nameplates.TTD.YOffsetElvUI*(Nameplate.unitFrame.HealthBar.currentScale or 1));
                local filename, fontHeight, flags = Nameplate.unitFrame.HealthBar.text:GetFont();
                Frame:SetFont(filename, fontHeight * Nameplate.unitFrame.HealthBar.currentScale or 1, flags);
              else
                Frame:SetPoint("LEFT", Nameplate.UnitFrame.name, "CENTER", (Nameplate.UnitFrame.healthBar:GetWidth()/2)+AT.GUISettings.Nameplates.TTD.XOffset, AT.GUISettings.Nameplates.TTD.YOffset);
              end
              Frame:Show();
            end
          end
        end
      end
    end

    -- Hide the TTD Text
    function AT.Nameplate.HideTTD ()
      for Key, Value in pairs(AT.Nameplate.TTD) do
        -- Hide the FontString if it is visible
        if Value:IsVisible() then Value:Hide(); end
      end
    end
