class_name HUD
extends Control

@export var inventory_control : Control
@export var item_grid_container : GridContainer
@export var interact_button : Button
@export var inventory_button : Button
@export var virtual_joystick : VirtualJoystick
const ICON_SIZE : int = 192


func _ready() -> void:
	virtual_joystick.visible = OS.get_name() in ["Android", "iOS"] or OS.has_feature("web_android") or OS.has_feature("web_ios")


func _process(delta: float) -> void:
	# change button visibility as needed
	interact_button.visible = InteractManager.get_instance().get_closest() != null
	inventory_button.visible = not Game.get_game().player.inventory.is_empty()


func update_items(inventory:Inventory) -> void:
	
	inventory_button.visible = inventory.get_items().size() > 0
	
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


func _on_interact_button_button_down() -> void:
	var event = InputEventAction.new()
	event.action = "interact"
	event.pressed = true
	Input.parse_input_event(event)


func _on_interact_button_button_up() -> void:
	var event = InputEventAction.new()
	event.action = "interact"
	event.pressed = false
	Input.parse_input_event(event)
