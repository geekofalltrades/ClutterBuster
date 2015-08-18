Scriptname ClutterBusterPlayerScript extends ReferenceAlias
{ClutterBuster player script for tracking OnCrosshairRefChanged events.}

ClutterBusterQuestScript Property ClutterBusterQuest Auto
{The ClutterBuster main script.}

Event OnInit()
	RegisterForCrosshairRef()

	ClutterBusterQuest.DebugMsg("ClutterBusterPlayerScript initialized.", 0)
EndEvent

;On mod initialization, we're unsure whether the player is focused on anything or not. This might
;mean that we bungle the very first filtering, if the player somehow manages to start focused on an
;item that they've added to their active filter list.

Auto State Ready
	Event OnCrosshairRefChange(ObjectReference crosshairRef)
		{Handle crosshair ref change.}

		GoToState("Working")

		;If we've shifted our focus from some ref to nothing, signal the quest script to unset its
		;current crosshairRef and manipulate controls, if appropriate.
		if crosshairRef == None
			ClutterBusterQuest.DebugMsg("Got crosshair ref None.", 2)
			ClutterBusterQuest.UnsetCrosshairRef()

		;If we've shifted our focus to some ref, either from nothing OR from some other ref, signal
		;the quest script to set its current crosshairRef and manipulate controls, if appropriate.
		else
			ClutterBusterQuest.DebugMsg("Got crosshair ref " + crosshairRef.GetName() + " (" + crosshairRef.GetBaseObject() + ").", 2)
			ClutterBusterQuest.SetCrosshairRef(crosshairRef)
		endif

		GoToState("Ready")
	EndEvent
EndState

State Working
	;Busy state.
EndState