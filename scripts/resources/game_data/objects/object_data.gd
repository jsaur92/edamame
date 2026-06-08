@tool
class_name ObjectData
extends Resource
## Data for an Object in the Object library of a game.
##
## ObjectInstances use this data.

## Unique ID of the ObjectData. Used as keys in the ObjectLibrary.
@export var uid : int
## Name of the Object.
@export var name : String
## Image file used for the object's sprite.
@export var image : Image
## Object Modifiers. If an Object is an Item, Collidable, or Interactable, the data
## for each modifier will be stored here.
@export var mods : Dictionary[Enums.ObjectModType, ObjectMod]

func setup(_name:String="", _image:Image=null, _mods:Dictionary[Enums.ObjectModType, ObjectMod]={}, _uid:int=-1) -> void:
	name = _name
	image = Validate.image(_image)
	uid = Validate.uid(_uid)
	mods = _mods


## Returns true if this ObjectData is an Item, false otherwise.
func is_item() -> bool:
	return mods.has(Enums.ObjectModType.ITEM)


## Returns true if this ObjectData is Collidable, false otherwise.
func is_collidable() -> bool:
	return mods.has(Enums.ObjectModType.COLLIDABLE)


## Returns true if this ObjectData is Interactable, false otherwise.
func is_interactable() -> bool:
	return mods.has(Enums.ObjectModType.INTERACTABLE)


## Returns a given ObjectMod. Returns null if nonexistent.
func get_mod(mod_type:Enums.ObjectModType):
	return mods.get(mod_type)
