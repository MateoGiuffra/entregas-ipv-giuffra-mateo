extends Area2D

@export var speed := 400
var facing_right := true
var screen_size := Vector2.ZERO

func start(pos):
	position = pos

func _ready():
	screen_size = get_viewport_rect().size

func can_shoot():
	return Input.is_action_just_pressed("shoot")

func _process(delta: float) -> void:
	var velocity := Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		facing_right = true
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		facing_right = false
	
	var mouse_pos = get_global_mouse_position()
	$Arm.aim_at(mouse_pos)
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.animation = "run"
		$AnimatedSprite2D.play()
		$Arm.hide_arm()
	else:
		$AnimatedSprite2D.animation = "idle"
		$Arm.hide_arm()
		$AnimatedSprite2D.play()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	$AnimatedSprite2D.flip_h = not facing_right

	if velocity.length() <= 0 and mouse_pos.y < position.y: 
		if mouse_pos.x < position.x:
			$AnimatedSprite2D.flip_h = true
			$Arm.position.x = -40
			$Arm.turn_around(-1)
		else:
			$AnimatedSprite2D.flip_h = false
			$Arm.position.x = 35
			$Arm.turn_around(1)
		$AnimatedSprite2D.animation = "up"
		$Arm.show_arm()
		$AnimatedSprite2D.play()
		
	if can_shoot():
		$Arm.shoot_to(mouse_pos)
