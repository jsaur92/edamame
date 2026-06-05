class_name CommandGive
extends Command
## Command for an Object to give an item to the Player.

## The ObjectData of the item to give. Should only accept Objects with
## the Item modifier (ModItem).
@export var item : ObjectData

func _init(_item:ObjectData=null) -> void:
	item = Validate.item(_item)

func _execute() -> int:
	return -1
