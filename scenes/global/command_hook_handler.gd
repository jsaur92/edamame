extends Node

var hooks : Array[CommandHook]

func add_hook(hook:CommandHook):
	hooks.append(hook)
	hook.connect("drop", receive_drop)

func receive_drop(hook:CommandHook):
	for to in hooks:
		var complete = to.receive_drop(hook)
		if complete != null:
			hook.set_connected(to)
			break
