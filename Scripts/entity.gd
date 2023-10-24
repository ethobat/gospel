extends Resource
class_name Entity

@export var name: String
@export var anatomy: Anatomy

var character: Character

var windup: bool = false
var windup_action: Action
var windup_source_part: Anatomy
var windup_time: float

@export var base_muscle: float = 1.0
@export var base_art: float = 1.0
@export var base_locomotion: float = 1.0
@export var base_replenishment: float = 1.0

func _time_process(delta):
	if windup:
		windup_time -= delta
		if windup_time <= 0:
			windup = false
			perform_action_immediate()
			if character.is_player:
				TimeSystem.stop_playing()

func get_stat(stat_name):
	return 0

func perform_action_windup(body_part_name: String, action_name: String):
	if windup:
		return
	windup = true
	windup_source_part = anatomy.find(body_part_name)
	windup_action = windup_source_part.get_action(action_name)
	windup_time = windup_action.windup_time
	var target = character.get_facing_character()
	
	print("Attempting " + action_name + " with " + body_part_name)
	if character.is_player:
		TimeSystem.begin_playing()

func perform_action_immediate():
	var target = character.get_facing_character()
	if target is Character:
		windup_action.perform(self, windup_source_part, target.entity)
	else:
		print("Miss")

func get_locomotion():
	return base_locomotion
