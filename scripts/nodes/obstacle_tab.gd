class_name ObstacleTab
extends Control

@export var object_texture : TextureRect
@export var shape_option : OptionButton
@export var rect_options : VBoxContainer
@export var circ_options : VBoxContainer
@export var width_spin_box : SpinBox
@export var height_spin_box : SpinBox
@export var radius_spin_box : SpinBox
var object_data : ObjectData
var collision_data : ModCollidable
const COLLISION_COLOR = Color(0, 1, 1, 0.5)
enum ShapeTypes {RECTANGLE, CIRCLE}


func open_tab(obj:ObjectData) -> void:
	object_data = obj
	object_texture.texture = ImageTexture.create_from_image( object_data.get_scaled_image() )
	object_texture.custom_minimum_size = object_data.get_scaled_image().get_size()
	collision_data = object_data.get_mod(Enums.ObjectModType.COLLIDABLE)
	update_values()
	await get_tree().create_timer(0.00001).timeout
	queue_redraw()


func _draw():
	if collision_data.shape is RectangleShape2D:
		var rect = collision_data.shape.get_rect()
		rect.position = object_texture.position + object_texture.custom_minimum_size/2 - rect.size/2
		draw_rect(rect, COLLISION_COLOR)
	elif collision_data.shape is CircleShape2D:
		draw_circle(object_texture.position + object_texture.custom_minimum_size/2, collision_data.shape.radius, COLLISION_COLOR)


func update_values() -> void:
	if collision_data.shape is RectangleShape2D:
		shape_option.selected = ShapeTypes.RECTANGLE
		rect_options.visible = true
		circ_options.visible = false
		width_spin_box.set_value_no_signal(100 * collision_data.shape.size.x / object_data.get_image_size_pixels().x)
		height_spin_box.set_value_no_signal(100 * collision_data.shape.size.y / object_data.get_image_size_pixels().y)
	elif collision_data.shape is CircleShape2D:
		shape_option.selected = ShapeTypes.CIRCLE
		rect_options.visible = false
		circ_options.visible = true
		radius_spin_box.set_value_no_signal(100 * collision_data.shape.radius / max(object_data.get_image_size_pixels().x, object_data.get_image_size_pixels().y))


func _on_width_spin_box_value_changed(value: float) -> void:
	collision_data.shape.size.x = (value / 100) * object_data.get_image_size_pixels().x
	queue_redraw()


func _on_height_spin_box_value_changed(value: float) -> void:
	collision_data.shape.size.y = (value / 100) * object_data.get_image_size_pixels().y
	queue_redraw()


func _on_radius_spin_box_value_changed(value: float) -> void:
	collision_data.shape.radius = (value / 100) * max(object_data.get_image_size_pixels().x, object_data.get_image_size_pixels().y)
	queue_redraw()


func _on_option_button_item_selected(index: int) -> void:
	match index:
		ShapeTypes.RECTANGLE:
			collision_data.shape = RectangleShape2D.new()
		ShapeTypes.CIRCLE:
			collision_data.shape = CircleShape2D.new()
	update_values()
	queue_redraw()
