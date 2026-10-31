extends CharacterBody2D
class_name Player

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var health: CanvasLayer = $Health
@onready var coins: Control = $Health/Coins
@onready var coins_text = $Health/Coins/Label
@onready var gm = get_parent()

@export var BULLET: PackedScene

var direction: int = 0
var heartslist: Array = []
var playerhealth: int = 5

signal player_death()

func _ready() -> void:
	playerhealth = GlobalManager.player_health
	GlobalManager.coins_collected = 0
	update_coins_display()
	
	GlobalManager.player_dead = false
	playerhealth = GlobalManager.player_health
	
	if GlobalManager.player_health <= 0:
		GlobalManager.player_dead = true
		emit_signal("player_death")


	if GlobalManager.knowledge_sacrificed:
		health.visible = false

	var hearts_parent = $Health/Lives/Panel/HBoxContainer
	heartslist.clear()
	for child in hearts_parent.get_children():
		if child.has_node("Sprite2D"):
			heartslist.append(child.get_node("Sprite2D"))
		elif child is Sprite2D:
			heartslist.append(child)
	update_hearts_display()

func _process(_delta: float) -> void:
	update_coins_display()
	if Input.is_action_just_pressed("shoot") and BULLET:
		$Shoot.play()
		var bullet = BULLET.instantiate()
		get_tree().root.add_child(bullet)
		bullet.global_position = global_position
		bullet.rotation = rotation
		
	if gm.level_number < 6:
		coins.visible = false
	elif gm.level_number > 5:
		coins.visible = true
		
	if GlobalManager.player_dead == true:
		get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")

func get_input() -> void:
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * GlobalManager.player_speed
	if Input.is_action_pressed("left"):
		direction = -1
	elif Input.is_action_pressed("right"):
		direction = 1

func _physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	get_input()
	move_and_slide()

func _takeDamage(amount: int) -> void:
	if amount > 0:
		playerhealth -= amount
		GlobalManager.player_health = playerhealth  # update global
		anim_player.play("death")
		update_hearts_display()

		if playerhealth <= 0:
			GlobalManager.player_dead = true

func update_hearts_display() -> void:
	for i in range(heartslist.size()):
		heartslist[i].visible = i < playerhealth
		
func update_coins_display() -> void:
	if GlobalManager.coins_collected != 0:
		coins_text.text = str(GlobalManager.coins_collected) + " / " + str(gm.total_coins)
	else:
		coins_text.text = "0" + " / " + str(gm.total_coins)


func _on_level_player_won() -> void:
	set_process(false)
	set_physics_process(false)


func _on_level_lose_health() -> void:
	if GlobalManager.player_health < 1:
		GlobalManager.player_dead = true
	else:
		_takeDamage(1)
		
func _on_level_lose_knowledge() -> void:
	GlobalManager.knowledge_sacrificed = true


func _on_level_lose_speed() -> void:
	GlobalManager.player_speed -= 200
