extends Node

class_name MaskConstructor


var currentMaskData :MaskData

@export var eyePos :Node3D
@export var mouthPos :Node3D
@export var topPos :Node3D
@export var shapePos :Node3D

# --- components

@export var 
@export var 
@export var 
@export var 
@export var 
@export var 
@export var 
@export var 
@export var 
@export var 
@export var 
@export var
@export var 






signal FinalizeMask(maskDataToSend:MaskData)

func clearBuilder():
	pass

func renderMask(maskData:MaskData):
	print("Render Mask ")
	
	match mas
	
	match maskData:
		maskData.eyes
	
	pass

func ReceiveMask(maskdatafrommanager:MaskData):
	if maskdatafrommanager == null:
		currentMaskData = MaskData.new()
	else:
		currentMaskData = maskdatafrommanager
		renderMask(currentMaskData)

func updateMaskProperty(slot:MaskComponent.SLOT,emotion:MaskComponent.EMOTIONS):
	
	match slot:
		MaskComponent.SLOT.EYES:
			currentMaskData.eyes = emotion
		
		MaskComponent.SLOT.MOUTH:
			currentMaskData.mouth = emotion
			
		MaskComponent.SLOT.TOP:
			currentMaskData.top = emotion
			
		MaskComponent.SLOT.SHAPE:
			currentMaskData.shape = emotion
