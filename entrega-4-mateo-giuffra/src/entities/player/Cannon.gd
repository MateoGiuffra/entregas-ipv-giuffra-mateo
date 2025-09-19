extends Node2D

@onready var weapon_tip: Node2D = $WeaponTip

@export var projectile_scene: PackedScene
@onready var fx_anim: AnimatedSprite2D = $FXAnim

var projectile_container: Node
var fire_tween: Tween

func _ready() -> void:
	fx_anim.stop()

## Desacoplamos el manejo del arma para que maneje su propia lógica.
## Es útil si queremos controlar su implementación independientemente
## o si queremos introducir variedad (muchas armas, por ejemplo).
func process_input() -> void:
	pass


func fire() -> void:
	if fire_tween != null: 
		fire_tween.kill()
	rotation = (get_global_mouse_position() - global_position).angle()
	
	fx_anim.play("fire")
	fx_anim.animation_finished.connect(_fire)
	

func _fire() -> void: 
	var projectile_instance: Node = projectile_scene.instantiate()
	projectile_container.add_child(projectile_instance)
	projectile_instance.initialize(
		weapon_tip.global_position,
		global_position.direction_to(weapon_tip.global_position)
	)
	
	fire_tween = create_tween()
	
	var final_angle:float = rotation + Vector2.LEFT.rotated(rotation).angle_to(Vector2.DOWN)
	
	fire_tween.tween_property(self, "rotation", final_angle, 0.5).set_delay(0.5)
