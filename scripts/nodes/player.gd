class_name Player
extends CharacterBody2D
## Controller for the Player.

@export var inventory : Inventory
@export var camera : Camera2D
const SPEED = 300.0
var direction : Vector2
signal open_inventory

func _ready() -> void:
	Game.get_game().interact_manager.set_player(self)
	camera.enabled = true


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		open_inventory.emit(inventory)


func _physics_process(delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
