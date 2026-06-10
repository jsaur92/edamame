class_name DialogUI
extends Control

@export var text : RichTextLabel
@export var answers_dock : VBoxContainer
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
	clear_answer_choices()
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
	make_answer_choices(command)

func give(command:CommandGive) -> void:
	display(true)
	text.text = "You got " + command.get_item().name + "!"

func take(command:CommandTake) -> void:
	display(true)
	text.text = "I request 1 " + command.get_item().name + "."

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and active and (CommandManager.current_node != null and (CommandManager.current_node.command is CommandSay or CommandManager.current_node.command is CommandGive)):
		confirm(0)


## Helper function for ask() that generates the buttons for choices.
func make_answer_choices(command:CommandAsk) -> void:
	var i = 0
	for choice in command.choices:
		var b = Button.new()
		b.text = choice
		b.connect("pressed", confirm.bind(i))
		answers_dock.add_child(b)
		i += 1


func clear_answer_choices() -> void:
	for child in answers_dock.get_children():
		child.queue_free()


func confirm(index:int) -> void:
	proceed.emit(index)
	if not (CommandManager.current_node != null):
		active = false
		hide()
