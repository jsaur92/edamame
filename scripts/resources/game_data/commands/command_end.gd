class_name CommandEnd
extends Command
## Command to end the game.

const FILE_PATH = "uid://dy7m3n6nekkyy"


func _to_string() -> String:
	return "End game."


func to_json_string() -> String:
	var dict = {}
	dict["script_path"] = FILE_PATH
	return JSON.stringify(dict)


static func from_json_string(json_string : String) -> CommandEnd:
	return CommandEnd.new()
