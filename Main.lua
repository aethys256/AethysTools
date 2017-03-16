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
    if AC.GetTime(true) > AT.Timer.Pulse then
      AT.Timer.Pulse = AC.GetTime() + AC.Timer.PulseOffset; 

      if AT.GUISettings.Nameplates.TTD.Enabled and AC.GetTime() > AT.Timer.TTD then
        AT.Timer.TTD = AC.Timer.TTD;
        AT.Nameplate.AddTTD();
      end
    end
  end

  -- Register the Pulse
  AT.MainFrame:SetScript("OnUpdate", AT.Pulse);
