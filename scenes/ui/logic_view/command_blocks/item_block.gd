extends Control

@export var duplicator = false

func _ready() -> void:
	z_index = 0


func _on_color_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		z_index = 1 if event.is_pressed() else 0
	elif event is InputEventMouseMotion and Input.is_action_pressed("click"):
		if duplicator:
			get_parent().add_child(duplicate())
			duplicator = false
		position += event.relative
