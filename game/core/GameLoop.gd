extends Node

func _ready() -> void:
	
	print("---STARTING GAME LOOP---")
	
	var sessionProperties : GameSessionProperties = GameSessionProperties.new(5, 10)
	var session : GameSession = GameSession.new(sessionProperties)
	
	session.sessionStarted.connect(onSessionStarted)
	session.stateChanged.connect(onSessionStateChanged)
	
	session.Start()
	
	pass

func _process(delta: float) -> void:
	pass

func onSessionStarted() -> void:
	print("Session started")
	
func onSessionStateChanged(newState : GameSession.GameState) -> void:
	print("Session changed State: " + str(newState))
