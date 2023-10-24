extends Action
class_name Attack

# When an entity is attacked, 

@export var name: String
@export var trauma_category: TRAUMA_CATEGORY
@export var base_damage: float = 1

enum TRAUMA_CATEGORY { BLUNT_FORCE, CUTTING, PENETRATIVE }
const BLUNT_FORCE = 0
const CUTTING = 1
const PENETRATIVE = 2


func perform(attacker: Entity, source_anatomy: Anatomy, target: Entity):
	print(attacker.name+" attacked "+target.name+" with "+source_anatomy.name+" "+name)
