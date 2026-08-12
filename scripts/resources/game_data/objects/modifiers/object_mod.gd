@abstract
class_name ObjectMod
extends Resource
## Abstract base class for Object Modifiers.

@abstract
func to_json_string() -> String


static func from_json_string(json_string : String) -> ObjectMod:
	var dict = JSON.parse_string(json_string)
	var mod_class : ObjectMod = load(dict["script_path"])
	return mod_class.from_json_string(json_string)
