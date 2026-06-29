class_name TerrainData
extends Resource
## Data of the TileSet and TileMap (stored as a TileMapPattern) of a Terrain.

## TileSet used for this Terrain's TileMap.
@export var tileset : TileSet
## The tiles of the TileMap.
@export var tilemap : TileMapPattern
## The top-left position of the tilemap.
@export var top_left : Vector2i

func setup(_tileset:TileSet, _tilemap:TileMapPattern=TileMapPattern.new()) -> void:
	tileset = _tileset
	tilemap = _tilemap


## Gets the x and y of the top-left corner, as well as the width and height.
func get_used_rect_in_tiles() -> Rect2i:
	var tiles : Array[Vector2i] = tilemap.get_used_cells()
	if tiles.size() <= 0:
		return Rect2i(Vector2i.ZERO, Vector2i.ZERO)
	if tiles.size() == 1:
		return Rect2i(tiles[0], Vector2i(1,1))
	var top_left : Vector2i = tiles[0]
	var bottom_right : Vector2i = tiles[0]
	for tile in tiles:
		top_left.x = min(tile.x, top_left.x)
		top_left.y = min(tile.y, top_left.y)
		bottom_right.x = max(tile.x, bottom_right.x)
		bottom_right.y = max(tile.y, bottom_right.y)
	return Rect2i(top_left, bottom_right - top_left)


func get_used_rect_in_pixels() -> Rect2i:
	var rect = get_used_rect_in_tiles()
	rect.position *= tileset.tile_size
	rect.size *= tileset.tile_size
	return rect
