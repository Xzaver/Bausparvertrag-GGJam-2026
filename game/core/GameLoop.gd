extends Node

var session : GameSession

func _ready() -> void:
	
	print("---STARTING GAME LOOP---")
	
	var sessionProperties : GameSessionProperties = GameSessionProperties.new(5, 10)
	session = GameSession.new(sessionProperties)
	
	session.sessionStarted.connect(onSessionStarted)
	session.stateChanged.connect(onSessionStateChanged)
	
	session.Start()
	
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DebugNextState"):
		session.NextState()

func onSessionStarted() -> void:
	print("Session started")
	
func onSessionStateChanged(newState : GameSession.GameState) -> void:
	print("Session changed State: " + GameSession.GameState.keys()[newState])
