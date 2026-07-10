extends PopupMenu

@export var grid_container : GridContainer

func load_objects() -> void:
	var lib = ObjectLibrary.get_current_library()
	for obj in lib.get_objects():
		var thum = ObjectThumbnail.create_from_object_data(obj)
		grid_container.add_child(thum)
