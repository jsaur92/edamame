extends Node2D

@export var notif_sprite : Sprite2D
var player_in_range : bool = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = true
		notif_sprite.visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false
		notif_sprite.visible = false


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and player_in_range:
		print("interacted!")
