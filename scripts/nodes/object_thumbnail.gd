class_name ObjectThumbnail
extends Control
## Visual representation of a single Object, used in the Objects Dock of the
## editor.

@export var texrect : TextureRect
@export var label : RichTextLabel

static func create_from_object_data(object:ObjectData) -> ObjectThumbnail:
	var ot : ObjectThumbnail = ConstScenes.OBJ_THUMBNAIL.instantiate()
	ot.set_object(object)
	return ot


func set_object(object:ObjectData) -> void:
	var imgtex = ImageTexture.create_from_image(object.get_image())
	imgtex.set_size_override(size)
	texrect.texture = imgtex
	label.text = "[center]"+object.name
