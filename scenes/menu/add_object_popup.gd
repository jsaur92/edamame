extends Popup

@export var object_name : LineEdit
@export var object_desc : TextEdit
@export var object_icon : TextureRect
@export var type_options_button : OptionButton
@export var type_description_label : Label
const description_dict : Dictionary[int, String] = {
	0 : "A simple object with no given properties.",
	1 : "An object that can be picked up off the ground, given to the player from a character, and held in the player's backpack.",
	2 : "An object that can say something to the player. It can do more complex things too, like asking multiple-choice questions or giving items, but you'll have to set that in the Interactive tab.",
	3 : "An object that the player cannot walk through.",
}
signal create_object

func _on_option_button_item_selected(index: int) -> void:
	type_description_label.text = description_dict[index]


func _on_object_icon_change_image(image : Image) -> void:
	image.convert(Image.FORMAT_RGBA8)
	object_icon.texture = ImageTexture.create_from_image(image)


func _on_confirm_button_pressed() -> void:
	var obj = ObjectData.create()
	obj.name = object_name.text
	obj.description = object_desc.text
	obj.set_image(object_icon.texture.get_image())
	obj.set_size_x(obj.get_image().get_width())
	obj.set_size_y(obj.get_image().get_height())
	
	match type_options_button.selected:
		0:
			pass
		1:
			obj.set_item()
			var interact_mod := ModInteractable.new()
			var head_node := CommandNode.new()
			head_node.command = CommandGive.new(obj.uid)
			var end_node := CommandNode.new()
			end_node.command = CommandRemove.new()
			head_node.next = [end_node]
			interact_mod.command_heads["default"] = head_node
			obj.set_interactable(interact_mod)
		2:
			var interact_mod := ModInteractable.new()
			var head_node := CommandNode.new()
			head_node.command = CommandSay.new("Hello, my name is " + obj.name + ".")
			interact_mod.command_heads["default"] = head_node
			obj.set_interactable(interact_mod)
		3:
			var collision_mod := ModCollidable.new()
			collision_mod.get_shape().get_rect().size = obj.image.size()
			obj.set_collidable(collision_mod)
	create_object.emit(obj)
	hide()
