class_name InteractableTab
extends Control

@export var graph_edit : GraphEdit
@export var split_container : VSplitContainer
@export var node_dock : Control
var held_node : GraphNode
var held_node_offset : Vector2 = Vector2.ZERO
var head_nodes : Array[HeadCommandGraphNode]
const NODE_SPACING : Vector2 = Vector2(300, 300)
signal save_node_tree

func _process(delta: float) -> void:
	if held_node != null:
		held_node.global_position = get_global_mouse_position() + held_node_offset
		if Input.is_action_just_released("click"):
			release()
	if Input.is_action_just_released("click"):
		graph_edit.set_selected(null)


func release() -> void:
	if held_node and held_node.selected:
		#position in control view
		var c_pos = get_global_mouse_position() - global_position + held_node_offset
		#position in graph edit
		var g_pos = c_pos + graph_edit.scroll_offset
		if _is_over_dock(c_pos.y):
			held_node.reparent(graph_edit)
			held_node.position_offset = g_pos 
		else:
			held_node.queue_free()
		
		graph_edit.set_selected(null)
		
	held_node = null
	held_node_offset = Vector2.ZERO


## Load in a whole Interactable node tree.
func load_data(data:ModInteractable) -> void:
	for graph_node in graph_edit.get_children():
		if graph_node is GraphNode:
			graph_node.queue_free()
	##when support for multiple node heads is available, this must be expanded.
	var head_cgn = HeadCommandGraphNode.make()
	graph_edit.add_child( head_cgn )
	if data.get_command_head() != null:
		var first_node = _load_node( data.get_command_head(), Vector2.ZERO + Vector2(NODE_SPACING.x, 0) )
		graph_edit.connect_node(head_cgn.name, 0, first_node.name, 0)
	graph_edit.arrange_nodes()


## Write the interactable data to a new object.
func write_data() -> ModInteractable:
	#gather head command node(s)
	print('a')
	head_nodes = []
	for child in graph_edit.get_children():
		print(child)
		if child is HeadCommandGraphNode:
			head_nodes.append(child)
	
	var interactable = ModInteractable.new()
	print('b')
	for head_node in head_nodes:
		print(head_node)
		head_node.node_data = _get_node_chain_from_head_node(head_node)
		interactable.set_command_head(head_node.get_interact_condition(), head_node.get_node_data())
	
	return interactable


func _get_node_chain_from_head_node(hgn:HeadCommandGraphNode) -> CommandNode:
	var first : BaseCommandGraphNode = _get_graph_node_nexts(hgn)[0]
	var cmd : CommandNode = first.node_data
	_update_connected_nodes(first, cmd)
	print('c')
	print(cmd)
	return cmd


##recursively set the connections of command nodes tied to command graph nodes
func _update_connected_nodes(cgn:BaseCommandGraphNode, cmd:CommandNode) -> void:
	cmd.command = cgn.command
	cmd.next = []
	for gn:BaseCommandGraphNode in _get_graph_node_nexts(cgn):
		var new_cmd = CommandNode.new()
		new_cmd.command = cgn.command
		cmd.next.append(new_cmd)
		_update_connected_nodes(gn, new_cmd)


func _get_graph_node_nexts(gn:BaseCommandGraphNode) -> Array[BaseCommandGraphNode]:
	var these_connections : Array[Dictionary] = []
	var connection_list = graph_edit.get_connection_list_from_node(gn.name)
	#gather all of the connections that start from this node
	for connection in connection_list:
		if connection["from_node"] == gn.name:
			these_connections.append(connection)
	#sort the connections by from_port, ascending.
	these_connections.sort_custom(_compare_connections_by_port)
	#make the `next` array as large as the port of the last connection and place the `next` nodes into the array by port index
	var i = 0
	var next : Array[BaseCommandGraphNode] = []
	while i < these_connections.size():
		if these_connections[i]["from_port"] == next.size():
			next.append(graph_edit.get_node(NodePath(these_connections[i]["to_node"])))
			i += 1
		else:
			next.append(null)
	
	return next


func _compare_connections_by_port(a, b) -> bool:
	return a["from_port"] < b["from_port"]


## Load in a single node by its CommandNode data, then load in its child(ren).
func _load_node(node:CommandNode, pos:Vector2) -> BaseCommandGraphNode:
	var command = node.command
	var new_node : GraphNode
	if command is CommandSay:
		new_node = SayCommandGraphNode.make(node)
	elif command is CommandAsk:
		new_node = AskCommandGraphNode.make(node)
	elif command is CommandGive:
		new_node = GiveCommandGraphNode.make(node)
	elif command is CommandTake:
		new_node = TakeCommandGraphNode.make(node)
	elif command is CommandRemove:
		new_node = RemoveCommandGraphNode.make(node)
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
	
	graph_edit.add_child(new_node)
	new_node.dragged.connect(_node_pos_changed.bind(new_node))
	
	var i = 0
	for next in node.next:
		var new_new_node = _load_node(next, pos + Vector2(NODE_SPACING.x, NODE_SPACING.y*i))
		graph_edit.connect_node(new_node.name, i, new_new_node.name, 0)
		i += 1
	return new_node


func _node_pos_changed(from:Vector2, to:Vector2, node:GraphNode) -> void:
	held_node = node
	held_node_offset = held_node.global_position - get_global_mouse_position()
	release()


func _is_over_dock(y_val:float) -> bool:
	return y_val < get_viewport_rect().size.y - split_container.split_offsets[0]


func _on_command_node_dock_node_clicked(node:BaseCommandGraphNode) -> void:
	held_node = node.make()
	held_node.position = node.position
	add_child(held_node)
	held_node.dragged.connect(_node_pos_changed.bind(held_node))
	held_node.selected = true
	held_node_offset = held_node.global_position - get_global_mouse_position() + node_dock.position


func _on_command_node_chains_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	graph_edit.connect_node(from_node, from_port, to_node, to_port)


func _on_command_node_chains_scroll_offset_changed(offset: Vector2) -> void:
	release()


func _on_save_button_pressed() -> void:
	save_node_tree.emit( write_data() )
