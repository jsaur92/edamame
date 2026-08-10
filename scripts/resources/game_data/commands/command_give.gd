class_name CommandGive
extends Command
## Command for an Object to give an item to the Player.

## The index in ObjectLibrary of the ObjectData of the item to give. Should only accept Objects with
## the Item modifier (ModItem).
@export var item_uid : int

const ENCODE_HEADER = "CommandGive"
const ENCODE_ITEM_START = "item : "
const ENCODE_SPLIT = "\n"

func _init(_item:int=-1) -> void:
	item_uid = _item


func _to_string() -> String:
	return "Give Item with uid " + str(item_uid) + "."


func get_item() -> ObjectData:
	return ObjectLibrary.get_current_library().get_object(item_uid)


func set_item(new_item_uid:int) -> void:
	item_uid = new_item_uid
