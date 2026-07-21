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

static func make(node:CommandNode=null) -> AskCommandGraphNode:
	var cgn : AskCommandGraphNode = _SELF_SCENE.instantiate()
	if node == null:
		node = CommandNode.new()
		node.command = CommandAsk.new()
	cgn.command = node.command
	cgn.node_data = node
	cgn.question_text_edit.text = cgn.command.dialog
	var i = 0
	for answer_choice in cgn.command.choices:
		if i >= cgn.answer_line_edits.size():
			cgn.add_answer()
		cgn.answer_line_edits[i].text = answer_choice
		i += 1
	return cgn


func update_data() -> void:
	command.dialog = question_text_edit.text
	var choices : Array[String] = []
	for line_edit in answer_line_edits:
		choices.append(line_edit.text)
	command.choices = choices


func get_command() -> Command:
	return command


func update_button_abled() -> void:
	add_button.disabled = answer_line_edits.size() >= MAX_ANSWER_CHOICES
	remove_button.disabled = answer_line_edits.size() <= MIN_ANSWER_CHOICES


func add_answer() -> void:
	set_slot_enabled_right(answer_line_edits.size()+SLOT_OFFSET, true)
	var new_line_edit = LineEdit.new()
	new_line_edit.placeholder_text = "Answer " + str(answer_line_edits.size()+1)
	answer_line_edits.append(new_line_edit)
	new_line_edit.text_changed.connect(_on_line_edit_text_changed)
	remove_child(buttons_container)
	add_child(new_line_edit)
	add_child(buttons_container)
	size.y += LINE_HEIGHT
	update_button_abled()
	update_data()


func remove_answer() -> void:
	var le = answer_line_edits.pop_back()
	le.queue_free()
	size.y -= LINE_HEIGHT
	update_button_abled()
	set_slot_enabled_right(answer_line_edits.size()+SLOT_OFFSET, false)
	update_data()


func _on_add_button_pressed() -> void:
	add_answer()


func _on_remove_button_pressed() -> void:
	remove_answer()


func _on_text_edit_text_changed() -> void:
	update_data()


func _on_line_edit_text_changed(new_text: String) -> void:
	update_data()


func _on_line_edit_2_text_changed(new_text: String) -> void:
	update_data()
