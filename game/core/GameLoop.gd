extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var sessionProperties : GameSessionProperties = GameSessionProperties.new(10)
	var session : GameSession = GameSession.new(sessionProperties)
	
	session.sessionStarted.connect(onSessionStarted)
	session.stateChanged.connect(onSessionStateChanged)
	
	session.Start()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func onSessionStarted() -> void:
	print("Session started")
	
func onSessionStateChanged(newState : GameSession.GameState) -> void:
	print("Session changed State: " + str(newState))
