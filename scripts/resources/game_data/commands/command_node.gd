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


func has_command() -> bool:
	return command != null


func _to_string() -> String:
	return "Command: " + str(command)


func to_json_string() -> String:
	var dict = {}
	dict["command"] = command.to_json_string()
	dict["next_size"] = next.size()
	for i in next.size():
		dict["next"+str(i)] = next[i].to_json_string()
	return JSON.stringify(dict)


static func from_json_string(json_string : String) -> CommandNode:
	var dict = JSON.parse_string(json_string)
	var command = Command.from_json_string(dict["command"])
	var next : Array[CommandNode] = []
	for i in int(dict["next_size"]):
		next.append(CommandNode.from_json_string(dict["next"+str(i)]))
	var node = CommandNode.new()
	node.command = command
	node.next = next
	return node
