extends Node

var session : GameSession
var scheduler : Scheduler
@export var maskBuilder : MaskConstructor

func _ready() -> void:
	print("---STARTING GAME LOOP---")
	var sessionProperties : GameSessionProperties = GameSessionProperties.new(5, 10)
	session = GameSession.new(sessionProperties)
	
	scheduler = RandomScheduler.new(session.customers)
	
	maskBuilder.FinalizeMask.connect(onMaskFinalized)
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
			
			var mask : MaskData = MaskResourceManager.fetch_mask(session.currentCustomer.maskID)
			
			if mask != null:
				print("Customer has a mask: \n" + mask.ToString())
			else:
				print("Customer has no mask yet. DO IT!")
			
		GameSession.GameState.ProcessCustomer:
			
			var mask : MaskData = MaskResourceManager.fetch_mask(session.currentCustomer.maskID)
			
			if mask != null:
				mask = mask.duplicate()	
			
			maskBuilder.ReceiveMask(mask)
			
			var rndMask : MaskData = MaskData.RandomMask()
			
			maskBuilder.updateMaskProperty(MaskComponent.SLOT.EYES, rndMask.eyes)
			maskBuilder.updateMaskProperty(MaskComponent.SLOT.MOUTH, rndMask.mouth)
			maskBuilder.updateMaskProperty(MaskComponent.SLOT.TOP, rndMask.top)
			maskBuilder.updateMaskProperty(MaskComponent.SLOT.SHAPE, rndMask.shape)
			
			maskBuilder.FinalizeMask.emit(maskBuilder.currentMaskData)
			
		GameSession.GameState.FinalizeCustomer:
			#Receive Mask from MaskBuilder
			#Evaluate Mask Errors
			#Next State
			pass

func onMaskFinalized(maskData: MaskData) -> void:
	session.SetGameState(GameSession.GameState.FinalizeCustomer)
	
	if session.currentCustomer.maskID == CustomerData.EMPTY_MASK_ID:
		session.currentCustomer.maskID = MaskResourceManager.save_mask(maskData)
		
	print("Mask finalized: \n" + maskData.ToString())
	pass
