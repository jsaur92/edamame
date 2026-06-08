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
