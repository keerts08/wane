extends CharacterBody2D
class_name Enemy


@onready var animplayer: AnimationPlayer = $AnimationPlayer
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

const PATH_UPDATE_INTERVAL := 0.1
var path_timer := 0.0
@export var speed = 150
@export var player : Player
var player_chase = false
var enemyhealth : int = 3

@export var ENEMYBULLET : PackedScene

var shoot_cooldown := 1.0 
var shoot_timer := 0.0

func _process(delta: float) -> void:
	if GlobalManager.game_started == false:
		return
	if Input.is_action_pressed("down") or Input.is_action_pressed("up") or Input.is_action_pressed("right") or Input.is_action_pressed("left") or Input.is_action_just_pressed("shoot"):
		player_chase = true
	if player_chase:
		path_timer -= delta
		if path_timer <= 0.0:
			nav_agent.target_position = player.global_position
			path_timer = PATH_UPDATE_INTERVAL

		var next_pos = nav_agent.get_next_path_position()
		var direction = (next_pos - global_position)
		# No baked navmesh on this level (or no path yet): chase in a straight line like before.
		if NavigationServer2D.map_get_regions(nav_agent.get_navigation_map()).is_empty():
			direction = player.global_position - global_position
		velocity = direction.normalized() * speed
		look_at(player.global_position)
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
	
