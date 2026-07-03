class_name GiveCommandGraphNode
extends BaseCommandGraphNode

@export var texture_rect : TextureRect
var command : CommandGive
const _SELF_SCENE = preload("uid://b3y1o0h0nwvq3")

static func make(node:CommandNode) -> GiveCommandGraphNode:
	var cgn : GiveCommandGraphNode = _SELF_SCENE.instantiate()
	cgn.command = node.command
	cgn.node_data = node
	var lib = ObjectLibrary.get_current_library()
	var img = cgn.command.get_item().get_image()
	img.resize( min(img.get_size().x, MAX_TEX_SIZE.x), min(img.get_size().y, MAX_TEX_SIZE.y) )
	cgn.texture_rect.texture =  ImageTexture.create_from_image( img )
	return cgn


func update_data() -> void:
	pass
