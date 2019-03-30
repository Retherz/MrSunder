MrSunderBars = {};
function MrSunder_CreateBars()
  for i=1,5 do
    MrSunder["Timestamp" .. i] = 0;
    local f = CreateFrame("StatusBar", "SunderBar" .. i, UIParent);
    f = getglobal("SunderBar" .. i);
    f:SetWidth(200);
    f:SetHeight(20);
    f:SetPoint("CENTER", UIParent, "CENTER",
      MrSunderOffsetX - MrSunderBarXPadding * (i - 1),
      MrSunderOffsetY - MrSunderBarYPadding * (i - 1));
    f:SetBackdrop({bgFile = [[Interface\ChatFrame\ChatFrameBackground]]})
    f:SetStatusBarColor(0, 0, 0, 0.7)
    f:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
    f:SetBackdropColor(0, 0.5, 1)
    f:SetMinMaxValues(0, 30);
    local l = f:CreateFontString("SunderBarLabel" .. i, "OVERLAY", "GameFontHighlight");
    l = getglobal("SunderBarLabel" .. i);
  	l:SetWidth(200);
  	l:SetPoint("TOPLEFT", 0, -20);
  	l:SetTextColor(0.3, 0.51, 0.77);
  	l:SetText("MRSUNDER_DEFAULT_BAR_TEXT" .. i);
    local l = f:CreateFontString("SunderBarTimer" .. i, "OVERLAY", "GameFontHighlight");
    l = getglobal("SunderBarTimer" .. i);
  	l:SetWidth(200);
  	l:SetPoint("TOPLEFT", 0, 0);
  	l:SetTextColor(1, 0.2, 0.2);
  	l:SetText("MRSUNDER_DEFAULT_BAR_TEXT" .. i);
    f:Hide();
    f.Index = i;

    --debugging

    f:SetScript("OnUpdate", function(self)
      local timestamp = MrSunder_GetTimeLeft(f.Index);
      l:SetText(30 - floor(timestamp + .5));
      if(timestamp >= 30) then
        f:Hide();
          MrSunder["Timestamp" .. f.Index] = 0;
      end
    	f:SetValue(timestamp)
    end)
  end
end

function MrSunder_Populate(name, time)
  if(MrSunderBars[1] == nil) then
    MrSunder_CreateBars();
  end
  if(not MrSunder_PlayerInstanced) then
    return;
  end
  for i=1,5 do
    if(MrSunderBars[i] == name) then
      MrSunder["Timestamp" .. i] = time;
      getglobal("SunderBarLabel" .. i):SetText(name);
      getglobal("SunderBar" .. i):Show();
      return;
    end
  end
  for i=1,5 do
    local bar = getglobal("SunderBar" .. i);
    if(not bar:IsVisible()) then
      MrSunderBars[i] = name;
      MrSunder["Timestamp" .. i] = time;
      getglobal("SunderBarLabel" .. i):SetText(name);
      getglobal("SunderBar" .. i):Show();
      return;
    end
  end
end

function MrSunder_RemoveBar(name)
  for i=1,5 do
    if(MrSunderBars[i] == name) then
      getglobal("SunderBar" .. i):Hide();
    end
  end
end

function MrSunder_GetTimeLeft(index)
    return GetTime() - MrSunder["Timestamp" .. index];
end
