extends ColorRect

@export var left : Control
@export var right : Control

## x=minimum, y=maximum
@export var boundaries : Vector2 

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.is_action_pressed("click"):
		var adjust = event.relative.x
		if position.x + adjust < boundaries.x:
			adjust = position.x - boundaries.x
		elif position.x + adjust > boundaries.y:
			adjust = position.x - boundaries.y
		position.x += adjust
		left.size.x += adjust
		right.size.x -= adjust
		right.position.x += adjust
