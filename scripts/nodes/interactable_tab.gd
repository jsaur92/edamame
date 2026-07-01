extends Control

@export var graph_edit : GraphEdit
var held_node : GraphNode

func _process(delta: float) -> void:
	if held_node != null:
		held_node.global_position = get_global_mouse_position()
		if Input.is_action_just_released("click"):
			release()


func release() -> void:
	var g_pos = get_global_mouse_position()
	held_node.reparent(graph_edit)
	held_node.position_offset = g_pos
	held_node = null


func _on_command_node_dock_node_clicked(node:Node) -> void:
	held_node = node.duplicate()
	add_child(held_node)


func _on_command_node_chains_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	graph_edit.connect_node(from_node, from_port, to_node, to_port)
