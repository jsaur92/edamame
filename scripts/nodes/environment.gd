class_name GameEnvironment
extends Node2D

@export var tilemap : TileMapLayer
@export var objects_root : Node2D
@export var camera : Camera2D
@export var player : Player
var environment_data : EnvironmentData
var graph_zoom : Vector2 = Vector2.ONE
const _SELF_SCENE = preload("uid://c4h1sc5o7rilv")

static func make(data:EnvironmentData):
	var ge : GameEnvironment = _SELF_SCENE.instantiate()
	ge.environment_data = data
	ge.setup_terrain()
	ge.setup_objects()
	ge.camera.limit_left = data.get_used_rect().position.x
	ge.camera.limit_top = data.get_used_rect().position.y
	ge.camera.limit_right = data.get_used_rect().position.x + data.get_used_rect().size.x
	ge.camera.limit_bottom = data.get_used_rect().position.y + data.get_used_rect().size.y
	return ge


func _process(delta: float) -> void:
	if player:
		camera.position = player.position


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
	return (get_global_mouse_position() - global_position) / graph_zoom


## If there is a tile at this position, turn it off. If there is not a tile,
## add one. Update the Terrain data and then update the actual TileMapLayer.
func toggle_tile_at(position:Vector2i, erase:bool=false) -> void:
	var map_data = environment_data.get_tilemap_pattern()
	if erase:
		map_data.remove_cell(position, true)
	else:
		map_data.set_cell(position, 0, Vector2i(0,0), 0)
	setup_terrain()
