extends Control
"""
Minimal UI click handler using a button list.
"""

# ==================================================
# Exported UI References
# ==================================================


signal shape_selected(index: int)
signal next_requested

const DEBUG_SIGNALS := true

@export var color_picker: ColorPickerButton


@export var next_button: Button


@export var shape_buttons: Array[Button]
"""
Buttons for Shapes
"""

var button_mesh_slots: Dictionary[int, Node3D] = {}
"""
Dict to set new shape 
"""



# ==================================================
# Lifecycle
# ==================================================

func _ready() -> void:
	#_collect_button_meshes()
	_connect_click_events()
	print("[UI] Buttons + meshes ready")
	



# ==================================================
# Click Logic
# ==================================================

func _connect_click_events() -> void:
	for i in range(shape_buttons.size()):
		shape_buttons[i].pressed.connect(_on_shape_button_clicked.bind(i))

	if next_button:
		next_button.pressed.connect(_on_next_button_clicked)



func _on_shape_button_clicked(index: int) -> void:
	if DEBUG_SIGNALS:
		print("[UI][SIGNAL] shape_selected | index =", index)

	emit_signal("shape_selected", index)

	
func _on_next_button_clicked() -> void:
	if DEBUG_SIGNALS:
		print("[UI][SIGNAL] next_requested")

	emit_signal("next_requested")


	
	
	
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
	
	
	
# ==================================================
# BUTTON MESHs
# ==================================================
	
func register_button_slot(index: int, slot: Node3D) -> void:
	button_mesh_slots[index] = slot

	
	
func replace_button_meshes(index: int, new_container: Node3D) -> void:
	var slot: Node3D = button_mesh_slots.get(index)
	if slot == null:
		push_warning("No mesh slot registered for button %d" % index)
		return

	for child in slot.get_children():
		child.queue_free()

	slot.add_child(new_container)

	
# ==================================================
# COLOR PICKER
# ==================================================



	
	
