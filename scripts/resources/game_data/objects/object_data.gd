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

func _init(_name:String="", _image:Image=null, _mods:Dictionary[Enums.ObjectModType, ObjectMod]={}, _uid:int=-1) -> void:
	name = _name
	image = Validate.image(_image)
	uid = Validate.uid(_uid)
	mods = _mods
