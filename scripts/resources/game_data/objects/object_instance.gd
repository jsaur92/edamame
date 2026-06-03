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

func _init(_object_data:ObjectData, _position:Vector2=Vector2.ZERO, _default_state:String="") -> void:
	object_data = _object_data
	position = _position
	default_state = _default_state
