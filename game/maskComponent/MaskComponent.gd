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
	
static func GetRandomEmotion() -> int:
	var values = MaskComponent.EMOTIONS.values()
	return values[randi() % values.size()] as MaskComponent.EMOTIONS

	
static func GetRandomSlot() -> int:
	var values = MaskComponent.SLOT.values()
	return values[randi() % values.size()] as MaskComponent.SLOT
