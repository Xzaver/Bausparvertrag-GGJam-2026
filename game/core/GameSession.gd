class_name GameSession

var currentGameState : GameState
var properties : GameSessionProperties

signal sessionStarted
signal stateChanged(newState : GameState)

func _init(props: GameSessionProperties) -> void:
	properties = props
	print("Initialized Session")

func Start() -> void:
	emit_signal("sessionStarted")
	SetGameState(GameState.Init)
	pass
	
func SetGameState(state: GameState) -> void:
	currentGameState = state
	emit_signal("stateChanged", currentGameState)
	
enum GameState {
	Init,
	WaitingForCustomer,
	IntroduceCustomer,
	ProcessCustomer,
	FinalizeCustomer
}
