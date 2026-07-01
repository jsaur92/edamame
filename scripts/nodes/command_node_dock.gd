extends Control

signal node_clicked

func _ready() -> void:
	for graph_node:GraphNode in get_children():
		graph_node.gui_input.connect(node_gui_input.bind(graph_node))

func node_gui_input(event:InputEvent, node:GraphNode) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			node_clicked.emit(node)
