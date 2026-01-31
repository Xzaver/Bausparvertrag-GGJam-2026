class_name GameSession

var properties : GameSessionProperties
var currentGameState : GameState
var maxCustomers : int
var currentCustomer : CustomerData

var customers : Array[CustomerData] = []

signal sessionStarted
signal stateChanged(newState : GameState)

func _init(props: GameSessionProperties) -> void:
	properties = props
	maxCustomers = rand_int(properties.customerCountMin, properties.customerCountMax)
	customers = CustomerFactory.CreateCustomers(0, maxCustomers)
	print("Initialized Session with customer count: " + str(maxCustomers))

func Start() -> void:
	emit_signal("sessionStarted")
	SetGameState(GameState.Init)
	pass
	
func SetGameState(state: GameState) -> void:
	currentGameState = state
	emit_signal("stateChanged", currentGameState)
	
func NextState() -> GameState:
	var newState = currentGameState
	
	if currentGameState == GameState.FinalizeCustomer:
		newState = 0
	else:
		newState += 1
	
	SetGameState(newState)
	
	return currentGameState
	
func SetCurrentCustomer(customer : CustomerData) -> void:
	currentCustomer = customer
	
func rand_int(min_val: int, max_val: int) -> int:
	return min_val + (randi() % (max_val - min_val + 1))
	
enum GameState {
	Init,
	WaitingForCustomer,
	IntroduceCustomer,
	ProcessCustomer,
	FinalizeCustomer
}
