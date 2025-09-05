extends Area2D

@export var fire_rate_min = 1.0
@export var fire_rate_max = 2.5
@export var speed = 400
@export var projectile_scene: PackedScene 
@export var projectile_offset = 30 

var time_until_next_shot = 0.0
var target = null 

func _ready():
	$AnimatedSprite2D.play()
	time_until_next_shot = randf_range(fire_rate_min, fire_rate_max)
	z_index = 1  # enemigo encima de los proyectiles

func _process(delta: float) -> void:
	time_until_next_shot -= delta
	
	if target and is_instance_valid(target):
		var direction = (target.global_position - global_position).normalized()
		rotation = direction.angle()
		
		if time_until_next_shot <= 0:
			shoot(direction)
			time_until_next_shot = randf_range(fire_rate_min, fire_rate_max)

func shoot(direction: Vector2):
	if not projectile_scene:
		print("Error: projectile_scene no asignado")
		return
	
	var projectile = projectile_scene.instantiate()
	projectile.global_position = global_position - direction * projectile_offset
	projectile.direction = direction
	projectile.speed = speed
	projectile.rotation = direction.angle()
	projectile.z_index = 0
	get_tree().current_scene.add_child(projectile)
