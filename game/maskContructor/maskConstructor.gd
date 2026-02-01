extends Node

class_name MaskConstructor


var currentMaskData :MaskData

@export var eyePosRef :Node3D
@export var mouthPosRef :Node3D
@export var topPosRef :Node3D
@export var shapePosRef :Node3D

# --- components

@export_group("eye")
@export var eye_SAD :PackedScene 
@export var eye_HAPPY :PackedScene 
@export var eye_ANGRY :PackedScene 
@export var eye_CUTE :PackedScene 

@export_group("mouth")
@export var mouth_SAD :PackedScene 
@export var mouth_HAPPY :PackedScene 
@export var mouth_ANGRY :PackedScene 
@export var mouth_CUTE :PackedScene 

@export_group("top")
@export var top_SAD :PackedScene 
@export var top_HAPPY :PackedScene 
@export var top_ANGRY :PackedScene 
@export var top_CUTE :PackedScene

@export_group("shape")
@export var shape_SAD :PackedScene
@export var shape_HAPPY :PackedScene 
@export var shape_ANGRY :PackedScene 
@export var shape_CUTE :PackedScene

#--- Mask Pos

@export var maskRoot : Node3D

var eyePos :Vector3
var mouthPos :Vector3
var topPos :Vector3
var shapePos :Vector3

signal FinalizeMask(maskDataToSend:MaskData)

var instanced_eyes :Node3D
var instanced_mouth :Node3D
var instanced_top :Node3D
var instanced_shape :Node3D

var colorizeable_EYES :Array[MeshInstance3D]
var colorizeable_MOUTH :Array[MeshInstance3D]
var colorizeable_TOP :Array[MeshInstance3D]
var colorizeable_SHAPE :Array[MeshInstance3D]

func _ready() -> void:
		
	eyePos = eyePosRef.global_position
	mouthPos = mouthPosRef.global_position
	topPos = topPosRef.global_position
	shapePos = shapePosRef.global_position

func clearBuilder():
	
	var childrenToKill : Array[Node] = maskRoot.get_children()
	
	for i in childrenToKill :
		i.queue_free()

func renderMask(maskData:MaskData):
	
	clearBuilder()
	
	instanced_eyes = PlaceSceneToSlot(MaskComponent.SLOT.EYES, GetEmotionEyes(maskData.eyes))
	colorizeable_EYES = getMeshestoChangeColor(instanced_eyes)
	
	instanced_mouth = PlaceSceneToSlot(MaskComponent.SLOT.MOUTH, GetEmotionMouth(maskData.mouth))
	colorizeable_MOUTH = getMeshestoChangeColor(instanced_mouth)
	
	instanced_top = PlaceSceneToSlot(MaskComponent.SLOT.TOP, GetEmotionTop(maskData.top))
	colorizeable_TOP = getMeshestoChangeColor(instanced_top)
	
	instanced_shape = PlaceSceneToSlot(MaskComponent.SLOT.SHAPE, GetEmotionShape(maskData.shape))
	colorizeable_SHAPE = getMeshestoChangeColor(instanced_shape)
	

func GetEmotionEyes(emotion : MaskComponent.EMOTIONS) -> PackedScene:
	match emotion:
		MaskComponent.EMOTIONS.SAD:
			return eye_SAD
		MaskComponent.EMOTIONS.HAPPY:
			return eye_HAPPY
		MaskComponent.EMOTIONS.ANGRY:
			return eye_ANGRY
		MaskComponent.EMOTIONS.CUTE:
			return eye_SAD
	return null

func GetEmotionMouth(emotion : MaskComponent.EMOTIONS) -> PackedScene:
	match emotion:
		MaskComponent.EMOTIONS.SAD:
			return mouth_SAD
		MaskComponent.EMOTIONS.HAPPY:
			return mouth_HAPPY
		MaskComponent.EMOTIONS.ANGRY:
			return mouth_ANGRY
		MaskComponent.EMOTIONS.CUTE:
			return mouth_SAD
	return null

func GetEmotionTop(emotion : MaskComponent.EMOTIONS) -> PackedScene:
	match emotion:
		MaskComponent.EMOTIONS.SAD:
			return top_SAD
		MaskComponent.EMOTIONS.HAPPY:
			return top_HAPPY
		MaskComponent.EMOTIONS.ANGRY:
			return top_ANGRY
		MaskComponent.EMOTIONS.CUTE:
			return top_SAD
	return null

func GetEmotionShape(emotion : MaskComponent.EMOTIONS) -> PackedScene:
	match emotion:
		MaskComponent.EMOTIONS.SAD:
			return shape_SAD
		MaskComponent.EMOTIONS.HAPPY:
			return shape_HAPPY
		MaskComponent.EMOTIONS.ANGRY:
			return shape_ANGRY
		MaskComponent.EMOTIONS.CUTE:
			return shape_SAD
	return null

func PlaceSceneToSlot(slot : MaskComponent.SLOT, objToInstantiate : PackedScene) -> Node3D:
	
	print("Place")
	
	var instantiatedComponent : Node3D = objToInstantiate.instantiate()
	
	maskRoot.add_child(instantiatedComponent)
	
	match slot:
		MaskComponent.SLOT.EYES:
			instantiatedComponent.global_position = eyePos
			return instantiatedComponent
		MaskComponent.SLOT.MOUTH:
			instantiatedComponent.global_position = mouthPos
			return instantiatedComponent
		MaskComponent.SLOT.TOP:
			instantiatedComponent.global_position = topPos
			return instantiatedComponent
		MaskComponent.SLOT.SHAPE:
			instantiatedComponent.global_position = shapePos
			return instantiatedComponent

	return instantiatedComponent

func ReceiveMask(maskdatafrommanager:MaskData):
	if maskdatafrommanager == null:
		currentMaskData = MaskData.new()
	else:
		currentMaskData = maskdatafrommanager
		renderMask(currentMaskData)

func updateMaskProperty(slot:MaskComponent.SLOT,emotion:MaskComponent.EMOTIONS,colorToChange:Color):
	
	match slot:
		MaskComponent.SLOT.EYES:
			currentMaskData.eyes = emotion
			renderMask(currentMaskData)
			var materialToChange:BaseMaterial3D = colorizeable_EYES[0].get_surface_override_material(0)
			materialToChange.albedo_color = colorToChange
		
		MaskComponent.SLOT.MOUTH:
			currentMaskData.mouth = emotion
			renderMask(currentMaskData)
			var materialToChange:BaseMaterial3D = colorizeable_MOUTH[0].get_surface_override_material(0)
			materialToChange.albedo_color = colorToChange
			
		MaskComponent.SLOT.TOP:
			currentMaskData.top = emotion
			renderMask(currentMaskData)
			var materialToChange:BaseMaterial3D = colorizeable_TOP[0].get_surface_override_material(0)
			materialToChange.albedo_color = colorToChange
			
		MaskComponent.SLOT.SHAPE:
			currentMaskData.shape = emotion
			renderMask(currentMaskData)
			var materialToChange:BaseMaterial3D = colorizeable_SHAPE[0].get_surface_override_material(0)
			materialToChange.albedo_color = colorToChange


func getMeshestoChangeColor(instancedComponent:Node3D) -> Array[MeshInstance3D]:
	
	var componentData :MaskComponent = instancedComponent.get_child(0)
	return componentData.colorizeableMeshes
	
