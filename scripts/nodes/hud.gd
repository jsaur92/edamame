class_name HUD
extends Control

@export var inventory_control : Control
@export var item_grid_container : GridContainer
const ICON_SIZE : int = 192

func update_items(inventory:Inventory) -> void:
	for child in item_grid_container.get_children():
		child.queue_free()
	for item in inventory.get_items():
		var ot = ObjectThumbnail.create_from_object_data(item)
		ot.mult_size(2)
		item_grid_container.add_child(ot)


#func get_icon_texture(item:ObjectData) -> Texture2D:
	#var img = ImageTexture.create_from_image(item.get_image())
	#img.set_size_override(Vector2i(ICON_SIZE, ICON_SIZE))
	#return img


func _on_inventory_button_pressed() -> void:
	inventory_control.visible = not inventory_control.visible
	get_tree().paused = inventory_control.visible 
