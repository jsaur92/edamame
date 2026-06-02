class_name MCActivity
extends ActivityData
## Activity Data for a Multiple-Choice Question Activity.

## Data for each answer choice. Can include text and/or image.
@export var answer_choices : Array[MCAnswer]
## Enable to allow Players to select and submit multiple answers. Multiple answers
## can be marked correct regardless of this option.
@export var multiple_selection : bool
