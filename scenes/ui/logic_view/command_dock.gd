extends ColorRect

@export var command_field : Control

func pass_to_command_field(node:Control):
	var glob_pos = node.global_position
	remove_child(node)
	command_field.add_child(node)
	node.global_position = glob_pos
