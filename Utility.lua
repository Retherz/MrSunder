function MrSunder_PlayerInstanced()
  local instanced, _ = IsInInstance();
  return (instanced ~= nil) and false or true;
end

function MrSunder_PlayerInCombat()
  return UnitAffectingCombat("player");
end

function MrSunder_StringSplit(str, delimiter)
  local str1, str2, it = "", "", true;
  for i = 1, string.len(str) do
    local strMsg = "";
    for i2 = 1, string.len(delimiter) do
      strMsg = strMsg .. string.sub(str, i + i2 - 1, i + i2 - 1);
    end
    if(strMsg == delimiter) then
      it = false;
    else
      if(it) then
        str1 = str1 .. string.sub(str, i, i);
      else
        str2 = str2 .. string.sub(str, i, i);
      end
    end
  end
  return str1, str2;
end
