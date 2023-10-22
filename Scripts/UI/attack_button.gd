extends Button

@export var entity: Entity
@export var body_part_name: String
@export var attack_name: String

@onready var body_part_label: Label = $BodyPartLabel
@onready var attack_name_label: Label = $AttackNameLabel

func initialize():
	body_part_label.text = body_part_name
	attack_name_label.text = attack_name
