"""
UI Manager
"""

extends Control
"""
Minimal UI click handler using a button list.
"""

# ==================================================
# Exported UI References
# ==================================================
const DEBUG_SIGNALS := true


signal shape_selected(index: int)
signal next_requested
signal color_selected(color: Color)



@export var color_picker: ColorPickerButton
var selected_color: Color = Color.WHITE

@export var next_button: Button
@export var shape_buttons: Array[ShapeButton]

@export var debug_mesh_container: Node3D



var button_mesh_slots: Dictionary[int, Node3D] = {}


var active_shape_index: int = -1


# ==================================================
# Lifecycle
# ==================================================

func _ready() -> void:
	_connect_click_events()

	for i in range(shape_buttons.size()):
		var button := shape_buttons[i]
		var slot := button.mesh_container

		if slot == null:
			push_warning("MeshContainer missing for ShapeButton %d" % i)
			continue

		button_mesh_slots[i] = slot

		if DEBUG_SIGNALS:
			print("[UI][SLOT] Button", i, "→ MeshContainer:", slot.name)

	if color_picker:
		color_picker.color_changed.connect(_on_color_changed)
		



# ==================================================
# Click Logic
# ==================================================

func _connect_click_events() -> void:
	for i in range(shape_buttons.size()):
		shape_buttons[i].pressed.connect(_on_shape_button_clicked.bind(i))

	if next_button:
		next_button.pressed.connect(_on_next_button_clicked)



func _on_shape_button_clicked(index: int) -> void:
	active_shape_index = index

	if DEBUG_SIGNALS:
		print("[UI][SIGNAL] shape_selected | index =", index)

	emit_signal("shape_selected", index)


	
func _on_next_button_clicked() -> void:
	if DEBUG_SIGNALS:
		print("[UI][SIGNAL] next_requested")

	apply_active_shape_to_debug_container()
	emit_signal("next_requested")


	

# ==================================================
# COLOR PICKER
# ==================================================


func _on_color_changed(color: Color) -> void:
	selected_color = color

	if DEBUG_SIGNALS:
		print("[UI][SIGNAL] color_selected =", color)

	apply_color_to_all_meshes(color)
	emit_signal("color_selected", color)

	
	
	
func apply_color_to_all_meshes(color: Color) -> void:
	if DEBUG_SIGNALS:
		print("[UI][SIGNAL] apply_color_to_all_meshes =", color)

	for button in shape_buttons:
		var container := button.mesh_container
		if container == null:
			continue

		for child in container.get_children():
			if child is MeshInstance3D:
				var mat: Material = child.get_surface_override_material(0)

				if mat == null:
					mat = StandardMaterial3D.new()
					child.set_surface_override_material(0, mat)

				(mat as StandardMaterial3D).albedo_color = color



func apply_active_shape_to_debug_container() -> void:
	if debug_mesh_container == null:
		push_warning("[UI][DEBUG] debug_mesh_container IS NULL")
		return

	if active_shape_index < 0 or active_shape_index >= shape_buttons.size():
		push_warning("[UI][DEBUG] No active shape selected")
		return

	var source_container := shape_buttons[active_shape_index].mesh_container
	if source_container == null:
		push_warning("[UI][DEBUG] Active Shape has no mesh_container")
		return

	# Alte Inhalte löschen
	for child in debug_mesh_container.get_children():
		child.queue_free()

	# Meshes kopieren
	for child in source_container.get_children():
		if child is MeshInstance3D:
			var clone := child.duplicate() as MeshInstance3D
			debug_mesh_container.add_child(clone)

	if DEBUG_SIGNALS:
		print(
			"[UI][DEBUG] Applied shape",
			active_shape_index,
			"to debug_mesh_container"
		)

	
