extends Control

@export var game_data : GameData
@export var objects_dock : HFlowContainer

## Sets game_data. Call after instantiation and before adding as child of scene.
func setup(_game_data:GameData):
	game_data = _game_data


func _ready() -> void:
	update_objects_dock()


func update_objects_dock() -> void:
	for child in objects_dock.get_children():
		child.queue_free()
	for object in game_data.object_library.get_objects():
		objects_dock.add_child( ObjectThumbnail.create_from_object_data(object) )
