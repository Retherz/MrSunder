function MrSunder_PlayerInstanced()
  local instanced, _ = IsInInstance();
  return (instanced ~= nil) and false or true;
end

function MrSunder_PlayerInCombat()
  return UnitAffectingCombat("player");
end
