class_name CommandRemove
extends Command
## Command to remove the object.

const FILE_PATH = "uid://btfrqyun3bhug"

func _to_string() -> String:
	return "Remove GameObject"


func to_json_string() -> String:
	var dict = {}
	dict["script_path"] = FILE_PATH
	return JSON.stringify(dict)


static func from_json_string(json_string : String) -> CommandRemove:
	return CommandRemove.new()
