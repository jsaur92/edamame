class_name ObjectLibrary
extends Resource
## Library of all data for Objects in the Game (including unused content).

## The dictionary of Objects in the library. Key is the UID for each ObjectData.
@export var objects : Dictionary[int, ObjectData]
static var library : ObjectLibrary

func _init(_objects:Dictionary[int, ObjectData]={}) -> void:
	objects = _objects
	_set_library(self)


## Returns the static ObjectLibrary instance.
static func get_current_library() -> ObjectLibrary:
	if library == null:
		_set_library( ObjectLibrary.new() )
	return library


static func _set_library(new_library:ObjectLibrary) -> void:
	library = new_library


## Add an object to the Objects library
func add_object(object:ObjectData):
	objects.set(object.uid, object)


## Remove an object from the Objects library
func remove_object(object:ObjectData):
	objects.erase(object.uid)


func get_object(key:int) -> ObjectData:
	if not objects.keys().has(key):
		key = objects.keys()[0]
	return objects[key]


func get_objects() -> Array[ObjectData]:
	return objects.values()


func to_json_string() -> String:
	var dict = {}
	for key in objects:
		dict[key] = objects[key].to_json_string()
	return JSON.stringify(dict)


static func from_json_string(json_string : String) -> ObjectLibrary:
	var dict = JSON.parse_string(json_string)
	var obj_dict : Dictionary[int, ObjectData] = {}
	for key in dict:
		obj_dict[int(key)] = ObjectData.from_json_string(dict[key])
	return ObjectLibrary.new(obj_dict)
