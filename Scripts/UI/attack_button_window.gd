extends GridContainer
class_name AttackButtonWindow

var player_chr: Character

@onready var attack_button_scene = preload("res://Scenes/UI/attack_button.tscn")

func _ready():
	player_chr = %Player/Character
	make_attack_buttons()

func make_attack_buttons():
	for node in get_children():
		node.queue_free()
	for anatomy in player_chr.anatomy.all():
		for action in anatomy.actions:
			make_attack_button(anatomy.name, action.name)
	#make_attack_button(scene, "left hand", "punch")
	#make_attack_button(scene, "right hand", "punch")

func make_attack_button(body_part_name, action_name):
	var button = attack_button_scene.instantiate()
	add_child(button)
	button.body_part_name = body_part_name
	button.action_name = action_name
	button.initialize()
	button.button_down.connect(func(): on_attack_button_down(button.body_part_name, button.action_name))
	button.button_up.connect(func(): on_attack_button_up(button.body_part_name, button.action_name))

func on_attack_button_down(body_part_name: String, action_name: String):
	player_chr.windup_start(body_part_name, action_name)

func on_attack_button_up(body_part_name: String, action_name: String):
	player_chr.windup_release()
