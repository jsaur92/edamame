class_name InspectorTab
extends Panel

@export var object_icon : TextureRect
@export var object_name : TextEdit
@export var width_text : SpinBox
@export var height_text : SpinBox
var current_object

## Used whenever a new object is selected. Gives the object to a helper function
## to handle it based on the object's type.
func update_panel(object:Resource) -> void:
	if object == null:
		pass
	elif object is ObjectData:
		update_panel_object(object)
	elif object is ObjectInstanceData:
		update_panel_instance(object)


## Update the panel based on an ObjectData.
func update_panel_object(object:ObjectData) -> void:
	object_name.text = object.name
	var img = object.get_image().duplicate(true)
	img.resize(object.image_scale.x * img.get_width(), object.image_scale.y * img.get_height(), Image.INTERPOLATE_NEAREST)
	object_icon.texture = ImageTexture.create_from_image(img)
	width_text.value = int(object.image_scale.x * object_icon.texture.get_width())
	height_text.value = int(object.image_scale.y * object_icon.texture.get_height())


## Update the panel based on an ObjectInstanceData.
func update_panel_instance(object:ObjectInstanceData) -> void:
	update_panel_object(object.object_data)
