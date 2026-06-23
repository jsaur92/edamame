extends Control

@export_category("Data")
@export var game_data : GameData
@export_category("Component Nodes")
@export var objects_dock : HFlowContainer
@export var inspector_tab : InspectorTab
@export var game_viewport : SubViewport
@export var environment_graph : GraphEdit
@export var dragables_root : Control
@export var above_left_side : Control
var environment : GameEnvironment
var scroll_offset : Vector2 = Vector2.ZERO

## Sets game_data. Call after instantiation and before adding as child of scene.
func setup(_game_data:GameData):
	game_data = _game_data


func _ready() -> void:
	OS.set_low_processor_usage_mode(true) #this should be toggled when going into/outof playtest.
	
	update_objects_dock()
	
	environment = ConstScenes.ENVIRONMENT.instantiate()
	game_viewport.add_child(environment)
	environment.setup(game_data.get_environment())
	
	inspector_tab.edited.connect(_on_inspector_value_changed)
	
	#wrap all objects from environment in DragableContainers.
	for object in environment.get_objects():
		var dc = DragableContainer.setup(object)
		add_dragable(dc)


func update_objects_dock() -> void:
	for child in objects_dock.get_children():
		child.queue_free()
	for object in game_data.object_library.get_objects():
		var ot = ObjectThumbnail.create_from_object_data(object)
		objects_dock.add_child(ot)
		ot.clicked.connect(_on_object_thumbnail_clicked)
		ot.make_obj_inst.connect(_on_object_thumbnail_dragged)


func add_dragable(dc:DragableContainer) -> void:
	dragables_root.add_child(dc)
	dc.clicked.connect(_on_dragable_container_clicked)
	dc.changed.connect(_on_dragable_container_moved)


func _on_object_thumbnail_clicked(ot:ObjectThumbnail) -> void:
	inspector_tab.update_panel(ot.get_object())


func _on_object_thumbnail_dragged(ot:ObjectThumbnail) -> void:
	var o = ObjectInstanceData.new()
	o.setup(ot.get_object())
	var go = GameObject.setup(o)
	above_left_side.add_child( DragableControlParent.make(go, true) )


func _on_dragable_container_clicked(dc:DragableContainer) -> void:
	inspector_tab.update_panel(dc.get_object_instance())


func _on_dragable_container_moved(dc:DragableContainer) -> void:
	inspector_tab.update_panel(dc.get_object_instance())


## object can be of type ObjectData or ObjectInstanceData.
func _on_inspector_value_changed(object:Variant) -> void:
	#for updating object data, find every instance of an object and update them.
	if object is ObjectData:
		for dragable:DragableContainer in dragables_root.get_children():
			if dragable.contained.get_object_data() == object:
				dragable.update()
	
	#for updating instance data, find the instance and update it.
	elif object is ObjectInstanceData:
		for dragable:DragableContainer in dragables_root.get_children():
			if dragable.contained.get_instance_data() == object:
				dragable.update()
				break


## Called when the GraphEdit's offset is chaged either by using the minimap or scroll bars.
func _on_environment_graph_container_scroll_offset_changed(offset: Vector2) -> void:
	scroll_offset = offset
	if environment != null:
		environment.position = -offset
		# TODO: make zoom work
		#game_viewport.size_2d_override = game_viewport.size / environment_graph.zoom
