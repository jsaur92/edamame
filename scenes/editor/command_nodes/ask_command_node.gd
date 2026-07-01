class_name AskCommandGraphNode
extends BaseCommandGraphNode

@export var question_text_edit : TextEdit
@export var answer_line_edits : Array[LineEdit]
@export var buttons_container : HBoxContainer
@export var add_button : Button
@export var remove_button : Button
var command : CommandAsk
const _SELF_SCENE = preload("uid://jro4xbkf8tjv")
const MIN_ANSWER_CHOICES = 1
const MAX_ANSWER_CHOICES = 8
const LINE_HEIGHT = 33.0
const SLOT_OFFSET = 2 #what you add to a lineedit's index in answer_line_edits
#to get the index of that lineedit's slot in the graph node.

static func make(node:CommandNode) -> AskCommandGraphNode:
	var cgn : AskCommandGraphNode = _SELF_SCENE.instantiate()
	cgn.command = cgn.node.command
	cgn.node_data = node
	cgn.question_text_edit.text = cgn.command.dialog
	return cgn


func update_data() -> void:
	command.dialog = question_text_edit.text
	var choices = []
	for line_edit in answer_line_edits:
		choices.append(line_edit.text)
	command.choices = choices


func update_button_abled() -> void:
	add_button.disabled = answer_line_edits.size() >= MAX_ANSWER_CHOICES
	remove_button.disabled = answer_line_edits.size() <= MIN_ANSWER_CHOICES


func add_answer() -> void:
	set_slot_enabled_right(answer_line_edits.size()+SLOT_OFFSET, true)
	var new_line_edit = LineEdit.new()
	new_line_edit.placeholder_text = "Answer " + str(answer_line_edits.size()+1)
	answer_line_edits.append(new_line_edit)
	remove_child(buttons_container)
	add_child(new_line_edit)
	add_child(buttons_container)
	size.y += LINE_HEIGHT
	update_button_abled()


func remove_answer() -> void:
	var le = answer_line_edits.pop_back()
	le.queue_free()
	size.y -= LINE_HEIGHT
	update_button_abled()
	set_slot_enabled_right(answer_line_edits.size()+SLOT_OFFSET, false)


func _on_add_button_pressed() -> void:
	add_answer()


func _on_remove_button_pressed() -> void:
	remove_answer()
