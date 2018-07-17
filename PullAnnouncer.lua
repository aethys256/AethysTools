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
  local CombatTime, OutCombatTime = 0, 0;
  local Pulled, Roster = {}, {};
  local SpecialSpells = {
    -- Taunt
    [355] = true,       -- Warrior - Taunt
    [62124] = true,     -- Paladin - Reckoning
    [20736] = true,     -- Hunter - Distracting Shot
    [56222] = true,     -- DK - Dark Command
    [115546] = true,    -- Monk - Provoke
    [6795] = true,      -- Druid - Growl
    [185245] = true,    -- DH - Torment
    -- Silence/Interrupt
    [6552] = true,      -- Warrior - Pummel
    [96231] = true,     -- Paladin - Rebuke
    [147362] = true,    -- Hunter - Counter Shot
    [1766] = true,      -- Rogue - Kick
    [47476] = true,     -- DK - Strangulate
    [47528] = true,     -- DK - Mindfreeze
    [183752] = true,    -- DH - Consume Magic
    -- Debuff
    [45524] = true,     -- DK - Chains of Ice
    [49576] = true,     -- DK - Death Grip
    [77606] = true,     -- DK - Dark Simulacrum
    -- Channel
    [117952] = true     -- Monk - Crackling Jade Lightning
  };


--- ============================ CONTENT ============================
  -- Functions to send the message.
  local function Output (Message, Channel)
    local BossModTime = HL.BossModTime or 0;
    local BossModEndTime = HL.BossModEndTime or 0;
    if BossModTime ~= 0 and BossModEndTime-GetTime() >= -1 then
      if Channel then
        SendChatMessage(Message .. " at " .. string.format("%0.2f", BossModEndTime-GetTime()) .. "s.", Channel);
      else
        print(Message .. " at " .. string.format("%0.2f", BossModEndTime-GetTime()) .. "s.");
      end
    else
      if Channel then
        SendChatMessage(Message .. ".", Channel);
      else
        print(Message .. ".");
      end
    end
  end
  local function Announce (Message)
    local Channel = AT.GUISettings.PullAnnouncer.Channel;
    if Channel == "AUTO" then
      if IsInGroup(LE_PARTY_CATEGORY_HOME) then
        if IsInRaid() then
          Output(Message, "RAID");
        else
          Output(Message, "PARTY");
        end
      else
        Output(Message);
      end
    elseif Channel == "AUTOX" then
      if IsInGroup() then
        if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
          Output(Message, "INSTANCE_CHAT");
        elseif IsInRaid() then
          Output(Message, "RAID");
        else
          Output(Message, "PARTY");
        end
      else
        Output(Message);
      end
    elseif Channel == "LOCAL" then
      Output(Message);
    elseif Channel == "SAY" or Channel == "YELL" or Channel == "PARTY" or Channel == "GUILD" or Channel == "OFFICER" or Channel == "RAID" or Channel == "RAID_WARNING" or Channel == "INSTANCE_CHAT" then
      Output(Message, Channel);
    else
      print("[WA_PullAnnoucer] Wrong channel set in the Init Section.");
    end
    CombatTime = CombatTime - 3;
    return;
  end

  -- Events listener
  -- PLAYER_REGEN_DISABLED
    -- Allow further Checks when going in combat.
    HL:RegisterForEvent(
      function ()
        CombatTime = GetTime() + 2;
      end
      , "PLAYER_REGEN_DISABLED"
    );

  -- PLAYER_REGEN_ENABLED
    -- Prevent further Checks when going out of combat.
    HL:RegisterForEvent(
      function ()
        OutCombatTime = GetTime() + 5;
        Pulled = {};
      end
      , "PLAYER_REGEN_ENABLED"
    );

  -- RAID_INSTANCE_WELCOME & GROUP_ROSTER_UPDATE
    -- Update the Group Roster if the mode is set to Group.
    HL:RegisterForEvent(
      function ()
        if AT.GUISettings.PullAnnouncer.FromWho == "GROUP" then
          Roster = {};
          if IsInGroup() then
            local Type, Name, Server;
            if IsInRaid() then Type = "Raid"; else Type = "Party"; end
            for i = 1, GetNumGroupMembers() do
              Name, Server = UnitName(Type..i);
              if Name then
                Roster[Server and Server ~= "" and Name.."-"..Server or Name] = true;
              end
            end
          else
            Roster[UnitName("Player")] = true;
          end
        end
      end
      , "RAID_INSTANCE_WELCOME"
      , "GROUP_ROSTER_UPDATE"
    );

  -- COMBAT_LOG_EVENT_UNFILTERED"
    -- Pull Check Handler
    -- TODO: Optimizations!
    HL:RegisterForCombatEvent(
      function (TimeStamp, CombatEvent, _, SourceGUID, SourceName, SourceFlags, _, DestGUID, DestName, DestFlags, _, SpellID, SpellName)
        if AT.GUISettings.PullAnnouncer.Difficulty[Player:InstanceDifficulty()] then
          if GetTime() >= OutCombatTime and not Player:IsDeadOrGhost() and (not Player:AffectingCombat() or GetTime() <= CombatTime)
            and SourceName and DestName and SourceName ~= DestName and (AT.GUISettings.PullAnnouncer.FromWho == "ALL" or Roster[SourceName] or Roster[DestName])
            and not string.find(CombatEvent, "PERIODIC")
            and (string.find(CombatEvent, "_DAMAGE") or string.find(CombatEvent, "_MISSED") or string.find(CombatEvent, "CAST_SUCCESS")) then
            -- Player Attack
            if bit.band(SourceFlags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0 and bit.band(DestFlags, COMBATLOG_OBJECT_TYPE_NPC) ~= 0 then
              if not Pulled[DestGUID] then
                if string.find(CombatEvent, "SWING") then
                  Pulled[DestGUID] = true;
                  Announce(SourceName.." pulled "..DestName.." with Auto Attack");
                  return;
                elseif not string.find(CombatEvent, "CAST_SUCCESS") or SpecialSpells[SpellID] then
                  Pulled[DestGUID] = true;
                  Announce(SourceName.." pulled "..DestName.." with "..SpellName);
                  return;
                end
              end
            -- Body Pull
            elseif bit.band(DestFlags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0 and bit.band(SourceFlags, COMBATLOG_OBJECT_TYPE_NPC) ~= 0 then
                if not Pulled[SourceGUID] then
                  Pulled[SourceGUID] = true;
                  Announce(DestName.." body pulled "..SourceName);
                  return;
                end
            -- Pet Attack
            elseif bit.band(SourceFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) ~= 0 and bit.band(DestFlags, COMBATLOG_OBJECT_TYPE_NPC) ~= 0 then
              if not Pulled[DestGUID] then
                Pulled[DestGUID] = true;
                Announce(SourceName.."(Pet) pulled "..DestName);
                return;
              end
            -- Pet Body Pull
            elseif bit.band(SourceFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) ~= 0 and bit.band(SourceFlags, COMBATLOG_OBJECT_TYPE_NPC) ~= 0 then
              if not Pulled[SourceGUID] then
                Pulled[SourceGUID] = true;
                Announce(DestName.."(Pet) body pulled "..SourceName);
                return;
              end
            end
          end
        end
      end
      , "CAST_SUCCESS"
    );

    HL:RegisterForCombatSuffixEvent(
      function (TimeStamp, CombatEvent, _, SourceGUID, SourceName, SourceFlags, _, DestGUID, DestName, DestFlags, _, SpellID, SpellName)
        if AT.GUISettings.PullAnnouncer.Difficulty[Player:InstanceDifficulty()] then
          if GetTime() >= OutCombatTime and not Player:IsDeadOrGhost() and (not Player:AffectingCombat() or GetTime() <= CombatTime)
            and SourceName and DestName and SourceName ~= DestName and (AT.GUISettings.PullAnnouncer.FromWho == "ALL" or Roster[SourceName] or Roster[DestName])
            and not string.find(CombatEvent, "PERIODIC")
            and (string.find(CombatEvent, "_DAMAGE") or string.find(CombatEvent, "_MISSED") or string.find(CombatEvent, "CAST_SUCCESS")) then
            -- Player Attack
            if bit.band(SourceFlags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0 and bit.band(DestFlags, COMBATLOG_OBJECT_TYPE_NPC) ~= 0 then
              if not Pulled[DestGUID] then
                if string.find(CombatEvent, "SWING") then
                  Pulled[DestGUID] = true;
                  Announce(SourceName.." pulled "..DestName.." with Auto Attack");
                  return;
                elseif not string.find(CombatEvent, "CAST_SUCCESS") or SpecialSpells[SpellID] then
                  Pulled[DestGUID] = true;
                  Announce(SourceName.." pulled "..DestName.." with "..SpellName);
                  return;
                end
              end
            -- Body Pull
            elseif bit.band(DestFlags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0 and bit.band(SourceFlags, COMBATLOG_OBJECT_TYPE_NPC) ~= 0 then
                if not Pulled[SourceGUID] then
                  Pulled[SourceGUID] = true;
                  Announce(DestName.." body pulled "..SourceName);
                  return;
                end
            -- Pet Attack
            elseif bit.band(SourceFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) ~= 0 and bit.band(DestFlags, COMBATLOG_OBJECT_TYPE_NPC) ~= 0 then
              if not Pulled[DestGUID] then
                Pulled[DestGUID] = true;
                Announce(SourceName.."(Pet) pulled "..DestName);
                return;
              end
            -- Pet Body Pull
            elseif bit.band(SourceFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) ~= 0 and bit.band(SourceFlags, COMBATLOG_OBJECT_TYPE_NPC) ~= 0 then
              if not Pulled[SourceGUID] then
                Pulled[SourceGUID] = true;
                Announce(DestName.."(Pet) body pulled "..SourceName);
                return;
              end
            end
          end
        end
      end
      , "_DAMAGE"
      , "_MISSED"
    );
