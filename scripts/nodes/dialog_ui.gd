class_name DialogUI
extends Control

@export var text : RichTextLabel
## True when the UI is on screen. Small buffer between it popping up and active
## becoming true so that the "interact" input doesn't open and close at the
## same time. Also can accomodate an "opening" animation if applicable.
var active : bool = false
signal proceed
const OPEN_DELAY = 0.1
const CLOSE_DELAY = 0.0

func _ready() -> void:
	CommandManager.set_dialog_ui(self)
	connect("proceed", CommandManager.execute_next)


func display(on:bool) -> void:
	visible = on
	if on:
		await get_tree().create_timer(OPEN_DELAY).timeout
		active = on

func say(command:CommandSay) -> void:
	display(true)
	text.text = command.dialog

func ask(command:CommandAsk) -> void:
	display(true)
	text.text = command.dialog

func give(command:CommandGive) -> void:
	display(true)
	text.text = "You got " + command.get_item().name + "!"

func take(command:CommandTake) -> void:
	display(true)
	text.text = "I request 1 " + command.get_item().name + "."

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and active:
		proceed.emit(0) #for non-asking
		if not (CommandManager.current_node != null and CommandManager.current_node.command.has_dialog()):
			active = false
			hide()
