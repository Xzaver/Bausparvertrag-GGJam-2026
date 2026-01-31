class_name ChallengeRepair extends Challenge
var brokenComp:MaskComponent.SLOT
var initialMask:MaskData

func _init(storedMask : MaskData, slot : MaskComponent.SLOT) -> void:
	brokenComp = slot
	initialMask = storedMask
	


func validate(receivedMask : MaskData)-> bool:
	match brokenComp:
		MaskComponent.SLOT.EYES:
			if receivedMask.eyes == initialMask.eyes:
				return true
			else:
				return false
		MaskComponent.SLOT.MOUTH:
			if receivedMask.mouth == initialMask.mouth:
				return true
			else:
				return false
		MaskComponent.SLOT.TOP:
			if receivedMask.top == initialMask.top:
				return true
			else:
				return false
		MaskComponent.SLOT.SHAPE:
			if receivedMask.shape == initialMask.shape:
				return true
			else:
				return false
	return false
