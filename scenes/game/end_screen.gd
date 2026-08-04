class_name EndScreen
extends Control

const TO_MENU_PATH = "uid://bciwvccv01rmp"
const _SELF_SCENE = preload("uid://5qb028tk6h4w")


static func create() -> EndScreen:
	var e : EndScreen = _SELF_SCENE.instantiate()
	return e


func _on_back_button_pressed() -> void:
	#if there is no editor scene (i.e. if we are not in playtest mode), go to menu.
	if Editor.get_instance() == null:
		get_tree().change_scene_to_file(TO_MENU_PATH)
	#otherwise just close the playtest scene.
	else:
		Editor.get_instance().end_playtest()
