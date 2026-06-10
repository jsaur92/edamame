class_name CommandGive
extends Command
## Command for an Object to give an item to the Player.

## The index in ObjectLibrary of the ObjectData of the item to give. Should only accept Objects with
## the Item modifier (ModItem).
@export var item_uid : int

func _init(_item:int=-1) -> void:
	item_uid = _item


func _to_string() -> String:
	return "Give Item with uid " + str(item_uid) + "."


func get_item() -> ObjectData:
	return GameDataAccess.get_game_data().object_library.get_object(item_uid)
