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
    local UnitClassification = UnitClassification
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
      local useKuiNameplates = KuiNameplates and true;
      local useElvUINameplates = ElvUI and ElvUI[1].NamePlates; -- check if ElvUI is used and the nameplates module is enabled
      local ThisUnit, Nameplate;
      local IsInInstancedPvP = Player:IsInInstancedPvP();
      local TargetGUID = Target:GUID();
      local TTDSettings = AT.GUISettings.Nameplates.TTD;
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
              local filename, fontHeight, flags = Frame:GetFont();
              Frame:SetFont(filename, fontHeight * TTDSettings.ScaleFac, flags);
              Frame:SetJustifyH("CENTER");
              Frame:SetJustifyV("CENTER");
              Frame:SetText("");
              AT.Nameplate.TTD[Nameplate:GetName()] = Frame;
            end

            if IsInInstancedPvP then
              Frame:SetText("");
            else
              Frame:SetText(((ThisUnit:TimeToDie() == 6666 and TTDSettings.ShowINF) and "INF")
                          or (ThisUnit:TimeToDie() < 6666 and stringformat("%d", ThisUnit:TimeToDie()))
                          or "");
            end

            if useKuiNameplates then
              local XOffset, YOffset;
              if UnitClassification(ThisUnit:ID()) == "minus" then
                if TargetGUID and ThisUnit:GUID() == TargetGUID then
                  XOffset = TTDSettings.XMinusTargetOffsetKui;
                  YOffset = TTDSettings.YMinusTargetOffsetKui;
                else
                  XOffset = TTDSettings.XMinusOffsetKui;
                  YOffset = TTDSettings.YMinusOffsetKui;
                end
              else
                if TargetGUID and ThisUnit:GUID() == TargetGUID then
                  XOffset = TTDSettings.XTargetOffsetKui;
                  YOffset = TTDSettings.YTargetOffsetKui;
                else
                  XOffset = TTDSettings.XOffsetKui;
                  YOffset = TTDSettings.YOffsetKui;
                end
              end
              Frame:SetPoint("LEFT", Nameplate.UnitFrame.name, "CENTER", (Nameplate.UnitFrame.healthBar:GetWidth()/2)+XOffset, YOffset);

              if not Frame:IsVisible() then Frame:Show(); end
            elseif not Frame:IsVisible() then
              if useElvUINameplates then
                Frame:SetPoint("LEFT", Nameplate.unitFrame.HealthBar, "RIGHT", TTDSettings.XOffsetElvUI, TTDSettings.YOffsetElvUI*(Nameplate.unitFrame.HealthBar.currentScale or 1));
                local filename, fontHeight, flags = Nameplate.unitFrame.HealthBar.text:GetFont();
                Frame:SetFont(filename, fontHeight * Nameplate.unitFrame.HealthBar.currentScale or 1, flags);
              else
                Frame:SetPoint("LEFT", Nameplate.UnitFrame.name, "CENTER", (Nameplate.UnitFrame.healthBar:GetWidth()/2)+TTDSettings.XOffset, TTDSettings.YOffset);
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
