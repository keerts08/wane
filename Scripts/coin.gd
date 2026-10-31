extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		GlobalManager.coins_collected += 1
		queue_free()
