extends Control

@export var file_dialog : FileDialog
@export var welcome_popup : Control
var game_data : GameData
const MAKE_MENU_SCENE_PATH : String = "uid://ouacseb7xvgj"
const PLAY_MENU_SCENE_PATH : String = "uid://bciwvccv01rmp"
## True if this is the first time the player has enterred the main menu this session.
static var first_time_enterred : bool = true


func _ready() -> void:
	if first_time_enterred and OS.get_name() == "Web":
		welcome_popup.visible = true
	else:
		welcome_popup.visible = false
	first_time_enterred = false


func _on_pick_file_button_pressed() -> void:
	file_dialog.popup_file_dialog()


func _on_file_dialog_file_selected(path: String) -> void:
	game_data = load(path)


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file(PLAY_MENU_SCENE_PATH)


func _on_make_button_pressed() -> void:
	get_tree().change_scene_to_file(MAKE_MENU_SCENE_PATH)


func _on_continue_button_pressed() -> void:
	welcome_popup.visible = false
	
