class_name ModCollidable
extends ObjectMod
## Data for collidable Objects.
##
## Only implemented for a single collision shape. In the future, this may allow
## for multiple shapes with different positioning.

## The shape of the collision of the Object.
@export var shape : Shape2D = RectangleShape2D.new()
const FILE_PATH = "uid://bm5ki8hon2jai"

func get_shape() -> Shape2D:
	return shape


func scale_width(value:float) -> void:
	if shape is RectangleShape2D:
		shape.size.x *= value


func scale_height(value:float) -> void:
	if shape is RectangleShape2D:
		shape.size.y *= value
	elif shape is CircleShape2D:
		shape.radius *= value


func to_json_string() -> String:
	var dict = {}
	dict["script_path"] = FILE_PATH
	if shape is CircleShape2D:
		dict["shape_type"] = "circle"
		dict["radius"] = shape.radius
	elif shape is RectangleShape2D:
		dict["shape_type"] = "rect"
		dict["size.x"] = shape.size.x
		dict["size.y"] = shape.size.y
	else:
		push_error("attempted to save ModCollidable with unsupported collision shape.")
	return JSON.stringify(dict)


static func from_json_string(json_string : String) -> ModCollidable:
	var dict = JSON.parse_string(json_string)
	var shape_type = dict["shape_type"]
	var mod = ModCollidable.new()
	if shape_type == "circle":
		mod.shape = CircleShape2D.new()
		mod.shape.radius = dict["radius"]
	elif shape_type == "rect":
		mod.shape = RectangleShape2D.new()
		mod.shape.size.x = dict["size.x"]
		mod.shape.size.y = dict["size.y"]
	else:
		push_error("attempted to load ModCollidable with unsupported collision shape.")
	return mod
