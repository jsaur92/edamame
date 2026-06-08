extends Node2D

@export var command_manager : CommandManager
@export var game_data : GameData
var environment : GameEnvironment

## Sets game_data. Call after instantiation and before adding as child of scene.
func setup(_game_data:GameData):
	game_data = _game_data


func _ready() -> void:
	environment = ConstScenes.ENVIRONMENT.instantiate()
	add_child(environment)
	environment.setup(game_data.get_environment())
	for object in environment.get_objects():
		if object.object_data.is_interactable():
			print(object)
			print(object.get_interactable())
			object.get_interactable().connect("interacted", receive_interaction)


func receive_interaction(object:GameObject) -> void:
	command_manager.interact_with(object)
