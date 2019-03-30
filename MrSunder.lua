--bars
MrSunderOffsetX = 200;
MrSunderOffsetY = 50;
MrSunderBarYPadding = 50;
MrSunderBarXPadding = 0;
--MrSunderBarCount = 5; //not using this atm.
--vars
MrSunderLastFail = 0;
MrSunderLastCast = 0;
MrSunderLastCastTarget = "";
--MrSunderSpellID = 0;
MrSunder = {};
MrSunder.Events = {
  "CHAT_MSG_SPELL_SELF_DAMAGE",
  "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE",
  "CHAT_MSG_COMBAT_HOSTILE_DEATH",
  "CHAT_MSG_ADDON";
};

function MrSunder_OnLoad()
  MrSunder_ToggleEvents(true);
  local _, englishClass = UnitClass("player");
  if(englishClass == "WARRIOR") then
    MrSunderSpellID = MrSunder_SetSpellID();
  end
end

function MrSunder_OnEvent()
    if(event == "CHAT_MSG_COMBAT_HOSTILE_DEATH") then
      if(strfind(arg1, "dies.")) then
        MrSunder_RemoveBar(gsub(arg1, " dies.", ""));
      end
      return;
    end
    if(event == "CHAT_MSG_ADDON" and arg1 == "MRSUNDER") then
      local a, b = strsplit("_", arg2);
      MrSunder_Populate(a, b);
      return;
    end
    if(strfind(arg1, "Sunder Armor")) then
      if(event == "CHAT_MSG_SPELL_SELF_DAMAGE") then
        MrSunderLastFail = GetTime();
        return;
      end
      --create / refresh bar as a sunder stack has been applied
      local a,_,_ = (strsplit(" is afflicted", arg1));
      MrSunder_Populate(a, GetTime());
    end
    if(MrSunderLastCast - MrSunderLastFail < 0) then
      MrSunderLastFail = 0;
      MrSunderLastCast = 0;
    end
    if(MrSunderLastCast > 0) then
      --send data for successful sunder application.,
      MrSunder_SendAddonMessage(MrSunderLastCastTarget .. "_" .. MrSunderLastCast);
      MrSunderLastCast = 0;
    end
end

function MrSunder_ToggleEvents(bool)
  for k, v in pairs(MrSunder.Events) do
    if(bool) then
      this:RegisterEvent(v);
    else
      this:UnregisterEvent(v);
    end
  end
end

function MrSunder_SetSpellID()
  local i = 1
  while true do
   local spellName = GetSpellName(i, "spell")
    if(spellName == "Sunder Armor") then
      MrSunderSpellID = i;
      return i;
    end
    if not spellName then
      break
    end
   i = i + 1
 end
end

function MrSunder_CastSunder()
  CastSpellByName("Sunder Armor");
  local start, duration = GetSpellCooldown(MrSunderSpellID, BOOKTYPE_SPELL);
  if(GetTime() - start == 0) then
    MrSunderLastCast = GetTime();
    MrSunderLastCastTarget = UnitName("target");
    --success, test with self_damage fail (miss, dodge)
  end
end


function MrSunder_SendAddonMessage(msg)
  if GetNumRaidMembers() == 0 then
    SendAddonMessage("MRSUNDER", msg, "PARTY");
  else
    SendAddonMessage("MRSUNDER", msg, "RAID");
  end
end

--TODO: Player blacklist, sunder use tracking, next sunder alert (if unitname = Targetunit name and t < x and targethealth > y),
