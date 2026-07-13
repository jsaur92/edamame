extends Control

@export var edit_button : Button
@export var file_dialog : FileDialog
@export var game_text : RichTextLabel
@export var game_data_init : Popup
var game_data : GameData


func _on_pick_file_button_pressed() -> void:
	file_dialog.popup_file_dialog()


func _on_file_dialog_file_selected(path: String) -> void:
	game_data = load(path)
	set_game_text()
	enable_buttons()


func _on_new_game_button_pressed() -> void:
	game_data_init.popup_centered()


func set_game_text() -> void:
	game_text.text = game_data.title + " by " + game_data.author


func enable_buttons(enable:bool=true) -> void:
	edit_button.disabled = not enable


func _on_edit_button_pressed() -> void:
	get_tree().change_scene_to_node( Editor.make(game_data) )


func _on_game_data_initializer_create_game(gd:GameData) -> void:
	game_data = gd
	set_game_text()
	enable_buttons()
	game_data_init.hide()
