class_name ChallengeManager extends Node

var challenges:Array[Challenge]
var slots:Array
func reset():
	challenges.clear()
	slots = MaskComponent.SLOT.values()

func _ready() -> void:
	reset()
	requestChallenge(MaskData.RandomMask(),4,true)
	print(challenges)

	
func requestChallenge(storedMaskData:MaskData, amount:int , first:bool = false) -> Array:
	var emotionFlags = 0
	for i in range(amount):
		var slot:MaskComponent.SLOT = randomSlot()
		print(slot)
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
	print(emotions)
	
	return challenges


func validate(userMaskData:MaskData):
	pass


func randomSlot() -> MaskComponent.SLOT:
	var slot = slots.pick_random()
	slots.erase(slot)
	return slot
