class_name ObjectInstanceData
extends Resource
## Data for an instanced object in a game.
##
## An ObjectInstanceData is still just data, not actually an instanced Node. It is
## called an instance because it represents an instanced object in the game, several
## of which can reference the same ObjectData resource.

## The ObjectData used by this instanced object.
@export var object_data : ObjectData
## The position of this instanced object in the environment.
@export var position : Vector2
## The default state of an instanced object.
@export var default_state : String


func setup(_object_data:ObjectData, _position:Vector2=Vector2.ZERO, _default_state:String="") -> void:
	object_data = _object_data
	position = _position
	default_state = _default_state


func get_position() -> Vector2:
	return position


func set_position(pos:Vector2) -> void:
	position = pos


func set_pos_x(x:int) -> void:
	position.x = x


func set_pos_y(y:int) -> void:
	position.y = y


func to_json_string() -> String:
	var dict = {}
	dict["object_data_uid"] = object_data.uid
	dict["position.x"] = position.x
	dict["position.y"] = position.y
	return JSON.stringify(dict)


static func from_json_string(json_string : String) -> ObjectInstanceData:
	var dict = JSON.parse_string(json_string)
	var object_data = ObjectLibrary.get_current_library().get_object(dict["object_data_uid"])
	var position = Vector2(dict["position.x"], dict["position.y"])
	var oid = ObjectInstanceData.new()
	oid.setup(object_data, position)
	return oid
	
