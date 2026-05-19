class_name CommandBlock
extends Control

@export var duplicator = false

var drag = false
var mouse_pos = Vector2.ZERO
var last_mouse_pos = Vector2.ZERO

func _ready() -> void:
	z_index = 0


func _process(delta: float):
	mouse_pos = get_viewport().get_mouse_position()
	
	if not Input.is_action_pressed("click"): 
		if z_index > 0: 
			z_index = 0
		if drag:
			drag = false
	
	if drag:
		position += mouse_pos - last_mouse_pos
	
	last_mouse_pos = mouse_pos


func _on_color_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		drag = true
		z_index = 100 if event.is_pressed() else 0
	elif event is InputEventMouseMotion and drag:
		if duplicator:
			get_parent().add_child(duplicate())
			duplicator = false
			get_parent().pass_to_command_field(self)
