class_name CommandAsk
extends Command
## Command for an Object to ask a question and return a response.

## The dialog to say.
@export var dialog : String
## The answer options the Player can choose from.
@export var choices : Array[String]

const FILE_PATH = "uid://bklghll274dss"

func _init(_dialog:String="", _choices:Array[String]=["yes", "no"]) -> void:
	dialog = _dialog
	choices = _choices


func _to_string() -> String:
	return "Ask \"" + dialog + "\""


func to_json_string() -> String:
	var dict = {}
	dict["script_path"] = FILE_PATH
	dict["dialog"] = dialog
	dict["choices_size"] = choices.size()
	for i in choices.size():
		dict["choice"+str(i)] = choices[i]
	return JSON.stringify(dict)


static func from_json_string(json_string : String) -> CommandAsk:
	var dict = JSON.parse_string(json_string)
	var dialog = dict["dialog"]
	var choices : Array[String] = []
	for i in int(dict["choices_size"]):
		choices.append(dict["choice"+str(i)])
	return CommandAsk.new(dialog, choices)
