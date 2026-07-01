class_name InteractableTab
extends Control

@export var graph_edit : GraphEdit
var held_node : GraphNode
const NODE_SPACING : Vector2 = Vector2(300, 300)

func _process(delta: float) -> void:
	if held_node != null:
		held_node.global_position = get_global_mouse_position()
		if Input.is_action_just_released("click"):
			release()


func release() -> void:
	var g_pos = get_global_mouse_position() - global_position
	held_node.reparent(graph_edit)
	held_node.position_offset = g_pos 
	held_node = null


## Load in a whole Interactable node tree.
func load_data(data:ModInteractable) -> void:
	for graph_node in graph_edit.get_children():
		graph_node.queue_free()
	#when support for multiple node heads is available, this must be expanded.
	if data.get_command_head() != null:
		_load_node( data.get_command_head(), Vector2.ZERO )
	graph_edit.arrange_nodes()


## Load in a single node by its CommandNode data, then load in its child(ren).
func _load_node(node:CommandNode, pos:Vector2) -> BaseCommandGraphNode:
	var command = node.command
	var new_node
	if command is CommandSay:
		new_node = SayCommandGraphNode.make(node)
	elif command is CommandAsk:
		new_node = AskCommandGraphNode.make(node)
	elif command is CommandGive:
		new_node = GiveCommandGraphNode.make(node)
	elif command is CommandTake:
		new_node = TakeCommandGraphNode.make(node)
	elif command is CommandRemove:
		new_node = RemoveCommandGraphNode.make()
	#elif command is CommandReset:
		#pass
	#elif command is CommandEnd:
		#pass
	#elif command is CommandActivity:
		#pass
	#elif command is CommandCheckState:
		#pass
	#elif command is CommandSetState:
		#pass
	else:
		push_error("Command type not recognized by load_node()")
	
	var i = 0
	for next in node.next:
		var new_new_node = _load_node(next, pos + Vector2(NODE_SPACING.x, NODE_SPACING.y*i))
		graph_edit.connect_node(new_node, i, new_new_node, 0)
		i += 1
	return new_node


func _on_command_node_dock_node_clicked(node:Node) -> void:
	held_node = node.duplicate()
	add_child(held_node)


func _on_command_node_chains_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	graph_edit.connect_node(from_node, from_port, to_node, to_port)
