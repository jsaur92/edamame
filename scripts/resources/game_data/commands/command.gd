@abstract
class_name Command
extends Resource
## Abstract base class for all Commands.

func has_dialog() -> bool:
	return get("dialog") != null


@abstract
func to_json_string() -> String


static func from_json_string(json_string : String) -> Command:
	var dict = JSON.parse_string(json_string)
	var cmd_class : Command = load(dict["script_path"])
	return cmd_class.from_json_string(json_string)
