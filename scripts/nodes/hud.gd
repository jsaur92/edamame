class_name HUD
extends Control

@export var container : HBoxContainer
const ICON_SIZE : int = 192

func update_items(inventory:Inventory) -> void:
	var i : int = 0
	while i < inventory.items.size():
		if i < container.get_child_count():
			container.get_child(i).visible = true
			container.get_child(i).texture = get_icon_texture(inventory.items[i])
		else:
			var img = TextureRect.new()
			img.texture = get_icon_texture(inventory.items[i])
			container.add_child(img)
		i += 1
	while i < container.get_child_count():
		container.get_child(i).visible = false
		i += 1


func get_icon_texture(item:ObjectData) -> Texture2D:
	var img = ImageTexture.create_from_image(item.get_image())
	img.set_size_override(Vector2i(ICON_SIZE, ICON_SIZE))
	return img
