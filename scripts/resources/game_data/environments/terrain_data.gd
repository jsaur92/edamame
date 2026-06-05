class_name TerrainData
extends Resource
## Data of the TileSet and TileMap (stored as a TileMapPattern) of a Terrain.

## TileSet used for this Terrain's TileMap.
@export var tileset : TileSet
## The tiles of the TileMap.
@export var tilemap : TileMapPattern

func setup(_tileset:TileSet, _tilemap:TileMapPattern=TileMapPattern.new()) -> void:
	tileset = _tileset
	tilemap = _tilemap
