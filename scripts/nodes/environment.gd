class_name GameEnvironment
extends Node2D

@export var tilemap : TileMapLayer
@export var objects_root : Node2D
var environment_data : EnvironmentData
const OBJECT_SCENE = preload("res://scenes/game/object.tscn")

func setup(data:EnvironmentData):
	environment_data = data
	setup_terrain()
	setup_objects()


func setup_terrain():
	tilemap.tile_set = environment_data.get_tileset()
	tilemap.set_pattern(Vector2i.ZERO, environment_data.get_tilemap_pattern())


func setup_objects():
	for child in objects_root.get_children():
		child.queue_free()
	for object in environment_data.get_objects():
		var new_obj : GameObject = OBJECT_SCENE.instantiate()
		new_obj.load_data(object)
		objects_root.add_child(new_obj)
