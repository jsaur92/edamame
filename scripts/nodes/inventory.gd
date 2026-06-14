class_name Inventory
extends Node
## Represents the Player's inventory containing all of their items.

@export var items : Array[ObjectInstanceData]

func add_item(item:ObjectInstanceData):
	item = Validate.item_instance(item)
	if item != null:
		items.append(item)


func remove_item(item:ObjectInstanceData):
	items.erase(item)


func get_items():
	return items


func has_item(item:ObjectInstanceData):
	return item in items
