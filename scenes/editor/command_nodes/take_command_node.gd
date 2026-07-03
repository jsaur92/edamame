class_name TakeCommandGraphNode
extends BaseCommandGraphNode

@export var texture_rect : TextureRect
var command : CommandTake
const _SELF_SCENE = preload("uid://de4t4xhsumgu5")

static func make(node:CommandNode) -> TakeCommandGraphNode:
	var cgn : TakeCommandGraphNode = _SELF_SCENE.instantiate()
	cgn.command = node.command
	cgn.node_data = node
	var lib = ObjectLibrary.get_current_library()
	cgn.texture_rect.texture = ImageTexture.create_from_image( cgn.command.get_item().get_image() )
	return cgn


func update_data() -> void:
	pass
