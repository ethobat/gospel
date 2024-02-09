extends GridContainer

var player_chr: Character

func _ready():
	player_chr = %Player/Character
	make_attack_buttons()

func make_attack_buttons():
	var scene = load("res://Scenes/UI/attack_button.tscn")
	for node in get_children():
		node.queue_free()
	for anatomy in player_chr.anatomy.all():
		for action in anatomy.actions:
			make_attack_button(scene, anatomy.name, action.name)
	#make_attack_button(scene, "left hand", "punch")
	#make_attack_button(scene, "right hand", "punch")

func make_attack_button(scene, body_part_name, action_name):
	var button = scene.instantiate()
	add_child(button)
	button.body_part_name = body_part_name
	button.action_name = action_name
	button.initialize()
	button.button_down.connect(func(): on_attack_button_down(button.body_part_name, button.action_name))
	button.button_up.connect(func(): on_attack_button_up(button.body_part_name, button.action_name))

func on_attack_button_down(body_part_name: String, action_name: String):
	if not TimeSystem.playing:
		player_chr.windup_hold(body_part_name, action_name)

func on_attack_button_up(body_part_name: String, action_name: String):
	if not TimeSystem.playing:
		player_chr.release_windup(body_part_name, action_name)
