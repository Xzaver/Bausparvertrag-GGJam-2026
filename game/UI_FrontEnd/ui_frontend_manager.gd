extends Control

signal ui_selection_changed(mask_index: int, color: Color)

@export var mask_buttons: Array[Button]
@export var color_picker: ColorPickerButton
@export var next_button: Button
@export var scroll_left_button: Button
@export var scroll_right_button: Button


var current_mask_index: int = -1
var current_color: Color = Color.WHITE


func _ready() -> void:
	print("[UI] UI Manager ready")

	_connect_mask_buttons()
	_connect_color_picker()
	_connect_next_button()
	_connect_scroll_buttons()


func _connect_mask_buttons() -> void:
	for i in range(mask_buttons.size()):
		var button := mask_buttons[i]
		button.pressed.connect(_on_mask_button_pressed.bind(i))
		print("[UI] Connected mask button index:", i)


func _connect_color_picker() -> void:
	if color_picker:
		color_picker.color_changed.connect(_on_color_changed)
		print("[UI] Connected color picker")


func _connect_next_button() -> void:
	if next_button:
		next_button.pressed.connect(_on_next_pressed)
		print("[UI] Connected NEXT button")


func _connect_scroll_buttons() -> void:
	if scroll_left_button:
		scroll_left_button.pressed.connect(_on_scroll_left_pressed)
		print("[UI] Connected SCROLL LEFT button")

	if scroll_right_button:
		scroll_right_button.pressed.connect(_on_scroll_right_pressed)
		print("[UI] Connected SCROLL RIGHT button")


# =========================
# Event Handlers
# =========================

func _on_mask_button_pressed(index: int) -> void:
	current_mask_index = index
	print("[UI] Mask button pressed | index =", index)
	_emit_change()


func _on_color_changed(color: Color) -> void:
	current_color = color
	print("[UI] Color changed | color =", color)
	_emit_change()


func _on_next_pressed() -> void:
	print("[UI] NEXT button pressed")
	_emit_change()


func _on_scroll_left_pressed() -> void:
	print("[UI] Scroll LEFT pressed")


func _on_scroll_right_pressed() -> void:
	print("[UI] Scroll RIGHT pressed")


# =========================
# Emit
# =========================

func _emit_change() -> void:
	print(
		"[UI] Emit ui_selection_changed | mask_index =",
		current_mask_index,
		"| color =",
		current_color
	)

	emit_signal(
		"ui_selection_changed",
		current_mask_index,
		current_color
	)
