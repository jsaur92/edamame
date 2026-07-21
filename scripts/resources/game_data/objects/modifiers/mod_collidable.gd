class_name ModCollidable
extends ObjectMod
## Data for collidable Objects.
##
## Only implemented for a single collision shape. In the future, this may allow
## for multiple shapes with different positioning.

## The shape of the collision of the Object.
@export var shape : Shape2D = RectangleShape2D.new()

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
