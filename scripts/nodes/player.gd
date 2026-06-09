class_name Player
extends CharacterBody2D
## Controller for the Player.

const SPEED = 300.0
var direction : Vector2

func _ready() -> void:
	GameGlobals.set_player(self)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		on_interact()
	if Input.is_action_just_pressed("inventory"):
		on_inventory()


func _physics_process(delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()


func on_interact():
	pass


func on_inventory():
	pass
