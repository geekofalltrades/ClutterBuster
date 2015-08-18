Scriptname ClutterBusterQuestScript extends Quest
{ClutterBuster main script.}

int Property addHotkey = -1 Auto
{Add selected item to the active list.}

int Property removeHotkey = -1 Auto
{Remove selected item from the active list.}

int Property debugLevel = 2 Auto
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

		;Hotkeys are only enabled when in the inventory menu.
		if Utility.IsInMenuMode()
			Form selectedItem = Game.GetForm(UI.GetInt("InventoryMenu", "_root.Menu_mc.inventoryLists.panelContainer.itemList.selectedEntry.formId"))
			if keyCode == addHotkey
				DebugMsg("Add hotkey pressed (keyCode = " + keyCode + ").", 2)
				_AddToList(selectedItem)
			elseif keyCode == removeHotkey
				DebugMsg("Remove hotkey pressed (keyCode = " + keyCode + ").", 2)
				_RemoveFromList(selectedItem)
			endif
		endif

		GoToState("Ready")
	EndEvent

	Function SetCrosshairRef(ObjectReference newCrosshairRef)
		{Set our current crosshairRef and block activation if it is on the active filter list.}

		GoToState("Working")

		if crosshairRef != None
			DebugMsg("Changing crosshairRef. Was " + FormatObjectReference(crosshairRef) + ".", 2)
		endif

		;If we are currently blocking activation, return BlockActivation to its previous state.
		if currentlyBlockingActivation
			DebugMsg("Activation was blocked. Restoring previous BlockActivation state (" + previousBlockActivation + ").", 2)
			crosshairRef.BlockActivation(previousBlockActivation)
			currentlyBlockingActivation = False
		endif

		;Change the crosshairRef to newCrosshairRef.
		DebugMsg("Setting crosshairRef to " + FormatObjectReference(newCrosshairRef) + ".", 2)
		crosshairRef = newCrosshairRef

		;If the new crosshairRef is in the active filter list, block activation.
		if JArray.findForm(activeList, crosshairRef.GetBaseObject()) > -1
			previousBlockActivation = crosshairRef.IsActivationBlocked()
			DebugMsg("Current crosshairRef is in filter list. Blocking activation. Previous BlockActivation state was " + previousBlockActivation, 2)
			crosshairRef.BlockActivation()
		endif

		GoToState("Ready")
	EndFunction

	Function UnsetCrosshairRef()
		{Clear our current crosshair Form and reset activate controls if we had disabled them.}

		GoToState("Working")

		DebugMsg("Unsetting crosshairRef. Was " + FormatObjectReference(crosshairRef) + ".", 2)

		;Restore previous BlockActivation state to crosshairRef, then unset it.
		if currentlyBlockingActivation
			DebugMsg("Activation was blocked. Restoring previous BlockActivation state (" + previousBlockActivation + ").", 2)
			crosshairRef.BlockActivation(previousBlockActivation)
			currentlyBlockingActivation = False
		endif

		crosshairRef = None

		GoToState("Ready")
	EndFunction
EndState

;=================================
;Thread-safe public API functions.
;=================================

Function DebugMsg(string msg, int level)
	if level <= debugLevel
		Debug.Trace("[ClutterBuster] " + msg)
	endif
EndFunction

string Function FormatObjectReference(ObjectReference toFormat)
	{Format an ObjectReference for printing.}

	return toFormat.GetName() + " (" + toFormat + ")"
EndFunction

;=====================
;Non-public functions.
;=====================

Function _AddToList(Form itemToAdd)
	{Add the currently selected item to the active list.}

	DebugMsg("Adding " + itemToAdd.GetName() + " (" + itemToAdd + ") to active filter list.", 1)
	if JArray.findForm(activeList, itemToAdd) == -1
		DebugMsg("Item wasn't in active filter list. Added.", 1)
		JArray.addForm(activeList, itemToAdd)
	else
		DebugMsg("Item was already in active filter list.", 1)
	endif
EndFunction

Function _RemoveFromList(Form itemToRemove)
	{Remove the currently selected item from the active list.}

	DebugMsg("Removing " + itemToRemove.GetName() + " (" + itemToRemove + ") from active filter list.", 1)
	int itemIndex = JArray.findForm(activeList, itemToRemove)
	if itemIndex > -1
		DebugMsg("Item was in active filter list. Removing", 1)
		JArray.eraseIndex(activeList, itemIndex)
	else
		DebugMsg("Item wasn't in active filter list.", 1)
	endif
EndFunction

;===============
;Busy functions.
;===============

State Working
	;Thread lock when state-altering actions are taking place.
EndState

Function SetCrosshairRef(ObjectReference newCrosshairRef)
	{Don't set crosshair Form while not Ready.}
EndFunction

Function UnsetCrosshairRef()
	{Don't uset crosshair Form while not Ready.}
EndFunction
