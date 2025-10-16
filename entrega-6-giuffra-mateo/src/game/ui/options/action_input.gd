extends HBoxContainer
@onready var action: Label = $Action
@onready var input: Label = $Input

@export var action_input: String
@export var action_name: String

func _ready() -> void:
	input.text = action_input
	action.text = action_name

func set_action_input(inp: String) -> void:
	action_input = inp
	if Engine.is_editor_hint() && has_node("Input"):
		input.text = inp

func set_action_name(nm: String) -> void:
	action_name = nm
	if Engine.is_editor_hint() && has_node("Action"):
		action.text = nm
