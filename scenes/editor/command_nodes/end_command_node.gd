class_name EndCommandGraphNode
extends BaseCommandGraphNode

var command : CommandEnd
const _SELF_SCENE = preload("uid://bdks471wf3n2s")

static func make(node:CommandNode=null) -> EndCommandGraphNode:
	var cgn : EndCommandGraphNode = _SELF_SCENE.instantiate()
	if node == null:
		node = CommandNode.new()
		node.command = CommandEnd.new()
	cgn.command = node.command
	cgn.node_data = node
	return cgn


func update_data() -> void:
	pass
