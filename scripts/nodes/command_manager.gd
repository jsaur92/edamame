class_name CommandManager
extends Node

var current_node : CommandNode

func set_node(node:CommandNode):
	current_node = node

func interact_with(object:GameObject) -> void:
	current_node = object.object_data.get_mod(Enums.ObjectModType.INTERACTABLE)

## Execute the current command.
func execute() -> void:
	current_node.execute()
