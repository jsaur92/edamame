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


## Get the used rectangle of the TileMap of the TerrainData, then expand that
## to fit in any objects that are outside of that rectangle.
func get_used_rect() -> Rect2:
	var rect : Rect2 = terrain.get_used_rect_in_pixels()
	
	var top_left : Vector2 = rect.position
	var bottom_right : Vector2 = rect.size + rect.position
	
	for object in objects:
		top_left.x = min(object.get_position().x, top_left.x)
		top_left.y = min(object.get_position().y, top_left.y)
		bottom_right.x = max(object.get_position().x, bottom_right.x)
		bottom_right.y = max(object.get_position().y, bottom_right.y)
	
	rect.position = top_left
	rect.size = bottom_right - rect.position
	
	return rect
