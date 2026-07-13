extends Popup

@export var line_edit_name : LineEdit
@export var line_edit_subject : LineEdit
@export var line_edit_author : LineEdit
signal create_game

func _on_confirm_button_pressed() -> void:
	var gd = GameData.create(line_edit_name.text, line_edit_subject.text, line_edit_author.text)
	create_game.emit(gd)
