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
  local NickTag = _G.NickTag;


--- ============================ CONTENT ============================
  -- Override NickTag SetName  
  if NickTag then
    local CONST_INDEX_NICKNAME = 1;
    --> set the "player" nickname and schedule for send updated persona
    function NickTag:SetNickname (name)
      --> check data before
      assert (type (name) == "string", "NickTag 'SetNickname' expects a string on #1 argument.");
      
      --> get player serial, note that serials are unique between battlegroups and we are using serial instead of full GUID just for reduce memory usage, 
      --> e.g guids are strings with 18 characters, serials are 8 digits number (or 9).
      local battlegroup_serial = NickTag:GetSerial();
      if (not battlegroup_serial) then
        return;
      end
      
      --> get the full nick table.
      local nick_table = NickTag:GetNicknameTable (battlegroup_serial);
      if (not nick_table) then
        nick_table = NickTag:Create (battlegroup_serial, true);
      end
      
      --> change the nickname for the player nick table.
      if (nick_table [CONST_INDEX_NICKNAME] ~= name) then
        nick_table [CONST_INDEX_NICKNAME] = name;
        
        --> send the update for script which need it.
        NickTag.callbacks:Fire ("NickTag_Update", CONST_INDEX_NICKNAME);
        
        --> schedule a update for revision and broadcast full persona.
        --> this is a kind of protection for scripts which call SetNickname, SetColor and SetAvatar one after other, so scheduling here avoid three revisions upgrades and 3 broadcasts to the guild.			
        if (not NickTag.send_scheduled) then
          NickTag.send_scheduled = true;
          NickTag:ScheduleTimer ("SendPersona", 1);
        end
      end
      
      return true;
    end

    for k, v in pairs (NickTag.embeds) do
      NickTag:Embed(k);
    end
  end
