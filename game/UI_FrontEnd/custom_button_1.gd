extends Button
class_name ShapeButton

@export var mesh_container: Node3D

var shapes: Array[MeshInstance3D] = []
var current_shape_index := 0


func _ready() -> void:
	_collect_shapes()
	_show_only(current_shape_index)
	_update_label()


# =========================
# Public API
# =========================

func set_label(value: String) -> void:
	text = value


func update_label_from_shape(index: int) -> void:
	if index < 0 or index >= shapes.size():
		return
	text = shapes[index].name


# =========================
# Internal
# =========================

func _collect_shapes() -> void:
	shapes.clear()
	for child in mesh_container.get_children():
		if child is MeshInstance3D:
			shapes.append(child)


func _show_only(index: int) -> void:
	for i in range(shapes.size()):
		shapes[i].visible = (i == index)


func _update_label() -> void:
	if shapes.is_empty():
		return
	text = shapes[current_shape_index].name
