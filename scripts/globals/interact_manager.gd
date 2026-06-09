extends Node

## Reference to the Player scene.
var player : Player
## All Interactables within range of the Player. Would work best as a minheap.
var inters_within_range : Array[Interactable] = []
var prev_closest : Interactable

func _process(delta: float) -> void:
	heapify()

## Add an Interactable to the iwr heap and keep the min-heap condition.
func add_near(inter:Interactable) -> void:
	
	var old_closest = get_closest()
	
	inters_within_range.append(inter)
	var i : int = inters_within_range.size()-1
	while i > 0 and dist_sq_to_player(i) < dist_sq_to_player((i-1)/2):
		swap_inters_at(i, (i-1)/2)
		i = (i-1)/2
	
	if old_closest != get_closest():
		get_closest().set_in_range(true)
		if old_closest != null:
			old_closest.set_in_range(false)

## Remove an Interactable to the iwr heap and keep the min-heap condition.
func remove_near(inter:Interactable) -> void:
	if not inters_within_range.is_empty():
		
		var old_closest = get_closest()
		
		var i = inters_within_range.find(inter)
		swap_inters_at(i, inters_within_range.size()-1)
		inters_within_range.remove_at(inters_within_range.size()-1)
		inter.set_in_range(false)
		
		heapify_down_at(i)
		
		if not inters_within_range.is_empty() and old_closest != get_closest():
			old_closest.set_in_range(false)
			get_closest().set_in_range(true)


func heapify():
	prev_closest = get_closest()
	var i : int = (inters_within_range.size()/2)-1
	while i >= 0:
		heapify_down_at(i)
		i -= 1
	if prev_closest != get_closest():
		get_closest().set_in_range(true)
		if prev_closest != null:
			prev_closest.set_in_range(false)


func heapify_down_at(i:int):
	while i < inters_within_range.size()/2:
		var closest_child = i*2 + 1
		if i*2 + 2 < inters_within_range.size() and dist_sq_to_player(i*2 + 2) < dist_sq_to_player(closest_child):
			closest_child = i*2 + 2
		
		if dist_sq_to_player(i) > dist_sq_to_player(closest_child):
			swap_inters_at(i, closest_child)
		else:
			break
		
		i = closest_child


func swap_inters_at(i:int, j:int):
	var temp = inters_within_range[i]
	inters_within_range[i] = inters_within_range[j]
	inters_within_range[j] = temp


func get_closest() -> Interactable:
	if inters_within_range.is_empty():
		return null
	else:
		return inters_within_range[0]

func set_player(p:Player) -> void:
	player = p

func dist_sq_to_player(index:int):
	return player.global_position.distance_squared_to(inters_within_range[index].global_position)
