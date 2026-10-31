extends Control
const BALLOON = preload("res://Dialogues/StorylineButton.tscn")

func _ready() -> void:
	var balloon = BALLOON.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(load("res://Dialogues/Storyline.dialogue"), "start")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
