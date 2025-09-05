extends Node
@export var enemy_scene: PackedScene  # arrastrás Enemy.tscn aquí
var screen_size := Vector2.ZERO

func _ready(): 
	screen_size = get_viewport().size
	create_new_enemy()
	create_new_enemy()
	
func create_new_enemy(): 
	var enemy = enemy_scene.instantiate()
	var random_pos = Vector2(
		randf() * screen_size.x,         
		randf() * screen_size.y * 0.25   
	)
	enemy.position = random_pos
	enemy.target = $Player
	add_child(enemy)
