class_name Validate
## Helper class for the init functions of different resources.

const DEFAULT_IMG = preload("uid://bcgovbjf0df12")

## For adding a UID to the ResourceUID singleton when loading in an object.
## If given less than 0, makes a new UID. Adds and returns the inputted
## or new UID.
static func uid(id:int) -> int:
	if id < 0:
		id = ResourceUID.create_id()
	ResourceUID.add_id(id, ResourceUID.id_to_text(id))
	return id


## Ensures that an Image is non-null. Returns a new empty 0x0 image
## if inputted null, returns input otherwise.
static func image(img:Image) -> Image:
	if img == null:
		img = DEFAULT_IMG.get_image()
	return img


## Ensures that an ObjectData has the Item modifier. Returns null otherwise.
static func item(obj:ObjectData):
	if obj == null:
		push_warning("Null value inputted.")
		obj = null
	elif not obj.is_item():
		push_error(obj.name+ " does not have the Item modifier.")
		obj = null
	return obj


## Ensures that an ObjectDataInstance has the Item modifier. Returns null otherwise.
static func item_instance(obj:ObjectInstanceData):
	return item(obj.object_data)
