@abstract
class_name Command
extends Resource
## Abstract base class for all Commands.

func has_dialog() -> bool:
	return get("dialog") != null

const ENCODE_SPLIT = "\n"


@abstract func encode_to_string() -> String

## Find the type of command from the first line, then send the rest of the lines
## to that type's decode function.
static func decode_from_string(string:String) -> Command:
	var header = string.split(ENCODE_SPLIT)[0]
	var type : Command = load(header)
	return type.decode_from_string(string.substr(header.length()))
