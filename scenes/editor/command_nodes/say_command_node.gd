class_name SayCommandGraphNode
extends BaseCommandGraphNode

@export var text_edit : TextEdit
var command : CommandSay
const _SELF_SCENE = preload("uid://d3gl55ve5torv")

static func make(node:CommandNode=null) -> SayCommandGraphNode:
	var cgn : SayCommandGraphNode = _SELF_SCENE.instantiate()
	if node == null:
		node = CommandNode.new()
		node.command = CommandSay.new()
	cgn.command = node.command
	cgn.node_data = node
	cgn.text_edit.text = cgn.command.dialog
	return cgn


func update_data() -> void:
	command.dialog = text_edit.text


func get_command() -> Command:
	return command


func _on_text_edit_text_changed() -> void:
	update_data()
