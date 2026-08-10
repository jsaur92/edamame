class_name CommandAsk
extends Command
## Command for an Object to ask a question and return a response.

## The dialog to say.
@export var dialog : String
## The answer options the Player can choose from.
@export var choices : Array[String]

const SCRIPT_FILE_PATH = "uid://bklghll274dss"
const ENCODE_DIALOG_START = "dialog : "
const ENCODE_CHOICE_START = "choice : "


func _init(_dialog:String="", _choices:Array[String]=["yes", "no"]) -> void:
	dialog = _dialog
	choices = _choices


func _to_string() -> String:
	return "Ask \"" + dialog + "\""


func encode_to_string() -> String:
	var str := SCRIPT_FILE_PATH
	str += ENCODE_SPLIT + ENCODE_DIALOG_START + dialog
	for choice in choices:
		str += ENCODE_SPLIT + ENCODE_CHOICE_START + choice
	return str


static func decode_from_string(string:String) -> CommandAsk:
	var dialog : String
	var choices : Array[String]
	var i = 0
	for line in string.split(ENCODE_SPLIT):
		if i == 0:
			dialog = line.substr(ENCODE_DIALOG_START.length())
		else:
			choices.append(line.substr(ENCODE_CHOICE_START.length()))
		i += 1
	return CommandAsk.new(dialog, choices)
