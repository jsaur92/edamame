class_name CommandSetState
extends Command
## Command to change the State of an Object.

## The state to set to.
@export var state : String

func _init(_state:String="") -> void:
	state = _state

func _execute() -> int:
	return -1
