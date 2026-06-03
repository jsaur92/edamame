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

func _init(_terrain:TerrainData, _objects:Array[ObjectInstanceData]=[]) -> void:
	terrain = _terrain
	objects = _objects
