class_name ModInteractable
extends ObjectMod
## Data for interactable Objects.

## Dictionary of CommandNodes, each of which are the Head Nodes of a Command Chain.
## Uses Head Node type as keys.
@export var command_heads : Dictionary[String, CommandNode]
