class_name TerrainData
extends Resource
## Data of the TileSet and TileMap (stored as a TileMapPattern) of a Terrain.

## TileSet used for this Terrain's TileMap.
@export var tileset : TileSet
## The tiles of the TileMap.
@export var tilemap : TileMapPattern
## The top-left position of the tilemap (offset).
@export var top_left : Vector2i
const DEFAULT_TILESET = preload("uid://cy0d150bm28j1")


static func create() -> TerrainData:
	var td = TerrainData.new()
	td.setup(DEFAULT_TILESET)
	return td


func setup(_tileset:TileSet, _tilemap:TileMapPattern=TileMapPattern.new()) -> void:
	tileset = _tileset
	tilemap = _tilemap


## Gets the x and y of the top-left corner, as well as the width and height.
func get_used_rect_in_tiles() -> Rect2i:
	if tilemap != null:
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
	return Rect2i(Vector2i.ZERO, Vector2i.ZERO)


func get_used_rect_in_pixels() -> Rect2i:
	var rect = get_used_rect_in_tiles()
	rect.position += top_left
	rect.position *= tileset.tile_size
	rect.size *= tileset.tile_size
	return rect


## Adjust the top-left of the tiles so that the given point fits in the tilemap.
## Returns the amount adjusted by.
func adjust_offset(point:Vector2i) -> Vector2i:
	point += top_left
	
	var adjust_amt = Vector2i.ZERO
	if point.x < top_left.x:
		adjust_amt.x = top_left.x - point.x
		top_left.x = point.x
	if point.y < top_left.y:
		adjust_amt.y = top_left.y - point.y
		top_left.y = point.y
	
	if adjust_amt.length() > 0:
		
		var new_tilemap = TileMapPattern.new()
		
		for old_cell in tilemap.get_used_cells():
			var cell_data = [tilemap.get_cell_source_id(old_cell), tilemap.get_cell_atlas_coords(old_cell), tilemap.get_cell_alternative_tile(old_cell)]
			new_tilemap.set_cell(old_cell + adjust_amt, cell_data[0], cell_data[1], cell_data[2])
		
		tilemap = new_tilemap
	return adjust_amt


func add_tile_to_tileset(texture:Texture2D) -> void:
	var new_source = TileSetAtlasSource.new()
	new_source.texture = texture
	new_source.create_tile(Vector2i.ZERO, texture.get_size())
	tileset.add_source(new_source)
