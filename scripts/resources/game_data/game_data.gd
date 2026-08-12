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
## The version of edamame that the project was made in.
@export var edamame_version : String


static func create(title:String, subject:String, author:String) -> GameData:
	var gd = GameData.new()
	gd.title = title
	gd.subject = subject
	gd.author = author
	gd.environments = Array([EnvironmentData.create()], TYPE_OBJECT, "RefCounted", EnvironmentData)
	gd.object_library = ObjectLibrary.new()
	gd.player_init_data = PlayerInitData.new()
	gd.edamame_version = ProjectSettings.get_setting("application/config/version")
	return gd


## Returns the game's environment of a given index. No parameters gives default Environment.
func get_environment(index:int=0) -> EnvironmentData:
	return environments[index]


func to_json_string() -> String:
	var dict = {}
	dict["title"] = title
	dict["subject"] = subject
	dict["author"] = author
	dict["edamame_version"] = edamame_version
	dict["object_library"] = object_library.to_json_string()
	dict["player_init_data"] = player_init_data.to_json_string()
	dict["environments_size"] = environments.size()
	for i in environments.size():
		dict["environment"+str(i)] = environments[i].to_json_string()
	return JSON.stringify(dict)


static func from_json_string(json_string : String) -> GameData:
	var dict = JSON.parse_string(json_string)
	
	var gd = GameData.new()
	gd.title = dict["title"]
	gd.subject = dict["subject"]
	gd.author = dict["author"]
	gd.edamame_version = dict["edamame_version"]
	gd.object_library = ObjectLibrary.from_json_string( dict["object_library"] )
	gd.player_init_data = PlayerInitData.from_json_string( dict["player_init_data"] )
	
	var environments : Array[EnvironmentData] = []
	for i in int(dict["environments_size"]):
		environments.append(dict["environment"+str(i)])
	gd.environments = environments
	
	return gd


func save_game_file(path:String) -> void:
	var json_string = to_json_string()
	var packed_bytes = var_to_bytes(json_string)
	
	### TESTING COMPRESSION MODES ###
	## NOTE: I DID IT SO WRONG LAST TIME OOPS. IN MULTIPLE WAYS
	var modes = ["fastlz", "deflate", "zstd", "gzip", "brotli"]
	for i in 5:
		print(i)
		var start_time = Time.get_ticks_msec()
		var compressed_bytes = packed_bytes.compress(i)
		var out_string = compressed_bytes.hex_encode()
		var file = FileAccess.open("res://tests/testfile_"+modes[i]+".edamame", FileAccess.WRITE)
		file.store_string(out_string)
		file.close()
		print("time taken for " + modes[i] + ": " + str(Time.get_ticks_msec() - start_time))
	
	## Conclusion: zstd slowest but lowest file size. since our file sizes arent that big anyway. let's just go with it.
	
	
