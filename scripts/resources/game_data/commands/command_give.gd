class_name CommandGive
extends Command
## Command for an Object to give an item to the Player.

## The ObjectData of the item to give. Should only accept Objects with
## the Item modifier (ModItem).
@export var item : ObjectData

func _init(_item:ObjectData=null) -> void:
	if item.mods.has(Enums.ObjectModType.ITEM):
		item = _item
	else:
		item = null
		push_error("Attempted to make a Give Command giving " + _item.name+ ", which does not have the Item modifier.")

func _execute() -> int:
	return -1
