class_name TextGenerator extends Node

@export var label: RichTextLabel
@export var dialogue: JSON
func _ready() -> void:
	pass
	
	
func displayChallengeDialogue(customer : CustomerData, challenges : Array[Challenge]) -> void:
	var cult :String
	var challenge:String
	match  challenges[0].type:
		Challenge.TYPES.REPAIR:
			challenge = "repair"
		Challenge.TYPES.EMOTION:
			challenge = "repair"
	match customer.cult:
		CustomerFactory.CULT.ELECTRO:
			cult = "lamp"
		CustomerFactory.CULT.ANIMAL:
			cult = "animal"
		CustomerFactory.CULT.PLANT:
			cult = "plant"
		CustomerFactory.CULT.SHOE:
			cult = "shoe"
	var linesToDecide :Array
	for i in dialogue.data.size():
		var line :Dictionary = dialogue.data[i]
		if line.get("type") == challenge:
			print(line.keys())
			if line.get("cult") == cult:
				linesToDecide.append(line)
				print("succes")
	
	var text = linesToDecide.pick_random().get("content")
	print(text)
	label.text = text
