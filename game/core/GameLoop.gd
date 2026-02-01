extends Node

var session : GameSession
var scheduler : Scheduler
@export var maskBuilder : MaskConstructor
@export var challengeManager : ChallengeManager
@export var scoreKeeper : ScoreKeeper
@export var ui: VibeCodedUI
@export var customerDoll : CustomerDoll

var debugEnabled : bool = false

func _ready() -> void:
	print("---STARTING GAME LOOP---")
	
	#Here you can select difficulty to get difficulty properties. Make difficulty settings in GameSessionProperties class
	var sessionProperties : GameSessionProperties = GameSessionProperties.GetDifficultyProperties(GameSessionProperties.Difficulty.MEDIUM)
	session = GameSession.new(sessionProperties)

	#if you want to access any current session states, like currentCustomer or difficulty settings --> Grab the session object from this GameLoop
	
	#This scheduler simply returns a random customer if you call next()
	scheduler = RandomScheduler.new(session.customers)
	
	maskBuilder.FinalizeMask.connect(onMaskFinalized)
	session.sessionStarted.connect(onSessionStarted)
	session.stateChanged.connect(onSessionStateChanged)
	session.Start()
	
#Just for debug
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DebugNextState"):
		ui.start()

#In Case of initialization stuff
func onSessionStarted() -> void:
	print("Session started")
	
func onSessionStateChanged(newState : GameSession.GameState) -> void:
	print("Session changed State: " + GameSession.GameState.keys()[newState])
	
	match newState:
		
		GameSession.GameState.Init:
			session.NextState()
			
		GameSession.GameState.WaitingForCustomer:
			
			session.SetCurrentCustomer(scheduler.Next())
			print("Customer " + str(session.currentCustomer.id) + " is entering the shop")
			##TODO 
			var mask : MaskData = MaskResourceManager.fetch_mask(session.currentCustomer.maskID)
			
			if mask != null:
				print("Customer has a mask: \n" + mask.ToString())
			else:
				print("Customer has no mask yet. DO IT!")
			
			
			customerDoll.updateSprite(session.currentCustomer) #set sprite
			
			#if debug enabled the program does not automatically go to next state
			if !debugEnabled:
				session.SetGameState(GameSession.GameState.ProcessCustomer)
			
		GameSession.GameState.ProcessCustomer:
			customerDoll.enter()
			
			await customerDoll.animPlayer.animation_finished
			ui.set_active(true)
			var mask : MaskData = MaskResourceManager.fetch_mask(session.currentCustomer.maskID)
			
			if mask != null:
				mask = mask.duplicate()	
				challengeManager.requestChallenge(mask,1) #challenge manager creates challenge
			else:
				mask = MaskData.RandomMask()
				challengeManager.requestChallenge(mask,1, true)
			
			#if debug enabled we automatically create random mask and go to next state
			if debugEnabled == true:
				
				if mask == null:
					mask = MaskData.RandomMask()
				
				maskBuilder.ReceiveMask(mask)
				
				#maskBuilder.updateMaskProperty(MaskComponent.SLOT.EYES, rndMask.eyes)
				#maskBuilder.updateMaskProperty(MaskComponent.SLOT.MOUTH, rndMask.mouth)
				#maskBuilder.updateMaskProperty(MaskComponent.SLOT.TOP, rndMask.top)
				#maskBuilder.updateMaskProperty(MaskComponent.SLOT.SHAPE, rndMask.shape)
				
				#maskBuilder.renderMask(rndMask)
				
				maskBuilder.FinalizeMask.emit(mask)
			else: 
				
				
				
				maskBuilder.ReceiveMask(mask)
			
			
		GameSession.GameState.GameOver:
			pass

func onMaskFinalized(userMaskData: MaskData) -> void:
	customerDoll.leave()
	ui.set_active(false)
	
	#here user feedback goes
	var malus:int = challengeManager.validate(userMaskData) #challenge manager validates through all challenges, saves malus
	
	session.currentCustomer.maskID = MaskResourceManager.save_mask(userMaskData)
	
	session.SetGameState(GameSession.GameState.FinalizeCustomer)
	challengeManager.reset()
	
	var gameOver :bool = scoreKeeper.updateScore(session.currentCustomer, malus) #scorekeeper gets malus
	await customerDoll.animPlayer.animation_finished
	if gameOver:
		session.SetGameState(GameSession.GameState.GameOver)
	else:
		session.NextState()
	print("Mask finalized: \n" + userMaskData.ToString())
	pass
