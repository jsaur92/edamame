class_name ModItem
extends ObjectMod
## Data for item Objects.

## If true, multiple copies of the same Item can fit in the same Inventory slot.
@export var stackable : bool
const FILE_PATH = "uid://c4b0hx6f7v4b6"


func to_json_string() -> String:
	var dict = {}
	dict["script_path"] = FILE_PATH
	return JSON.stringify(dict)


static func from_json_string(json_string : String) -> ModItem:
	return ModItem.new()
