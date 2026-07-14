class_name PlayerInitData
extends Resource

@export var init_pos : Vector2 = Vector2.ZERO


func set_pos_x(x:int) -> void:
	init_pos.x = x


func set_pos_y(y:int) -> void:
	init_pos.y = y
