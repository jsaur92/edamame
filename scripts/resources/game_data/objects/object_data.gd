class_name ObjectData
extends Resource
## Data for an Object in the Object library of a game.
##
## ObjectInstances use this data.

## Unique ID of the ObjectData. Used as keys in the ObjectLibrary.
@export var uid : String
## Name of the Object.
@export var name : String
## Image of the Object.
@export var image : Image
## Object Modifiers. If an Object is an Item, Collidable, or Interactable, the data
## for each modifier will be stored here.
@export var mods : Dictionary[Enums.ObjectModType, ObjectMod]
