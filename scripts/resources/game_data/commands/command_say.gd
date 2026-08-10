class_name CommandSay
extends Command
## Command for an Object to say a line of dialog.

## The dialog to say.
@export var dialog : String

const SCRIPT_FILE_PATH = "uid://by3vegmjhgnnt"
const ENCODE_DIALOG_START = "dialog : "

func _init(_dialog:String="") -> void:
	dialog=_dialog


func _to_string() -> String:
	return "Say \"" + dialog + "\""


func encode_to_string() -> String:
	var str := SCRIPT_FILE_PATH
	str += ENCODE_SPLIT + ENCODE_DIALOG_START + dialog
	return str


static func decode_from_string(string:String) -> CommandAsk:
	var dialog : String
	var choices : Array[String]
	var i = 0
	for line in string.split(ENCODE_SPLIT):
		if i == 0:
			pass
		elif i == 1:
			dialog = line.substr(ENCODE_DIALOG_START.length())
		else:
			choices.append(line.substr(ENCODE_CHOICE_START.length()))
		i += 1
	return CommandAsk.new(dialog, choices)
