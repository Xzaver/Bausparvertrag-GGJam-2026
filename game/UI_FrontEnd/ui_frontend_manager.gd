extends Control
"""
Minimal UI click handler using a button list.
"""

# ==================================================
# Exported UI References
# ==================================================

@export var buttons: Array[Button]
"""Clickable buttons (order = index)."""

var button_mesh_references: Array[MeshInstance3D] = []
"""Meshes collected from buttons at runtime."""

#@export var button_mesh_references: Array[MeshInstance3D]
"""Mesh previews corresponding to buttons (same index)."""

#@export var default_meshs: Array[MeshInstance3D]
"""Mesh previews corresponding to buttons (same index)."""




# ==================================================
# Lifecycle
# ==================================================

func _ready() -> void:
	#_collect_button_meshes()
	_connect_click_events()
	print("[UI] Buttons + meshes ready")


# ==================================================
# Setup
# ==================================================

func _collect_button_meshes() -> void:
	"""
	Collects one MeshInstance3D per button.
	Index alignment with buttons is guaranteed.
	"""
	button_mesh_references.clear()

	for i in range(buttons.size()):
		var mesh := _find_mesh(buttons[i])
		button_mesh_references.append(mesh)

		if mesh:
			print("[UI] Found mesh for button:", i)
		else:
			print("[UI][WARN] No mesh for button:", i)

# ==================================================
# Click Logic
# ==================================================

func _connect_click_events() -> void:
	for i in range(buttons.size()):
		buttons[i].pressed.connect(_on_button_clicked.bind(i))
		print("[UI] Connected CLICK for button:", i)


func _on_button_clicked(index: int) -> void:
	print("[UI] BUTTON CLICKED | index =", index)
	
	
	
# ==================================================
# Utilities
# ==================================================

func _find_mesh(root: Node) -> MeshInstance3D:
	for child in root.get_children():
		if child is MeshInstance3D:
			return child

		var found := _find_mesh(child)
		if found:
			return found

	return null
