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
	if item.mods.has(Enums.ObjectModType.ITEM):
		item = _item
	else:
		item = null
		push_error("Attempted to make a Take Command taking " + _item.name+ ", which does not have the Item modifier.")


func _execute() -> int:
	return -1
