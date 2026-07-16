class_name HUD
extends Control

@export var inventory_control : Control
const ICON_SIZE : int = 192

func update_items(inventory:Inventory) -> void:
	pass


#func get_icon_texture(item:ObjectData) -> Texture2D:
	#var img = ImageTexture.create_from_image(item.get_image())
	#img.set_size_override(Vector2i(ICON_SIZE, ICON_SIZE))
	#return img


func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		inventory_control.visible = not inventory_control.visible
