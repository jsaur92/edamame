class_name CommandSay
extends Command
## Command for an Object to say a line of dialog.

## The dialog to say.
@export var dialog : String

func _init(_dialog:String="") -> void:
	dialog=_dialog


func _to_string() -> String:
	return "Say \"" + dialog + "\""
