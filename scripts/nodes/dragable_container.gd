class_name DragableContainer
extends Control

var contained : GameObject
var held : bool = false
var time_last_clicked : int = 0
var shadow : Sprite2D
signal clicked
signal dropped
## emit when a value of the attached GameObject is changed (i.e. when its
## position is changed by dragging it).
signal changed

static func setup(child:GameObject) -> DragableContainer:
	var container : DragableContainer = ConstScenes.DRAGABLE_CONTAINER.instantiate()
	container.contained = child
	container.update()
	
	# makes the shadow for picking up. this is kind of superfluous and not coded great
	# but it is fun.
	var s = child.sprite.duplicate()
	s.z_index -= 1
	s.modulate = 0x0000007f
	s.scale /= child.object_data.image_scale
	s.position += Vector2(7,7) / child.object_data.image_scale
	s.visible = false
	child.sprite.add_child(s)
	container.shadow = s
	
	return container


func update() -> void:
	contained.update()
	size = contained.object_data.get_scaled_image().get_size()
	position = contained.position - size/2


func _process(delta: float) -> void:
	shadow.visible = held
	if held:
		contained.rotation = sin(get_time_since_clicked() * 10.) * 0.5
		contained.global_position = global_position + size/2
	else:
		global_position = contained.global_position - size/2
		contained.rotation_degrees = 0


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		held = Input.is_action_just_pressed("click")
		if held:
			clicked.emit(self)
			time_last_clicked = Time.get_ticks_msec()
		else:
			dropped.emit(self)
	elif event is InputEventMouseMotion:
		if held:
			position += event.relative
			contained.get_instance_data().set_position(contained.position)
			changed.emit(self)


func get_time_since_clicked() -> float:
	return (Time.get_ticks_msec()-time_last_clicked) / 1000.


func get_object_instance() -> ObjectInstanceData:
	return contained.get_instance_data()
