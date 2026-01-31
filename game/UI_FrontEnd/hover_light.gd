extends Node3D
"""
Hover light controller for 3D UI previews.

Turns a light on/off when the UI tells it to.
Includes debug output for hover tracing.
"""

@export var hover_light: OmniLight3D
"""Light used for hover glow."""

@export var hover_energy: float = 2.0
"""Light energy when hover is active."""


func hover_on() -> void:
	"""
	Enable hover glow.
	"""
	if not hover_light:
		print("[HOVER][WARN] No hover_light assigned on:", name)
		return

	hover_light.light_energy = hover_energy
	print("[HOVER] ON  | Node:", name, "| Energy:", hover_energy)


func hover_off() -> void:
	"""
	Disable hover glow.
	"""
	if not hover_light:
		print("[HOVER][WARN] No hover_light assigned on:", name)
		return

	hover_light.light_energy = 0.0
	print("[HOVER] OFF | Node:", name)
