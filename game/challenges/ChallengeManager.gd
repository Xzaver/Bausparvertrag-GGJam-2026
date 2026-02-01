class_name ChallengeManager extends Node

var challenges:Array[Challenge]
var slots:Array

func reset():
	challenges.clear()
	slots = MaskComponent.SLOT.values()


func _ready() -> void:
	reset()



func requestChallenge(storedMaskData:MaskData, amount:int , first:bool = false):

	var emotionFlags = 0
	for i in range(amount):
		var slot:MaskComponent.SLOT = randomSlot()
		if first:
			challenges.append(ChallengeRepair.new(storedMaskData, slot))
			first = false
		else:
			var rand = randi_range(0,1)
			match rand:
				0:
					challenges.append(ChallengeRepair.new(storedMaskData, slot))
				1:
					emotionFlags+=1
					challenges.append(ChallengeRepair.new(storedMaskData, slot))
			

	var emotions = {
		"sad" = 0,
		"happy" = 0,
		"angry" = 0,
		"cute" = 0
	}
	
	for i in range(emotionFlags):
		emotions[emotions.keys().pick_random()] += 1
		
		
	return challenges

	




func validate(userMaskData:MaskData) -> int:
	var malus: int = 0
	for i in challenges.size():
		if challenges[i].validate(userMaskData) == false:
			malus+=1
		
	return malus


func randomSlot() -> MaskComponent.SLOT:
	var slot = slots.pick_random()
	slots.erase(slot)
	return slot
