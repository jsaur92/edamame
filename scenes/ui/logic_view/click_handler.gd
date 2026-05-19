extends Control

@export var movable_node : Control


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.is_action_pressed("move_click"):
		movable_node.position += event.relative
