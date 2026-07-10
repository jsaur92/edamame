extends PopupMenu

@export var grid_container : GridContainer
signal selected_obj

func load_objects() -> void:
	for node in grid_container.get_children():
		node.queue_free()
	var lib = ObjectLibrary.get_current_library()
	for obj in lib.get_objects():
		if obj.is_item():
			var thum := ObjectThumbnail.create_from_object_data(obj)
			grid_container.add_child(thum)
			thum.clicked.connect(_on_thum_clicked)


func _on_thum_clicked(thum:ObjectThumbnail) -> void:
	selected_obj.emit(thum)
