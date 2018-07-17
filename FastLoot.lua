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
  
  -- File Locals
  


--- ============================ CONTENT ============================
  -- Fast Loot
  if AT.GUISettings.FastLootEnabled then
    -- Disable Default Auto Loot
    SetCVar("autoLootDefault", 0);

    local LootSlotHasItem, LootSlot = LootSlotHasItem, LootSlot;
    local function GetLoots ()
      local EmptySlot = 0;
      for i = 1, GetNumLootItems() do
        if LootSlotHasItem(i) then
          LootSlot(i);
        else
          EmptySlot = EmptySlot + 1;
        end
      end
      return EmptySlot;
    end
    HL:RegisterForEvent(
      function ()
        if not IsShiftKeyDown() then
          -- Window Close fallback in case the game forgot to do it on an empty window.
          if GetLoots() == GetNumLootItems() then
            CloseLoot(); 
          end
        end
      end
      , "LOOT_OPENED"
    );
    HL:RegisterForEvent(
      function (Event, MessageType, Message)
        if Message == ERR_OBJECT_IS_BUSY then
          GetLoots();
        end
      end
      , "UI_ERROR_MESSAGE"
    );
  end
