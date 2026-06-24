class_name DragableGOParent
extends Control

var held : bool = false
var game_object : GameObject
var time_last_clicked : int = 0
var shadow
signal clicked
signal released
const _SELF_SCENE = preload("uid://kf8ej751k86u")

static func make(go:GameObject, pre_held:bool=false) -> DragableGOParent:
	var dgp : DragableGOParent = _SELF_SCENE.instantiate()
	dgp.set_global_position(go.global_position)
	dgp.held = pre_held
	dgp.set_size(Vector2(go.sprite.texture.get_image().get_size()) * go.sprite.scale)
	dgp.add_child(go)
	dgp.game_object = go
	dgp.gui_input.connect(dgp._on_gui_input)
	
	#make shadow
	var s = go.sprite.duplicate()
	s.z_index -= 1
	s.modulate = 0x0000007f
	s.position += Vector2(7,7)
	s.visible = false
	go.add_child(s)
	dgp.shadow = s
	
	return dgp


func _process(delta: float) -> void:
	if Input.is_action_just_released("click"):
			held = false
			released.emit()
	if held:
		global_position = get_tree().root.get_mouse_position() - size/2
		game_object.global_position = get_tree().root.get_mouse_position()
		
		game_object.rotation = sin(get_time_since_clicked() * 10.) * 0.5
		game_object.global_position = global_position + size/2
		shadow.visible = true
	else:
		global_position = game_object.global_position - size/2
		game_object.rotation_degrees = 0
		shadow.visible = false


func get_time_since_clicked() -> float:
	return (Time.get_ticks_msec()-time_last_clicked) / 1000.


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		held = event.is_pressed()
		if event.is_pressed():
			clicked.emit()
		else:
			released.emit()
