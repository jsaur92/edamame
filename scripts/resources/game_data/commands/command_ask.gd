class_name CommandAsk
extends Command
## Command for an Object to ask a question and return a response.

## The dialogue to say.
@export var dialogue : String
## The answer options the Player can choose from.
@export var choices : Array[String]

func _init(_dialogue:String="", _choices:Array[String]=["yes", "no"]) -> void:
	dialogue = _dialogue
	choices = _choices
