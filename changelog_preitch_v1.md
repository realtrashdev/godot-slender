# Endless Pages Changelog: Pre-Itch Playtest v1



###### This text file details changes to the game since December 2025.





##### Mechanics

\---

The radar now has a limited battery.

* Collect pages to replenish it.
* The flashlight is now powered by the radar.
* Battery is measured in chunks, with each chunk lasting 20 seconds by default.
* Battery chunks can be added or lost.
* Do not run out of battery...





##### Audio

\---

Added new in-game music. This music dynamically builds as pages are collected.

* The previous in-game music has been removed.



Added credits music.





##### Settings

\---

Added a mouse sensitivity setting.



Added a fullscreen setting.

* This can also be toggled at any time using \[F11].





##### New Enemies

\---

Added Shade, an enemy that will chase down and kill you shortly after your radar dies.

* This enemy is currently always active.
* If you collect a page before Shade kills you, the battery will recharge and it will disappear.





##### Existing Enemies

\---

Chaser:

* Now attracts the flashlight, making it much easier to get rid of it.
* Now moves faster the further it is you.
* Now moves slower when close to you.
* Now has a unique sprite for when it is successfully repelled.
* Adjusted max instances from 3 to 1.

  * Only one Chaser can be active at once per spawner.



Gum:

* Is still here!



Eyes:

* Has received an art redesign to keep their style consistent with other enemies.
* Now has unique sprite for when your light is on.
* Now close (leave) much faster (8sec -> 2sec).
* Now attack faster (12sec -> 5sec).
* No longer kill you. Instead, they will take a chunk of your radar battery away for the rest of the run.
* When they take battery, text will show at the bottom of the screen to notify you.



Scam Likely:

* Will now cause the radar battery to rapidly drain.
* The decline call button no longer bounces around the screen.
* Instead, you must now hold it down for 2 seconds to decline the call.





##### Maps

\---

Edited tutorial map.

* Added two pages.
* Made the "exit" spawn after collecting a page instead of walking far enough.
* Added a path.
* Added fences to keep the play area contained.





##### Challenge Mode

\---

Renamed Scenarios to Challenges.



Slightly changed descriptions some Challenges.





##### Endless Mode

\---

is in development...





##### UI (Menus)

\---

Added a mouse parallax effect to most menus.



Added an animated background to the main menu.



Added a pixelated transition effect to the main menu.



Added text to the top left corner of the menu that allows you to see a string of recent letters you've typed.



Added the ability to reset progress.

* Type "reset" when in the settings menu, a button will show up in the bottom right.



Added an animated background to the enemy overview.

Fixed a layering issue with the enemy overview.



Added a credits menu.





##### UI (In-Game)

\---

Added a game over screen.

* Displays a photo of the enemy that killed you.
* Displays the name of the enemy that killed you.
* Displays a tip on how to deal with the enemy that killed you.
* Gives the option to either retry or return to the main menu.



Added a pause menu which allows you to:

* Change settings.
* View the enemy overview for the current challenge.
* Restart the level.
* Quit to the main menu.



Changed the animation of the "Pages: X/X" text.

