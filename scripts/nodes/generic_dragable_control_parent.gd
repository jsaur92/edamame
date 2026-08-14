class_name DragableParent
extends Control
## Holds a Node2D. Not actually that generic and is hardcoded to expect a
## GameObject or Player in most circumstances.

var held : bool = false
var child : Node2D
var time_last_clicked : int = 0
var shadow
signal clicked
signal released
signal dragged
const _SELF_SCENE = preload("uid://kf8ej751k86u")
## The maximum "length" of a GameObject's size in pixels (that is, taking the .length()
## parameter of the size vector) before the GameObject counts as "large".
## (Large GameObjects get a modifier attached to their rotation to rotate less).
## (This set value is the size length value of a 128 x 128 pixel object).
const SMALL_SIZE_THRESHOLD := 181.02

static func make(node:Node2D, pre_held:bool=false) -> DragableParent:
	var dgp : DragableParent = _SELF_SCENE.instantiate()
	dgp.set_global_position(node.global_position)
	dgp.held = pre_held
	if node.get_parent() == null:
		dgp.add_child(node)
	else:
		node.reparent(dgp)
	dgp.child = node
	dgp.update_transform()
	
	#make shadow
	dgp._update_shadow()
	
	return dgp


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if held:
		if Input.is_action_just_pressed("click"):
			_update_shadow()
		elif Input.is_action_just_released("click"):
			held = false
			released.emit()
		else:
			update_transform()
			dragged.emit()
			
			var rot_range_mod := 1.0
			if has_game_object():
				child = child as GameObject
				if child.object_data.get_image_size_pixels().length() > SMALL_SIZE_THRESHOLD:
					rot_range_mod = SMALL_SIZE_THRESHOLD / child.object_data.get_image_size_pixels().length()
			
			child.rotation = sin(get_time_since_clicked() * 10.) * 0.5 * rot_range_mod
			shadow.visible = true
	else:
		child.rotation_degrees = 0
		shadow.visible = false


func get_time_since_clicked() -> float:
	return (Time.get_ticks_msec()-time_last_clicked) / 1000.


func update_transform() -> void:
	set_size(Vector2(child.get_size()) * child.sprite.scale)
	child.position = size/2
	global_position = child.global_position - size
	if child is GameObject:
		position = child.get_instance_data().position - size/2
	elif child is Player:
		position = child.get_init_data().init_pos - size/2


func has_game_object() -> bool:
	return child and child is GameObject


func get_game_object() -> GameObject:
	if has_game_object():
		return child
	push_error("Attempted to get a GameObject child from a DragableParent without a GameObject.")
	return null


func has_player() -> bool:
	return child and child is Player


func get_player() -> Player:
	if has_player():
		return child
	push_error("Attempted to get a Player child from a DragableParent without a Player.")
	return null


func _update_shadow() -> void:
	if shadow != null:
		shadow.queue_free()
	var s = child.sprite.duplicate()
	s.z_index -= 1
	s.modulate = 0x0000007f
	s.position += Vector2(7,7)
	s.visible = false
	child.add_child(s)
	shadow = s


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("click"):
			mouse_filter = Control.MOUSE_FILTER_STOP
			held = event.is_pressed()
			if event.is_pressed():
				clicked.emit()
			else:
				released.emit()
		else:
			mouse_filter = Control.MOUSE_FILTER_PASS
