class_name EnvironmentGraphEdit
extends GraphEdit

@export var top_left : GraphNode
@export var bottom_right : GraphNode

func update_boundaries(rect:Rect2i) -> void:
	top_left.position_offset = rect.position
	bottom_right.position_offset = rect.size - rect.position
