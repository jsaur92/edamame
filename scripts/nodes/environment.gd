class_name GameEnvironment
extends Node2D

@export var tilemap : TileMapLayer
@export var objects_root : Node2D
@export var player : Player
var environment_data : EnvironmentData
const _SELF_SCENE = preload("uid://c4h1sc5o7rilv")

static func make(data:EnvironmentData):
	var ge : GameEnvironment = _SELF_SCENE.instantiate()
	ge.environment_data = data
	ge.setup_terrain()
	ge.setup_objects()
	return ge


func setup_terrain():
	tilemap.tile_set = environment_data.get_tileset()
	tilemap.clear()
	tilemap.set_pattern(Vector2i.ZERO, environment_data.get_tilemap_pattern())


func setup_objects():
	for child in get_objects():
		child.queue_free()
	for object in environment_data.get_objects():
		objects_root.add_child( GameObject.make(object) )


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
	var go = GameObject.make(object_instance)
	objects_root.add_child( go )
	return go


func get_mouse_pos_in_environment() -> Vector2:
	return get_tree().root.get_mouse_position() - position


## If there is a tile at this position, turn it off. If there is not a tile,
## add one. Update the Terrain data and then update the actual TileMapLayer.
func toggle_tile_at(position:Vector2i) -> void:
	var map_data = environment_data.get_tilemap_pattern()
	if map_data.has_cell(position):
		print("remove cell")
		map_data.remove_cell(position, true)
	else:
		print("add cell")
		map_data.set_cell(position, 0, Vector2i(0,0), 0)
	setup_terrain()
