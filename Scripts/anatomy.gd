extends Resource
class_name Anatomy

@export var name: String
@export var hp: float
@export var children: Array[Anatomy]
@export var actions: Array[Action]

func find(part_name: String) -> Anatomy:
	if part_name == name:
		return self 
	for child in children:
		var ret = child.find(part_name)
		if ret != null:
			return ret
	return

func get_action(action_name: String) -> Action:
	for action in actions:
		if action.name == action_name:
			return action
	assert(false, "No such action " + action_name + " on " + name)
	return
	
func all():
	var ret = [self]
	for child in children:
		ret += child.all()
	return ret
