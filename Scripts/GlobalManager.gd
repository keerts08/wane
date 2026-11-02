extends Node2D

@export var level_number: int
@export var leveltochange: PackedScene
@export var sacrificedialogue : DialogueResource
@export var intro_dialogue: DialogueResource
@onready var total_coins = str(get_tree().get_nodes_in_group("coin").size())

var level_cleared := false
var change_level: bool = false
var player_health: int = 5
var player_speed: int = 400
var knowledge_sacrificed : bool = false
var player_dead : bool = false
var bullet_player_speed = 500
var coins_collected = 0
var game_started := false

signal player_won()
signal lose_knowledge()
signal lose_health()
signal lose_speed()

func _ready() -> void:
	level_cleared = false
	GlobalManager.game_started = false
	if intro_dialogue != null:
		get_tree().paused = true
		DialogueManager.dialogue_ended.connect(_on_intro_ended, CONNECT_ONE_SHOT)
		DialogueManager.show_dialogue_balloon(intro_dialogue, "start")
	else:
		GlobalManager.game_started = true

func _on_intro_ended(_resource: DialogueResource) -> void:
	get_tree().paused = false
	_start_game()

func _start_game() -> void:
	await get_tree().create_timer(0.7).timeout
	GlobalManager.game_started = true
	
func _process(_delta: float) -> void:
	var enemies = get_tree().get_nodes_in_group("Enemy")
	var coins = get_tree().get_nodes_in_group("coin")
	
	if not level_cleared:
		if enemies.is_empty() and coins.is_empty():
			level_cleared = true  
			change_level_after_delay()

func change_level_after_delay() -> void:
	change_level = true
	await get_tree().create_timer(0.1).timeout
	get_tree().paused = false
	if leveltochange:
		emit_signal("player_won")
		DialogueManager.show_dialogue_balloon(sacrificedialogue, "start")

func sac_knowledge():
	emit_signal("lose_knowledge")

func sac_health():
	emit_signal("lose_health")

func sac_speed():
	emit_signal("lose_speed")
	
func sac_shoot_speed():
	GlobalManager.bullet_player_speed *= 0.5

func _finished():
	get_tree().change_scene_to_packed(leveltochange)
