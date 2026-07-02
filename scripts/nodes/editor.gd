class_name Editor
extends Control

@export_category("Data")
@export var game_data : GameData
@export_category("Component Nodes")
@export var h_split : HSplitContainer
@export var v_split_left_side : VSplitContainer
@export var objects_dock : HFlowContainer
@export var inspector_tabs_container  : TabContainer
@export var details_tab : InspectorTab
@export var obstacle_tab : Control
@export var interactive_tab : InteractableTab
@export var game_viewport : SubViewport
@export var environment_graph : EnvironmentGraphEdit
@export var dragables_root : Control
@export var above_left_side : Control
@export var file_dialog : FileDialog
var environment : GameEnvironment
var scroll_offset : Vector2 = Vector2.ZERO
var min_inspector_size : float = 320
const _SELF_SCENE = preload("uid://be4ok444g1l0f")


static func make(_game_data:GameData) -> Editor:
	var e = _SELF_SCENE.instantiate()
	e.game_data = _game_data
	return e


func _ready() -> void:
	OS.set_low_processor_usage_mode(true) #this should be toggled when going into/outof playtest.
	
	update_objects_dock()
	update_inspector_tabs()
	
	environment = GameEnvironment.make(game_data.get_environment())
	game_viewport.add_child(environment)
	
	details_tab.edited.connect(_on_inspector_value_changed)
	
	environment_graph.update_boundaries( game_data.get_environment().get_used_rect() )
	environment_graph.toggle_tile.connect(_on_tile_toggled)
	
	#wrap all objects from environment in DragableGOParents.
	for object in environment.get_objects():
		var dgp = DragableGOParent.make(object)
		add_dragable(dgp)
		dragables_root.add_child(dgp)


func update_objects_dock() -> void:
	for child in objects_dock.get_children():
		child.queue_free()
	for object in game_data.object_library.get_objects():
		var ot = ObjectThumbnail.create_from_object_data(object)
		objects_dock.add_child(ot)
		ot.clicked.connect(_on_object_thumbnail_clicked)
		ot.make_obj_inst.connect(_on_object_thumbnail_dragged)


func add_dragable(dgp:DragableGOParent) -> void:
	dgp.clicked.connect(_on_dragable_container_clicked.bind(dgp))
	dgp.released.connect(_on_dragable_container_released.bind(dgp))
	dgp.dragged.connect(_on_dragable_container_dragged.bind(dgp))


func get_object_dock_top() -> float:
	return v_split_left_side.position.y + v_split_left_side.split_offsets[1]


## Completely remove a GameObject and its DGP from the editor view and its data from the
## Environment data (if applicable)
func remove_object(dgp:DragableGOParent) -> void:
	environment.environment_data.remove_object( dgp.game_object.get_instance_data() )
	dgp.queue_free()


func get_mouse_pos_in_environment() -> Vector2:
	return environment.get_mouse_pos_in_environment() - Vector2(0, v_split_left_side.split_offsets[0])


func update_inspector_tabs() -> void:
	var obstacle_tab_index = inspector_tabs_container.get_tab_idx_from_control(obstacle_tab)
	var interactive_tab_index = inspector_tabs_container.get_tab_idx_from_control(interactive_tab)
	inspector_tabs_container.set_tab_hidden(obstacle_tab_index, details_tab.current_object_data == null or not details_tab.current_object_data.is_collidable())
	inspector_tabs_container.set_tab_hidden(interactive_tab_index, details_tab.current_object_data == null or not details_tab.current_object_data.is_interactable())


func _on_object_thumbnail_clicked(ot:ObjectThumbnail) -> void:
	details_tab.update_panel(ot.get_object())


func _on_object_thumbnail_dragged(ot:ObjectThumbnail) -> void:
	var o = ObjectInstanceData.new()
	o.setup(ot.get_object())
	var go = environment.add_object(o)
	
	var dgp = DragableGOParent.make(go, true)
	add_dragable(dgp)
	_on_dragable_container_clicked(dgp)
	above_left_side.add_child( dgp )


func _on_dragable_container_clicked(dgp:DragableGOParent) -> void:
	if dgp.get_parent() != null:
		dgp.reparent(above_left_side)
	else:
		above_left_side.add_child(dgp)
	dgp.game_object.instance_data.position = get_mouse_pos_in_environment()
	details_tab.update_panel(dgp.game_object.get_instance_data())


func _on_dragable_container_dragged(dgp:DragableGOParent) -> void:
	dgp.game_object.instance_data.position = get_mouse_pos_in_environment()
	details_tab.update_panel(dgp.game_object.get_instance_data())


func _on_dragable_container_released(dgp:DragableGOParent) -> void:
	if get_global_mouse_position().y > get_object_dock_top():
		remove_object(dgp)
	else:
		dgp.reparent(dragables_root)
		dgp.game_object.instance_data.position = get_mouse_pos_in_environment()
		details_tab.update_panel(dgp.game_object.get_instance_data())


## object can be of type ObjectData or ObjectInstanceData.
func _on_inspector_value_changed(object:Variant) -> void:
	#for updating object data, find every instance of an object and update them.
	if object is ObjectData:
		for dragable:DragableGOParent in dragables_root.get_children():
			if dragable.game_object.get_object_data() == object:
				dragable.update()
	
	#for updating instance data, find the instance and update it.
	elif object is ObjectInstanceData:
		for dragable:DragableGOParent in dragables_root.get_children():
			if dragable.game_object.get_instance_data() == object:
				dragable.update()
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


func _on_save_button_pressed() -> void:
	file_dialog.popup_file_dialog()


func _on_file_dialog_file_selected(path: String) -> void:
	ResourceSaver.save(game_data, path)


func _on_tile_toggled(tile_pos:Vector2i) -> void:
	environment.toggle_tile_at(tile_pos)
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
		#interact tab
		2:
			min_inspector_size = 1020
			interactive_tab.load_data(details_tab.current_object_data.get_mod(Enums.ObjectModType.INTERACTABLE))
	if already_min:
		h_split.split_offsets[0] = get_viewport().get_visible_rect().size.x - min_inspector_size
	check_h_split_offset()


func _on_h_split_container_dragged(offset: int) -> void:
	check_h_split_offset()


func check_h_split_offset() -> void:
	if h_split.split_offsets[0] > get_viewport().get_visible_rect().size.x - min_inspector_size:
		h_split.split_offsets[0] = get_viewport().get_visible_rect().size.x - min_inspector_size
