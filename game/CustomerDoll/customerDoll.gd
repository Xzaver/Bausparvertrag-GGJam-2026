class_name CustomerDoll extends Node3D
@export var sprite :Sprite3D
@export var animPlayer :AnimationPlayer
func updateSprite(customer :CustomerData) -> void :
	sprite.texture 


func enter() -> void:
	animPlayer.play("enter")


func leave() -> void:
	animPlayer.play("leave")
