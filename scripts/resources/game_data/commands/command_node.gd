class_name CommandNode
extends Resource
## A Node that contains a Command and points to zero or more next CommandNodes.

## The Command to call.
@export var command : Command
## Array of possible next Command Nodes to call after this Node's Command is executed.
## The integer returned by this Node's Command will be the index of the next Command
## called in this array.
@export var next : Array[CommandNode]

## Perform this CommandNode's Command, then execute the next command based on the
## result of this Command's call.
## Returns the result of the last call.
func execute() -> int:
	var result = command._execute()
	if result >= 0 and result < next.size():
		next[result].execute()
	return result
