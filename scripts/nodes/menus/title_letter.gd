@tool
extends TextureRect

@export var character : String:
	set(value):
		if value.length() > 1:
			value = value.substr(0,1)
		if character != value:
			character = value
			update_char()
@export_enum("Lawn Green", "Web Green") var color_name : String = "Lawn Green":
	set(value):
		if value != color_name:
			color_name = value
			update_color()
				
var color : Color
var hovered : bool = false
const TEXTURE_DIRECTORY_PATH = "res://assets/textures/menu/title/title_%s.png"
const SCALE_DELTA = 0.1
const SCALE_MIN = 1.
const SCALE_MAX = 1.5

func _ready() -> void:
	material = material.duplicate()
	update_char()
	update_color()


func _physics_process(delta: float) -> void:
	rotation_degrees = sin(Time.get_ticks_msec()/200.) * 5.
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


func update_char() -> void:
	var path = TEXTURE_DIRECTORY_PATH % character
	if ResourceLoader.exists(path):
		texture = load(path)
		pivot_offset = size/2
	else:
		texture = null


func update_color() -> void:
	match color_name:
		"Lawn Green":
			color = Color.LAWN_GREEN
		"Web Green":
			color = Color.WEB_GREEN
	material.set_shader_parameter("my_color", color)


func _on_mouse_entered() -> void:
	hovered = true
	z_index += 1


func _on_mouse_exited() -> void:
	hovered = false
	z_index -= 1
