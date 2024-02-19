The arena is rectangular, so we don't need to worry about navigating around objects.
"Roughly aligned with target" means along the same axis as the target, plus or minus 1 tile.

If not facing towards target:
	Turn to face target
	Return
If not roughly aligned with target:
	Strafe towards target
	Return
If player is diagonally in front:
	Do armada kick
	Return
Strafe to be in front of player