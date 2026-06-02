class_name CommandNode
extends Resource
## A Node that contains a Command and points to zero or more next CommandNodes.

@export var command : Command
@export var next : Array[CommandNode]

## Perform this CommandNode's Command, then execute the next command based on the
## result of this Command's call.
## Returns the result of the last call.
func execute() -> int:
	var result = command._execute()
	if result < next.size():
		next[result].execute()
	return result
