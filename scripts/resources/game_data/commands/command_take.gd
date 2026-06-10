class_name CommandTake
extends Command
## Command for an Object to request an item from the Player.
##
## Prompts the Player to give the requested item. The Player may choose to give
## or not give the item if they have it. 

## The ObjectData of the item to request. Should only accept Objects with
## the Item modifier (ModItem).
@export var item : ObjectData

func _init(_item:ObjectData=null) -> void:
	item = Validate.item(_item)


func _to_string() -> String:
	return "Take \"" + str(item) + "\""
