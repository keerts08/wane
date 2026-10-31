extends Node2D

@export var level_number: int
@export var leveltochange: PackedScene
@export var sacrificedialogue : DialogueResource
@onready var total_coins = str(get_tree().get_nodes_in_group("coin").size())

var level_cleared := false
var change_level: bool = false
var player_health: int = 5
var player_speed: int = 400
var knowledge_sacrificed : bool = false
var player_dead : bool = false
var bullet_player_speed = 500
var coins_collected = 0



signal player_won()
signal lose_knowledge()
signal lose_health()
signal lose_speed()


func _ready() -> void:

	level_cleared = false

func _process(_delta: float) -> void:
	var enemies = get_tree().get_nodes_in_group("Enemy")
	var coins = get_tree().get_nodes_in_group("coin")
	
	if level_number < 6:
		if not level_cleared:
			if enemies.is_empty():
				level_cleared = true 
				change_level_after_delay()
	elif level_number > 5:
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
		DialogueManager.show_example_dialogue_balloon(sacrificedialogue, "start")

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
