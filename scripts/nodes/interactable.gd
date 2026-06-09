class_name Interactable
extends Node2D
## Node that manages the interactions between the GameObject Node that it's
## attached to and the player.

@export var notif_sprite : Sprite2D
var player_in_range : bool = false
var game_object : GameObject

signal interacted


func _ready() -> void:
	connect("interacted", CommandManager.interact_with)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		var success = GameGlobals.try_in_range_interactable(self)
		player_in_range = success
		notif_sprite.visible = success


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		remove_in_range()
		GameGlobals.try_remove_in_range_interactable(self)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and player_in_range:
		interacted.emit(game_object)


func setup(obj:GameObject) -> void:
	game_object = obj


func remove_in_range():
	player_in_range = false
	notif_sprite.visible = false
