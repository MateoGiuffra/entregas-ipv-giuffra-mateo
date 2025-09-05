extends Area2D

@export var speed = 400 
var direction = Vector2.ZERO

func _process(delta: float) -> void:
	if direction != Vector2.ZERO:
		position += direction * speed * delta 

	var screen_size = get_viewport_rect().size
	if position.x < 0 or position.y < 0 or position.x > screen_size.x or position.y > screen_size.y:
		queue_free()
	$AnimatedSprite2D.play("shooting")
