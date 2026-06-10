extends Control

@export var game_data : GameData
var environment : GameEnvironment

## Sets game_data. Call after instantiation and before adding as child of scene.
func setup(_game_data:GameData):
	game_data = _game_data


func _ready() -> void:
	environment = ConstScenes.ENVIRONMENT.instantiate()
	add_child(environment)
	environment.setup(game_data.get_environment())
	
