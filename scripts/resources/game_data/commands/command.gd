@abstract
class_name Command
extends Resource
## Abstract base class for all Commands.

func has_dialog() -> bool:
	return get("dialog") != null
