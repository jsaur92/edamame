class_name CommandAsk
extends Command
## Command for an Object to ask a question and return a response.

## The dialog to say.
@export var dialog : String
## The answer options the Player can choose from.
@export var choices : Array[String]

func _init(_dialog:String="", _choices:Array[String]=["yes", "no"]) -> void:
	dialog = _dialog
	choices = _choices


func _to_string() -> String:
	return "Ask \"" + dialog + "\""
