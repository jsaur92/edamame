extends Control

@export_category("Data")
@export var game_data : GameData
@export_category("Component Nodes")
@export var objects_dock : HFlowContainer
@export var inspector_tab : InspectorTab
@export var game_viewport : SubViewport
@export var environment_graph : GraphEdit
@export var draggables_root : Control
var environment : GameEnvironment

## Sets game_data. Call after instantiation and before adding as child of scene.
func setup(_game_data:GameData):
	game_data = _game_data


func _ready() -> void:
	OS.set_low_processor_usage_mode(true) #this should be toggled when going into/outof playtest.
	
	update_objects_dock()
	
	environment = ConstScenes.ENVIRONMENT.instantiate()
	game_viewport.add_child(environment)
	environment.setup(game_data.get_environment())
	
	#wrap all objects in DragableContainers.
	for object in environment.get_objects():
		draggables_root.add_child(DragableContainer.setup(object))


func update_objects_dock() -> void:
	for child in objects_dock.get_children():
		child.queue_free()
	for object in game_data.object_library.get_objects():
		var ot = ObjectThumbnail.create_from_object_data(object)
		objects_dock.add_child(ot)
		ot.clicked.connect(_on_object_thumbnail_clicked)


func _on_object_thumbnail_clicked(ot:ObjectThumbnail) -> void:
	inspector_tab.update_panel(ot.get_object())


## Called when the GraphEdit's offset is chaged either by using the minimap or scroll bars.
func _on_environment_graph_container_scroll_offset_changed(offset: Vector2) -> void:
	if environment != null:
		environment.position = -offset
		# TODO: make zoom work
		#game_viewport.size_2d_override = game_viewport.size / environment_graph.zoom
