class_name Editor
extends Control

@export_category("Data")
@export var game_data : GameData
@export_category("Component Nodes")
@export var v_split_left_side : VSplitContainer
@export var objects_dock : HFlowContainer
@export var inspector_tab : InspectorTab
@export var game_viewport : SubViewport
@export var environment_graph : EnvironmentGraphEdit
@export var dragables_root : Control
@export var above_left_side : Control
@export var file_dialog : FileDialog
var environment : GameEnvironment
var scroll_offset : Vector2 = Vector2.ZERO
const _SELF_SCENE = preload("uid://be4ok444g1l0f")


static func make(_game_data:GameData) -> Editor:
	var e = _SELF_SCENE.instantiate()
	e.game_data = _game_data
	return e


func _ready() -> void:
	OS.set_low_processor_usage_mode(true) #this should be toggled when going into/outof playtest.
	
	update_objects_dock()
	
	environment = GameEnvironment.make(game_data.get_environment())
	game_viewport.add_child(environment)
	
	inspector_tab.edited.connect(_on_inspector_value_changed)
	
	environment_graph.update_boundaries( game_data.get_environment().get_used_rect() )
	
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


func _on_object_thumbnail_clicked(ot:ObjectThumbnail) -> void:
	inspector_tab.update_panel(ot.get_object())


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
	inspector_tab.update_panel(dgp.game_object.get_instance_data())


func _on_dragable_container_dragged(dgp:DragableGOParent) -> void:
	dgp.game_object.instance_data.position = get_mouse_pos_in_environment()
	inspector_tab.update_panel(dgp.game_object.get_instance_data())


func _on_dragable_container_released(dgp:DragableGOParent) -> void:
	if get_global_mouse_position().y > get_object_dock_top():
		remove_object(dgp)
	else:
		dgp.reparent(dragables_root)
		dgp.game_object.instance_data.position = get_mouse_pos_in_environment()
		inspector_tab.update_panel(dgp.game_object.get_instance_data())


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


## Called when the GraphEdit's offset is chaged either by using the minimap or scroll bars.
func _on_environment_graph_container_scroll_offset_changed(offset: Vector2) -> void:
	scroll_offset = offset
	if environment != null:
		environment.position = -offset
		dragables_root.position = environment.position
		# TODO: make zoom work
		#game_viewport.size_2d_override = game_viewport.size / environment_graph.zoom


func _on_save_button_pressed() -> void:
	file_dialog.popup_file_dialog()


func _on_file_dialog_file_selected(path: String) -> void:
	ResourceSaver.save(game_data, path)
