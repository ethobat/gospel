extends Action
class_name Attack

@export var name: String
@export var animation: ActionAnimation
@export var trauma_category: TraumaCategory
@export var base_damage: float = 1

@export var windup_time: float = 0.3

enum TraumaCategory { BLUNT_FORCE, CUTTING, PENETRATIVE }
const BLUNT_FORCE = 0
const CUTTING = 1
const PENETRATIVE = 2

func perform(attacker: Character, source_anatomy: Anatomy, target: Character):
	print(attacker.character_name+" attacked "+target.character_name+" with "+source_anatomy.name+" "+name)
	print(attacker.anatomy.find("heart").hp)
	print(target.anatomy.find("heart").hp)
