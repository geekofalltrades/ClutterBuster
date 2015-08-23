Scriptname ClutterBusterQuestScript extends Quest
{ClutterBuster main script.}

int Property addHotkey = -1 Auto
{Add selected item to the active list.}

bool Property addHotkeyInInventory = True Auto
{Whether the add hotkey is enabled in the inventory.}

bool Property addHotkeyInWorld = True Auto
{Whether the add hotkey is enabled in the world.}

int Property removeHotkey = -1 Auto
{Remove selected item from the active list.}

bool Property removeHotkeyInInventory = True Auto
{Whether the remove hotkey is enabled in the inventory.}

bool Property removeHotkeyInWorld = True Auto
{Whether the remove hotkey is enabled in the world.}

int Property debugLevel = 1 Auto
{ClutterBuster debug logging level. 0 = off; 1 = debug; 2 = trace.}

ObjectReference crosshairRef = None
;The ref that we are currently focused on.

bool previousBlockActivation
;The state of the crosshairRef's activation before we affected it.

bool currentlyBlockingActivation = False
;Whether we are currently blocking activation on crosshairRef.

int activeList = 0
;The JValue ID of the currently active filter list.

Event OnInit()
	{Perform script setup.}

	;Add our blacklist to JDB.
	activeList = JArray.object()
	JDB.SolveObjSetter(".ClutterBuster.blacklist", activeList, True)

	DebugMsg("ClutterBusterQuestScript initialized.", 0)
EndEvent

;=====================================
;Non-thread-safe public API functions.
;=====================================

Auto State Ready
	Event OnKeyDown(int keyCode)
		{Map key presses to their respective hotkey actions.}

		GoToState("Working")

		if keyCode == addHotkey
			_HandleAddHotkey()
		elseif keyCode == removeHotkey
			_HandleRemoveHotkey()
		endif

		GoToState("Ready")
	EndEvent

	Function SetCrosshairRef(ObjectReference newCrosshairRef)
		{Set our current crosshairRef and block activation if it is on the active filter list.}

		GoToState("Working")

		if crosshairRef != None
			DebugMsg("Setting crosshairRef to " + FormatObjectReference(newCrosshairRef) + ". Was " + FormatObjectReference(crosshairRef) + ".", 2)
		else
			DebugMsg("Setting crosshairRef to " + FormatObjectReference(newCrosshairRef) + ". Was None.", 2)
		endif

		;If we are currently blocking activation, return BlockActivation to its previous state.
		if currentlyBlockingActivation
			DebugMsg("Activation was blocked. Restoring previous BlockActivation state (" + previousBlockActivation + ").", 2)
			crosshairRef.BlockActivation(previousBlockActivation)
			currentlyBlockingActivation = False
		endif

		;Change the crosshairRef to newCrosshairRef.
		crosshairRef = newCrosshairRef

		;If the new crosshairRef is in the active filter list, block activation.
		if JArray.findForm(activeList, crosshairRef.GetBaseObject()) > -1
			previousBlockActivation = crosshairRef.IsActivationBlocked()
			DebugMsg("Current crosshairRef is in filter list. Blocking activation. Previous BlockActivation state was " + previousBlockActivation, 2)
			crosshairRef.BlockActivation()
			currentlyBlockingActivation = True
		endif

		GoToState("Ready")
	EndFunction

	Function UnsetCrosshairRef()
		{Clear our current crosshairRef and reset activate controls if we had disabled them.}

		GoToState("Working")

		DebugMsg("Unsetting crosshairRef. Was " + FormatObjectReference(crosshairRef) + ".", 2)

		;If we are currently blocking activation, return BlockActivation to its previous state.
		if currentlyBlockingActivation
			DebugMsg("Activation was blocked. Restoring previous BlockActivation state (" + previousBlockActivation + ").", 2)
			crosshairRef.BlockActivation(previousBlockActivation)
			currentlyBlockingActivation = False
		endif

		;Unset the crosshairRef.
		crosshairRef = None

		GoToState("Ready")
	EndFunction
EndState

;=================================
;Thread-safe public API functions.
;=================================

Function DebugMsg(string msg, int level)
	{Print a debug message, log level permitting.}

	if level <= debugLevel
		Debug.Trace("[ClutterBuster] " + msg)
	endif
EndFunction

string Function FormatObjectReference(ObjectReference toFormat)
	{Format an ObjectReference for printing.}

	return toFormat.GetBaseObject().GetName() + " (" + toFormat + ")"
EndFunction

string Function FormatForm(Form toFormat)
	{Format a Form for printing.}

	return toFormat.GetName() + " (" + toFormat + ")"
EndFunction

;=====================
;Non-public functions.
;=====================

Function _HandleAddHotkey()
	{Handle add hotkey presses.}

	;If we are in menu mode.
	if Utility.IsInMenuMode()

		;If we are handling add hotkey presses in menu mode.
		if addHotkeyInInventory
			Form toAdd = Game.GetForm(UI.GetInt("InventoryMenu", "_root.Menu_mc.inventoryLists.panelContainer.itemList.selectedEntry.formId"))
			if toAdd == None
				DebugMsg("Add hotkey pressed from menu. Skipping (no highlighted item to process).", 1)

			else
				DebugMsg("Add hotkey pressed from menu. Processing.", 1)

				;If this item was just added, and it matches the current crosshairRef, block its activation.
				if _AddToList(toAdd) && crosshairRef != None && toAdd == crosshairRef.GetBaseObject()
					previousBlockActivation = crosshairRef.IsActivationBlocked()
					DebugMsg("Current crosshairRef is in filter list. Blocking activation. Previous BlockActivation state was " + previousBlockActivation, 2)
					crosshairRef.BlockActivation()
					currentlyBlockingActivation = True
				endif
			endif

		;If we aren't handling add hotkey presses in menu mode.
		else
			DebugMsg("Add hotkey pressed from menu. Skipping (add hotkey is not enabled in inventory).", 1)
		endif

	;If we are in the world.
	else

		;If we are handling add hotkey presses in the world.
		if addHotkeyInWorld
			if crosshairRef == None
				DebugMsg("Add hotkey pressed from from world. Skipping (no crosshairRef to process).", 1)

			else
				DebugMsg("Add hotkey pressed from world. Processing.", 1)

				;If the current crosshairRef was just added, block its activation.
				if _AddToList(crosshairRef.GetBaseObject())
					previousBlockActivation = crosshairRef.IsActivationBlocked()
					DebugMsg("Current crosshairRef is in filter list. Blocking activation. Previous BlockActivation state was " + previousBlockActivation, 2)
					crosshairRef.BlockActivation()
					currentlyBlockingActivation = True
				endif
			endif

		;If we aren't handling add hotkey presses in the world.
		else
			DebugMsg("Add hotkey pressed from world. Skipping (add hotkey is not enabled in world).", 1)
		endif
	endif
EndFunction

Function _HandleRemoveHotkey()
	{Handle remove hotkey presses.}

	;If we are in menu mode.
	if Utility.IsInMenuMode()

		;If we are handling remove hotkey presses in menu mode.
		if removeHotkeyInInventory
			Form toRemove = Game.GetForm(UI.GetInt("InventoryMenu", "_root.Menu_mc.inventoryLists.panelContainer.itemList.selectedEntry.formId"))
			if toRemove == None
				DebugMsg("Remove hotkey pressed from menu. Skipping (no highlighted item to process).", 1)
			else
				DebugMsg("Remove hotkey pressed from menu. Processing.", 1)

				;If this item was just removed, and it matches the current crosshairRef, reset its BlockActivation state.
				if _RemoveFromList(toRemove) && crosshairRef != None && toRemove == crosshairRef.GetBaseObject()
					DebugMsg("Activation was blocked. Restoring previous BlockActivation state (" + previousBlockActivation + ").", 2)
					crosshairRef.BlockActivation(previousBlockActivation)
					currentlyBlockingActivation = False
				endif
			endif

		;If we aren't handling remove hotkey presses in menu mode.
		else
			DebugMsg("Remove hotkey pressed from menu. Skipping (remove hotkey is not enabled in inventory).", 1)
		endif

	;If we are in the world.
	else

		;If we are handling remove hotkey presses in the world.
		if removeHotkeyInWorld
			if crosshairRef == None
				DebugMsg("Remove hotkey pressed from from world. Skipping (no crosshairRef to process).", 1)
			else
				DebugMsg("Remove hotkey pressed from world. Processing.", 1)

				;If the current crosshairRef was just removed, reset its BlockActivation state.
				if _RemoveFromList(crosshairRef.GetBaseObject())
					DebugMsg("Activation was blocked. Restoring previous BlockActivation state (" + previousBlockActivation + ").", 2)
					crosshairRef.BlockActivation(previousBlockActivation)
					currentlyBlockingActivation = False
				endif
			endif

		;If we aren't handling remove hotkey presses in the world.
		else
			DebugMsg("Remove hotkey pressed from world. Skipping (remove hotkey is not enabled in world).", 1)
		endif
	endif
EndFunction

bool Function _AddToList(Form itemToAdd)
	{Add the currently selected item to the active list. Returns True if item was added, False if item was already in filter list.}

	DebugMsg("Adding " + FormatForm(itemToAdd) + " to active filter list.", 1)

	;If the item wasn't in the active filter list, add it.
	if JArray.findForm(activeList, itemToAdd) == -1
		DebugMsg("Item wasn't in active filter list. Added.", 1)
		JArray.addForm(activeList, itemToAdd)
		return True

	;If the item was already in the active filter list, take no action.
	else
		DebugMsg("Item was already in active filter list.", 1)
		return False
	endif
EndFunction

bool Function _RemoveFromList(Form itemToRemove)
	{Remove the currently selected item from the active list. Returns True if item was removed, False if item was not in filter list.}

	DebugMsg("Removing " + FormatForm(itemToRemove) + " from active filter list.", 1)

	int itemIndex = JArray.findForm(activeList, itemToRemove)

	;If the item was in the active filter list, remove it.
	if itemIndex > -1
		DebugMsg("Item was in active filter list. Removing.", 1)
		JArray.eraseIndex(activeList, itemIndex)
		return True

	;If the item was not in the active filter list, take no action.
	else
		DebugMsg("Item wasn't in active filter list.", 1)
		return False
	endif
EndFunction

;===============
;Busy functions.
;===============

State Working
	;Thread lock when state-altering actions are taking place.
EndState

Function SetCrosshairRef(ObjectReference newCrosshairRef)
	{Don't set crosshairRef while not Ready.}
EndFunction

Function UnsetCrosshairRef()
	{Don't uset crosshairRef while not Ready.}
EndFunction
