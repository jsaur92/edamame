class_name GameData
extends Resource
## Data for one Game project.
##
## This Resource can be exported to a file to be imported by other users.

## Title of the game.
@export var title : String
## Subject of the course content of the game (e.g. Math, History, Algebra, Chemistry).
@export var subject : String
## Author (or authors) of the game.
@export var author : String
## Environment data of the game. The first EnvironmentData in the array is the default Environment of the game.
@export var environments : Array[EnvironmentData]
## Library of all data for Objects in the Game (including unused content).
@export var object_library : ObjectLibrary
## Library of all data for Activities in the Game (including unused content).
@export var activity_library : ActivityLibrary
