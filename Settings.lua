--- ============================ HEADER ============================
--- ======= LOCALIZE =======
  -- Addon
  local addonName, AT = ...;


--- ============================ CONTENT ============================
  -- All settings here should be moved into the GUI someday
  AT.GUISettings = {
    FastLootEnabled = true,
    Nameplates = {
      TTD = {
        Enabled = true,
        -- TODO: Make a DB with all "default" offset loaded based on what addon the user has Enabled
        -- TODO: And make a command to input custom offset
        -- Default Nameplate
          --XOffset = 5,
          --YOffset = -11
        -- Kui Nameplate
          XOffset = 16,
          YOffset = -16
      }
    },
    PullAnnouncer = {
      RaidOnly = true,
      -- Set the Tracker Mode, "GROUP" to track mobs pulled by Group Members, "ALL" to track everything.
      -- TODO: Fix "GROUP" :D
      Mode = "ALL",
      -- Output Channel
      -- Put "AUTO" to display the message in "RAID" while in Raid, "PARTY" while in Party, "LOCAL" while solo. (X-Realm group are ignored.)
      -- Put "AUTOX"to display the message in "INSTANCE_CHAT" while in Instance Group, "RAID" while in Raid, "PARTY" while in Party, "LOCAL" while solo.
      -- Put "LOCAL" to display the message only for you or on the channel you want (values below).
      -- "SAY", "YELL", "PARTY", "GUILD", "OFFICER", "RAID", "RAID_WARNING", "INSTANCE_CHAT".
      Channel = "SAY"
    }
  };
