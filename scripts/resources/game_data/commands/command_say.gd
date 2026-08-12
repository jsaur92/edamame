class_name CommandSay
extends Command
## Command for an Object to say a line of dialog.

## The dialog to say.
@export var dialog : String

const FILE_PATH = "uid://by3vegmjhgnnt"

func _init(_dialog:String="") -> void:
	dialog=_dialog


func _to_string() -> String:
	return "Say \"" + dialog + "\""


func to_json_string() -> String:
	var dict = {}
	dict["script_path"] = FILE_PATH
	dict["dialog"] = dialog
	return JSON.stringify(dict)


static func from_json_string(json_string : String) -> CommandSay:
	var dict = JSON.parse_string(json_string)
	return CommandSay.new(dict["dialog"])
