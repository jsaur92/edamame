class_name GameEnvironment
extends Node2D

@export var tilemap : TileMapLayer
@export var objects_root : Node2D
@export var player : Player
var environment_data : EnvironmentData

func setup(data:EnvironmentData):
	environment_data = data
	setup_terrain()
	setup_objects()


func setup_terrain():
	tilemap.tile_set = environment_data.get_tileset()
	tilemap.set_pattern(Vector2i.ZERO, environment_data.get_tilemap_pattern())


func setup_objects():
	for child in get_objects():
		child.queue_free()
	for object in environment_data.get_objects():
		var new_obj : GameObject = GameObject.setup(object)
		objects_root.add_child(new_obj)


## Returns the child GameObjects stored in the objects_root node. Uses a work
## around to force get_children into a typed array without using a loop.
func get_objects() -> Array[GameObject]:
	var children = objects_root.get_children()
	var objects : Array[GameObject] = []
	objects.append_array(children)
	return objects


## Add ObjectInstanceData to the environment_data and return the generated
## GameObject made in objects_root.
func add_object(object_instance:ObjectInstanceData) -> GameObject:
	environment_data.add_object(object_instance)
	var new_obj = GameObject.setup(object_instance)
	objects_root.add_child( new_obj )
	return new_obj


func get_mouse_pos_in_environment() -> Vector2:
	return get_tree().root.get_mouse_position() - position
