class_name Editor
extends Control

@export_category("Data")
@export var game_data : GameData
@export_category("Component Nodes")
@export var v_split_root : VSplitContainer
@export var h_split : HSplitContainer
@export var v_split_left_side : VSplitContainer
@export var odpanel : Panel
@export var objects_dock : HFlowContainer
@export var inspector_tabs_container  : TabContainer
@export var details_tab : InspectorTab
@export var obstacle_tab : ObstacleTab
@export var interactive_tab : InteractableTab
@export var game_viewport : SubViewport
@export var environment_graph : EnvironmentGraphEdit
@export var dragables_root : Control
@export var above_left_side : Control
@export var file_dialog : FileDialog
@export var line_edit_title : LineEdit
@export var line_edit_author : LineEdit
@export var line_edit_subject : LineEdit
@export var playtest_vp_container : SubViewportContainer
@export var playtest_vp : SubViewport
var environment : GameEnvironment
var scroll_offset : Vector2 = Vector2.ZERO
var min_inspector_size : float = 320
var exit_on_save : bool = false
static var instance : Editor
const _SELF_SCENE = preload("uid://be4ok444g1l0f")
const _MAIN_MENU_SCENE = preload("uid://ouacseb7xvgj")


static func make(_game_data:GameData) -> Editor:
	var e = _SELF_SCENE.instantiate()
	e.game_data = _game_data
	instance = e
	return e


func _ready() -> void:
	OS.set_low_processor_usage_mode(true) #this should be toggled when going into/outof playtest.
	
	update_objects_dock()
	update_inspector_tabs()
	update_header_text()
	
	environment = GameEnvironment.make(game_data.get_environment())
	environment.toggle_camera(false)
	game_viewport.add_child(environment)
	
	details_tab.edited.connect(_on_inspector_value_changed)
	
	environment_graph.update_boundaries( game_data.get_environment().get_used_rect() )
	environment_graph.toggle_tile.connect(_on_tile_toggled)
	
	#wrap all objects from environment in DragableParents.
	for object in environment.get_objects():
		var dgp = DragableParent.make(object)
		add_dragable(dgp)
		dragables_root.add_child(dgp)
	
	#make the player object and wrap it in a DGP
	var p = Player.make(game_data.player_init_data)
	var dgp = DragableParent.make(p)
	dgp.position = p.init_data.init_pos
	add_dragable(dgp)
	dragables_root.add_child(dgp)


static func get_instance() -> Editor:
	return instance


func update_objects_dock() -> void:
	for child in objects_dock.get_children():
		child.queue_free()
	for object in game_data.object_library.get_objects():
		var ot = ObjectThumbnail.create_from_object_data(object)
		objects_dock.add_child(ot)
		ot.clicked.connect(_on_object_thumbnail_clicked)
		ot.drag_start.connect(_on_object_thumbnail_dragged)
	#put in the 'add' button
	var b = Button.new()
	b.text = "Add Object"
	b.custom_minimum_size = Vector2(80, 80)
	b.pressed.connect(_on_add_object_button_pressed)
	objects_dock.add_child(b)


func add_dragable(dgp:DragableParent) -> void:
	dgp.clicked.connect(_on_dragable_container_clicked.bind(dgp))
	dgp.released.connect(_on_dragable_container_released.bind(dgp))
	dgp.dragged.connect(_on_dragable_container_dragged.bind(dgp))


func get_object_dock_top() -> float:
	return v_split_left_side.position.y + v_split_left_side.split_offsets[0]


## Completely remove a GameObject and its DGP from the editor view and its data from the
## Environment data (if applicable)
func remove_object(dgp:DragableParent) -> void:
	environment.environment_data.remove_object( dgp.get_game_object().get_instance_data() )
	dgp.queue_free()


func get_mouse_pos_in_environment() -> Vector2:
	return (environment.get_mouse_pos_in_environment())


func update_inspector_tabs() -> void:
	var obstacle_tab_index = inspector_tabs_container.get_tab_idx_from_control(obstacle_tab)
	var interactive_tab_index = inspector_tabs_container.get_tab_idx_from_control(interactive_tab)
	inspector_tabs_container.set_tab_hidden(obstacle_tab_index, details_tab.current_object_data == null or not details_tab.current_object_data.is_collidable())
	inspector_tabs_container.set_tab_hidden(interactive_tab_index, details_tab.current_object_data == null or not details_tab.current_object_data.is_interactable())


func fit_within_bounds(dgp:DragableParent) -> void:
	var bounds = environment.environment_data.get_used_rect()
	dgp.position.x = min( max(dgp.position.x, bounds.position.x) , bounds.position.x + bounds.size.x )
	dgp.position.y = min( max(dgp.position.y, bounds.position.y) , bounds.position.y + bounds.size.y )


func _on_object_thumbnail_clicked(ot:ObjectThumbnail) -> void:
	details_tab.update_panel(ot.get_object())
	if details_tab.current_object_data.is_interactable():
		interactive_tab.open_tab(details_tab.current_object_data)
	if details_tab.current_object_data.is_collidable():
		obstacle_tab.open_tab(details_tab.current_object_data)


func _on_object_thumbnail_dragged(ot:ObjectThumbnail) -> void:
	var o = ObjectInstanceData.new()
	o.setup(ot.get_object())
	var go = environment.add_object(o)
	
	var dgp = DragableParent.make(go, true)
	add_dragable(dgp)
	_on_dragable_container_clicked(dgp)
	if dgp.get_parent() == null:
		above_left_side.add_child( dgp )
	
	#correct for graph edit scale stuff
	go.scale = Vector2(1,1)
	go.position = dgp.size/2


func _on_dragable_container_clicked(dgp:DragableParent) -> void:
	if dgp.get_parent() != null:
		dgp.reparent(above_left_side)
	else:
		above_left_side.add_child(dgp)
	
	if dgp.has_game_object():
		dgp.get_game_object().instance_data.position = get_mouse_pos_in_environment()
		details_tab.update_panel(dgp.get_game_object().get_instance_data())
		interactive_tab.open_tab(details_tab.current_object_data)
	elif dgp.has_player():
		dgp.get_player().get_init_data().init_pos = get_mouse_pos_in_environment()
		details_tab.update_panel(dgp.get_player().get_init_data())


func _on_dragable_container_dragged(dgp:DragableParent) -> void:
	if dgp.has_game_object():
		dgp.get_game_object().get_instance_data().position = get_mouse_pos_in_environment()
		details_tab.update_panel(dgp.get_game_object().get_instance_data())
	elif dgp.has_player():
		dgp.get_player().get_init_data().init_pos = get_mouse_pos_in_environment()
		details_tab.update_panel(dgp.get_player().get_init_data())


func _on_dragable_container_released(dgp:DragableParent) -> void:
	if dgp.has_game_object():
		if get_global_mouse_position().y > get_object_dock_top():
			remove_object(dgp)
		else:
			dgp.reparent(dragables_root)
			dgp.get_game_object().instance_data.position = dgp.position + dgp.size/2
			details_tab.update_panel(dgp.get_game_object().get_instance_data())
	else:
		dgp.reparent(dragables_root)
		fit_within_bounds(dgp)


## object can be of type ObjectData or ObjectInstanceData.
func _on_inspector_value_changed(object:Variant) -> void:
	#for updating object data, find every instance of an object and update them.
	if object is ObjectData:
		for dragable:DragableParent in dragables_root.get_children():
			if dragable.has_game_object():
				if dragable.get_game_object().get_object_data() == object:
					dragable.get_game_object().update_image()
		for child in objects_dock.get_children():
			if child is ObjectThumbnail:
				if child.object_data == object:
					child.set_object(object)
	
	#for updating instance data, find the instance and update it.
	elif object is ObjectInstanceData:
		for dragable:DragableParent in dragables_root.get_children():
			if dragable.has_game_object() and dragable.get_game_object().get_instance_data() == object:
				dragable.update_position()
				break
	
	elif object is PlayerInitData:
		for dragable:DragableParent in dragables_root.get_children():
			if dragable.has_player():
				dragable.update_position()
				break
	
	
	update_inspector_tabs()


## Called when the GraphEdit's offset is chaged either by using the minimap or scroll bars.
func _on_environment_graph_container_scroll_offset_changed(offset: Vector2) -> void:
	scroll_offset = offset
	if environment != null:
		environment.position = -offset
		dragables_root.position = environment.position
		var zoom_vec = Vector2(environment_graph.zoom, environment_graph.zoom)
		environment.scale = zoom_vec
		dragables_root.scale = zoom_vec
		above_left_side.global_position = environment.global_position + environment_graph.global_position
		above_left_side.scale = zoom_vec
		environment.graph_zoom = zoom_vec


func _on_save_button_pressed() -> void:
	file_dialog.popup_file_dialog()
	exit_on_save = false


func _on_save_exit_button_pressed() -> void:
	file_dialog.popup_file_dialog()
	exit_on_save = true


func _on_file_dialog_file_selected(path: String) -> void:
	ResourceSaver.save(game_data, path)
	if exit_on_save:
		close_editor()
		get_tree().change_scene_to_packed(_MAIN_MENU_SCENE)


func _on_tile_toggled(tile_pos:Vector2i, source:int, erase:bool=false) -> void:
	environment.toggle_tile_at(tile_pos, source, erase)
	environment_graph.update_boundaries(game_data.get_environment().get_used_rect())


## When the Inspector tab changes, change the min/max boundaries on the HSplitContainer.
func _on_inspector_tab_changed(tab: int) -> void:
	var already_min = h_split.split_offsets[0] == get_viewport().get_visible_rect().size.x - min_inspector_size
	match tab:
		#properties tab
		0:
			min_inspector_size = 320
		#collision tab
		1:
			min_inspector_size = 320
			obstacle_tab.open_tab(details_tab.current_object_data)
		#interact tab
		2:
			min_inspector_size = 1500
			interactive_tab.open_tab(details_tab.current_object_data)
	if already_min:
		h_split.split_offsets[0] = get_viewport().get_visible_rect().size.x - min_inspector_size
	check_h_split_offset()


func _on_h_split_container_dragged(offset: int) -> void:
	check_h_split_offset()


func check_h_split_offset() -> void:
	if h_split.split_offsets[0] > get_viewport().get_visible_rect().size.x - min_inspector_size:
		h_split.split_offsets[0] = get_viewport().get_visible_rect().size.x - min_inspector_size


func _on_v_split_container_dragged(offset: int) -> void:
	above_left_side.position.y = offset


func _on_interactable_tab_save_node_tree(mod_int:ModInteractable) -> void:
	details_tab.current_object_data.set_interactable(mod_int)


func _on_add_object_button_pressed() -> void:
	ObjectLibrary.get_current_library().add_object(ObjectData.create())
	update_objects_dock()


func _on_line_edit_title_text_changed(new_text: String) -> void:
	game_data.title = new_text


func _on_line_edit_author_text_changed(new_text: String) -> void:
	game_data.author = new_text


func _on_line_edit_subject_text_changed(new_text: String) -> void:
	game_data.subject = new_text


func update_header_text() -> void:
	line_edit_title.text = game_data.title
	line_edit_author.text = game_data.author
	line_edit_subject.text = game_data.subject


func _on_environment_graph_container_switch_modes() -> void:
	odpanel.visible = not odpanel.visible


func _on_playtest_button_pressed() -> void:
	start_playtest()


func start_playtest() -> void:
	playtest_vp_container.visible = true
	playtest_vp.add_child( Game.make(game_data) )


func end_playtest() -> void:
	playtest_vp_container.visible = false
	playtest_vp.get_child(0).queue_free()


func close_editor() -> void:
	instance = null
