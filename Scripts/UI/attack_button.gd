extends Button

@export var character: Character
@export var body_part_name: String
@export var action_name: String

@onready var body_part_label: Label = $BodyPartLabel
@onready var action_name_label: Label = $AttackNameLabel

func initialize():
	body_part_label.text = body_part_name
	action_name_label.text = action_name
