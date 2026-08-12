class_name CommandTake
extends Command
## Command for an Object to request an item from the Player.
##
## Prompts the Player to give the requested item. The Player may choose to give
## or not give the item if they have it. 

## The index in ObjectLibrary of the ObjectData of the item to request. Should only accept Objects with
## the Item modifier (ModItem).
@export var item_uid : int

const FILE_PATH = "uid://bjbpb55op4g7c"

func _init(_item:int=-1) -> void:
	item_uid = _item


func _to_string() -> String:
	return "Take Item with uid " + str(item_uid) + "."


func get_item() -> ObjectData:
	return ObjectLibrary.get_current_library().get_object(item_uid)


func set_item(new_item_uid:int) -> void:
	item_uid = new_item_uid


func to_json_string() -> String:
	var dict = {}
	dict["script_path"] = FILE_PATH
	dict["item_uid"] = item_uid
	return JSON.stringify(dict)


static func from_json_string(json_string : String) -> CommandGive:
	var dict = JSON.parse_string(json_string)
	return CommandGive.new(dict["item_uid"])
