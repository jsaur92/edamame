extends Control

const EDITOR_SCENE = preload("res://scenes/ui/editor.tscn")

func _on_edit_button_pressed() -> void:
	get_tree().change_scene_to_packed(EDITOR_SCENE)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
