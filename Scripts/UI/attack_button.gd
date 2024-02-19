extends Button

var window: AttackButtonWindow
var body_part_name: String
var action_name: String

@onready var body_part_label: Label = $BodyPartLabel
@onready var action_name_label: Label = $AttackNameLabel

func initialize():
	window = get_parent()
	body_part_label.text = body_part_name
	action_name_label.text = window.player_chr.anatomy.find(body_part_name).get_action(action_name).display_name
