extends Control

@export var file_dialog : FileDialog
@export var filter : ColorRect
var game_data : GameData
const MAIN_MENU_SCENE_PATH : String = "uid://e7ed5bvjy3jm"
const PLAYER_MATERIAL : Material = preload("uid://c71d04dx7bdxl")

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU_SCENE_PATH)


func _on_pick_file_button_2_pressed() -> void:
	file_dialog.popup_file_dialog()
	filter.visible = true


func _on_file_dialog_file_selected(path: String) -> void:
	game_data = load(path)
	get_tree().change_scene_to_node( Game.make(game_data) )


func _on_file_dialog_canceled() -> void:
	filter.visible = false


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file(MAIN_MENU_SCENE_PATH)


func _on_option_button_item_selected(index: int) -> void:
	var color : Color
	match index:
		0:
			color = Color(1,0,0)
		1:
			color = Color(1,0.5,0)
		2:
			color = Color(1,1,0)
		3:
			color = Color(0,1,0)
		4:
			color = Color(0,1,1)
		5:
			color = Color(0,0,1)
		6:
			color = Color(0.5,0,1)
		7:
			color = Color(1,0,1)
		8:
			color = Color(1,0.5,1)
		9:
			color = Color(0.5,0.25,0)
		10:
			color = Color(1,1,1)
	PLAYER_MATERIAL.set_shader_parameter("my_color", color)
