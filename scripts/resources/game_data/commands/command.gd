@abstract
class_name Command
extends Resource
## Abstract base class for all Commands.

## Whether a command must be the start of a command chain (HEAD), the middle (BODY), or end (TAIL).
enum Connectivity {HEAD, BODY, TAIL}

## Each child class must override this function to perform its command.
## Returns the index of the next command to call for Command Nodes.
## -1 -> error
## 0 -> default, or failure case for commands with split ends.
## 1 -> success case for commands with split ends.
## Also allows for values higher than 1 if Commands with more than 2 outcomes
## are ever implemented.
@abstract
func _execute() -> int
