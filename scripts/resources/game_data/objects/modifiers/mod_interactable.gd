class_name ModInteractable
extends ObjectMod
## Data for interactable Objects.

## Dictionary of CommandNodes, each of which are the Head Nodes of a Command Chain.
## Uses Head Node type as keys.
@export var command_heads : Dictionary[String, CommandNode]


## Returns the starting Node for the Object's Interact chain. In the future, there
## may be multiple command heads for different triggers, such as when the player
## is nearby, or when the player interacts with a certain condition. For now,
## this command will return null if there are no command nodes, the "default"
## node if that exists, and otherwise simply the first in the dict's values.
func get_command_head() -> CommandNode:
	if command_heads.size() == 0:
		return null
	if command_heads.has("default"):
		return command_heads["default"]
	return command_heads.values()[0]
