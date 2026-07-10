class_name GiveCommandGraphNode
extends BaseCommandGraphNode

@export var texture_rect : TextureRect
var command : CommandGive
const _SELF_SCENE = preload("uid://b3y1o0h0nwvq3")
signal clicked

static func make(node:CommandNode=null) -> GiveCommandGraphNode:
	var cgn : GiveCommandGraphNode = _SELF_SCENE.instantiate()
	if node == null:
		node = CommandNode.new()
		node.command = CommandGive.new()
	cgn.command = node.command
	cgn.node_data = node
	var img = cgn.command.get_item().get_image()
	img.resize( min(img.get_size().x, MAX_TEX_SIZE.x), min(img.get_size().y, MAX_TEX_SIZE.y) )
	cgn.texture_rect.texture =  ImageTexture.create_from_image( img )
	return cgn


func update_data() -> void:
	pass


func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			clicked.emit(self)
