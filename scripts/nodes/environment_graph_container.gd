class_name EnvironmentGraphEdit
extends GraphEdit

@export var top_left : GraphNode
@export var bottom_right : GraphNode
@export var tile_edit : Control
@export var edit_tiles_button : Button
signal toggle_tile
const TILE_SIZE = 160
var this_drag : Array[Vector2i] = []
var held : bool = false
var erase = false

func update_boundaries(rect:Rect2i) -> void:
	top_left.position_offset = rect.position
	bottom_right.position_offset = rect.size - rect.position


func _on_edit_tiles_button_pressed() -> void:
	tile_edit.visible = not tile_edit.visible
	if tile_edit.visible:
		edit_tiles_button.text = "object edit mode"
	else:
		edit_tiles_button.text = "tile edit mode"


func _on_tile_edit_bg_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		held = event.is_pressed() and (event.button_index == MouseButton.MOUSE_BUTTON_LEFT or event.button_index == MouseButton.MOUSE_BUTTON_RIGHT)
		if held:
			tile_edit.mouse_filter = Control.MOUSE_FILTER_STOP
			if event.is_pressed():
				erase = event.button_index == MouseButton.MOUSE_BUTTON_RIGHT
				var this_tile = Vector2i(floor((event.position + scroll_offset)/(TILE_SIZE * zoom)))
				print("click " , this_tile)
				toggle_tile.emit(this_tile, erase)
				this_drag = [this_tile]
		else:
			tile_edit.mouse_filter = Control.MOUSE_FILTER_PASS
	elif event is InputEventMouseMotion and held:
		var this_tile = Vector2i(floor((event.position + scroll_offset)/(TILE_SIZE * zoom)))
		if not this_drag.has(this_tile):
			toggle_tile.emit(this_tile, erase)
			this_drag.append(this_tile)
