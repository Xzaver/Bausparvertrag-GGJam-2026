class_name CustomerDoll extends Node3D
@export var sprite :Sprite3D
@export var animPlayer :AnimationPlayer

@export var electro_Sprites :Array[Texture2D]
@export var shoe_Sprites :Array[Texture2D]
@export var animal_Sprites :Array[Texture2D]
@export var plant_Sprites :Array[Texture2D]

var cultList :Dictionary = {
CustomerFactory.CULT.ELECTRO: electro_Sprites,
CustomerFactory.CULT.SHOE: shoe_Sprites,
CustomerFactory.CULT.ANIMAL: animal_Sprites,
CustomerFactory.CULT.PLANT: plant_Sprites
}




func updateSprite(customer :CustomerData) -> void :
	sprite.texture = cultList[customer.cult][customer.sprite]
	


func enter() -> void:
	animPlayer.play("enter")


func leave() -> void:
	animPlayer.play("leave")
