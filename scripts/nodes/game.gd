extends Node2D

@export var game_data : GameData
var environment : GameEnvironment

const ENVIRONMENT_SCENE = preload("uid://c4h1sc5o7rilv")

func _ready() -> void:
	environment = ENVIRONMENT_SCENE.instantiate()
	add_child(environment)
	environment.setup(game_data.get_environment())
