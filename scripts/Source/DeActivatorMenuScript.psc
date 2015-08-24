Scriptname DeActivatorMenuScript extends SKI_ConfigBase
{DeActivator MCM menu script.}

DeActivatorQuestScript Property DeActivatorQuest Auto
{The main quest script.}

DeActivatorPlayerScript Property PlayerScript Auto
{The player script.}

string[] debugLevels
;String representations of debug log levels.

Event OnConfigInit()
; 	{Perform menu setup.}

; 	Pages = new string[3]
; 	Pages[0] = "$Settings"
; 	Pages[1] = "$Blacklists"
; 	Pages[2] = "$Whitelists"

; 	yesOrNo = new string[2]
; 	yesOrNo[0] = "$Yes"
; 	yesOrNo[1] = "$No"

	debugLevels = new string[3]
	debugLevels[0] = "$OFF"
	debugLevels[1] = "$DEBUG"
	debugLevels[2] = "$TRACE"

	DeActivatorQuest.DebugMsg("DeActivatorMenuScript intialized.", 0)
EndEvent

Event OnPageReset(string page)
	{Draw the menu.}

	; if page == ""
	; 	LoadCustomContent("DeActivator_MCM.dds", 120, 95)
	; 	return
	; else
	; 	UnloadCustomContent()
	; endif

	SetCursorFillMode(TOP_TO_BOTTOM)
	; if page == "$Settings"
		DrawSettingsPage()
	; elseif page == "$Blacklists"
	; 	DrawBlacklistsPage()
	; elseif page == "$Whitelists"
	; 	DrawWhitelistsDropPage()
	; endif
EndEvent

Event OnConfigClose()
	{When the menu is closed, rebind the hotkeys.}

	UnregisterForAllKeys()
	RegisterForKey(DeActivatorQuest.addHotkey)
	RegisterForKey(DeActivatorQuest.removeHotkey)
EndEvent

;=============
;Settings Page
;=============

Function DrawSettingsPage()
	{Draw the "Settings" MCM page.}

	AddHeaderOption("$Hotkeys")
	AddKeymapOptionST("AddHotkey", "$Add to List", DeActivatorQuest.addHotkey)
	AddToggleOptionST("AddHotkeyInInventory", "$  Active in Inventory", DeActivatorQuest.addHotkeyInInventory)
	AddToggleOptionST("AddHotkeyInWorld", "$  Active in World", DeActivatorQuest.addHotkeyInWorld)
	AddKeymapOptionST("RemoveHotkey", "$Remove from List", DeActivatorQuest.removeHotkey)
	AddToggleOptionST("RemoveHotkeyInInventory", "$  Active in Inventory", DeActivatorQuest.removeHotkeyInInventory)
	AddToggleOptionST("RemoveHotkeyInWorld", "$  Active in World", DeActivatorQuest.removeHotkeyInWorld)
	AddEmptyOption()
	AddHeaderOption("$Debugging")
	AddTextOptionST("DebugLevel", "$Debug Logging Level", debugLevels[DeActivatorQuest.debugLevel])
EndFunction

bool Function CheckKeyConflict(string conflictControl, string conflictName)
	{Check for OnKeyMapChange key conflicts and get user input.}

	if conflictControl != ""
		string msg = ""
		if conflictName != ""
			msg = "$DEACTIVATOR_KEY_CONFLICT_{" + conflictControl + "}_FROM_{" + conflictName +"}"
		else
			msg = "$DEACTIVATOR_KEY_CONFLICT_{" + conflictControl + "}_FROM_SKYRIM"
		endif
		return ShowMessage(msg, True, "$Yes", "$No")
	endif
	return True
EndFunction

string Function GetCustomControl(int KeyCode)
	{Provide hotkey names to MCM for key conflict notifications.}

	if KeyCode == DeActivatorQuest.addHotkey
		return "$Add to List"
	elseif KeyCode == DeActivatorQuest.removeHotkey
		return "$Remove from List"
	endif
	return ""
EndFunction

State AddHotkey
	Event OnKeyMapChangeST(int keyCode, string conflictControl, string conflictName)
		if CheckKeyConflict(conflictControl, conflictName)
			DeActivatorQuest.addHotkey = keyCode
			SetKeymapOptionValueST(keyCode)

			DeActivatorQuest.DebugMsg("Set add hotkey to " + keyCode + " from MCM.", 1)
		else
			DeActivatorQuest.DebugMsg("Failed to set add hotkey to " + keyCode + " from MCM.", 1)
		endif
	EndEvent

	Event OnDefaultST()
		DeActivatorQuest.addHotkey = -1
		SetKeymapOptionValueST(-1)

		DeActivatorQuest.DebugMsg("Cleared add hotkey from MCM.", 1)
	EndEvent

	Event OnHighlightST()
		SetInfoText("$DEACTIVATOR_HIGHLIGHT_ADD_HOTKEY")
	EndEvent
EndState

State AddHotkeyInInventory
	Event OnSelectST()
		DeActivatorQuest.addHotkeyInInventory = !DeActivatorQuest.addHotkeyInInventory
		SetToggleOptionValueST(DeActivatorQuest.addHotkeyInInventory)

		DeActivatorQuest.DebugMsg("Set add hotkey enabled in inventory to " + DeActivatorQuest.addHotkeyInInventory + " from MCM.", 1)
	EndEvent

	Event OnDefaultST()
		DeActivatorQuest.addHotkeyInInventory = True
		SetToggleOptionValueST(True)

		DeActivatorQuest.DebugMsg("Restored add hotkey enabled in inventory to default (" + True + ") from MCM.", 1)
	EndEvent

	Event OnHighlightST()
		SetInfoText("$DEACTIVATOR_HIGHLIGHT_ADD_HOTKEY_IN_INVENTORY")
	EndEvent
EndState

State AddHotkeyInWorld
	Event OnSelectST()
		DeActivatorQuest.addHotkeyInWorld = !DeActivatorQuest.addHotkeyInWorld
		SetToggleOptionValueST(DeActivatorQuest.addHotkeyInWorld)

		DeActivatorQuest.DebugMsg("Set add hotkey enabled in world to " + DeActivatorQuest.addHotkeyInWorld + " from MCM.", 1)
	EndEvent

	Event OnDefaultST()
		DeActivatorQuest.addHotkeyInWorld = True
		SetToggleOptionValueST(True)

		DeActivatorQuest.DebugMsg("Restored add hotkey enabled in world to default (" + True + ") from MCM.", 1)
	EndEvent

	Event OnHighlightST()
		SetInfoText("$DEACTIVATOR_HIGHLIGHT_ADD_HOTKEY_IN_WORLD")
	EndEvent
EndState

State RemoveHotkey
	Event OnKeyMapChangeST(int keyCode, string conflictControl, string conflictName)
		if CheckKeyConflict(conflictControl, conflictName)
			DeActivatorQuest.removeHotkey = keyCode
			SetKeymapOptionValueST(keyCode)

			DeActivatorQuest.DebugMsg("Set remove hotkey to " + keyCode + " from MCM.", 1)
		else
			DeActivatorQuest.DebugMsg("Failed to set remove hotkey to " + keyCode + " from MCM.", 1)
		endif
	EndEvent

	Event OnDefaultST()
		DeActivatorQuest.removeHotkey = -1
		SetKeymapOptionValueST(-1)

		DeActivatorQuest.DebugMsg("Cleared remove hotkey from MCM.", 1)
	EndEvent

	Event OnHighlightST()
		SetInfoText("$DEACTIVATOR_HIGHLIGHT_REMOVE_HOTKEY")
	EndEvent
EndState

State RemoveHotkeyInInventory
	Event OnSelectST()
		DeActivatorQuest.removeHotkeyInInventory = !DeActivatorQuest.removeHotkeyInInventory
		SetToggleOptionValueST(DeActivatorQuest.removeHotkeyInInventory)

		DeActivatorQuest.DebugMsg("Set remove hotkey enabled in inventory to " + DeActivatorQuest.removeHotkeyInInventory + " from MCM.", 1)
	EndEvent

	Event OnDefaultST()
		DeActivatorQuest.removeHotkeyInInventory = True
		SetToggleOptionValueST(True)

		DeActivatorQuest.DebugMsg("Restored remove hotkey enabled in inventory to default (" + True + ") from MCM.", 1)
	EndEvent

	Event OnHighlightST()
		SetInfoText("$DEACTIVATOR_HIGHLIGHT_REMOVE_HOTKEY_IN_INVENTORY")
	EndEvent
EndState

State RemoveHotkeyInWorld
	Event OnSelectST()
		DeActivatorQuest.removeHotkeyInWorld = !DeActivatorQuest.removeHotkeyInWorld
		SetToggleOptionValueST(DeActivatorQuest.removeHotkeyInWorld)

		DeActivatorQuest.DebugMsg("Set remove hotkey enabled in world to " + DeActivatorQuest.removeHotkeyInWorld + " from MCM.", 1)
	EndEvent

	Event OnDefaultST()
		DeActivatorQuest.removeHotkeyInWorld = True
		SetToggleOptionValueST(True)

		DeActivatorQuest.DebugMsg("Restored remove hotkey enabled in world to default (" + True + ") from MCM.", 1)
	EndEvent

	Event OnHighlightST()
		SetInfoText("$DEACTIVATOR_HIGHLIGHT_REMOVE_HOTKEY_IN_WORLD")
	EndEvent
EndState

State DebugLevel
	Event OnSelectST()
		if DeActivatorQuest.debugLevel >= 2
			DeActivatorQuest.DebugMsg("Set debug level to 0 from MCM.", 1)
			DeActivatorQuest.debugLevel = 0
		else
			DeActivatorQuest.debugLevel += 1
			DeActivatorQuest.DebugMsg("Set debug level to " + DeActivatorQuest.debugLevel + " from MCM.", 1)
		endif
		SetTextOptionValueST(debugLevels[DeActivatorQuest.debugLevel])
	EndEvent

	Event OnDefaultST()
		DeActivatorQuest.DebugMsg("Set debug level to 0 from MCM.", 1)
		DeActivatorQuest.debugLevel = 0
		SetTextOptionValueST(debugLevels[0])
	EndEvent

	Event OnHighlightST()
		SetInfoText("$DEACTIVATOR_HIGHLIGHT_DEBUG_LEVEL")
	EndEvent
EndState