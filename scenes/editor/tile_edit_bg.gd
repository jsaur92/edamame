class_name TileEditBG
extends Control

@export var tile_selector : OptionButton
var items_dict : Dictionary[int, int] #match option index with source tile index (not always the same).

func _ready() -> void:
	update_tile_options()


func update_tile_options() -> void:
	for i in tile_selector.item_count:
		tile_selector.get_popup().remove_item(i)
	items_dict.clear()
	
	var tileset = Editor.get_instance().game_data.get_environment().terrain.tileset
	for i in tileset.get_source_count():
		add_tile_option(tileset.get_source(tileset.get_source_id(i)).get_runtime_texture())
		items_dict[i] = tileset.get_source_id(i)


func add_tile_option(texture:Texture2D) -> void:
	tile_selector.get_popup().add_item("")
	tile_selector.get_popup().set_item_icon(tile_selector.item_count-1, texture) 


func get_current_tile_source_id() -> int:
	return items_dict[tile_selector.selected]
