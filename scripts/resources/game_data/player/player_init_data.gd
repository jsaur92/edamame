class_name PlayerInitData
extends Resource

@export var init_pos : Vector2 = Vector2.ZERO


func set_pos_x(x:int) -> void:
	init_pos.x = x


func set_pos_y(y:int) -> void:
	init_pos.y = y


func to_json_string() -> String:
	var dict = {}
	dict["init_pos.x"] = init_pos.x
	dict["init_pos.y"] = init_pos.y
	return JSON.stringify(dict)


static func from_json_string(json_string : String) -> PlayerInitData:
	var dict = JSON.parse_string(json_string)
	var pid = PlayerInitData.new()
	pid.init_pos.x = dict["init_pos.x"]
	pid.init_pos.y = dict["init_pos.y"]
	return pid
