class_name InspectorTab
extends Control

@export_category("Containers")
@export var name_container : HBoxContainer
@export var size_container : HBoxContainer
@export var position_container : HBoxContainer
@export var toggles_container : VBoxContainer
@export_category("Other Nodes")
@export var object_icon : ObjectIconTexRect
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
var current_player_data : PlayerInitData

## Emitted whenever the value of an object or object instance changes in the
## inspector. Passes the changed object/instance. In the future, this could
## also pass the changed value so that it only adjusts that.
## Only emit on things that would change the objects displayed in the environment,
## like size.
signal edited

func _ready() -> void:
	update_panel(null)


## Used whenever a new object is selected. Gives the object to a helper function
## to handle it based on the object's type.
func update_panel(object:Resource) -> void:
	if object is ObjectData:
		current_object_data = object
		current_object_instance = null
		current_player_data = null
		update_panel_object(object)
	
	elif object is ObjectInstanceData:
		current_object_data = object.object_data
		current_object_instance = object
		current_player_data = null
		update_panel_instance(object)
	
	elif object is PlayerInitData:
		current_object_data = null
		current_object_instance = null
		current_player_data = object
		update_panel_player(object)
	
	else:
		current_object_data = null
		current_object_instance = null
		current_player_data = null
	set_vis()
	edited.emit(object)


## Update the panel based on an ObjectData.
func update_panel_object(object:ObjectData) -> void:
	object_name.text = object.name
	update_image(object)
	width_text.set_value_no_signal(int(object_icon.texture.get_width()))
	height_text.set_value_no_signal(int(object_icon.texture.get_height()))
	item_check_box.set_pressed_no_signal(object.is_item())
	collidable_check_box.set_pressed_no_signal(object.is_collidable())
	interactable_check_box.set_pressed_no_signal(object.is_interactable())


## Update the panel based on an ObjectInstanceData.
func update_panel_instance(object:ObjectInstanceData) -> void:
	update_panel_object(object.object_data)
	x_text.set_value_no_signal(object.position.x)
	y_text.set_value_no_signal(object.position.y)


func update_panel_player(object:PlayerInitData) -> void:
	object_name.text = "Player"
	x_text.set_value_no_signal(object.init_pos.x)
	y_text.set_value_no_signal(object.init_pos.y)

## Set the visibility of containers and nodes based on current data availability.
func set_vis() -> void:
	# helper variables
	var c_has_object_data = current_object_data != null
	var c_has_instance_data = current_object_instance != null
	var c_is_object_not_instance = c_has_object_data and not c_has_instance_data
	var c_is_player = current_player_data != null
	
	name_container.visible 		= c_has_object_data or c_is_player
	size_container.visible 		= c_has_object_data
	position_container.visible 	= c_has_instance_data or c_is_player
	toggles_container.visible	= c_has_object_data
	object_icon.visible 		= c_has_object_data
	
	set_container_editable(name_container, c_is_object_not_instance)
	set_container_editable(size_container, c_is_object_not_instance)
	set_container_editable(toggles_container, c_is_object_not_instance)
	


## Helper function for set_vis().
func set_container_editable(container:Container, editable:bool=true) -> void:
	for child in container.get_children():
		# for the text / number edits
		if child.get("editable") != null:
			child.set("editable", editable)
		# for the checkboxes / buttons
		if child.get("disabled") != null:
			child.set("disabled", not editable)


func update_image(object:ObjectData) -> void:
	object_icon.set_texture_with_size_adjustment( ImageTexture.create_from_image( object.get_scaled_image() ) )


func _on_name_text_text_changed() -> void:
	current_object_data.name = object_name.text


func _on_width_text_value_changed(value: float) -> void:
	var pre_value = current_object_data.get_image_size_pixels().x
	current_object_data.set_size_x(value)
	update_image(current_object_data)
	if current_object_data.is_collidable():
		current_object_data.get_mod(Enums.ObjectModType.COLLIDABLE).scale_width( value / pre_value )
	edited.emit(current_object_data)


func _on_height_text_value_changed(value: float) -> void:
	var pre_value = current_object_data.get_image_size_pixels().y
	current_object_data.set_size_y(value)
	update_image(current_object_data)
	if current_object_data.is_collidable():
		current_object_data.get_mod(Enums.ObjectModType.COLLIDABLE).scale_height( value / pre_value )
	edited.emit(current_object_data)


func _on_x_text_value_changed(value: float) -> void:
	if current_object_instance != null:
		current_object_instance.set_pos_x(value)
		edited.emit(current_object_instance)
	
	elif current_player_data != null:
		current_player_data.set_pos_x(value)
		edited.emit(current_player_data)


func _on_y_text_value_changed(value: float) -> void:
	if current_object_instance != null:
		current_object_instance.set_pos_y(value)
		edited.emit(current_object_instance)
	
	elif current_player_data != null:
		current_player_data.set_pos_y(value)
		edited.emit(current_player_data)


func _is_player_input_on(line:LineEdit) -> bool:
	return line.has_focus() or Input.is_action_just_pressed("editor_confirm")


func _on_is_item_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		if not current_object_data.is_item():
			current_object_data.set_item()
	else:
		current_object_data.remove_item()
	edited.emit(current_object_data)


func _on_is_collidable_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		if not current_object_data.is_collidable():
			current_object_data.set_collidable()
	else:
		current_object_data.remove_collidable()
	edited.emit(current_object_data)


func _on_is_interactable_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		if not current_object_data.is_interactable():
			current_object_data.set_interactable()
	else:
		current_object_data.remove_interactable()
	edited.emit(current_object_data)


func _on_object_icon_change_image(image) -> void:
	if image is Texture2D:
		if image.has_method("get_image"):
			image = image.get_image()
		else:
			push_error("Image not selected.")
			image = load(ObjectData.DEFAULT_IMAGE_PATH)
	current_object_data.set_image( image )
	update_image(current_object_data)
	edited.emit(current_object_data)
