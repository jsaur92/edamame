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


static func create() -> EnvironmentData:
	var ed = EnvironmentData.new()
	ed.setup(TerrainData.create(), [])
	return ed


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


func to_json_string() -> String:
	var dict = {}
	dict["terrain"] = terrain.to_json_string()
	dict["objects_size"] = objects.size()
	for i in objects.size():
		dict["object"+str(i)] = objects[i].to_json_string()
	return JSON.stringify(dict)


static func from_json_string(json_string : String) -> EnvironmentData:
	var dict = JSON.parse_string(json_string)
	var terrain = TerrainData.from_json_string(dict["terrain"])
	var objects : Array[ObjectInstanceData] = []
	for i in int(dict["objects_size"]):
		objects.append( ObjectInstanceData.from_json_string(dict["object"+str(i)]) )
	var ed = EnvironmentData.new()
	ed.setup(terrain, objects)
	return ed
