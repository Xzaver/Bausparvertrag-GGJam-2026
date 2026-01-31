class_name GameSessionProperties

var amountOfRounds : int
var customerCountMin : int
var customerCountMax : int
var difficulty : Difficulty

func _init(_amountOfRounds : int, _customerCountMin : int, _customerCountMax : int, _difficulty : Difficulty):
	customerCountMin = _customerCountMin
	customerCountMax = _customerCountMax
	difficulty = _difficulty
	amountOfRounds = _amountOfRounds

enum Difficulty {
	EASY,
	MEDIUM,
	HARD,
	UNMASKED
}

static func GetDifficultyProperties(_difficulty: Difficulty) -> GameSessionProperties:
	
	match _difficulty:
		Difficulty.EASY:
			return GameSessionProperties.new(10, 1, 1, Difficulty.EASY)
		Difficulty.MEDIUM:
			return GameSessionProperties.new(15, 5, 8, Difficulty.MEDIUM)
		Difficulty.HARD:
			return GameSessionProperties.new(20, 7, 10, Difficulty.HARD)
		Difficulty.UNMASKED:
			return GameSessionProperties.new(30, 9, 15, Difficulty.UNMASKED)
	
	return 
