extends Control

## Menú de pausa genérico, abierto utilizando la acción "pause_menu"
## (por default la tecla Esc).
@onready var options_button: Button = $Panel/VBoxContainer/OptionsButton
@onready var options_menu: Control = $OptionsMenu

signal return_requested()

func _ready() -> void:
	hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("pause_menu"):
		visible = !visible
		get_tree().paused = visible
		
		
func _on_resume_button_pressed() -> void:
	hide()
	get_tree().paused = false
	options_menu.hide()

func _on_options_button_pressed() -> void:
	options_menu.show()


func _on_return_button_pressed() -> void:
	return_requested.emit()
