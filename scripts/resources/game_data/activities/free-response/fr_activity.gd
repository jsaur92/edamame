class_name FRActivity
extends ActivityData
## Activity Data for a Free-Response Activity.

## Acceptable answers for the Free-Response Activity.
@export var answers : Array[String]
## Setting to false will compare the Player's answer with the valid answers
## without regard to capitalisation.
@export var case_sensative : bool
## Setting to false will remove all spaces, tabs, etc from the Player's answer
## and valid answers when checking for correctness.
@export var count_whitespace : bool
## Setting to false will remove punctuation from the Player's answer and valid
## answers when checking for correctness.
@export var count_punctuation : bool
