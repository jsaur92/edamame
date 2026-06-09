class_name GameGlobals

## Reference to the Player scene.
static var player : Player
## The current in-range interactable. Null if no objects in range.
static var current_interactable_in_range : Interactable = null


## Checks to see if a given interactable is closer to the Player than the
## currently "interactable" interactable, and sets the closer one to current.
static func try_in_range_interactable(inter:Interactable) -> bool:
	# If there is no one currently in range, success.
	if not is_player_within_range_of_interactable():
		set_in_range_interactable(inter)
		return true
	# Otherwise, check to see if this one is closer to the current one.
	elif player.global_position.distance_squared_to(inter.global_position) > player.global_position.distance_squared_to(current_interactable_in_range.global_position):
		set_in_range_interactable(inter)
		return true
	return false


static func try_remove_in_range_interactable(inter:Interactable) -> bool:
	if current_interactable_in_range == inter:
		remove_in_range_interactable()
		return true
	return false


static func set_in_range_interactable(inter:Interactable) -> void:
	if current_interactable_in_range != null:
		current_interactable_in_range.remove_in_range()
	current_interactable_in_range = inter


static func remove_in_range_interactable() -> void:
	current_interactable_in_range = null


static func is_player_within_range_of_interactable() -> bool:
	return current_interactable_in_range != null


static func set_player(p:Player) -> void:
	player = p
