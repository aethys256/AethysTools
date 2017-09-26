--- ============================ HEADER ============================
--- ======= LOCALIZE =======
  -- Addon
    local addonName, AT = ...;
    -- AethysCore
    local AC = AethysCore;
    local Cache = AethysCache;
    local Unit = AC.Unit;
    local Player = Unit.Player;
    local Target = Unit.Target;
    local Spell = AC.Spell;
    local Item = AC.Item;
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
      local ThisUnit, Nameplate;
      local IsInInstancedPvP = Player:IsInInstancedPvP();
      for i = 1, #NameplateUnits do
        ThisUnit = NameplateUnits[i];
        Nameplate = C_NamePlate.GetNamePlateForUnit(ThisUnit:ID());
        if Nameplate then
          -- Update TTD
          if Nameplate.UnitFrame.unitExists or AT.GUISettings.Nameplates.TTD.useElvUI then
            local Frame = AT.Nameplate.TTD[Nameplate:GetName()];
            -- Init Frame if not already
            if not Frame then
              Frame = Nameplate:CreateFontString(string.format("%s%d", "AethysRotation_TTD_NamePlate", i), UIParent, "GameFontHighlightSmallOutline");
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
			  if AT.GUISettings.Nameplates.TTD.useElvUI then
			    Frame:SetPoint("LEFT", Nameplate.UnitFrame.HealthBar, "RIGHT", AT.GUISettings.Nameplates.TTD.XOffsetElvUI, AT.GUISettings.Nameplates.TTD.YOffsetElvUI*(Nameplate.UnitFrame.HealthBar.currentScale or 1));
				Frame:SetTextHeight(10*(Nameplate.UnitFrame.HealthBar.currentScale or 1));
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
