extends Button
class_name ShapeButton

@export var mesh_container: Node3D

var shapes: Array[MeshInstance3D] = []
var current_shape_index := 0


func _ready() -> void:
	_collect_shapes()
	_show_only(current_shape_index)


func _collect_shapes() -> void:
	shapes.clear()

	for child in mesh_container.get_children():
		if child is MeshInstance3D:
			shapes.append(child)

	if shapes.is_empty():
		push_warning("No shapes found in MeshContainer:", name)

func _show_only(index: int) -> void:
	for i in range(shapes.size()):
		shapes[i].visible = (i == index)
