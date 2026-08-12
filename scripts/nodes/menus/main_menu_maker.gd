extends Control

@export var file_dialog : FileDialog
@export var game_data_init : Popup
@export var filter : ColorRect
var game_data : GameData
const MAIN_MENU_SCENE_PATH : String = "uid://e7ed5bvjy3jm"

var file_access_web: FileAccessWeb = FileAccessWeb.new()

func _on_pick_file_button_pressed() -> void:
	if OS.get_name() == "Web":
		file_access_web.open(".res")
		file_access_web.loaded.connect(_on_file_loaded_web)
	else:
		file_dialog.popup_file_dialog()
		filter.visible = true


func _on_file_dialog_file_selected(path: String) -> void:
	if path.ends_with(".res") or path.ends_with(".tres"):
		game_data = load(path)
	elif path.ends_with(".edamame"):
		game_data = GameData.load_game_file_from_path(path)
	else:
		push_error("Attempted to load unsupported file type.")
	
	get_tree().change_scene_to_node( Editor.make(game_data) )


func _on_file_loaded_web(file_name: String, type: String, base64_data: String) -> void:
	var decoded = Marshalls.base64_to_variant(base64_data, true)
	print(decoded)
	#get_tree().change_scene_to_node( Editor.make(game_data) )
	#var raw_data: PackedByteArray = Marshalls.base64_to_raw(base64_data)
	

func _on_new_game_button_pressed() -> void:
	game_data_init.popup_centered()
	filter.visible = true


func _on_edit_button_pressed() -> void:
	get_tree().change_scene_to_node( Editor.make(game_data) )


func _on_game_data_initializer_create_game(gd:GameData) -> void:
	game_data = gd
	game_data_init.hide()
	get_tree().change_scene_to_node( Editor.make(game_data) )


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU_SCENE_PATH)


func _on_game_data_initializer_popup_hide() -> void:
	filter.visible = false


func _on_file_dialog_canceled() -> void:
	filter.visible = false


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file(MAIN_MENU_SCENE_PATH)
