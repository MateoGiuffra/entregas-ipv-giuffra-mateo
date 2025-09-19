extends StaticBody2D

@export var hit_poins: int = 3
@export var wait_time_to_shot: float = 1
@export var projectile_scene: PackedScene

@onready var fire_position: Node2D = $FirePosition
@onready var raycast: RayCast2D = $RayCast2D
@onready var body_anim: AnimatedSprite2D = $Body
@onready var fire_timer: Timer = $FireTimer
@onready var hit_timer: Timer = $DetectionArea/HitTimer

var target: Node2D
var projectile_container: Node


func _ready() -> void:
	fire_timer.timeout.connect(fire)
	fire_timer.wait_time = wait_time_to_shot
	set_physics_process(false)


func initialize(turret_pos: Vector2, projectile_container: Node) -> void:
	global_position = turret_pos
	self.projectile_container = projectile_container
	_play_animation("idle")


func fire() -> void:
	if target == null or _is_died():
		return
	
	var proj_instance: Node = projectile_scene.instantiate()
	if projectile_container == null:
		projectile_container = get_parent()
	projectile_container.add_child(proj_instance)
	proj_instance.initialize(
		fire_position.global_position,
		fire_position.global_position.direction_to(target.global_position)
	)
	fire_timer.start()


func _physics_process(_delta: float) -> void:
	if target == null or _is_died():
		return
	
	raycast.set_target_position(raycast.to_local(target.global_position))
	
	if raycast.is_colliding() and raycast.get_collider() == target:
		if fire_timer.is_stopped():
			fire_timer.start()
	elif not fire_timer.is_stopped():
		fire_timer.stop()
	
	if body_anim.animation != "hitted":
		_play_animation("idle")


func notify_hit() -> void:
	if _is_died():
		return
	_hit()
	

func _hit() -> void: 
	hit_poins -= 1
	_play_animation("hitted")
	hit_timer.start()
	if _is_died(): 
		_die()


func _is_died() -> bool: 
	return hit_poins <= 0


func _die() -> void:
	_play_animation("die")
	fire_timer.stop()
	hit_timer.stop()
	set_physics_process(false)

func _remove() -> void:
	get_parent().remove_child(self)
	queue_free()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if target == null and not _is_died():
		target = body
		set_physics_process(true)


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
		set_physics_process(false)


func _on_hit_timer_timeout() -> void:
	if not _is_died():
		_play_animation("idle")
 
func _play_animation(animation: StringName) -> void:
	if body_anim.sprite_frames.has_animation(animation):
		if body_anim.animation != animation: 
			body_anim.play(animation)

func _on_body_animation_finished() -> void:
	if _is_died() and body_anim.animation == "die":
		body_anim.stop()
		_remove()
