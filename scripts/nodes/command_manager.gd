class_name CommandManager
extends Node
## Node that manages all commands.
##
## When an Interactable's Interact is called, it sends a signal that this Node
## receives and handles all of its Command information.

var current_obj : GameObject
var current_data : ObjectData
var current_node : CommandNode

var dialog_ui : DialogUI

signal update_current_node


func set_dialog_ui(d:DialogUI):
	dialog_ui = d


func set_current_node(node:CommandNode):
	current_node = node
	update_current_node.emit(node)
	get_tree().paused = (node != null)


func interact_with(object:GameObject) -> void:
	print("OBJECT: ", object)
	if current_obj == null:
		current_obj = object
		current_data = current_obj.object_data
		set_current_node(current_data.get_mod(Enums.ObjectModType.INTERACTABLE).get_command_head())
		execute()


func reset() -> void:
	current_obj = null
	current_data = null
	set_current_node(null)


## Execute the current command. Read the data from the CommandNode's Command,
## then do something about it.
func execute() -> void:
	print("CURRENT: ", current_node)
	if current_node != null:
		get_tree().paused = true
		var command = current_node.command
		if command is CommandSay:
			execute_say(command)
		elif command is CommandAsk:
			execute_ask(command)
		elif command is CommandGive:
			execute_give(command)
		elif command is CommandTake:
			execute_take(command)
		elif command is CommandRemove:
			execute_remove()


func execute_next(index:int) -> void:
	if current_node.has_next(index):
		set_current_node(current_node.next[index])
		execute()
	else:
		reset()


func execute_say(command:CommandSay):
	dialog_ui.say(command)


func execute_ask(command:CommandAsk):
	dialog_ui.ask(command)


func execute_give(command:CommandGive):
	dialog_ui.give(command)
	## wait for player to "accept" the gift. That will send a signal to do the next command.


func execute_take(command:CommandTake):
	dialog_ui.take(command)
	## wait for player give / not give. That will send a signal to do the next command.


func execute_remove():
	current_obj.queue_free()
	execute_next(0)
