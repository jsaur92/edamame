class_name ModInteractable
extends ObjectMod
## Data for interactable Objects.

## Dictionary of CommandNodes, each of which are the Head Nodes of a Command Chain.
## Uses Head Node type as keys.
@export var command_heads : Dictionary[String, CommandNode]
const FILE_PATH = "uid://b8umwh4qgb70w"


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


func set_command_head(key:String, value:CommandNode) -> void:
	command_heads[key] = value

func to_json_string() -> String:
	var dict = {}
	dict["script_path"] = FILE_PATH
	var command_head_strings = {}
	for key in command_heads:
		command_head_strings[key] = command_heads[key].to_json_string()
	dict["command_heads"] = JSON.stringify(command_head_strings)
	return JSON.stringify(dict)


static func from_json_string(json_string : String) -> ModInteractable:
	var dict = JSON.parse_string(json_string)
	var command_head_strings = JSON.parse_string( dict["command_heads"] )
	var mod = ModInteractable.new()
	for key in command_head_strings:
		mod.command_heads[key] = CommandNode.from_json_string( command_head_strings[key] )
	return mod
