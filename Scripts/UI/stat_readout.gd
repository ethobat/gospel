extends Panel

@export var entity: Entity
@export var stat_name: String

@onready var stat_name_label: Label = $StatNameLabel
@onready var value_label: Label = $ValueLabel

func _ready():
	stat_name_label.text = stat_name
	#update_value_label()
	
func update_value_label():
	value_label.text = entity.get_stat(stat_name)
