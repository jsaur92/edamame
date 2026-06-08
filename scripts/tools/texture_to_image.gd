@tool
extends Node
## Used to convert textures to images within the Godot editor for testing purposes.

@export var texture : Texture2D
@export_tool_button("Convert to Image!", "Image") var c = convert_to_img
@export var image : Image
@export_category("Saving")
@export var save_dir : String = "res://assets/resources/"
@export_enum(".tres", ".res") var extension : String = ".tres"
@export_tool_button("Save Image file", "Save") var s = save
@export var save_output_error : Error

func convert_to_img():
	if texture != null:
		image = texture.get_image()


func save():
	var splits = texture.resource_path.split("/")
	var word = splits.get(splits.size()-1)
	word = word.substr(0, word.find("."))
	word += extension
	var path = save_dir + word
	var result = ResourceSaver.save(image, path)
	save_output_error = result
	notify_property_list_changed()
	image = null #get this out of here to save storage when saving the scene.
