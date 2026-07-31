extends Control

@export var file_dialog : FileDialog
@export var filter : ColorRect
var game_data : GameData
const MAIN_MENU_SCENE_PATH : String = "uid://e7ed5bvjy3jm"

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
