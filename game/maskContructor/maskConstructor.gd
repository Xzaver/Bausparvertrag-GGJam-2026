extends Node

class_name MaskConstructor

@export var TestMesh :MeshInstance3D = null
@export var TestColor :Color = Color(1,1,1,1)
var currentMaskData :MaskData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var TestMat: BaseMaterial3D = TestMesh.get_surface_override_material(0)
	TestMat.set_albedo(TestColor)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func initMaskData():
	
	currentMaskData = MaskData.new()

func updateMaskProperty(slot:MaskComponent.SLOT,emotion:MaskComponent.EMOTIONS):
	
	match slot:
		MaskComponent.SLOT.EYES:
			
			currentMaskData.eyes = emotion
