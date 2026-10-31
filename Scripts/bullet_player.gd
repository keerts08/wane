extends Area2D

func  _ready() -> void:
	pass

func _process(delta: float) -> void:
	position += transform.x * GlobalManager.bullet_player_speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		var collider = body
		collider._takeDamage(1)
		queue_free()
	elif body is TileMapLayer:
		queue_free()
