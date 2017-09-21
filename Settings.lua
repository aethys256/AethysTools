--- ============================ HEADER ============================
--- ======= LOCALIZE =======
  -- Addon
  local addonName, AT = ...;


--- ============================ CONTENT ============================
  -- All settings here should be moved into the GUI someday
  AT.GUISettings = {
    FastLootEnabled = false,
    Nameplates = {
      TTD = {
        Enabled = true,
		useElvUI = false, -- set this if you are using ElvUI nameplates
		showINF = true,
        -- TODO: Make a DB with all "default" offset loaded based on what addon the user has Enabled
        -- TODO: And make a command to input custom offset
        -- Default Nameplate
          --XOffset = 5,
          --YOffset = -11
        -- Kui Nameplate
          XOffset = 16,
          YOffset = -16,
		-- ElvUI Nameplate
          XOffsetElvUI = 5,
          YOffsetElvUI = -16
      }
    },
    PullAnnouncer = {
      -- Set the Tracker Mode, "GROUP" to track mobs pulled by Group Members, "ALL" to track everything.
      -- TODO: Fix "GROUP" :D
      FromWho = "ALL",
      BossModTimerOnly = false, -- TODO
      BossOnly = true, -- TODO
      Difficulty = {
        [0] = false, -- None; not in an Instance.
        [1] = false, -- 5-player Instance.
        [2] = false, -- 5-player Heroic Instance.
        [3] = true, -- 10-player Raid Instance.
        [4] = true, -- 25-player Raid Instance.
        [5] = true, -- 10-player Heroic Raid Instance.
        [6] = true, -- 25-player Heroic Raid Instance.
        [7] = true, -- 25-player Raid Finder Instance.
        [8] = false, -- Challenge Mode Instance.
        [9] = true, -- 40-player Raid Instance.
        [11] = false, -- Heroic Scenario Instance.
        [12] = false, -- Scenario Instance.
        [14] = true, -- 10-30-player Normal Raid Instance.
        [15] = true, -- 10-30-player Heroic Raid Instance.
        [16] = true, -- 20-player Mythic Raid Instance .
        [17] = false, -- 10-30-player Raid Finder Instance.
        [18] = false, -- 40-player Event raid (Used by the level 100 version of Molten Core for WoW's 10th anniversary).
        [19] = false, -- 5-player Event instance (Used by the level 90 version of UBRS at WoD launch).
        [20] = true, -- 25-player Event scenario (unknown usage).
        [23] = false, -- Mythic 5-player Instance.
        [24] = false -- Timewalker 5-player Instance.
      },
      -- Output Channel
      -- Put "AUTO" to display the message in "RAID" while in Raid, "PARTY" while in Party, "LOCAL" while solo. (X-Realm group are ignored.)
      -- Put "AUTOX"to display the message in "INSTANCE_CHAT" while in Instance Group, "RAID" while in Raid, "PARTY" while in Party, "LOCAL" while solo.
      -- Put "LOCAL" to display the message only for you or on the channel you want (values below).
      -- "SAY", "YELL", "PARTY", "GUILD", "OFFICER", "RAID", "RAID_WARNING", "INSTANCE_CHAT".
      Channel = "LOCAL"
    }
  };
