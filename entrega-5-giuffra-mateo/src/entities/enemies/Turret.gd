extends CharacterBody2D
class_name EnemyTurret

@onready var fire_position: Node2D = $FirePosition
@onready var fire_timer: Timer = $FireTimer
@onready var raycast: RayCast2D = $RayCast2D
@onready var body_anim: AnimatedSprite2D = $Body
@export var radius: Vector2 = Vector2(10.0, 10.0)
@export var speed: float = 10.0
@export var max_speed: float = 100.0
@export var pathfinding_stop_threshold: float = 5.0

@export var projectile_scene: PackedScene


@export var pathfinding_path: NodePath
var pathfinding: PathfindAstar


@onready var idle_timer: Timer = $IdleTimer

var path: Array = []
var target: Node2D
var projectile_container: Node
var dead: bool = false


func _ready() -> void:
	fire_timer.timeout.connect(fire)
	_play_animation(&"idle")
	pathfinding = get_node_or_null(pathfinding_path)


func initialize(turret_pos: Vector2, _projectile_container: Node) -> void:
	global_position = turret_pos
	self.projectile_container = _projectile_container
	idle_timer.start()


func fire() -> void:
	if target != null and !dead:
		var proj_instance: Node = projectile_scene.instantiate()
		if projectile_container == null:
			projectile_container = get_parent()
		projectile_container.add_child(proj_instance)
		proj_instance.initialize(
			fire_position.global_position,
			fire_position.global_position.direction_to(target.global_position)
		)
		fire_timer.start()
		_play_animation(&"attack")


func _physics_process(_delta: float) -> void:
	if dead:
		return
	
	if target != null: 
		raycast.set_target_position(raycast.to_local(target.global_position))
		if raycast.is_colliding() and raycast.get_collider() == target:
			path = []
			velocity = Vector2.ZERO
			if fire_timer.is_stopped():
				fire_timer.start()
		elif !fire_timer.is_stopped():
			fire_timer.stop()
		
	if !path.is_empty():
		var next_point: Vector2 = path.front()
		
		var dir := global_position.direction_to(next_point)
		velocity += dir * speed
		velocity = velocity.limit_length(max_speed)
		
		while global_position.distance_to(next_point) < pathfinding_stop_threshold:
			path.pop_front()
			if path.is_empty():
				idle_timer.start()
				break
			next_point = path.front()
	else: 
		if target != null:
			body_anim.flip_h = raycast.target_position.x < 0
	
	move_and_slide()


func notify_hit() -> void:
	print("I'm turret and imma die")
	dead = true
	target = null
	fire_timer.stop()
	collision_layer = 0
	
	if target != null:
		_play_animation(&"die_alert")
	else:
		_play_animation(&"die")


func _remove() -> void:
	get_parent().remove_child(self)
	queue_free()


func _on_detection_area_body_entered(body: Node2D) -> void:
	if target == null and !dead:
		target = body
		_play_animation(&"alert")


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == target and !dead:
		target = null
		fire_timer.stop()
		_play_animation(&"go_normal")


func _on_animation_finished() -> void:
	match body_anim.animation:
		&"alert":
			_play_animation(&"idle_alert")
		&"go_normal":
			_play_animation(&"idle")
		&"fire", &"attack":
			_play_animation(&"alert")
		&"die", &"die_alert":
			call_deferred(&"_remove")


func _play_animation(animation: StringName) -> void:
	if body_anim.sprite_frames.has_animation(animation):
		body_anim.play(animation)


func _on_idle_timer_timeout() -> void:
	if pathfinding != null and !dead: 
		var random_target: Vector2 = global_position + Vector2(
			randf_range(-radius.x, radius.x),
			randf_range(-radius.y, radius.y)
		)
		path = pathfinding.get_simple_path(global_position, random_target)
