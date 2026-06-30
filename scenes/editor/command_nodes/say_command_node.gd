class_name SayCommandGraphNode
extends BaseCommandGraphNode

@export var text_edit : TextEdit
var command : CommandSay
const _SELF_SCENE = preload("uid://d3gl55ve5torv")

static func make(node:CommandNode) -> SayCommandGraphNode:
	var cgn : SayCommandGraphNode = _SELF_SCENE.instantiate()
	cgn.command = cgn.node.command
	cgn.node_data = node
	cgn.text_edit.text = cgn.command.dialog
	return cgn


func update_data() -> void:
	command.dialog = text_edit.text
