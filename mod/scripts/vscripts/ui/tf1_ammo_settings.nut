global function TF1AmmoSettings_Init

void function TF1AmmoSettings_Init()
{
	string red = "^ff010000Red^e0e0e000 "
	string green = "^00ff0000Green^e0e0e000 " 
	string blue = "^0000ff00Blue^e0e0e000 "

	AddModTitle("Titanfall 1 Ammo Counters")
	AddModCategory("#SETTINGS")
	AddConVarSettingSlider("TF1AMMO.digit_style","Number Style", 0, 2, 1, true)
	ModSettings_AddEnumSetting("TF1AMMO.blank_rounds", "Show Blank Rounds", [ "#SETTING_OFF", "#SETTING_ON" ])
}