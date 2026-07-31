extends TextureRect

var hovered : bool = false
const SCALE_DELTA = 0.05
const SCALE_MIN = 1.
const SCALE_MAX = 1.2
var time_on_start = 0

func _ready() -> void:
	pivot_offset = size/2
	mouse_entered.connect(_on_mouse_enter)
	mouse_exited.connect(_on_mouse_exit)
	time_on_start = Time.get_ticks_msec()

func _physics_process(delta: float) -> void:
	rotation_degrees = sin((Time.get_ticks_msec() - time_on_start)/200.) * 5.
	if hovered:
		if scale.x < SCALE_MAX:
			scale += Vector2(SCALE_DELTA, SCALE_DELTA)
		else:
			scale = Vector2(SCALE_MAX, SCALE_MAX)
	else:
		if scale.x > SCALE_MIN:
			scale -= Vector2(SCALE_DELTA, SCALE_DELTA)
		else:
			scale = Vector2(SCALE_MIN, SCALE_MIN)

func _on_mouse_enter() -> void:
	hovered = true
	z_index += 1


func _on_mouse_exit() -> void:
	hovered = false
	z_index -= 1
