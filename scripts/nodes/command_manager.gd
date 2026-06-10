extends Node
## Singleton that manages all commands.
##
## When an Interactable's Interact is called, it sends a signal that this Node
## receives and handles all of its Command information.

var current_obj : GameObject
var current_data : ObjectData
var current_node : CommandNode

var dialog_ui : DialogUI

func set_dialog_ui(d:DialogUI):
	dialog_ui = d

func _process(delta: float) -> void:
	print(current_node)

func set_current_node(node:CommandNode):
	current_node = node
	get_tree().paused = (node == null)


func interact_with(object:GameObject) -> void:
	current_obj = object
	current_data = current_obj.object_data
	current_node = current_data.get_mod(Enums.ObjectModType.INTERACTABLE).get_command_head()
	execute()


## Execute the current command. Read the data from the CommandNode's Command,
## then do something about it.
func execute() -> void:
	if current_node != null:
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
		current_node = current_node.next[index]
		execute()
	else:
		current_node = null


func execute_say(command:CommandSay):
	dialog_ui.say(command)


func execute_ask(command:CommandAsk):
	dialog_ui.ask(command)


func execute_give(command:CommandGive):
	pass
	#if command.item == null:
		#print(current_data.name + " gives itself!")
	#else:
		#print(current_data.name + " gives: " + command.item.name)
	dialog_ui.give(command)
	## wait for player to "accept" the gift. That will send a signal to do the next command.


func execute_take(command:CommandTake):
	pass
	#if command.item == null:
		#print(current_data.name + " attempts to take one of itself!")
	#else:
		#print(current_data.name + " attempts to take: " + command.item.name)
	dialog_ui.take(command)
	## wait for player give / not give. That will send a signal to do the next command.


func execute_remove():
	current_obj.queue_free()
	execute_next(0)
