class_name CustomerDoll extends Node3D
@export var sprite :Sprite3D
@export var animPlayer :AnimationPlayer

@export var electro_Sprites :Array[Texture2D]
@export var shoe_Sprites :Array[Texture2D]
@export var animal_Sprites :Array[Texture2D]
@export var plant_Sprites :Array[Texture2D]

@onready var cultList :Dictionary = {
0: electro_Sprites,
1: shoe_Sprites,
2: animal_Sprites,
3: plant_Sprites
}




func updateSprite(customer :CustomerData) -> void :
	cultList = {
	0: electro_Sprites,
	1: shoe_Sprites,
	2: animal_Sprites,
	3: plant_Sprites
	}

	var cultArray : Array[Texture2D] = cultList[customer.cult]
	
	sprite.texture = cultArray.get(customer.sprite)


func enter() -> void:
	animPlayer.play("enter")


func leave() -> void:
	animPlayer.play("leave")
