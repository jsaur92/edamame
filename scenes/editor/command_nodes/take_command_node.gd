class_name TakeCommandGraphNode
extends BaseCommandGraphNode

@export var texture_rect : TextureRect
var command : CommandTake
const _SELF_SCENE = preload("uid://de4t4xhsumgu5")
signal clicked

static func make(node:CommandNode=null) -> TakeCommandGraphNode:
	var cgn : TakeCommandGraphNode = _SELF_SCENE.instantiate()
	if node == null:
		node = CommandNode.new()
		node.command = CommandTake.new()
	cgn.command = node.command
	cgn.node_data = node
	var lib = ObjectLibrary.get_current_library()
	cgn.texture_rect.texture = ImageTexture.create_from_image( cgn.command.get_item().get_image() )
	return cgn


func update_data() -> void:
	pass


func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			clicked.emit(self)
