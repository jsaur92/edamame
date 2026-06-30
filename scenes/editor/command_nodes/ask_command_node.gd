class_name AskCommandGraphNode
extends BaseCommandGraphNode

@export var question_text_edit : TextEdit
@export var answer_line_edits : Array[LineEdit]
var command : CommandAsk
const _SELF_SCENE = preload("uid://jro4xbkf8tjv")

static func make(node:CommandNode) -> AskCommandGraphNode:
	var cgn : AskCommandGraphNode = _SELF_SCENE.instantiate()
	cgn.command = cgn.node.command
	cgn.node_data = node
	cgn.question_text_edit.text = cgn.command.dialog
	return cgn


func update_data() -> void:
	command.dialog = question_text_edit.text
