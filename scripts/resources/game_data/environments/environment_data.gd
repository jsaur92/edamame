class_name EnvironmentData
extends Resource
## The data for an Environment of a Game.
##
## Contains the terrain and object information of a single Environment. In a game
## with multiple Environments, different Environments represent different areas,
## including building interiors.

## Terrain data containing the TileSet and TileMapPattern of the Environment.
@export var terrain : TerrainData
## Array of all instanced Object data used in the Game.
@export var objects : Array[ObjectInstanceData]

func setup(_terrain:TerrainData, _objects:Array[ObjectInstanceData]=[]) -> void:
	terrain = _terrain
	objects = _objects


func get_tileset() -> TileSet:
	return terrain.tileset


func get_tilemap_pattern() -> TileMapPattern:
	return terrain.tilemap


func get_objects() -> Array[ObjectInstanceData]:
	return objects


func add_object(obj:ObjectInstanceData) -> void:
	objects.append(obj)


func remove_object(obj:ObjectInstanceData) -> void:
	objects.erase(obj)
