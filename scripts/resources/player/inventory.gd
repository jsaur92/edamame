class_name Inventory
extends Resource
## Represents the Player's inventory containing all of their items.

@export var items : Array[ObjectInstanceData]

func add_item(item:ObjectInstanceData):
	item = Validate.item_instance(item)
