extends GridContainer

@export var player: Character

func _ready():
	make_attack_buttons()

func make_attack_buttons():
	var scene = load("res://Scenes/UI/attack_button.tscn")
	for node in get_children():
		node.queue_free()
	for anatomy in player.entity.anatomy.all():
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
	button.button_down.connect(func(): on_attack_button_press(button.body_part_name, button.action_name))

func on_attack_button_press(body_part_name: String, action_name: String):
	if not TimeSystem.playing:
		player.entity.perform_action_windup(body_part_name, action_name)
