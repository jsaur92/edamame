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
## The data for setting up the player at the beginning of the game.
@export var player_init_data : PlayerInitData


static func create(title:String, subject:String, author:String) -> GameData:
	var gd = GameData.new()
	gd.title = title
	gd.subject = subject
	gd.author = author
	gd.environments = Array([EnvironmentData.create()], TYPE_OBJECT, "RefCounted", EnvironmentData)
	gd.object_library = ObjectLibrary.new()
	gd.player_init_data = PlayerInitData.new()
	return gd


## Returns the game's environment of a given index. No parameters gives default Environment.
func get_environment(index:int=0) -> EnvironmentData:
	return environments[index]
	
