class_name CommandNode
extends Resource
## A Node that contains a Command and points to zero or more next CommandNodes.

## The Command to call.
@export var command : Command
## Array of possible next Command Nodes to call after this Node's Command is executed.
## The integer returned by this Node's Command will be the index of the next Command
## called in this array.
@export var next : Array[CommandNode]


## Returns true if this Node has a "next" node at a certain index.
func has_next(index:int=0) -> bool:
	return next != null and index >= 0 and index < next.size()
