class_name Player
extends CharacterBody2D
## Controller for the Player.

@export var inventory : Inventory
@export var sprite : AnimatedSprite2D
const SPEED = 600.0
var direction : Vector2
signal open_inventory
const _SELF_SCENE = preload("uid://dxlyubokb3s33")

static func make() -> Player:
	var p = _SELF_SCENE.instantiate()
	return p


func _ready() -> void:
	Game.get_game().interact_manager.set_player(self)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		open_inventory.emit(inventory)
	
	update_sprite()


func _physics_process(delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()


func update_sprite() -> void:
	if velocity.length() > 0:
		sprite.play("walk")
	else:
		sprite.play("default")
	
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true
