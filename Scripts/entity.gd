extends Node
class_name Entity

@export var anatomy: Anatomy

func get_stat(stat_name):
	return 0

func perform_attack(body_part_name, attack_name):
	print("Performing " + attack_name + " with " + body_part_name)
