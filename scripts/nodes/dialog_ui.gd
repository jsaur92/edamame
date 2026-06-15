class_name DialogUI
extends Control

@export var text : RichTextLabel
@export var answers_dock : VBoxContainer
var current_node
## True when the UI is on screen. Small buffer between it popping up and active
## becoming true so that the "interact" input doesn't open and close at the
## same time. Also can accomodate an "opening" animation if applicable.
var active : bool = false
signal proceed
signal give_item
signal take_item
const OPEN_DELAY = 0.1
const CLOSE_DELAY = 0.0

func _ready() -> void:
	Game.get_game().command_manager.set_dialog_ui(self)
	proceed.connect(Game.get_game().command_manager.execute_next)


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
	make_answer_choices(command.choices)

func give(command:CommandGive) -> void:
	display(true)
	text.text = "You got " + command.get_item().name + "!"
	give_item.emit(command.get_item())

func take(command:CommandTake) -> void:
	display(true)
	text.text = "Give 1 " + command.get_item().name + "?"
	make_answer_choices(["Give " + command.get_item().name, "Do not give"])

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and active and (current_node != null and (current_node.command is CommandSay or current_node.command is CommandGive)):
		confirm(0)


## Helper function for ask() that generates the buttons for choices.
func make_answer_choices(choices:Array[String]) -> void:
	var i = 0
	for choice in choices:
		var b = Button.new()
		b.text = choice
		b.connect("pressed", confirm.bind(i))
		answers_dock.add_child(b)
		i += 1


func clear_answer_choices() -> void:
	for child in answers_dock.get_children():
		child.queue_free()


func confirm(index:int) -> void:
	if current_node.command is CommandTake:
		if index == 0:
			if Game.get_game().environment.player.inventory.has_item(current_node.command.get_item()):
				take_item.emit(current_node.command.get_item())
			else:
				index = 1
	proceed.emit(index)
	if current_node == null:
		active = false
		hide()


func set_current_node(node:CommandNode):
	current_node = node
