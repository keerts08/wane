extends CharacterBody2D
class_name Enemy


@onready var animplayer: AnimationPlayer = $AnimationPlayer

@export var speed = 150
@export var player : Player
var player_chase = false
var enemyhealth : int = 3

@export var ENEMYBULLET : PackedScene

var shoot_cooldown := 1.0 
var shoot_timer := 0.0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("down") or Input.is_action_just_pressed("up") or Input.is_action_just_pressed("right") or Input.is_action_just_pressed("left") or Input.is_action_just_pressed("shoot"):
		player_chase = true
	if player_chase:
		var direction = (player.position - position).normalized()
		velocity = direction * speed
		look_at(player.position)
		move_and_slide()

		# Shooting cooldown logic
		shoot_timer -= delta
		if shoot_timer <= 0.0:
			shoot_bullet()
			shoot_timer = shoot_cooldown
		
func  _takeDamage(amount: int):
	if amount > 0:
		enemyhealth -= amount
		animplayer.play("death")
		if enemyhealth <= 0:
			queue_free()


func shoot_bullet():
	var bullet = ENEMYBULLET.instantiate()
	get_tree().root.add_child(bullet)
	bullet.global_position = global_position
	bullet.rotation = rotation
	
