class_name ScoreKeeper extends Node
var malus: int = 0
@export var loseThreshold : int = 10;
signal game_over

func reset():
	malus = 0

func updateScore(customer:CustomerData, incomingMalus:int) -> bool:
	malus += incomingMalus 
	
	if malus > loseThreshold:
		return true
	else :
		return false
