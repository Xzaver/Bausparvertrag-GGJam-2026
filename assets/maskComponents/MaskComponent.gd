extends Node

class_name MaskComponent

enum SLOT {
	EYES = 1,
	MOUTH = 2,
	TOP = 3,
	SHAPE = 4,}
@export var slot:SLOT

enum EMOTIONS {
	SAD = 1,
	HAPPY = 2,
	ANGRY = 3,
	CUTE = 4,
}
@export var emotions:EMOTIONS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
