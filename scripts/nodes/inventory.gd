class_name Inventory
extends Node
## Represents the Player's inventory containing all of their items.

@export var items : Array[ObjectData]

func add_item(item:ObjectData):
	item = Validate.item(item)
	if item != null:
		items.append(item)


func remove_item(item:ObjectData):
	items.erase(item)


func get_items():
	return items


func has_item(item:ObjectData):
	return item in items
