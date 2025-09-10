extends CharacterBody2D 

@onready var cannon: Node = $Cannon
@export var ACCELERATION: float = 20.0
@export var H_SPEED_LIMIT: float = 600.0
@export var FRICTION_WEIGHT: float = 0.1
@export var GRAVITY:float = 15.0 
@export var JUMP_SPEED: float = 500.9
signal shot

var projectile_container: Node

func initialize(projectile_container: Node) -> void:
	self.projectile_container = projectile_container
	cannon.projectile_container = projectile_container

func cannon_fire():
	# Cannon rotation
	var mouse_position: Vector2 = get_global_mouse_position()
	cannon.look_at(mouse_position)
	
	# Cannon fire
	if Input.is_action_just_pressed("fire_cannon"):
		if projectile_container == null:
			projectile_container = get_parent()
			cannon.projectile_container = projectile_container
		cannon.fire()
		
func player_movement():
	# Player movement
	
	if Input.is_action_just_pressed("jump") and is_on_floor(): 
		velocity.y = -JUMP_SPEED
	
	var h_movement_direction: int = int(
		Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left")
	)
	
	if h_movement_direction != 0:
		velocity.x = clamp(
			velocity.x + (h_movement_direction * ACCELERATION),
			-H_SPEED_LIMIT,
			H_SPEED_LIMIT
		)
	else:
		velocity.x = lerp(velocity.x, 0.0, FRICTION_WEIGHT) if abs(velocity.x) > 1.0 else 0.0
		
	
func _physics_process(delta: float) -> void:
	cannon_fire()
	player_movement()
	velocity.y += GRAVITY
	move_and_slide()
	

func _on_shot() -> void:
	print("mori...")
	#queue_free()
