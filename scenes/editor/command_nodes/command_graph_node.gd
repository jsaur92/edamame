@abstract
class_name BaseCommandGraphNode
extends GraphNode
## Abstract base class for the visual representation of a CommandNode that can
## be connected on a graph.

@export var node_data : CommandNode

@abstract func update_data() -> void
