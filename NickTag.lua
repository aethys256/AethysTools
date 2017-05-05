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
  
  -- File Locals
  local NickTag = _G.NickTag;


--- ============================ CONTENT ============================
  if NickTag then
    -- Bypass Details NickTag CheckName by overriding CheckName
    -- Do not abuse it :P
    function NickTag:CheckName (name)
      return true;
    end
  end
