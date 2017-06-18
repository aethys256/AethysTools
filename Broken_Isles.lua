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
  local stringlower = string.lower;
  -- File Locals
  local NickTag = _G.NickTag;


--- ============================ CONTENT ============================
  -- Print with AT Prefix
  function AT.Print (...)
    print("[|cFFFF6600Aethys Tools|r]", ...);
  end
  -- Command Handler
  local Argument1, Argument2, Argument3;
  function AT.CmdHandler (Message)
    Argument1, Argument2, Argument3 = strsplit(" ", stringlower(Message));
    if Argument1 == "bi" then
      local Name, State, Time;
      for i = 1, 4 do
        Name = C_ContributionCollector.GetName(i);
        if Name ~= "" then
          State, _, Time = C_ContributionCollector.GetState(i);
          AT.Print(Name, ":"
            ,State == 2 and"Attack"
            or State == 3 and"Destroyed"
            or State == 4 and "Reset"
            or "Building"
            ,Time and date("%a %d %b %X", Time) or "");
        end
      end
    elseif Argument1 == "help" then
      AT.Print("|cffffff00--[Infos]--|r");
      AT.Print("  BrokenIsles: |cff8888ff/aet bi|r");
      AT.Print("  Button Anchor Reset : |cff8888ff/aer resetbuttons|r");
    else
      AT.Print("Invalid arguments.");
      AT.Print("Type |cff8888ff/aet help|r for more infos.");
    end
  end
  SLASH_AETHYSTOOLS1 = "/aet"
  SLASH_AETHYSTOOLS2 = "/at"
  SlashCmdList["AETHYSTOOLS"] = AT.CmdHandler;
