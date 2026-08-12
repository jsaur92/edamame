class_name ObjectData
extends Resource
## Data for an Object in the Object library of a game.
##
## ObjectInstances use this data.

## Unique ID of the ObjectData. Used as keys in the ObjectLibrary.
@export var uid : int
## Name of the Object.
@export var name : String
## Description of the Object. An optional attribute.
@export var description : String
## Image file used for the object's sprite.
@export var image : PackedByteArray
## Dimensions of the source image.
@export var image_source_size_pixels : Vector2i
## Scale vector for the texture made from Image.
@export var image_size_pixels : Vector2 = Vector2(100,100)
## Object Modifiers. If an Object is an Item, Collidable, or Interactable, the data
## for each modifier will be stored here.
@export var mods : Dictionary[Enums.ObjectModType, ObjectMod]
const DEFAULT_IMAGE_PATH : String = "uid://c2e54hcvh2rbc"


static func create() -> ObjectData:
	var od = ObjectData.new()
	od.setup()
	return od


func setup(_name:String="", _image:Image=null, _mods:Dictionary[Enums.ObjectModType, ObjectMod]={}, _uid:int=-1) -> void:
	name = _name
	image = Validate.image(_image).get_data()
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


func set_size_x(x:int) -> void:
	image_size_pixels.x = x


func set_size_y(y:int) -> void:
	image_size_pixels.y = y


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


## Set the image binary data and dimensions based on a given image.
func set_image(img:Image) -> void:
	image = img.get_data()
	image_source_size_pixels = img.get_size()


func get_image() -> Image:
	if image.size() > 0:
		var img = Image.create_from_data(image_source_size_pixels.x, image_source_size_pixels.y, false, Image.FORMAT_RGBA8, image)
		return img
	else:
		return load(DEFAULT_IMAGE_PATH)


func get_scaled_image() -> Image:
	if image == null:
		return null
	var i = get_image()
	i.resize(image_size_pixels.x, image_size_pixels.y, Image.INTERPOLATE_NEAREST)
	return i


func get_image_size_pixels() -> Vector2i:
	return image_size_pixels


func _to_string() -> String:
	return name


func to_json_string() -> String:
	var dict = {}
	dict["uid"] = uid
	dict["name"] = name
	dict["description"] = description
	dict["image"] = image.hex_encode()
	dict["img_source_size.x"] = image_source_size_pixels.x
	dict["img_source_size.y"] = image_source_size_pixels.y
	dict["img_size.x"] = image_size_pixels.x
	dict["img_size.y"] = image_size_pixels.y
	var mods_dict = {}
	for key in mods:
		mods_dict[key] = mods[key].to_json_string()
	dict["mods"] = JSON.stringify(mods_dict)
	return JSON.stringify(dict)


static func from_json_string(json_string : String) -> ObjectData:
	var dict = JSON.parse_string(json_string)
	var od = ObjectData.new()
	od.uid = dict["uid"]
	od.name = dict["name"]
	od.description = dict["description"]
	od.image = dict["image"].hex_decode()
	od.image_source_size_pixels = Vector2i(dict["img_source_size.x"], dict["img_source_size.y"])
	od.image_size_pixels = Vector2i(dict["img_size.x"], dict["img_size.y"])
	var mods_dict = JSON.parse_string(dict["mods"])
	for key in mods_dict:
		od.mods[int(key)] = ObjectMod.from_json_string( mods_dict[key] )
	return od
