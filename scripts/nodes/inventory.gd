class_name Inventory
extends Node
## Represents the Player's inventory containing all of their items.

@export var items : Array[ObjectData]

func add_item(item:ObjectData):
	item = Validate.item(item)
	if item != null:
		items.append(item)


func remove_item(item:ObjectData) -> void:
	items.erase(item)


func get_items() -> Array[ObjectData]:
	return items


func has_item(item:ObjectData) -> bool:
	return item in items


func is_empty() -> bool:
	return items.size() == 0
