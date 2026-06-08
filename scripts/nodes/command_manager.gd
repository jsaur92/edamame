extends Node
## Singleton that manages all commands.
##
## When an Interactable's Interact is called, it sends a signal that this Node
## receives and handles all of its Command information.

var current_obj : ObjectData
var current_node : CommandNode

func interact_with(object:GameObject) -> void:
	current_obj = object.object_data
	current_node = current_obj.get_mod(Enums.ObjectModType.INTERACTABLE).get_command_head()
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

func execute_next(index:int) -> void:
	if current_node.has_next(index):
		current_node = current_node.next[index]
		execute()


func execute_say(command:CommandSay):
	print(current_obj.name + " says: " + command.dialogue)
	## wait for player to continue the dialogue. That will send a signal to do the next command.


func execute_ask(command:CommandAsk):
	print(current_obj.name + " asks: " + command.dialogue)
	## wait for player to answer the question. That will send a signal to do the next command.


func execute_give(command:CommandGive):
	print(current_obj.name + " gives: " + command.item.name)
	## wait for player to "accept" the gift. That will send a signal to do the next command.


func execute_take(command:CommandTake):
	print(current_obj.name + " attempts to take: " + command.item.name)
	## wait for player give / not give. That will send a signal to do the next command.
