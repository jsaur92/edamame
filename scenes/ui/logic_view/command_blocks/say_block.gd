extends CommandBlock

@export var textedit : TextEdit
var base_height
const HEIGHT_PER_LINE = 42

func _ready() -> void:
	z_index = 0
	base_height = size.y - textedit.size.y


func _on_text_edit_resized() -> void:
	size.y = textedit.size.y
