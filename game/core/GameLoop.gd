extends Node

var session : GameSession
var scheduler : Scheduler

func _ready() -> void:
	print("---STARTING GAME LOOP---")
	var sessionProperties : GameSessionProperties = GameSessionProperties.new(5, 10)
	session = GameSession.new(sessionProperties)
	
	scheduler = RandomScheduler.new(session.customers)
	
	session.sessionStarted.connect(onSessionStarted)
	session.stateChanged.connect(onSessionStateChanged)
	session.Start()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DebugNextState"):
		session.NextState()

func onSessionStarted() -> void:
	print("Session started")
	
func onSessionStateChanged(newState : GameSession.GameState) -> void:
	print("Session changed State: " + GameSession.GameState.keys()[newState])
	
	match newState:
		GameSession.GameState.WaitingForCustomer:
			session.SetCurrentCustomer(scheduler.Next())
			print("Customer " + str(session.currentCustomer.id) + " is entering the shop")
			#Call Fetch Mask ID from MaskResourceManager
			#Call Render Mask/Customer from MaskBuilder
		GameSession.GameState.FinalizeCustomer:
			#Receive Mask from MaskBuilder
			#Evaluate Mask Errors
			#Next State
			pass
