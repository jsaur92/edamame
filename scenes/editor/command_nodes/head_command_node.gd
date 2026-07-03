class_name HeadCommandGraphNode
extends BaseCommandGraphNode

@export var interact_condition : String = "default"
const _SELF_SCENE = preload("uid://dn67hwpkg7v5s")

static func make() -> HeadCommandGraphNode:
	var cgn = _SELF_SCENE.instantiate()
	return cgn


func update_data() -> void:
	pass


func get_interact_condition() -> String:
	return interact_condition
