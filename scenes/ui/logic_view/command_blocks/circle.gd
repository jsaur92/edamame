class_name CommandHook
extends TextureRect

@export var line : Line2D

var connected : CommandHook

var hovered = false
var tracked = false
const DEFAULT_POINT_SPOT = Vector2(12,12)

signal drop

func _ready() -> void:
	CommandHookHandler.add_hook(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if tracked:
		if not Input.is_action_pressed("click"):
			tracked = false
			drop.emit(self)
		else:
			line.set_point_position(1, get_viewport().get_mouse_position() - line.global_position)
	elif connected != null:
		line.set_point_position(1, connected.global_position - line.global_position + DEFAULT_POINT_SPOT)
	else:
		line.set_point_position(1, DEFAULT_POINT_SPOT)

## Called by the CommandHookHandler global whenever a CommandHook is dropped (mouse button is released after it is held)
func receive_drop(from:CommandHook):
	if from != self:
		if hovered:
			set_connected(from)
			return self
	return null

## Set this connected to "to", then disconnect it from its old connection (and vice versa)
func set_connected(to:CommandHook):
	var prev_connected = connected
	connected = to
	if prev_connected != null:
		prev_connected.set_connected(null)

## Collect mouse input
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		tracked = true
		set_connected(null)


func _on_mouse_entered() -> void:
	hovered = true


func _on_mouse_exited() -> void:
	hovered = false
