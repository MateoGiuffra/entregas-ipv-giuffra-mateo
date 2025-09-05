extends Node2D

@export var rotation_limit_right_deg := 20.0   
@export var rotation_limit_left_deg := 150.0  
@export var projectile_scene: PackedScene

func aim_at(target: Vector2) -> void:
	look_at(target)

func turn_around(scale_y):
	scale.y = scale_y
	
func hide_arm():
	hide()
	
func show_arm():
	show()

func shoot_to(target: Vector2):
	var projectile = projectile_scene.instantiate()
	projectile.global_position = global_position
	projectile.direction = (target - global_position).normalized()
	projectile.rotation = (target - global_position).angle()
	projectile.speed = 400
	get_tree().current_scene.add_child(projectile)
	print("Disparo! desde ", position, " hasta ",  target)
