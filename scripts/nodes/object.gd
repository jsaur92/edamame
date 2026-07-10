class_name GameObject
extends Node2D

@export var object_data : ObjectData
@export var instance_data : ObjectInstanceData
@export var sprite : Sprite2D
@export var collision_shape : CollisionShape2D
const _SELF_SCENE = preload("uid://6l5iyo5bci0o")

static func make(obj_inst : ObjectInstanceData) -> GameObject:
	var go : GameObject = _SELF_SCENE.instantiate()
	go.load_data(obj_inst)
	return go


func _ready() -> void:
	update_position()


func update_position() -> void:
	position = instance_data.position


func update_image() -> void:
	if object_data.has_image():
		sprite.texture = ImageTexture.create_from_image(object_data.get_scaled_image())


func load_data(obj_inst : ObjectInstanceData) -> void:
	instance_data = obj_inst
	object_data = instance_data.object_data
	if object_data.is_collidable():
		collision_shape.shape = object_data.get_mod(Enums.ObjectModType.COLLIDABLE).get_shape()
	collision_shape.disabled = not object_data.is_collidable()
	if object_data.is_interactable():
		add_child( Interactable.make(self) )
	update_image()


func update() -> void:
	update_position()
	update_image()


func get_interactable() -> Interactable:
	if object_data.is_interactable():
		return find_child("Interactable")
	return null


func get_object_data() -> ObjectData:
	return object_data


func get_instance_data() -> ObjectInstanceData:
	return instance_data
