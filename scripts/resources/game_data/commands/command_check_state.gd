class_name CommandCheckState
extends Command
## Command to check the State of an Object.
##
## If the State of the checked Object is equal to the state variable of this
## command, returns true, else returns false.

## The state to check for.
@export var state : String

func _execute() -> int:
	return -1
