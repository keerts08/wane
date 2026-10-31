extends Node2D


@export var player : Player
@export var sprite : Sprite2D

func  _physics_process(delta: float) -> void:
	if player.direction == 1:
		sprite.flip_h = false
	elif player.direction == -1:
		sprite.flip_h = true
		

		
