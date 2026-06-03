class_name Validate
## Helper class for the init functions of different resources.

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
		img = Image.create_empty(0, 0, false, Image.FORMAT_RGBAF)
	return img
