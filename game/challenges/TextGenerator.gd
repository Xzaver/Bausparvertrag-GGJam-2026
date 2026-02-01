class_name TextGenerator extends Node

@export var label: Label
@export var dialogue: JSON
func _ready() -> void:
	print(dialogue.data)
	
	
func onCustomerEntered(customer : CustomerData) -> void:
	print(dialogue.data)
