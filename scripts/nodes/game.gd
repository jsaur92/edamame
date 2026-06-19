class_name Game
extends Control

@export var game_data : GameData
@export var command_manager : CommandManager
@export var interact_manager : InteractManager
@export var dialog_ui : DialogUI
@export var hud : HUD
var environment : GameEnvironment
var player : Player
## Reference to singleton of self
static var game : Game

## Sets game_data. Call after instantiation and before adding as child of scene.
func setup(_game_data:GameData):
	game_data = _game_data
	game = self


static func get_game():
	return game


func _ready() -> void:
	environment = ConstScenes.ENVIRONMENT.instantiate()
	add_child(environment)
	environment.setup(game_data.get_environment())
	player = ConstScenes.PLAYER.instantiate()
	environment.add_child(player)
	environment.player = player


func _on_dialog_ui_give_item(item:ObjectData) -> void:
	player.inventory.add_item(item)
	update_hud()


func _on_dialog_ui_take_item(item:ObjectData) -> void:
	player.inventory.remove_item(item)
	update_hud()


func _on_command_manager_update_current_node(node:CommandNode) -> void:
	dialog_ui.set_current_node(node)


func update_hud() -> void:
	hud.update_items(player.inventory)
