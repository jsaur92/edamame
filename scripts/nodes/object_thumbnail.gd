class_name ObjectThumbnail
extends Control
## Visual representation of a single Object, used in the Objects Dock of the
## editor.

@export var texrect : TextureRect
@export var label : RichTextLabel
var object_data : ObjectData
signal clicked

static func create_from_object_data(object:ObjectData) -> ObjectThumbnail:
	var ot : ObjectThumbnail = ConstScenes.OBJ_THUMBNAIL.instantiate()
	ot.set_object(object)
	return ot


func set_object(object:ObjectData) -> void:
	object_data = object
	var imgtex = ImageTexture.create_from_image(object.get_image())
	imgtex.set_size_override(size)
	texrect.texture = imgtex
	label.text = "[center]"+object.name


func get_object() -> ObjectData:
	return object_data


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		clicked.emit(self)
