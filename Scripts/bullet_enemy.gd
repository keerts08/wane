extends Area2D


const  speed: int = 500

func _process(delta: float) -> void:
	position += transform.x * speed * delta



func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var collider = body
		collider._takeDamage(1)
		queue_free()
		
	elif body is TileMapLayer:
		queue_free()
