class_name DragableControlParent
extends Control

var held : bool = false
signal clicked
signal released

static func make(child:CanvasItem, pre_held:bool=false) -> DragableControlParent:
	var dcp = Control.new()
	dcp.set_script(DragableControlParent)
	dcp.set_global_position(child.global_position)
	dcp.held = pre_held
	if child is Control:
		dcp.set_size(child.size)
	elif child is Node2D:
		var sprite : Sprite2D
		for grandchild in child.get_children():
			if grandchild is Sprite2D:
				sprite = grandchild
	dcp.add_child(child)
	dcp.gui_input.connect(dcp._on_gui_input)
	return dcp


func _process(delta: float) -> void:
	if held:
		global_position = get_tree().root.get_mouse_position()


func _on_gui_input(event: InputEvent) -> void:
	print("help")
	if event is InputEventMouseButton:
		held = event.is_pressed()
		if event.is_pressed():
			clicked.emit()
		else:
			released.emit()
	elif event is InputEventMouseMotion:
		if held:
			global_position = get_tree().root.get_mouse_position()
