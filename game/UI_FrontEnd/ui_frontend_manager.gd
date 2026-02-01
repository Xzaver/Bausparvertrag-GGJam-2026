extends Control
"""
UI Manager – handles shape selection, preview and confirmation.
"""
const SLOT_SEQUENCE := [
	MaskComponent.SLOT.EYES,
	MaskComponent.SLOT.MOUTH,
	MaskComponent.SLOT.TOP,
	MaskComponent.SLOT.SHAPE,
]
var current_slot_index: int = 0


const SLOT_LABELS := {
	MaskComponent.SLOT.EYES: "EYES",
	MaskComponent.SLOT.MOUTH: "MOUTH",
	MaskComponent.SLOT.TOP: "TOP",
	MaskComponent.SLOT.SHAPE: "SHAPE",
}

const EMOTION_LABELS := {
	MaskComponent.EMOTIONS.SAD: "SAD",
	MaskComponent.EMOTIONS.HAPPY: "HAPPY",
	MaskComponent.EMOTIONS.ANGRY: "ANGRY",
	MaskComponent.EMOTIONS.CUTE: "CUTE",
}


# ==================================================
# Exported UI References
# ==================================================
const DEBUG_SIGNALS := true

signal mask_process_finished(selections: Dictionary)

var mask_selections: Dictionary = {}
var mask_process_completed: bool = false

signal simple_mask_selection(data: Dictionary)

signal shape_selected(index: int)
signal next_requested
signal color_selected(color: Color)
signal selection_confirmed(
	shape_index: int,
	mesh_container: Node3D,
	color: Color
)
signal mask_selection_changed(
	slot: MaskComponent.SLOT,
	emotion: MaskComponent.EMOTIONS,
	color: Color
)


# 
# SINGAL Masken Config process abgeschlossen -> der kommt dann wenn man durch alle EMotions und shapes durch ist
# SINGAL COlor
# SINGAL Dict emotion slot
# SIgnal maskcomponentSlot, MaskCmponent.Emotions 

#Xaver — 09:40Sunday, 1 February 2026 09:40
#func updateMaskProperty(slot:MaskComponent.SLOT,emotion:MaskComponent.EMOTIONS):


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

	# 🔁 Selbst-Listener
	self.mask_process_finished.connect(_on_mask_process_finished)

	# Initiale Iteration
	set_mask_text_for_iteration(SLOT_SEQUENCE[current_slot_index])

	if color_picker:
		color_picker.color_changed.connect(_on_color_changed)

	if debug_apply_all_button:
		debug_apply_all_button.pressed.connect(_on_debug_apply_all_pressed)


func _to_one_based(value: int) -> int:
	return value + 1

func _on_mask_process_finished(selections: Dictionary) -> void:
	if DEBUG_SIGNALS:
		print("[UI] Resetting mask process")

	_reset_mask_process()

func _reset_mask_process() -> void:
	# Prozess-Status
	mask_process_completed = false
	current_slot_index = 0
	active_shape_index = -1

	# Selections löschen
	mask_selections.clear()

	# UI zurücksetzen
	set_mask_text_for_iteration(SLOT_SEQUENCE[current_slot_index])

	# Optional: Debug-Mesh leeren
	if debug_mesh_container:
		for child in debug_mesh_container.get_children():
			child.queue_free()

	# Optional: Next wieder aktivieren
	if next_button:
		next_button.disabled = false


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

	var slot: MaskComponent.SLOT = SLOT_SEQUENCE[current_slot_index]
	var emotion: MaskComponent.EMOTIONS = _emotion_from_button_index(index)
	var color: Color = selected_color

	# ==================================================
	# State speichern (für Final-Payload)
	# ==================================================
	mask_selections[slot] = {
		"slot": slot,
		"emotion": emotion,
		"shape_index": index,
		"color": color,
	}

	# ==================================================
	# SIGNAL 1: mask_selection_changed (Enum + Color)
	# ==================================================
	if DEBUG_SIGNALS:
		print(
			"[UI][SIGNAL] mask_selection_changed |",
			"slot =", slot,
			"| emotion =", emotion,
			"| color =", color
		)

	emit_signal("mask_selection_changed", slot, emotion, color)

	# ==================================================
	# SIGNAL 2: simple_mask_selection (1–4 / 1–4)
	# ==================================================
	var simple_payload := {
		"emotion": emotion + 1, # Enum (0–3) → 1–4
		"shape": index + 1     # Index (0–3) → 1–4
	}

	if DEBUG_SIGNALS:
		print(
			"[UI][SIGNAL] simple_mask_selection |",
			"emotion =", simple_payload["emotion"],
			"| shape =", simple_payload["shape"]
		)

	emit_signal("simple_mask_selection", simple_payload)

	# ==================================================
	# SIGNAL 3: updateMaskProperty (Domain-Signal)
	# ==================================================
	if DEBUG_SIGNALS:
		print(
			"[UI][SIGNAL] updateMaskProperty |",
			"slot =", slot,
			"| emotion =", emotion
		)

	emit_signal("updateMaskProperty", slot, emotion)

	# ==================================================
	# UI / Debug
	# ==================================================
	apply_active_shape_to_debug_container()

	if DEBUG_SIGNALS:
		print(
			"[UI][SIGNAL] shape_selected |",
			"shape_index =", index
		)

	emit_signal("shape_selected", index)


func _on_next_button_clicked() -> void:
	# ⛔ Guard: Prozess ist bereits abgeschlossen
	if mask_process_completed:
		return

	current_slot_index += 1

	if current_slot_index >= SLOT_SEQUENCE.size():
		mask_process_completed = true

		if DEBUG_SIGNALS:
			print("[UI][SIGNAL] mask_process_finished")

		emit_signal("mask_process_finished", mask_selections)
		return

	# Slot-Wechsel normal
	active_shape_index = -1
	set_mask_text_for_iteration(SLOT_SEQUENCE[current_slot_index])

	if DEBUG_SIGNALS:
		print(
			"[UI][SIGNAL] next_requested | active_shape_index =",
			active_shape_index,
			"| color =",
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
# SET TEXTs
# ==================================================

# UIManager.gd

func set_mask_text_for_iteration(slot: MaskComponent.SLOT) -> void:
	var slot_text: String = SLOT_LABELS.get(slot, "UNKNOWN")
	var emotions := MaskComponent.EMOTIONS.values()
	var color_text := _color_to_hex(selected_color)

	for i in range(shape_buttons.size()):
		if i >= emotions.size():
			break

		var emotion: MaskComponent.EMOTIONS = emotions[i]
		var emotion_text: String = EMOTION_LABELS.get(emotion, "UNKNOWN")

		shape_buttons[i].set_label(
			"%s\n%s\n%s" % [slot_text, emotion_text, color_text]
		)




# ==================================================
# COLOR PICKER
# ==================================================
func _emotion_from_button_index(index: int) -> MaskComponent.EMOTIONS:
	var emotions := MaskComponent.EMOTIONS.values()

	if index < 0 or index >= emotions.size():
		push_warning("[UI] Invalid button index for emotion:", index)
		return emotions[0] as MaskComponent.EMOTIONS

	return emotions[index] as MaskComponent.EMOTIONS





# ==================================================
# COLOR PICKER
# ==================================================


func _color_to_hex(color: Color) -> String:
	var r := int(color.r * 255.0)
	var g := int(color.g * 255.0)
	var b := int(color.b * 255.0)
	return "#%02X%02X%02X" % [r, g, b]


func _on_color_changed(color: Color) -> void:
	selected_color = color

	apply_color_to_all_meshes(color)

	# ⬇️ NEU: Button-Texte live aktualisieren
	set_mask_text_for_iteration(SLOT_SEQUENCE[current_slot_index])

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
	
