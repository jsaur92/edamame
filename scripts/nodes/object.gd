class_name GameObject
extends Node2D

@export var object_data : ObjectData
@export var instance_data : ObjectInstanceData
@export var collision_shape : CollisionShape2D

func _ready() -> void:
	setup_position()


func setup_position() -> void:
	position = instance_data.position


func load_data(obj_inst : ObjectInstanceData) -> void:
	instance_data = obj_inst
	object_data = instance_data.object_data
	if object_data.is_collidable():
		collision_shape.shape = object_data.get_mod(Enums.ObjectModType.COLLIDABLE).get_shape()
	collision_shape.disabled = not object_data.is_collidable()
	if object_data.is_interactable():
		add_child(ConstScenes.INTERACTABLE.instantiate())
