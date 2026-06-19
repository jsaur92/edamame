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
## Scale vector for the texture made from Image.
@export var image_scale : Vector2 = Vector2(1,1)
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


func set_item(mod:ModItem=ModItem.new()) -> void:
	mods[Enums.ObjectModType.ITEM] = mod


func set_collidable(mod:ModCollidable=ModCollidable.new()) -> void:
	mods[Enums.ObjectModType.COLLIDABLE] = mod


func set_interactable(mod:ModInteractable=ModInteractable.new()) -> void:
	mods[Enums.ObjectModType.INTERACTABLE] = mod


func remove_item() -> bool:
	return mods.erase(Enums.ObjectModType.ITEM)


func remove_collidable() -> bool:
	return mods.erase(Enums.ObjectModType.COLLIDABLE)


func remove_interactable() -> bool:
	return mods.erase(Enums.ObjectModType.INTERACTABLE)


## Returns a given ObjectMod. Returns null if nonexistent.
func get_mod(mod_type:Enums.ObjectModType) -> ObjectMod:
	return mods.get(mod_type)


## Returns true if this Object has an Image, false otherwise.
func has_image() -> bool:
	return image != null


func get_image() -> Image:
	return image


func get_scaled_image() -> Image:
	if image == null:
		return null
	var i = get_image().duplicate()
	i.resize(get_image().get_size().x * image_scale.x, get_image().get_size().y * image_scale.y, Image.INTERPOLATE_NEAREST)
	return i


func _to_string() -> String:
	return name
