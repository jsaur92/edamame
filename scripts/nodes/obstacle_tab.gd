class_name ObstacleTab
extends Control

@export var object_texture : TextureRect
@export var rect_options : VBoxContainer
@export var circ_options : VBoxContainer
var shape : Shape2D
const COLLISION_COLOR = Color(0, 1, 1, 0.5)


func open_tab(object_data:ObjectData) -> void:
	object_texture.texture = ImageTexture.create_from_image( object_data.get_scaled_image() )
	object_texture.custom_minimum_size = object_data.get_scaled_image().get_size()
	shape = object_data.get_mod(Enums.ObjectModType.COLLIDABLE).get_shape()
	await get_tree().create_timer(0.00001).timeout
	queue_redraw()


func _draw():
	if shape is RectangleShape2D:
		var rect = shape.get_rect()
		rect.position = object_texture.position + object_texture.custom_minimum_size/2 - rect.size/2
		draw_rect(rect, COLLISION_COLOR)
	elif shape is CircleShape2D:
		draw_circle(Vector2.ZERO, shape.radius, COLLISION_COLOR)
