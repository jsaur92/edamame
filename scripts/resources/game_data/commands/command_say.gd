class_name CommandSay
extends Command
## Command for an Object to say a line of dialogue.

## The dialogue to say.
@export var dialogue : String

func _init(_dialogue:String="") -> void:
	dialogue=_dialogue
