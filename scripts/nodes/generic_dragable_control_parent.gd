class_name DragableParent
extends Control

var held : bool = false
var child : Node2D
var time_last_clicked : int = 0
var shadow
signal clicked
signal released
signal dragged
const _SELF_SCENE = preload("uid://kf8ej751k86u")

static func make(node:Node2D, pre_held:bool=false) -> DragableParent:
	var dgp : DragableParent = _SELF_SCENE.instantiate()
	dgp.set_global_position(node.global_position)
	dgp.held = pre_held
	dgp.set_size(Vector2(node.sprite.texture.get_image().get_size()) * node.sprite.scale)
	if node.get_parent() == null:
		dgp.add_child(node)
	else:
		node.reparent(dgp)
	dgp.child = node
	
	#make shadow
	dgp._update_shadow()
	
	return dgp


func _ready() -> void:
	child.global_position += size/2
	global_position = child.global_position - size


func _process(delta: float) -> void:
	if held:
		if Input.is_action_just_pressed("click"):
			_update_shadow()
		elif Input.is_action_just_released("click"):
			held = false
			released.emit()
		else:
			update_position()
			#global_position = get_tree().root.get_mouse_position() - size/2
			#game_object.global_position = global_position + size/2
			#game_object.global_position = get_tree().root.get_mouse_position()
			dragged.emit()
			
			child.rotation = sin(get_time_since_clicked() * 10.) * 0.5
			#game_object.global_position = global_position + size/2
			shadow.visible = true
	else:
		child.rotation_degrees = 0
		shadow.visible = false


func get_time_since_clicked() -> float:
	return (Time.get_ticks_msec()-time_last_clicked) / 1000.


func update_position() -> void:
	if child is GameObject:
		position = child.get_instance_data().position - size/2


func has_game_object() -> bool:
	return child and child is GameObject


func get_game_object() -> GameObject:
	if has_game_object():
		return child
	push_error("Attempted to get a GameObject child from a DragableParent without a GameObject.")
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
