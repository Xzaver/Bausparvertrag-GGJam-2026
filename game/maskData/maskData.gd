class_name MaskData extends Resource

@export_group("Components")
@export var eyes:MaskComponent.EMOTIONS
@export var mouth:MaskComponent.EMOTIONS
@export var top:MaskComponent.EMOTIONS
@export var shape:MaskComponent.EMOTIONS


static func RandomMask() -> MaskData:
	var mask : MaskData = MaskData.new()
	mask.eyes = MaskComponent.GetRandomEmotion()
	mask.mouth = MaskComponent.GetRandomEmotion()
	mask.shape = MaskComponent.GetRandomEmotion()
	mask.top = MaskComponent.GetRandomEmotion()
	
	return mask

func ToString() -> String:
	var maskString : String = "EYES: " + str(eyes) +" \nMOUTH: " + str(mouth) + " \nTOP: " + str(eyes) + " \nSHAPE: " + str(shape)
		
	return maskString
