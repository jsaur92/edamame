class_name RemoveCommandGraphNode
extends BaseCommandGraphNode

var command : CommandRemove
const _SELF_SCENE = preload("uid://27igkab5ompo")

static func make(node:CommandNode=null) -> RemoveCommandGraphNode:
	var cgn : RemoveCommandGraphNode = _SELF_SCENE.instantiate()
	if node == null:
		node = CommandNode.new()
		node.command = CommandRemove.new()
	cgn.command = node.command
	cgn.node_data = node
	return cgn


func update_data() -> void:
	pass
