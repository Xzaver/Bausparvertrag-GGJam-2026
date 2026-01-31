extends Control
"""
UI Manager – handles shape selection, preview and confirmation.
"""

# ==================================================
# UI Frontend – Public API (for external systems)
# ==================================================
#
# The following methods are intended to be called
# from outside the UIManager (e.g. GameLogic, Debug,
# Editor tools).
#
# --------------------------------------------------
# Selection / State
# --------------------------------------------------
#
# set_mesh_for_all_buttons(source)
# - Replaces the preview meshes of ALL ShapeButtons.
# - `source` can be:
#     - Node3D            (uses its MeshInstance3D children)
#     - MeshInstance3D   (single mesh)
#     - Array[MeshInstance3D]
#
#
# --------------------------------------------------
# Debug / Preview
# --------------------------------------------------
#
# apply_active_shape_to_debug_container()
# - Copies the currently active ShapeButton preview
#   into the DebugMeshContainer.
#
# debug_apply_active_shape_to_all_buttons()
# - Debug-only helper.
# - Applies the currently active ShapeButton preview
#   to ALL button mesh containers.
#
#
# --------------------------------------------------
# Signals to listen to (preferred over direct access)
# --------------------------------------------------
#
# shape_selected(index)
# - Emitted when a ShapeButton is clicked.
#
# color_selected(color)
# - Emitted when the ColorPicker value changes.
#
# next_requested
# - Emitted when the Next button is pressed.
#
# selection_confirmed(shape_index, mesh_container, color)
# - Final selection payload.
# - External systems should use THIS signal.
#
#
# --------------------------------------------------
# Rules for External Usage
# --------------------------------------------------
# - Do NOT access shape_buttons directly.
# - Do NOT re-parent meshes owned by the UI.
# - Always react via signals where possible.
# ==================================================



# ==================================================
# Exported UI References
# ==================================================
const DEBUG_SIGNALS := true


signal shape_selected(index: int)
signal next_requested
signal color_selected(color: Color)
signal selection_confirmed(
	shape_index: int,
	mesh_container: Node3D,
	color: Color
)


@export var debug_mesh_instance: MeshInstance3D
@export var debug_mesh_resource: Mesh
@export var debug_apply_all_button: Button


@export var color_picker: ColorPickerButton
var selected_color: Color = Color.WHITE

@export var next_button: Button
@export var shape_buttons: Array[ShapeButton]

@export var debug_mesh_container: Node3D




var active_shape_index: int = -1




# ==================================================
# Lifecycle
# ==================================================

func _ready() -> void:
	_connect_click_events()

	if color_picker:
		color_picker.color_changed.connect(_on_color_changed)

	if debug_apply_all_button:
		debug_apply_all_button.pressed.connect(_on_debug_apply_all_pressed)
		


func _on_debug_apply_all_pressed() -> void:
	if not DEBUG_SIGNALS:
		return
	print("[UI][DEBUG] _on_debug_apply_all_pressed")

	if active_shape_index < 0 or active_shape_index >= shape_buttons.size():
		push_warning("[UI][DEBUG] No active shape selected")
		return

	var source_container := shape_buttons[active_shape_index].mesh_container
	if source_container == null:
		push_warning("[UI][DEBUG] Active shape has no mesh_container")
		return

	print(
		"[UI][DEBUG] Debug button → apply shape to all buttons | index =",
		active_shape_index
	)

	set_mesh_for_all_buttons(source_container)

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

	apply_active_shape_to_debug_container()
	emit_signal("shape_selected", index)



	
func _on_next_button_clicked() -> void:
	if DEBUG_SIGNALS:
		print(
			"[UI][SIGNAL] next_requested | active_shape_index =",
			active_shape_index,
			"| color =",
			selected_color
		)

	if active_shape_index < 0:
		push_warning("[UI] Next pressed without shape selection")
		return

	var container := shape_buttons[active_shape_index].mesh_container
	if container == null:
		push_warning("[UI] Selected shape has no mesh_container")
		return

	if DEBUG_SIGNALS:
		print(
			"[UI][DEBUG] Next payload →",
			"index =", active_shape_index,
			"| container =", container.name,
			"| mesh_count =", container.get_child_count()
		)

	emit_signal(
		"selection_confirmed",
		active_shape_index,
		container,
		selected_color
	)

	emit_signal("next_requested")





# ==================================================
# SET ALL BUTTONS
# ==================================================

func set_mesh_for_all_buttons(source) -> void:
	for button in shape_buttons:
		var target_container := button.mesh_container
		
		# Fall 0: Mesh-Resource (.tres)
		if source is Mesh:
			var instance := MeshInstance3D.new()
			instance.mesh = source
			target_container.add_child(instance)
			
		if target_container == null:
			continue

		# Alte Inhalte entfernen
		for child in target_container.get_children():
			child.free() # statt queue_free()


		# Fall 1: kompletter Container
		if source is Node3D:
			for child in source.get_children():
				if child is MeshInstance3D:
					target_container.add_child(child.duplicate())

		# Fall 2: einzelnes Mesh
		elif source is MeshInstance3D:
			target_container.add_child(source.duplicate())

		# Fall 3: mehrere Meshes
		elif source is Array:
			for item in source:
				if item is MeshInstance3D:
					target_container.add_child(item.duplicate())

		else:
			push_warning("[UI] Unsupported source type passed to set_mesh_for_all_buttons")
			return

	if DEBUG_SIGNALS:
		print("[UI][DEBUG] set_mesh_for_all_buttons applied")

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

	
func debug_apply_active_shape_to_all_buttons() -> void:
	if not DEBUG_SIGNALS:
		return

	if active_shape_index < 0 or active_shape_index >= shape_buttons.size():
		push_warning("[UI][DEBUG] No active shape selected for debug apply")
		return

	var source_container := shape_buttons[active_shape_index].mesh_container
	if source_container == null:
		push_warning("[UI][DEBUG] Active shape has no mesh_container")
		return

	print(
		"[UI][DEBUG] Applying active shape to all buttons | index =",
		active_shape_index,
		"| source =", source_container.name
	)

	set_mesh_for_all_buttons(source_container)
	
