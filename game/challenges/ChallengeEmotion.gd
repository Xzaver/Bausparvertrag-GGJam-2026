class_name ChallengeEmotion extends Challenge
var requiredEmotion : MaskComponent.EMOTIONS
var requiredRatio : float

func _init(storedMask : MaskData, emotion : MaskComponent.EMOTIONS, ratio : float) -> void:
	type = Challenge.TYPES.EMOTION
	requiredEmotion = emotion
	requiredRatio = ratio 


func validate(receivedMask:MaskData)-> bool:
	if calcEmotionRatio(requiredEmotion, receivedMask) >= requiredRatio:
		return true
	else:
		return false


func calcEmotionRatio(emotion : MaskComponent.EMOTIONS, receivedMask:MaskData) -> float:
	var val = 0;
	if receivedMask.eyes == emotion:
		val+=1
	if receivedMask.mouth == emotion:
		val+=1
	if receivedMask.top == emotion:
		val+=1
	if receivedMask.shape == emotion:
		val+=1
	return val/4
