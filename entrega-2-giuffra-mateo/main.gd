extends Node
@export var enemy_scene: PackedScene  # arrastrás Enemy.tscn aquí
var screen_size := Vector2.ZERO

func _ready(): 
	screen_size = get_viewport().size
	create_new_enemy()
	create_new_enemy()
	create_new_enemy()
	
func create_new_enemy(): 
	var enemy = enemy_scene.instantiate()
	var random_pos: Vector2
	var valid_pos := false

	while not valid_pos:
		random_pos = Vector2(
			randf() * screen_size.x * 0.20,
			randf() * screen_size.y * 0.25
		)
		valid_pos = true
		for child in get_children():
			if child.is_in_group("enemies"):  
				if child.position.distance_to(random_pos) < 200:
					valid_pos = false
					break

	enemy.position = random_pos
	enemy.target = $Player
	enemy.add_to_group("enemies")
	add_child(enemy)
