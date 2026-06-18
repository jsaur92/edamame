class_name InspectorTab
extends Panel

@export_category("Containers")
@export var name_container : HBoxContainer
@export var size_container : HBoxContainer
@export var position_container : HBoxContainer
@export var toggles_container : VBoxContainer
@export_category("Other Nodes")
@export var object_icon : TextureRect
@export var object_name : TextEdit
@export var width_text : SpinBox
@export var height_text : SpinBox
@export var x_text : SpinBox
@export var y_text : SpinBox
@export var item_check_box : CheckBox
@export var collidable_check_box : CheckBox
@export var interactable_check_box : CheckBox
var current_object_data : ObjectData
var current_object_instance : ObjectInstanceData

func _ready() -> void:
	update_panel(null)

## Used whenever a new object is selected. Gives the object to a helper function
## to handle it based on the object's type.
func update_panel(object:Resource) -> void:
	if object == null:
		current_object_data = null
		current_object_instance = null
	elif object is ObjectData:
		current_object_data = object
		current_object_instance = null
		update_panel_object(object)
	elif object is ObjectInstanceData:
		current_object_data = object.object_data
		current_object_instance = object
		update_panel_instance(object)
	set_vis()


## Update the panel based on an ObjectData.
func update_panel_object(object:ObjectData) -> void:
	object_name.text = object.name
	update_image(object)
	width_text.value = int(object_icon.texture.get_width())
	height_text.value = int(object_icon.texture.get_height())
	item_check_box.button_pressed = object.is_item()
	collidable_check_box.button_pressed = object.is_collidable()
	interactable_check_box.button_pressed = object.is_interactable()


## Update the panel based on an ObjectInstanceData.
func update_panel_instance(object:ObjectInstanceData) -> void:
	update_panel_object(object.object_data)
	x_text.text = str(object.position.x)
	y_text.text = str(object.position.y)


## Set the visibility of containers and nodes based on current data availability.
func set_vis() -> void:
	name_container.visible 		= current_object_data != null
	size_container.visible 		= current_object_data != null
	position_container.visible 	= current_object_instance != null
	toggles_container.visible	= current_object_data != null
	object_icon.visible 		= current_object_data != null


func update_image(object:ObjectData) -> void:
	var img = object.get_image().duplicate(true)
	img.resize(object.image_scale.x * img.get_width(), object.image_scale.y * img.get_height(), Image.INTERPOLATE_NEAREST)
	object_icon.texture = ImageTexture.create_from_image(img)


func _on_name_text_text_changed() -> void:
	current_object_data.name = object_name.text


func _on_width_text_value_changed(value: float) -> void:
	current_object_data.image_scale.x = value / current_object_data.get_image().duplicate(true).get_width()
	update_image(current_object_data)


func _on_height_text_value_changed(value: float) -> void:
	current_object_data.image_scale.y = value / current_object_data.get_image().duplicate(true).get_height()
	update_image(current_object_data)


func _on_x_text_value_changed(value: float) -> void:
	current_object_instance.position.x = value


func _on_y_text_value_changed(value: float) -> void:
	current_object_instance.position.y = value


func _on_is_item_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		current_object_data.set_item()
	else:
		current_object_data.remove_item()


func _on_is_collidable_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		current_object_data.set_collidable()
	else:
		current_object_data.remove_collidable()


func _on_is_interactable_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		current_object_data.set_interactable()
	else:
		current_object_data.remove_interactable()
