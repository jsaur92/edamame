class_name GameObject
extends Node2D

@export var object_data : ObjectData
@export var instance_data : ObjectInstanceData

func _ready() -> void:
	setup()


func setup() -> void:
	position = instance_data.position


func load_data(obj_inst : ObjectInstanceData) -> void:
	instance_data = obj_inst
	object_data = instance_data.object_data
