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


var button_mesh_slots: Dictionary[int, Node3D] = {}



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
		
	debug_print_shape_meshes()
	




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
# COLOR PICKER
# ==================================================


func _on_color_changed(color: Color) -> void:
	selected_color = color

	print("[UI][SIGNAL] color_selected =", color)

	emit_signal("color_selected", color)

# ==================================================
# MESH
# ==================================================

func debug_print_shape_meshes() -> void:
	print("===== DEBUG: ShapeButton Mesh Names =====")

	for i in range(shape_buttons.size()):
		var button := shape_buttons[i]
		if button == null or button.mesh_container == null:
			continue

		for child in button.mesh_container.get_children():
			if child is MeshInstance3D:
				print("Button", i, "→ Mesh:", child.name)

	print("===== END DEBUG =====")

	
