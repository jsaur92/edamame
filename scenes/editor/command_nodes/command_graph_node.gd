@abstract
class_name BaseCommandGraphNode
extends GraphNode
## Abstract base class for the visual representation of a CommandNode that can
## be connected on a graph.

## The maximum size for textures displayed in a command graph node
const MAX_TEX_SIZE = Vector2(100,100)

@export var node_data : CommandNode

@abstract func update_data() -> void


func get_node_data() -> CommandNode:
	return node_data
