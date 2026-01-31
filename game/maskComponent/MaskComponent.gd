extends Node

class_name MaskComponent

enum SLOT {
	EYES = 0,
	MOUTH = 1,
	TOP = 2,
	SHAPE = 3,
	}
@export var slot:SLOT

enum EMOTIONS {
	SAD = 0,
	HAPPY = 1,
	ANGRY = 2,
	CUTE = 3,
	}
@export var emotions:EMOTIONS

@export var colorizeableMeshes :Array[MeshInstance3D] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
