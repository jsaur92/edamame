class_name ObjectIconTexRect
extends TextureRect

@export var button : Button
@export var file_dialog : FileDialog
signal change_image

func _ready() -> void:
	_set_control_size()


func set_texture_with_size_adjustment(new_texture:Texture2D) -> void:
	texture = new_texture
	_set_control_size()


func _set_control_size() -> void:
	if texture != null:
		custom_minimum_size = texture.get_size()


func _on_mouse_entered() -> void:
	button.visible = true


func _on_mouse_exited() -> void:
	button.visible = false


func _on_button_pressed() -> void:
	file_dialog.popup_file_dialog()


func _on_file_dialog_file_selected(path: String) -> void:
	var img := Image.load_from_file(path)
	if img != null:
		change_image.emit( img )
	else:
		push_error("No image found at ", path)
