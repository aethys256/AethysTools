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
    local tostring = tostring;
    -- File Locals
    local FrameID, Nameplate, ThisUnit, Count
    AT.Nameplate = {
        TTD = {}
    };


--- ============================ CONTENT ============================
--- ======= TTD TEXT =======
    -- Add TTD Infos to Nameplates
    function AT.Nameplate.AddTTD ()
        AT.Nameplate.HideTTD();
        for i = 1, AC.MAXIMUM do
            Count = tostring(i);

            Nameplate = C_NamePlate.GetNamePlateForUnit("nameplate"..Count);
            if Nameplate then
            -- Update TTD
            if Nameplate.UnitFrame.unitExists then
                FrameID = Nameplate:GetName();
                -- Init Frame if not already
                if not AT.Nameplate.TTD[FrameID] then
                    AT.Nameplate.TTD[FrameID] = Nameplate:CreateFontString("NamePlate"..Count.."AT-TTD", UIParent, "GameFontHighlightSmallOutline")
                    AT.Nameplate.TTD[FrameID]:SetJustifyH("CENTER");
                    AT.Nameplate.TTD[FrameID]:SetJustifyV("CENTER");
                    AT.Nameplate.TTD[FrameID]:SetText("");
                end
                ThisUnit = Unit["Nameplate"..Count];
                AT.Nameplate.TTD[FrameID]:SetText(ThisUnit:TimeToDie() == 6666 and "INF" or ThisUnit:TimeToDie() < 6666 and tostring(ThisUnit:TimeToDie()) or "");
                if not AT.Nameplate.TTD[FrameID]:IsVisible() then
                    AT.Nameplate.TTD[FrameID]:SetPoint("LEFT", Nameplate.UnitFrame.name, "CENTER", (Nameplate.UnitFrame.healthBar:GetWidth()/2)+AT.GUISettings.Nameplates.TTD.XOffset, AT.GUISettings.Nameplates.TTD.YOffset)
                    AT.Nameplate.TTD[FrameID]:Show();
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
