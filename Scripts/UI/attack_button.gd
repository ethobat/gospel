extends Panel

@export var entity: Entity
@export var stat_name: String

@onready var body_part_label: Label = $BodyPartLabel
@onready var attack_name_label: Label = $AttackNameLabel

func _ready():
	stat_name_display.text = stat_name
	#update_value_display()
	
func update_value_display():
	value_display.text = entity.get_stat(stat_name)
