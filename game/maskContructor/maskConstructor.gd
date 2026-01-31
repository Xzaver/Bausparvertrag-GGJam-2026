extends Node

class_name MaskConstructor


var currentMaskData :MaskData

@export var eyePosRef :Node3D
@export var mouthPosRef :Node3D
@export var topPosRef :Node3D
@export var shapePosRef :Node3D

# --- components

@export var eye_SAD :PackedScene 
@export var eye_HAPPY :PackedScene 
@export var eye_ANGRY :PackedScene 
@export var eye_CUTE :PackedScene 

@export var mouth_SAD :PackedScene 
@export var mouth_HAPPY :PackedScene 
@export var mouth_ANGRY :PackedScene 
@export var mouth_CUTE :PackedScene 

@export var top_SAD :PackedScene 
@export var top_HAPPY :PackedScene 
@export var top_ANGRY :PackedScene 
@export var top_CUTE :PackedScene 

@export var shape_SAD :PackedScene 

#--- Mask Pos

var eyePos :Transform3D = eyePosRef.transform
var mouthPos :Transform3D = mouthPosRef.transform
var topPos :Transform3D = topPosRef.transform
var shapePos :Transform3D = shapePosRef.transform


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
