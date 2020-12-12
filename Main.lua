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
  -- File Locals


--- ======= GLOBALIZE =======
  -- Addon
  AethysTools = AT;


--- ============================ CONTENT ============================
  -- Create the MainFrame
  AT.MainFrame = CreateFrame("Frame", "AethysTools_MainFrame", UIParent);

  -- Main
  AT.Timer = {
    Pulse = 0,
    TTD = 0
  };
  function AT.Pulse ()
    if GetTime(true) > AT.Timer.Pulse then
      AT.Timer.Pulse = GetTime() + HL.Timer.PulseOffset;

      if AT.GUISettings.Nameplates.TTD.Enabled and GetTime() > AT.Timer.TTD then
        AT.Timer.TTD = HL.Timer.TTD;
        AT.Nameplate.AddTTD();
      end
    end
  end

  -- Register the Pulse
  AT.MainFrame:SetScript("OnUpdate", AT.Pulse);
