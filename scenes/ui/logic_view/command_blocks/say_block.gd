extends Control

@export var duplicator = false
@export var textedit : TextEdit
var base_height
const HEIGHT_PER_LINE = 42

func _ready() -> void:
	z_index = 0
	base_height = size.y - textedit.size.y

func _on_text_edit_text_changed() -> void:
	pass


func _on_text_edit_resized() -> void:
	size.y = textedit.size.y


func _on_color_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		z_index = 1 if event.is_pressed() else 0
	elif event is InputEventMouseMotion and Input.is_action_pressed("click"):
		if duplicator:
			get_parent().add_child(duplicate())
			duplicator = false
		position += event.relative
