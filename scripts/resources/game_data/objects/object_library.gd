class_name ObjectLibrary
extends Resource
## Library of all data for Objects in the Game (including unused content).

## The dictionary of Objects in the library. Key is the UID for each ObjectData.
@export var objects : Dictionary[int, ObjectData]

func _init(_objects:Dictionary[int, ObjectData]={}) -> void:
	objects = _objects

## Add an object to the Objects library
func add_object(object:ObjectData):
	objects.set(object.uid, object)

## Remove an object from the Objects library
func remove_object(object:ObjectData):
	objects.erase(object.uid)
