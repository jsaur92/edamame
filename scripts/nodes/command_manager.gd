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

#cooldown timer (physics frames) to prevent double inputs at the end of an interact.
var cooldown_timer = 0
const INTERACT_COOLDOWN = 2

signal update_current_node


func _physics_process(delta: float) -> void:
	if cooldown_timer > 0:
		cooldown_timer -= 1


func set_dialog_ui(d:DialogUI):
	dialog_ui = d


func set_current_node(node:CommandNode):
	current_node = node
	update_current_node.emit(node)
	get_tree().paused = (node != null)


func interact_with(object:GameObject) -> void:
	if current_obj == null and cooldown_timer <= 0:
		current_obj = object
		current_data = current_obj.object_data
		set_current_node(current_data.get_mod(Enums.ObjectModType.INTERACTABLE).get_command_head())
		execute()


func reset() -> void:
	current_obj = null
	current_data = null
	set_current_node(null)
	cooldown_timer = 2


## Execute the current command. Read the data from the CommandNode's Command,
## then do something about it.
func execute() -> void:
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
		elif command is CommandEnd:
			execute_end()


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


func execute_end():
	get_tree().paused = false
	if Editor.get_instance() == null:
		get_tree().change_scene_to_node( EndScreen.create() )
	else:
		Editor.get_instance().end_playtest()
