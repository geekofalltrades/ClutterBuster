DeActivator 1.0
geekofalltrades
not yet released


CONTENTS
--------
 * Introduction
 * Requirements
 * Compatibility
 * Installation
 * Uninstallation
 * Permissions
 * Acknowledgements
 * Contact


INTRODUCTION
------------
DeActivator prevents the player from activating in-game objects (items, weapons, actors, doors...)
of their choosing based on configurable whitelists and blacklists.

DeActivator is the spiritual successor to another of my mods, DeActivator. Where DeActivator bandaged
over the issue of accidentally picking up dumb clutter by giving you hotkeys to quickly drop it,
DeActivator implements a more robust solution that actually prevents the clutter from ever being
picked up in the first place.

And thank god. Stupid dungeon clutter.

But wait - there's more! DeActivator can function on anything with activation controls - so you can
filter out actors you don't want to talk to, filter out plants you don't want to harvest, filter out
doors you don't want to enter (sort of)... the possibilities are endless! Well, no, they're not, but
there are a very impressive array of them!


REQUIREMENTS
------------
  * JContainers v3.2
  * SKSE
  * SkyUI v5.1


COMPATIBILITY
-------------
No incompatibilities are known.

DeActivator is anticipated to raise odd incompatibilities in situations where it filters mod or
vanilla game content that uses the on OnActivation script event. DeActivator cannot stop these
events from firing.


INSTALLATION
------------
Mod Manager (Recommended): Install with Mod Organizer or Nexus Mod Manager.

Manual: Place DeActivator.esp and DeActivator.bsa in your Skyrim/Data directory.


UNINSTALLATION
--------------
DeActivator is a script mod. Unless you really know what you're doing, you should not remove script
mods from an existing save. If you try, and it breaks your save, I cannot support you. Only
uninstall DeActivator before starting a new game.

Mod Manager (Recommended): If installed with Mod Organizer or Nexus Mod Manager, uninstall with the
same.

Manual: Remove DeActivator.esp and DeActivator.bsa from your Skyrim/Data directory.


PERMISSIONS
-----------
Do not reupload this mod at sites other than Skyrim Nexus. If you alter this mod (by translating,
adding functionality, etc) you may distribute it freely, so long as I am credited as its original
author; in this case, I would prefer that it were made available at Skyrim Nexus. If you want to
include this mod as part of a larger compilation, please contact me.


ACKNOWLEDGEMENTS
----------------
Thanks to Nexus Mods and to all contributors to the Creation Kit wiki and forums.

Credit to perseid9, author of Realistic Needs and Diseases. I poked around in RN&D's source code
to figure out how to create hotkeys that act on highlighted inventory items.

And thanks to silvericed, author of JContainers, for making Papyrus actually useable.


CONTACT
-------
For general questions, comments, complaints, compliments, musings, propositions, reticulations,
etc, please post to this mod's thread on the Skyrim Nexus forums. To contact me directly, please
send me a private message on the Nexus Mods website. My account name there is "thegeekofalltrades."
