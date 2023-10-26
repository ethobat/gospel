extends Resource
class_name Anatomy

@export var name: String : set = _set_name
@export var hp: float
@export var children: Array[Anatomy]
@export var actions: Array[Action]
# the get_stat method of Anatomy returns the value of the get_stat method of its parent,
# multiplied by the respective value in this array 
@export var stat_mults: Array[StatRecord]

var parent: Anatomy = null
		
func _set_name(new):
	name = new
	resource_name = new

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

func get_stat(stat_name: String) -> float:
	return get_stat_mult(stat_name) * (1.0 if parent==null else parent.get_stat(stat_name))

func get_stat_mult(stat_name: String) -> float:
	for sr in stat_mults:
		if sr.stat_name == stat_name:
			return sr.value
	return 1.0

func all():
	var ret = [self]
	for child in children:
		ret += child.all()
	return ret
